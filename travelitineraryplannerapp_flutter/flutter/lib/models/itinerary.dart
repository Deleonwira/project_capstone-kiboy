class Itinerary {
  final int? id;
  final int userId;
  final String title;
  final String destination;
  final String startDate;
  final String endDate;
  final String status; // 'published' or 'draft'

  Itinerary({
    this.id,
    required this.userId,
    required this.title,
    required this.destination,
    required this.startDate,
    required this.endDate,
    this.status = 'published',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'destination': destination,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
    };
  }

  factory Itinerary.fromMap(Map<String, dynamic> map) {
    return Itinerary(
      id: map['id'],
      userId: map['userId'] ?? 0,
      title: map['title'] ?? '',
      destination: map['destination'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      status: map['status'] ?? 'published',
    );
  }

  bool get isDraft => status == 'draft';
  bool get isPublished => status == 'published';
}
