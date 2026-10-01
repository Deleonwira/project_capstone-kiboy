class Expense {
  final int? id;
  final int itineraryId;
  final String title;
  final double amount;
  final String category; // e.g., 'Transport', 'Food', 'Accommodation', 'Tickets', 'Other'

  Expense({
    this.id,
    required this.itineraryId,
    required this.title,
    required this.amount,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itineraryId': itineraryId,
      'title': title,
      'amount': amount,
      'category': category,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      itineraryId: map['itineraryId'],
      title: map['title'],
      amount: map['amount'],
      category: map['category'],
    );
  }
}
