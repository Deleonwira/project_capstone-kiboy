class PackingItem {
  final int? id;
  final int itineraryId;
  final String name;
  final bool isPacked;

  PackingItem({
    this.id,
    required this.itineraryId,
    required this.name,
    this.isPacked = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itineraryId': itineraryId,
      'name': name,
      'isPacked': isPacked ? 1 : 0,
    };
  }

  factory PackingItem.fromMap(Map<String, dynamic> map) {
    return PackingItem(
      id: map['id'],
      itineraryId: map['itineraryId'],
      name: map['name'],
      isPacked: map['isPacked'] == 1,
    );
  }
}
