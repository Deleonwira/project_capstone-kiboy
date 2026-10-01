import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/user_preferences.dart';
import '../services/auth_service.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final _db = DatabaseHelper();
  late int _userId;
  bool _isLoading = true;

  String _currency = 'IDR';
  String _distanceUnit = 'km';
  List<String> _selectedInterests = [];

  final List<String> _currencies = [
    'IDR',
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'SGD',
    'MYR',
    'THB',
    'AUD',
    'KRW',
  ];

  final Map<String, String> _currencyLabels = {
    'IDR': '🇮🇩 IDR - Rupiah',
    'USD': '🇺🇸 USD - Dollar',
    'EUR': '🇪🇺 EUR - Euro',
    'GBP': '🇬🇧 GBP - Pound',
    'JPY': '🇯🇵 JPY - Yen',
    'SGD': '🇸🇬 SGD - Dollar Singapura',
    'MYR': '🇲🇾 MYR - Ringgit',
    'THB': '🇹🇭 THB - Baht',
    'AUD': '🇦🇺 AUD - Dollar Australia',
    'KRW': '🇰🇷 KRW - Won',
  };

  final List<Map<String, dynamic>> _allInterests = [
    {'label': 'Kuliner', 'icon': Icons.restaurant},
    {'label': 'Alam', 'icon': Icons.park},
    {'label': 'Budget', 'icon': Icons.savings},
    {'label': 'Luxury', 'icon': Icons.diamond},
    {'label': 'Sejarah', 'icon': Icons.museum},
    {'label': 'Pantai', 'icon': Icons.beach_access},
    {'label': 'Gunung', 'icon': Icons.terrain},
    {'label': 'Belanja', 'icon': Icons.shopping_bag},
    {'label': 'Fotografi', 'icon': Icons.camera_alt},
    {'label': 'Olahraga', 'icon': Icons.sports},
    {'label': 'Religi', 'icon': Icons.mosque},
    {'label': 'Nightlife', 'icon': Icons.nightlife},
  ];

  @override
  void initState() {
    super.initState();
    _userId = AuthService().currentUser?.id ?? 0;
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await _db.getPreferences(_userId);
    if (prefs != null) {
      setState(() {
        _currency = prefs.currency;
        _distanceUnit = prefs.distanceUnit;
        _selectedInterests = prefs.interestList;
      });
    }
    setState(() => _isLoading = false);
  }

  Future<void> _savePreferences() async {
    final prefs = UserPreferences(
      userId: _userId,
      currency: _currency,
      distanceUnit: _distanceUnit,
      interests: _selectedInterests.join(','),
    );
    await _db.insertOrUpdatePreferences(prefs);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Preferensi tersimpan ✓'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Preferensi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Currency Section
          _buildSectionCard(
            icon: Icons.monetization_on_rounded,
            iconColor: Colors.amber,
            title: 'Mata Uang',
            subtitle: 'Pilih mata uang default untuk biaya perjalanan',
            child: DropdownButtonFormField<String>(
              initialValue: _currency,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              items: _currencies.map((c) {
                return DropdownMenuItem(
                  value: c,
                  child: Text(_currencyLabels[c] ?? c),
                );
              }).toList(),
              onChanged: (v) {
                if (v != null) setState(() => _currency = v);
              },
            ),
          ),
          const SizedBox(height: 16),

          // Distance Unit Section
          _buildSectionCard(
            icon: Icons.straighten_rounded,
            iconColor: Colors.blue,
            title: 'Satuan Jarak',
            subtitle: 'Pilih satuan untuk navigasi dan estimasi jarak',
            child: Row(
              children: [
                Expanded(
                  child: _buildUnitOption('km', 'Kilometer', Icons.speed),
                ),
                const SizedBox(width: 12),
                Expanded(child: _buildUnitOption('mi', 'Mil', Icons.speed)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Interests Section
          _buildSectionCard(
            icon: Icons.favorite_rounded,
            iconColor: Colors.red,
            title: 'Minat Destinasi',
            subtitle: 'Pilih kategori perjalanan yang Anda sukai',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _allInterests.map((interest) {
                final isSelected = _selectedInterests.contains(
                  interest['label'],
                );
                return FilterChip(
                  selected: isSelected,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        interest['icon'] as IconData,
                        size: 18,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF1E88E5),
                      ),
                      const SizedBox(width: 6),
                      Text(interest['label'] as String),
                    ],
                  ),
                  selectedColor: const Color(0xFF1E88E5),
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  backgroundColor: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF1E88E5)
                          : Colors.grey.shade300,
                    ),
                  ),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedInterests.add(interest['label'] as String);
                      } else {
                        _selectedInterests.remove(interest['label'] as String);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Save Button
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _savePreferences,
              icon: const Icon(Icons.save_rounded),
              label: const Text(
                'Simpan Preferensi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E88E5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildUnitOption(String value, String label, IconData icon) {
    final isSelected = _distanceUnit == value;
    return GestureDetector(
      onTap: () => setState(() => _distanceUnit = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1E88E5).withAlpha(25)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF1E88E5) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF1E88E5)
                  : Colors.grey.shade500,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                color: isSelected ? const Color(0xFF1E88E5) : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
