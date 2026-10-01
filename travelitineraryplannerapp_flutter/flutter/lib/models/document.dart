class Document {
  final int? id;
  final int userId;
  final int? itineraryId;
  final String fileName;
  final String filePath;
  final String fileType; // pdf, jpg, png, etc
  final String category; // ticket, passport, other
  final String createdAt;

  Document({
    this.id,
    required this.userId,
    this.itineraryId,
    required this.fileName,
    required this.filePath,
    required this.fileType,
    this.category = 'other',
    String? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'itineraryId': itineraryId,
      'fileName': fileName,
      'filePath': filePath,
      'fileType': fileType,
      'category': category,
      'createdAt': createdAt,
    };
  }

  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      id: map['id'],
      userId: map['userId'],
      itineraryId: map['itineraryId'],
      fileName: map['fileName'],
      filePath: map['filePath'],
      fileType: map['fileType'] ?? 'other',
      category: map['category'] ?? 'other',
      createdAt: map['createdAt'] ?? '',
    );
  }

  String get categoryLabel {
    switch (category) {
      case 'ticket':
        return 'Tiket / Voucher';
      case 'passport':
        return 'Paspor / ID';
      default:
        return 'Lainnya';
    }
  }
}
