class Transaction {
  final int? id;
  final int userId;
  final String date;
  final double amount;
  final String category;
  final String type; // INCOME or EXPENSE
  final String description;

  Transaction({
    this.id,
    required this.userId,
    required this.date,
    required this.amount,
    required this.category,
    required this.type,
    required this.description,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      userId: json['userId'],
      date: json['date'],
      amount: json['amount'].toDouble(),
      category: json['category'],
      type: json['type'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'date': date,
      'amount': amount,
      'category': category,
      'type': type,
      'description': description,
    };
  }
}
