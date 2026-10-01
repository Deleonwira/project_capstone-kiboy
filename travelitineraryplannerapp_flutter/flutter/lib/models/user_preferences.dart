class UserPreferences {
  final int? id;
  final int userId;
  final String currency;
  final String distanceUnit;
  final String interests; // comma-separated: "Kuliner,Alam,Budget"

  UserPreferences({
    this.id,
    required this.userId,
    this.currency = 'IDR',
    this.distanceUnit = 'km',
    this.interests = '',
  });

  List<String> get interestList =>
      interests.isEmpty ? [] : interests.split(',');

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'currency': currency,
      'distanceUnit': distanceUnit,
      'interests': interests,
    };
  }

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      id: map['id'],
      userId: map['userId'],
      currency: map['currency'] ?? 'IDR',
      distanceUnit: map['distanceUnit'] ?? 'km',
      interests: map['interests'] ?? '',
    );
  }

  UserPreferences copyWith({
    int? id,
    int? userId,
    String? currency,
    String? distanceUnit,
    String? interests,
  }) {
    return UserPreferences(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      currency: currency ?? this.currency,
      distanceUnit: distanceUnit ?? this.distanceUnit,
      interests: interests ?? this.interests,
    );
  }
}
