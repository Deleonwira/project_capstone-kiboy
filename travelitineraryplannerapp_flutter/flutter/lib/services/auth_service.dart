import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  /// Penentuan Base URL REST API secara dinamis berdasarkan platform run.
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080';
    }
    try {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:8080';
      }
    } catch (_) {}
    return 'http://localhost:8080';
  }

  /// Register a new user via Spring Boot REST API
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/api/auth/register');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': name,
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        if (data['success'] == true) {
          final userData = data['data'];
          final idFromServer = userData['id'] as int;
          final usernameFromServer = userData['username'] as String;
          final emailFromServer = userData['email'] as String;

          final dbHelper = DatabaseHelper();
          final Database db = await dbHelper.database;
          
          // Bersihkan data user lama dengan email yang sama di SQLite lokal (jika ada) untuk menghindari duplikasi
          await db.delete('users', where: 'email = ?', whereArgs: [emailFromServer]);
          
          _currentUser = User(
            id: idFromServer,
            name: usernameFromServer,
            email: emailFromServer,
            password: '', // Password kosong karena disimpan secara terenkripsi di server MySQL
          );

          await dbHelper.insertUser(_currentUser!);
          await _saveSession();
          return {'success': true, 'message': 'Registrasi berhasil'};
        } else {
          return {'success': false, 'message': data['message'] ?? 'Registrasi gagal'};
        }
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal menghubungi server'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan koneksi: $e'};
    }
  }

  /// Login user via Spring Boot REST API
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/api/auth/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': email, // Spring Boot Auth mendukung login lewat Username atau Email
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (data['success'] == true) {
          final responseData = data['data'];
          final idFromServer = responseData['id'] as int;
          final usernameFromServer = responseData['username'] as String;
          final emailFromServer = responseData['email'] as String;
          final token = responseData['token'] as String;

          // Simpan token JWT ke SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwtToken', token);

          final dbHelper = DatabaseHelper();
          final Database db = await dbHelper.database;
          
          // Bersihkan data user lama dengan email yang sama di SQLite lokal (jika ada) untuk menghindari duplikasi
          await db.delete('users', where: 'email = ?', whereArgs: [emailFromServer]);

          _currentUser = User(
            id: idFromServer,
            name: usernameFromServer,
            email: emailFromServer,
            password: '',
          );

          await dbHelper.insertUser(_currentUser!);
          await _saveSession();
          return {'success': true, 'message': 'Login berhasil'};
        } else {
          return {'success': false, 'message': data['message'] ?? 'Login gagal'};
        }
      } else {
        return {'success': false, 'message': data['message'] ?? 'Email atau password salah'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan koneksi: $e'};
    }
  }

  /// Logout user
  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    await prefs.remove('jwtToken');
  }

  /// Save session to SharedPreferences
  Future<void> _saveSession() async {
    if (_currentUser == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', _currentUser!.id!);
    await prefs.setString('userName', _currentUser!.name);
    await prefs.setString('userEmail', _currentUser!.email);
  }

  /// Try to restore session from SharedPreferences
  Future<bool> tryRestoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final userName = prefs.getString('userName');
    final userEmail = prefs.getString('userEmail');

    if (userId != null && userName != null && userEmail != null) {
      _currentUser = User(
        id: userId,
        name: userName,
        email: userEmail,
        password: '', // Tidak perlu dimuat ulang
      );
      return true;
    }
    return false;
  }
}
