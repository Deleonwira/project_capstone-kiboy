import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/itinerary.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';

class AddEditItineraryScreen extends StatefulWidget {
  final Itinerary? itinerary;

  const AddEditItineraryScreen({super.key, this.itinerary});

  @override
  State<AddEditItineraryScreen> createState() => _AddEditItineraryScreenState();
}

class _AddEditItineraryScreenState extends State<AddEditItineraryScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _destinationController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  bool _isDraft = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.itinerary?.title ?? '',
    );
    _destinationController = TextEditingController(
      text: widget.itinerary?.destination ?? '',
    );
    _startDateController = TextEditingController(
      text: widget.itinerary?.startDate ?? '',
    );
    _endDateController = TextEditingController(
      text: widget.itinerary?.endDate ?? '',
    );
    _isDraft = widget.itinerary?.isDraft ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _destinationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _scheduleTripReminder(int id, Itinerary it) {
    try {
      if (it.isDraft) return;
      final start = DateTime.parse(it.startDate);
      // Scheduled for 1 day before at 10:00 AM
      final reminderDate = start
          .subtract(const Duration(days: 1))
          .add(const Duration(hours: 10));

      if (reminderDate.isAfter(DateTime.now())) {
        NotificationService().scheduleReminder(
          id:
              id *
              100, // Multiply by 100 to avoid clashing with activity reminders
          title: 'Pengingat Perjalanan Besok!',
          body: 'Siap-siap! Trip kamu ke ${it.destination} dimulai besok.',
          scheduledTime: reminderDate,
        );
      }
    } catch (e) {
      // Ignore parse errors
    }
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final userId = AuthService().currentUser?.id ?? 0;
      final itinerary = Itinerary(
        id: widget.itinerary?.id,
        userId: widget.itinerary?.userId ?? userId,
        title: _titleController.text,
        destination: _destinationController.text,
        startDate: _startDateController.text,
        endDate: _endDateController.text,
        status: _isDraft ? 'draft' : 'published',
      );

      int savedId;
      if (widget.itinerary == null) {
        savedId = await DatabaseHelper().insertItinerary(itinerary);
      } else {
        await DatabaseHelper().updateItinerary(itinerary);
        savedId = itinerary.id!;
      }

      _scheduleTripReminder(savedId, itinerary);

      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.itinerary != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Trip' : 'Add Trip'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Trip Title (e.g. Summer Vacation)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _destinationController,
                decoration: InputDecoration(
                  labelText: 'Destination (e.g. Bali, Indonesia)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.location_city),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a destination' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _startDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Start Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.calendar_today),
                      ),
                      onTap: () => _selectDate(context, _startDateController),
                      validator: (value) =>
                          value!.isEmpty ? 'Select date' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _endDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'End Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.event),
                      ),
                      onTap: () => _selectDate(context, _endDateController),
                      validator: (value) =>
                          value!.isEmpty ? 'Select date' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Draft toggle
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SwitchListTile(
                  title: const Text(
                    'Simpan sebagai Draft',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    _isDraft
                        ? 'Trip ini belum dipublikasikan'
                        : 'Trip ini akan langsung aktif',
                  ),
                  value: _isDraft,
                  onChanged: (v) => setState(() => _isDraft = v),
                  secondary: Icon(
                    _isDraft ? Icons.edit_note : Icons.check_circle,
                    color: _isDraft ? Colors.orange : Colors.green,
                  ),
                  activeThumbColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: const Color(0xFF1E88E5),
                  foregroundColor: Colors.white,
                ),
                onPressed: _save,
                child: Text(
                  _isDraft ? 'Simpan Draft' : 'Save Trip',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
