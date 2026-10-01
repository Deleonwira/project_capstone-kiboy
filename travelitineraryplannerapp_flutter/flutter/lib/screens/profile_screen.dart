import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../database/database_helper.dart';
import 'login_screen.dart';
import 'vault_screen.dart';
import 'preferences_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _db = DatabaseHelper();
  bool _isLoading = true;
  int _totalTrips = 0;
  int _totalDocs = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    final userId = AuthService().currentUser?.id ?? 0;
    
    final upcomingTrips = await _db.getUpcomingTrips(userId);
    final pastTrips = await _db.getPastTrips(userId);
    final draftTrips = await _db.getDraftTrips(userId);
    
    final int trips = upcomingTrips.length + pastTrips.length + draftTrips.length;
    final docs = await _db.getDocuments(userId);
    
    setState(() {
      _totalTrips = trips;
      _totalDocs = docs.length;
      _isLoading = false;
    });
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await AuthService().logout();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;
    final userName = user?.name ?? 'Traveler';
    final userEmail = user?.email ?? 'Tidak ada email';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun Saya', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        elevation: 0,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildProfileHeader(userName, userEmail),
              const SizedBox(height: 32),
              _buildStatsRow(),
              const SizedBox(height: 32),
              const Text('Pengaturan & Fitur', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildMenuTile(
                icon: Icons.settings_rounded,
                title: 'Preferensi Perjalanan',
                subtitle: 'Mata uang, jarak, dan minat',
                color: Colors.blue,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PreferencesScreen()));
                },
              ),
              _buildMenuTile(
                icon: Icons.folder_rounded,
                title: 'Vault',
                subtitle: 'Dokumen tiket & paspor Anda',
                color: Colors.orange,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const VaultScreen()));
                },
              ),
              _buildMenuTile(
                icon: Icons.help_outline_rounded,
                title: 'Bantuan & Dukungan',
                subtitle: 'Tanya jawab & kontak kami',
                color: Colors.teal,
                onTap: () {},
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                  label: const Text('Logout', style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _logout,
                ),
              ),
              const SizedBox(height: 32),
              const Center(
                child: Text('Travel Itinerary Planner v1.0.0', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            ],
          ),
    );
  }

  Widget _buildProfileHeader(String name, String email) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: const Color(0xFF1E88E5).withAlpha(40),
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1E88E5)),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('$_totalTrips', 'Total Trips', Icons.flight_takeoff)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard('$_totalDocs', 'Dokumen', Icons.folder)),
      ],
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF1E88E5), size: 28),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildMenuTile({required IconData icon, required String title, required String subtitle, required Color color, required VoidCallback onTap}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withAlpha(30),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }
}
