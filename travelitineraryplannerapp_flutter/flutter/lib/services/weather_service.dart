import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static Future<Map<String, dynamic>?> getWeatherForDestination(String destination) async {
    try {
      // 1. Geocode destination
      final geoUrl = Uri.parse('https://geocoding-api.open-meteo.com/v1/search?name=${Uri.encodeComponent(destination)}&count=1');
      final geoRes = await http.get(geoUrl);
      if (geoRes.statusCode == 200) {
        final geoData = jsonDecode(geoRes.body);
        if (geoData['results'] != null && geoData['results'].isNotEmpty) {
          final lat = geoData['results'][0]['latitude'];
          final lon = geoData['results'][0]['longitude'];

          // 2. Get weather
          final weatherUrl = Uri.parse('https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true');
          final weatherRes = await http.get(weatherUrl);
          
          if (weatherRes.statusCode == 200) {
            final weatherData = jsonDecode(weatherRes.body);
            final current = weatherData['current_weather'];
            final code = current['weathercode'] as int;
            
            return {
              'temperature': current['temperature'],
              'condition_text': _getWeatherCondition(code),
              'icon': _getWeatherIcon(code),
            };
          }
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  static String _getWeatherCondition(int code) {
    if (code == 0) return 'Cerah';
    if (code == 1 || code == 2) return 'Berawan Sebagian';
    if (code == 3) return 'Mendung';
    if (code == 45 || code == 48) return 'Berkabut';
    if (code >= 51 && code <= 55) return 'Gerimis';
    if (code >= 61 && code <= 65) return 'Hujan';
    if (code >= 71 && code <= 75) return 'Bersalju';
    if (code >= 80 && code <= 82) return 'Hujan Lebat';
    if (code >= 95) return 'Badai Petir';
    return 'Berawan'; // default
  }

  static String _getWeatherIcon(int code) {
    if (code == 0) return '☀️'; // Cerah
    if (code == 1 || code == 2) return '⛅'; // Berawan sebagian
    if (code == 3) return '☁️'; // Mendung
    if (code == 45 || code == 48) return '🌫️'; // Kabut
    if (code >= 51 && code <= 65) return '🌧️'; // Hujan
    if (code >= 71 && code <= 75) return '❄️'; // Salju
    if (code >= 80 && code <= 82) return '🌦️'; // Hujan deras
    if (code >= 95) return '⛈️'; // Petir
    return '🌥️';
  }
}
