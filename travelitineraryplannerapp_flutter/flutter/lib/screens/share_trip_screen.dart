import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/shared_itinerary.dart';
import '../services/auth_service.dart';

class ShareTripScreen extends StatefulWidget {
  final int itineraryId;
  final String itineraryTitle;

  const ShareTripScreen({
    super.key,
    required this.itineraryId,
    required this.itineraryTitle,
  });

  @override
  State<ShareTripScreen> createState() => _ShareTripScreenState();
}

class _ShareTripScreenState extends State<ShareTripScreen> {
  final _db = DatabaseHelper();
  final _emailController = TextEditingController();
  String _accessLevel = 'readonly';
  bool _isLoading = true;
  List<Map<String, dynamic>> _shares = [];

  @override
  void initState() {
    super.initState();
    _loadShares();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadShares() async {
    setState(() => _isLoading = true);
    _shares = await _db.getSharesForItinerary(widget.itineraryId);
    setState(() => _isLoading = false);
  }

  Future<void> _addShare() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showMessage('Masukkan email pengguna', Colors.redAccent);
      return;
    }

    final currentUser = AuthService().currentUser;
    if (currentUser?.email == email) {
      _showMessage('Tidak bisa share ke diri sendiri', Colors.redAccent);
      return;
    }

    // Find user by email
    final user = await _db.getUserByEmail(email);
    if (user == null) {
      _showMessage('Pengguna dengan email ini tidak ditemukan', Colors.redAccent);
      return;
    }

    // Check if already shared
    final existingAccess =
        await _db.getAccessLevel(widget.itineraryId, user.id!);
    if (existingAccess != null) {
      _showMessage('Sudah di-share ke pengguna ini', Colors.orange);
      return;
    }

    final share = SharedItinerary(
      itineraryId: widget.itineraryId,
      ownerUserId: currentUser!.id!,
      sharedWithUserId: user.id!,
      accessLevel: _accessLevel,
    );

    await _db.shareItinerary(share);
    _emailController.clear();
    await _loadShares();
    _showMessage('Berhasil di-share ke ${user.name} ✓', Colors.green);
  }

  Future<void> _removeShare(int shareId) async {
    await _db.removeShare(shareId);
    await _loadShares();
    _showMessage('Akses dihapus', Colors.grey);
  }

  void _showMessage(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bagikan Trip',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Trip Info
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E88E5).withAlpha(25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.flight_takeoff,
                        color: Color(0xFF1E88E5)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(widget.itineraryTitle,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Add Share Section
          const Text('Undang Teman',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email pengguna',
              hintText: 'contoh@email.com',
              prefixIcon: const Icon(Icons.person_add_alt_1),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
          const SizedBox(height: 12),

          // Access Level
          Row(
            children: [
              const Text('Akses: ', style: TextStyle(fontSize: 15)),
              const SizedBox(width: 8),
              ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.visibility,
                        size: 16,
                        color: _accessLevel == 'readonly'
                            ? Colors.white
                            : Colors.grey),
                    const SizedBox(width: 4),
                    const Text('Lihat Saja'),
                  ],
                ),
                selected: _accessLevel == 'readonly',
                selectedColor: const Color(0xFF1E88E5),
                labelStyle: TextStyle(
                    color: _accessLevel == 'readonly'
                        ? Colors.white
                        : Colors.black87),
                onSelected: (_) => setState(() => _accessLevel = 'readonly'),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit,
                        size: 16,
                        color: _accessLevel == 'edit'
                            ? Colors.white
                            : Colors.grey),
                    const SizedBox(width: 4),
                    const Text('Edit'),
                  ],
                ),
                selected: _accessLevel == 'edit',
                selectedColor: Colors.orange,
                labelStyle: TextStyle(
                    color: _accessLevel == 'edit'
                        ? Colors.white
                        : Colors.black87),
                onSelected: (_) => setState(() => _accessLevel = 'edit'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _addShare,
              icon: const Icon(Icons.share),
              label: const Text('Bagikan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E88E5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),

          // Shared Users List
          const Text('Pengguna dengan Akses',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_shares.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.group_outlined,
                        size: 48, color: Colors.grey.shade300),
                    const SizedBox(height: 8),
                    Text('Belum dibagikan ke siapapun',
                        style: TextStyle(color: Colors.grey.shade500)),
                  ],
                ),
              ),
            )
          else
            ...(_shares.map((share) => Card(
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: share['accessLevel'] == 'edit'
                          ? Colors.orange.withAlpha(30)
                          : const Color(0xFF1E88E5).withAlpha(30),
                      child: Icon(
                        share['accessLevel'] == 'edit'
                            ? Icons.edit
                            : Icons.visibility,
                        color: share['accessLevel'] == 'edit'
                            ? Colors.orange
                            : const Color(0xFF1E88E5),
                        size: 20,
                      ),
                    ),
                    title: Text(share['sharedWithName'] ?? 'Unknown',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(share['sharedWithEmail'] ?? '',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade600)),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, color: Colors.redAccent),
                      onPressed: () => _removeShare(share['id']),
                    ),
                  ),
                ))),
        ],
      ),
    );
  }
}
