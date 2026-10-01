class Reminder {
  final int? id;
  final int activityId;
  final String reminderTime; // ISO 8601
  final String message;
  final int isActive; // 1 = active, 0 = inactive

  Reminder({
    this.id,
    required this.activityId,
    required this.reminderTime,
    required this.message,
    this.isActive = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'activityId': activityId,
      'reminderTime': reminderTime,
      'message': message,
      'isActive': isActive,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      activityId: map['activityId'],
      reminderTime: map['reminderTime'] ?? '',
      message: map['message'] ?? '',
      isActive: map['isActive'] ?? 1,
    );
  }
}
