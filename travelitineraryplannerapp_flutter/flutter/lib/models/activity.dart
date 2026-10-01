class Activity {
  final int? id;
  final int itineraryId;
  final String title;
  final String description;
  final String date;
  final String time;

  Activity({
    this.id,
    required this.itineraryId,
    required this.title,
    this.description = '',
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itineraryId': itineraryId,
      'title': title,
      'description': description,
      'date': date,
      'time': time,
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'],
      itineraryId: map['itineraryId'],
      title: map['title'],
      description: map['description'],
      date: map['date'],
      time: map['time'],
    );
  }
}
