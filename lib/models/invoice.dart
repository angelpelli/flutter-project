class Invoice {
  final String id;
  final String petId;
  final DateTime date;
  final int days;
  final double amount;

  Invoice({
    required this.id,
    required this.petId,
    required this.date,
    required this.days,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'petId': petId,
      'date': date.toIso8601String(),
      'days': days,
      'amount': amount,
    };
  }

  static Invoice fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'],
      petId: map['petId'],
      date: DateTime.parse(map['date']),
      days: map['days'],
      amount: map['amount'],
    );
  }
}