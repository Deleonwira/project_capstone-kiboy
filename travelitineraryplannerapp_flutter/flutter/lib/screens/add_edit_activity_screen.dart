import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/activity.dart';
import '../models/reminder.dart';
import '../services/notification_service.dart';

class AddEditActivityScreen extends StatefulWidget {
  final int itineraryId;
  final Activity? activity;

  const AddEditActivityScreen({
    super.key,
    required this.itineraryId,
    this.activity,
  });

  @override
  State<AddEditActivityScreen> createState() => _AddEditActivityScreenState();
}

class _AddEditActivityScreenState extends State<AddEditActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _db = DatabaseHelper();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;

  bool _setReminder = false;
  int _reminderMinutes = 60; // default 1 hour before

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.activity?.title ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.activity?.description ?? '',
    );
    _dateController = TextEditingController(text: widget.activity?.date ?? '');
    _timeController = TextEditingController(text: widget.activity?.time ?? '');

    // Load existing reminder if editing
    if (widget.activity?.id != null) {
      _loadReminder();
    }
  }

  Future<void> _loadReminder() async {
    final reminder = await _db.getReminderForActivity(widget.activity!.id!);
    if (reminder != null && mounted) {
      setState(() => _setReminder = true);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && mounted) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final activity = Activity(
      id: widget.activity?.id,
      itineraryId: widget.itineraryId,
      title: _titleController.text,
      description: _descriptionController.text,
      date: _dateController.text,
      time: _timeController.text,
    );

    int activityId;
    if (widget.activity == null) {
      activityId = await _db.insertActivity(activity);
    } else {
      await _db.updateActivity(activity);
      activityId = widget.activity!.id!;
    }

    // Handle reminder
    if (_setReminder) {
      await _scheduleReminder(activityId, activity);
    } else {
      // Remove existing reminder if toggled off
      await _db.deleteReminderForActivity(activityId);
      await NotificationService().cancelReminder(activityId);
    }

    if (mounted) Navigator.pop(context);
  }

  Future<void> _scheduleReminder(int activityId, Activity activity) async {
    // Parse date and time
    try {
      final dateParts = activity.date.split('-');
      if (dateParts.length != 3) return;

      // Parse time - handle both "HH:mm" and "h:mm AM/PM" formats
      int hour = 0, minute = 0;
      final timeStr = activity.time;
      if (timeStr.contains('AM') || timeStr.contains('PM')) {
        final parsed = DateFormat.jm().parse(timeStr);
        hour = parsed.hour;
        minute = parsed.minute;
      } else {
        final timeParts = timeStr.split(':');
        hour = int.parse(timeParts[0]);
        minute = int.parse(timeParts[1]);
      }

      final activityTime = DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
        hour,
        minute,
      );

      final reminderTime = activityTime.subtract(
        Duration(minutes: _reminderMinutes),
      );

      // Delete old reminder
      await _db.deleteReminderForActivity(activityId);

      // Save new reminder
      final reminder = Reminder(
        activityId: activityId,
        reminderTime: reminderTime.toIso8601String(),
        message: '${activity.title} dimulai dalam $_reminderMinutes menit',
      );
      await _db.insertReminder(reminder);

      // Schedule notification
      await NotificationService().scheduleReminder(
        id: activityId,
        title: '⏰ Pengingat Perjalanan',
        body: reminder.message,
        scheduledTime: reminderTime,
      );
    } catch (e) {
      debugPrint('Error scheduling reminder: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.activity != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Activity' : 'Add Activity'),
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
                  labelText: 'Activity Name (e.g. Scuba Diving)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.surfing),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Notes / Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.notes),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.calendar_month),
                      ),
                      onTap: () => _selectDate(context),
                      validator: (value) =>
                          value!.isEmpty ? 'Select date' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _timeController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Time',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.access_time),
                      ),
                      onTap: () => _selectTime(context),
                      validator: (value) =>
                          value!.isEmpty ? 'Select time' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Reminder Section
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text(
                        '🔔 Set Pengingat',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        _setReminder
                            ? 'Akan diingatkan $_reminderMinutes menit sebelum'
                            : 'Aktifkan untuk menerima notifikasi',
                      ),
                      value: _setReminder,
                      onChanged: (v) => setState(() => _setReminder = v),
                      activeThumbColor: const Color(0xFF1E88E5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    if (_setReminder) ...[
                      const Divider(height: 0),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Text(
                              'Ingatkan: ',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 8),
                            _buildReminderChip(15, '15 mnt'),
                            const SizedBox(width: 6),
                            _buildReminderChip(30, '30 mnt'),
                            const SizedBox(width: 6),
                            _buildReminderChip(60, '1 jam'),
                          ],
                        ),
                      ),
                    ],
                  ],
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
                child: const Text(
                  'Save Activity',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReminderChip(int minutes, String label) {
    final isSelected = _reminderMinutes == minutes;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: const Color(0xFF1E88E5),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
      onSelected: (_) => setState(() => _reminderMinutes = minutes),
    );
  }
}
