import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/itinerary.dart';
import '../services/auth_service.dart';
import 'add_edit_itinerary_screen.dart';
import 'itinerary_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _db = DatabaseHelper();
  late int _userId;

  List<Itinerary> _upcoming = [];
  List<Itinerary> _past = [];
  List<Itinerary> _drafts = [];
  List<Map<String, dynamic>> _shared = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _userId = AuthService().currentUser?.id ?? 0;
    _refreshAll();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshAll() async {
    setState(() => _isLoading = true);
    var upcoming = await _db.getUpcomingTrips(_userId);
    var past = await _db.getPastTrips(_userId);
    var drafts = await _db.getDraftTrips(_userId);
    var shared = await _db.getSharedWithMe(_userId);

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      upcoming = upcoming.where((i) => i.title.toLowerCase().contains(q) || i.destination.toLowerCase().contains(q)).toList();
      past = past.where((i) => i.title.toLowerCase().contains(q) || i.destination.toLowerCase().contains(q)).toList();
      drafts = drafts.where((i) => i.title.toLowerCase().contains(q) || i.destination.toLowerCase().contains(q)).toList();
      shared = shared.where((i) => 
        (i['title']?.toString().toLowerCase().contains(q) ?? false) || 
        (i['destination']?.toString().toLowerCase().contains(q) ?? false)
      ).toList();
    }

    if (mounted) {
      setState(() {
        _upcoming = upcoming;
        _past = past;
        _drafts = drafts;
        _shared = shared;
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final userName = AuthService().currentUser?.name ?? 'Traveler';

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Cari trip atau destinasi...',
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                  _refreshAll();
                },
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Halo, $userName 👋',
                      style:
                          const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                  const Text('My Trips',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchQuery = '';
                  _refreshAll();
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
        ],
        elevation: 0,
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF1E88E5),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF1E88E5),
          indicatorWeight: 3,
          tabs: [
            Tab(text: 'Upcoming (${_upcoming.length})'),
            Tab(text: 'Past (${_past.length})'),
            Tab(text: 'Drafts (${_drafts.length})'),
            Tab(text: 'Shared (${_shared.length})'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildTripList(_upcoming, 'Belum ada rencana trip.\nTambahkan satu!',
                    Icons.flight_takeoff),
                _buildTripList(
                    _past, 'Belum ada perjalanan lalu.', Icons.history),
                _buildTripList(
                    _drafts, 'Belum ada draft.', Icons.edit_note),
                _buildSharedList(),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const AddEditItineraryScreen()),
          );
          _refreshAll();
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Trip'),
      ),
    );
  }

  Widget _buildTripList(
      List<Itinerary> itineraries, String emptyMessage, IconData emptyIcon) {
    if (itineraries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(emptyIcon, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(emptyMessage,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade500)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshAll,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: itineraries.length,
        itemBuilder: (context, index) {
          final it = itineraries[index];
          return _buildTripCard(it);
        },
      ),
    );
  }

  Widget _buildTripCard(Itinerary it, {String? ownerName, bool isShared = false, String? accessLevel}) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ItineraryDetailScreen(
                itinerary: it,
                isReadOnly: accessLevel == 'readonly',
              ),
            ),
          );
          _refreshAll();
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(it.title,
                        style: const TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold)),
                  ),
                  if (it.isDraft)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Draft',
                          style: TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ),
                  if (isShared && accessLevel != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: accessLevel == 'edit'
                            ? Colors.orange.withAlpha(25)
                            : const Color(0xFF1E88E5).withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        accessLevel == 'edit' ? 'Edit' : 'Read-Only',
                        style: TextStyle(
                          color: accessLevel == 'edit'
                              ? Colors.orange
                              : const Color(0xFF1E88E5),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.orange),
                  const SizedBox(width: 6),
                  Expanded(
                      child: Text(it.destination,
                          style: const TextStyle(fontSize: 15))),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.date_range, size: 16, color: Colors.blue),
                  const SizedBox(width: 6),
                  Text('${it.startDate}  →  ${it.endDate}',
                      style: const TextStyle(
                          fontSize: 13, color: Colors.black54)),
                ],
              ),
              if (ownerName != null) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text('Dari: $ownerName',
                        style: const TextStyle(
                            fontSize: 13, color: Colors.grey)),
                  ],
                ),
              ],
              if (!isShared) ...[
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.grey, size: 20),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AddEditItineraryScreen(itinerary: it),
                            ),
                          );
                          _refreshAll();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete,
                            color: Colors.redAccent, size: 20),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              title: const Text('Hapus Trip'),
                              content: Text(
                                  'Yakin ingin menghapus "${it.title}"?'),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(ctx, false),
                                    child: const Text('Batal')),
                                ElevatedButton(
                                  onPressed: () =>
                                      Navigator.pop(ctx, true),
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
                            await _db.deleteItinerary(it.id!);
                            _refreshAll();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSharedList() {
    if (_shared.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text('Belum ada trip yang dibagikan ke Anda.',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade500)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshAll,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _shared.length,
        itemBuilder: (context, index) {
          final s = _shared[index];
          final it = Itinerary(
            id: s['itineraryId'],
            userId: s['userId'] ?? 0,
            title: s['title'] ?? '',
            destination: s['destination'] ?? '',
            startDate: s['startDate'] ?? '',
            endDate: s['endDate'] ?? '',
            status: s['status'] ?? 'published',
          );
          return _buildTripCard(
            it,
            ownerName: s['ownerName'],
            isShared: true,
            accessLevel: s['accessLevel'],
          );
        },
      ),
    );
  }
}
