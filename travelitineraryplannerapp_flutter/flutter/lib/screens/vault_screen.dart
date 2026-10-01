import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../database/database_helper.dart';
import '../models/document.dart';
import '../services/auth_service.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen>
    with SingleTickerProviderStateMixin {
  final _db = DatabaseHelper();
  late int _userId;
  late TabController _tabController;
  bool _isLoading = true;

  List<Document> _allDocs = [];
  List<Document> _ticketDocs = [];
  List<Document> _passportDocs = [];
  List<Document> _otherDocs = [];

  @override
  void initState() {
    super.initState();
    _userId = AuthService().currentUser?.id ?? 0;
    _tabController = TabController(length: 3, vsync: this);
    _loadDocuments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDocuments() async {
    setState(() => _isLoading = true);
    _allDocs = await _db.getDocuments(_userId);
    _ticketDocs = _allDocs.where((d) => d.category == 'ticket').toList();
    _passportDocs = _allDocs.where((d) => d.category == 'passport').toList();
    _otherDocs = _allDocs.where((d) => d.category == 'other').toList();
    setState(() => _isLoading = false);
  }

  Future<void> _uploadFile(String category) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
    );

    if (result == null || result.files.isEmpty) return;

    final pickedFile = result.files.first;
    if (pickedFile.path == null) return;

    // Copy file to app directory for persistence
    final appDir = await getApplicationDocumentsDirectory();
    final vaultDir = Directory(p.join(appDir.path, 'vault'));
    if (!vaultDir.existsSync()) {
      vaultDir.createSync(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final newFileName = '${timestamp}_${pickedFile.name}';
    final newPath = p.join(vaultDir.path, newFileName);
    final sourceFile = File(pickedFile.path!);
    await sourceFile.copy(newPath);

    final extension = p.extension(pickedFile.name).replaceFirst('.', '');

    final doc = Document(
      userId: _userId,
      fileName: pickedFile.name,
      filePath: newPath,
      fileType: extension,
      category: category,
    );

    await _db.insertDocument(doc);
    await _loadDocuments();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${pickedFile.name} berhasil diupload ✓'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Future<void> _openFile(Document doc) async {
    final file = File(doc.filePath);
    if (await file.exists()) {
      await OpenFilex.open(doc.filePath);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('File tidak ditemukan'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  Future<void> _deleteDocument(Document doc) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Dokumen'),
        content: Text('Yakin ingin menghapus "${doc.fileName}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Delete file from storage
      final file = File(doc.filePath);
      if (await file.exists()) await file.delete();

      await _db.deleteDocument(doc.id!);
      await _loadDocuments();
    }
  }

  void _showUploadSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Upload Dokumen',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Pilih kategori dokumen:',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            _buildCategoryTile(ctx, 'ticket', Icons.airplane_ticket_rounded,
                'Tiket / Voucher', Colors.orange),
            _buildCategoryTile(ctx, 'passport', Icons.badge_rounded,
                'Paspor / ID', Colors.blue),
            _buildCategoryTile(ctx, 'other', Icons.folder_rounded,
                'Lainnya', Colors.grey),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTile(BuildContext ctx, String category, IconData icon,
      String label, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withAlpha(30),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () {
        Navigator.pop(ctx);
        _uploadFile(category);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vault',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF1E88E5),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF1E88E5),
          tabs: [
            Tab(
                icon: const Icon(Icons.airplane_ticket_rounded),
                text: 'Tiket (${_ticketDocs.length})'),
            Tab(
                icon: const Icon(Icons.badge_rounded),
                text: 'ID (${_passportDocs.length})'),
            Tab(
                icon: const Icon(Icons.folder_rounded),
                text: 'Lainnya (${_otherDocs.length})'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildDocList(_ticketDocs, 'ticket'),
                _buildDocList(_passportDocs, 'passport'),
                _buildDocList(_otherDocs, 'other'),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showUploadSheet,
        icon: const Icon(Icons.upload_file_rounded),
        label: const Text('Upload'),
      ),
    );
  }

  Widget _buildDocList(List<Document> docs, String category) {
    if (docs.isEmpty) {
      final labels = {
        'ticket': 'Belum ada tiket atau voucher',
        'passport': 'Belum ada dokumen identitas',
        'other': 'Belum ada dokumen lainnya',
      };
      final icons = {
        'ticket': Icons.airplane_ticket_outlined,
        'passport': Icons.badge_outlined,
        'other': Icons.folder_open,
      };
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icons[category], size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(labels[category] ?? '',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade500)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final doc = docs[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _getFileColor(doc.fileType).withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_getFileIcon(doc.fileType),
                  color: _getFileColor(doc.fileType)),
            ),
            title: Text(doc.fileName,
                style: const TextStyle(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            subtitle: Text(
              doc.createdAt.length >= 10
                  ? doc.createdAt.substring(0, 10)
                  : doc.createdAt,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.open_in_new, color: Color(0xFF1E88E5)),
                  onPressed: () => _openFile(doc),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () => _deleteDocument(doc),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getFileIcon(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image_rounded;
      case 'doc':
      case 'docx':
        return Icons.description_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  Color _getFileColor(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Colors.teal;
      case 'doc':
      case 'docx':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
