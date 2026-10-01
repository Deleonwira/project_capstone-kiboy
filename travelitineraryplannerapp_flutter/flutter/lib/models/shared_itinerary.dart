class SharedItinerary {
  final int? id;
  final int itineraryId;
  final int ownerUserId;
  final int sharedWithUserId;
  final String accessLevel; // 'edit' or 'readonly'

  SharedItinerary({
    this.id,
    required this.itineraryId,
    required this.ownerUserId,
    required this.sharedWithUserId,
    this.accessLevel = 'readonly',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itineraryId': itineraryId,
      'ownerUserId': ownerUserId,
      'sharedWithUserId': sharedWithUserId,
      'accessLevel': accessLevel,
    };
  }

  factory SharedItinerary.fromMap(Map<String, dynamic> map) {
    return SharedItinerary(
      id: map['id'],
      itineraryId: map['itineraryId'],
      ownerUserId: map['ownerUserId'],
      sharedWithUserId: map['sharedWithUserId'],
      accessLevel: map['accessLevel'] ?? 'readonly',
    );
  }
}
