import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fl_chart/fl_chart.dart';
import '../database/database_helper.dart';
import '../models/itinerary.dart';
import '../models/activity.dart';
import '../models/expense.dart';
import '../models/packing_item.dart';
import '../services/weather_service.dart';
import '../services/pdf_service.dart';
import 'add_edit_activity_screen.dart';
import 'add_edit_expense_screen.dart';
import 'share_trip_screen.dart';

class ItineraryDetailScreen extends StatefulWidget {
  final Itinerary itinerary;
  final bool isReadOnly;

  const ItineraryDetailScreen({
    super.key,
    required this.itinerary,
    this.isReadOnly = false,
  });

  @override
  State<ItineraryDetailScreen> createState() => _ItineraryDetailScreenState();
}

class _ItineraryDetailScreenState extends State<ItineraryDetailScreen> with SingleTickerProviderStateMixin {
  late Future<List<Activity>> _activitiesFuture;
  late Future<List<Expense>> _expensesFuture;
  late Future<List<PackingItem>> _packingFuture;
  Map<String, dynamic>? _weatherData;
  bool _isLoadingWeather = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    _refreshAll();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    final wData = await WeatherService.getWeatherForDestination(widget.itinerary.destination);
    if (mounted) {
      setState(() {
        _weatherData = wData;
        _isLoadingWeather = false;
      });
    }
  }

  void _refreshAll() {
    setState(() {
      _activitiesFuture = DatabaseHelper().getActivitiesForItinerary(widget.itinerary.id!);
      _expensesFuture = DatabaseHelper().getExpensesForItinerary(widget.itinerary.id!);
      _packingFuture = DatabaseHelper().getPackingItemsForItinerary(widget.itinerary.id!);
    });
  }

  Future<void> _openGoogleMaps(String location) async {
    final query = Uri.encodeComponent(location);
    final url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");
    if (!await launchUrl(url)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal membuka Maps')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.itinerary.title),
        elevation: 0,
        actions: [
          if (!widget.isReadOnly)
            IconButton(
              icon: const Icon(Icons.picture_as_pdf, color: Color(0xFF1E88E5)),
              tooltip: 'Export PDF',
              onPressed: () async {
                final activities = await _activitiesFuture;
                final expenses = await _expensesFuture;
                await PdfService.printItinerary(
                  itinerary: widget.itinerary,
                  activities: activities,
                  expenses: expenses,
                );
              },
            ),
          if (!widget.isReadOnly)
            IconButton(
              icon: const Icon(Icons.share_rounded, color: Color(0xFF1E88E5)),
              tooltip: 'Bagikan',
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ShareTripScreen(
                      itineraryId: widget.itinerary.id!,
                      itineraryTitle: widget.itinerary.title,
                    ),
                  ),
                );
              },
            ),
          if (widget.isReadOnly)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Chip(
                label: const Text('Read-Only', style: TextStyle(fontSize: 12, color: Colors.white)),
                backgroundColor: Colors.grey,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF1E88E5),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFF1E88E5),
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'Aktivitas'),
              Tab(text: 'Checklist'),
              Tab(text: 'Budget'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActivitiesTab(),
                _buildPackingTab(),
                _buildBudgetTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: widget.isReadOnly
          ? null
          : FloatingActionButton.extended(
              onPressed: () async {
                if (_tabController.index == 0) {
                  await Navigator.push(context, MaterialPageRoute(builder: (_) => AddEditActivityScreen(itineraryId: widget.itinerary.id!)));
                } else if (_tabController.index == 1) {
                  await _showAddPackingDialog();
                } else {
                  await Navigator.push(context, MaterialPageRoute(builder: (_) => AddEditExpenseScreen(itineraryId: widget.itinerary.id!)));
                }
                _refreshAll();
              },
              icon: const Icon(Icons.add),
              label: Text(_tabController.index == 0 ? 'Add Activity' : (_tabController.index == 1 ? 'Add Item' : 'Add Expense')),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => _openGoogleMaps(widget.itinerary.destination),
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.itinerary.destination,
                    style: const TextStyle(color: Colors.white, fontSize: 18, decoration: TextDecoration.underline, decorationColor: Colors.white),
                  ),
                ),
                const Icon(Icons.open_in_new, color: Colors.white70, size: 14),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.date_range, color: Colors.white70, size: 20),
              const SizedBox(width: 8),
              Text(
                '${widget.itinerary.startDate} to ${widget.itinerary.endDate}',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
          if (widget.itinerary.isDraft) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.withAlpha(50),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('📝 Draft', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ],
          if (_isLoadingWeather)
            const Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: SizedBox(height: 16, width: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
            )
          else if (_weatherData != null)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Row(
                children: [
                  Text(_weatherData!['icon'] ?? '', style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text('${_weatherData!['temperature']}°C - ${_weatherData!['condition_text']}',
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActivitiesTab() {
    return FutureBuilder<List<Activity>>(
      future: _activitiesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
        if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text('Belum ada aktivitas.'));

        final activities = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent.withAlpha(51),
                  child: const Icon(Icons.schedule, color: Colors.blueAccent),
                ),
                title: Text(activity.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (activity.description.isNotEmpty) Text(activity.description),
                    const SizedBox(height: 4),
                    Text('${activity.date} at ${activity.time}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                trailing: widget.isReadOnly
                    ? null
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.map, color: Colors.blueAccent, size: 20),
                            onPressed: () => _openGoogleMaps('${activity.title} di ${widget.itinerary.destination}'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.grey, size: 20),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => AddEditActivityScreen(itineraryId: widget.itinerary.id!, activity: activity)),
                              );
                              _refreshAll();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                            onPressed: () async {
                              await DatabaseHelper().deleteActivity(activity.id!);
                              _refreshAll();
                            },
                          ),
                        ],
                      ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBudgetTab() {
    return FutureBuilder<List<Expense>>(
      future: _expensesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text('Belum ada pengeluaran.'));

        final expenses = snapshot.data!;
        double total = 0;
        final Map<String, double> categorySums = {};
        for (var e in expenses) {
          total += e.amount;
          categorySums[e.category] = (categorySums[e.category] ?? 0) + e.amount;
        }

        final List<PieChartSectionData> pieSections = [];
        int colorIdx = 0;
        final colors = [Colors.blue, Colors.orange, Colors.teal, Colors.redAccent, Colors.purple, Colors.green];
        
        categorySums.forEach((key, value) {
          pieSections.add(PieChartSectionData(
            color: colors[colorIdx % colors.length],
            value: value,
            title: key,
            radius: 50,
            titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          ));
          colorIdx++;
        });

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  const Text('Total Pengeluaran', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text(total.toStringAsFixed(2), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1E88E5))),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: pieSections,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Riwayat Transaksi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...expenses.map((e) {
              return Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.shade100,
                    child: const Icon(Icons.receipt_long, color: Colors.grey),
                  ),
                  title: Text(e.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(e.category, style: const TextStyle(fontSize: 12)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(e.amount.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      if (!widget.isReadOnly)
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                          onPressed: () async {
                            await DatabaseHelper().deleteExpense(e.id!);
                            _refreshAll();
                          },
                        ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 80),
          ],
        );
      },
    );
  }

  Widget _buildPackingTab() {
    return FutureBuilder<List<PackingItem>>(
      future: _packingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

        final items = snapshot.data ?? [];

        if (items.isEmpty) return const Center(child: Text('Belum ada packing list.'));

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return CheckboxListTile(
              value: item.isPacked,
              title: Text(item.name, style: TextStyle(decoration: item.isPacked ? TextDecoration.lineThrough : null)),
              onChanged: widget.isReadOnly ? null : (bool? val) async {
                if (val != null) {
                  final updatedItem = PackingItem(id: item.id, itineraryId: item.itineraryId, name: item.name, isPacked: val);
                  await DatabaseHelper().updatePackingItem(updatedItem);
                  _refreshAll();
                }
              },
              secondary: widget.isReadOnly ? null : IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () async {
                  await DatabaseHelper().deletePackingItem(item.id!);
                  _refreshAll();
                },
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showAddPackingDialog() async {
    String newItem = '';
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Bawaan'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Cth: Paspor, Kamera..'),
            onChanged: (val) => newItem = val,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () async {
                if (newItem.trim().isNotEmpty) {
                  await DatabaseHelper().insertPackingItem(PackingItem(itineraryId: widget.itinerary.id!, name: newItem.trim()));
                  _refreshAll();
                }
                if (context.mounted) Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E88E5), foregroundColor: Colors.white),
              child: const Text('Simpan'),
            )
          ],
        );
      }
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
