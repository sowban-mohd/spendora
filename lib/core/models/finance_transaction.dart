// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:spendora/core/utils/capitalize_first_letter.dart';

enum TransactionType {
  income,
  expense;

  String get label => capitalizeFirstLetter(name);

  List<TransactionCategory> get categories {
    switch (this) {
      case TransactionType.income:
        return TransactionCategory.incomeCategories;
      case TransactionType.expense:
        return TransactionCategory.expenseCategories;
    }
  }

  TransactionCategory get defaultCategory => categories.first;
}

enum TransactionCategory {
  salary,
  freelance,
  food,
  transport,
  shopping,
  bills,
  entertainment,
  savings,
  health,
  education,
  other;

  String get label => capitalizeFirstLetter(name);

  static const List<TransactionCategory> incomeCategories = [
    TransactionCategory.salary,
    TransactionCategory.freelance,
    TransactionCategory.other,
  ];

  static const List<TransactionCategory> expenseCategories = [
    TransactionCategory.food,
    TransactionCategory.transport,
    TransactionCategory.shopping,
    TransactionCategory.bills,
    TransactionCategory.entertainment,
    TransactionCategory.savings,
    TransactionCategory.health,
    TransactionCategory.education,
    TransactionCategory.other,
  ];

  bool supportsType(TransactionType type) => type.categories.contains(this);
}

class FinanceTransaction {
  final String id;
  final double amount;
  final TransactionType type;
  final TransactionCategory category;
  final DateTime date;
  final String notes;

  const FinanceTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    required this.notes,
  });

  bool get isExpense => type == TransactionType.expense;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'type': type.name,
      'category': category.name,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  factory FinanceTransaction.fromMap(Map<String, dynamic> map) {
    return FinanceTransaction(
      id: map['id'] as String,
      amount: (map['amount'] as num).toDouble(),
      type: TransactionType.values.byName(map['type'] as String),
      category: TransactionCategory.values.byName(map['category'] as String),
      date: DateTime.parse(map['date'] as String),
      notes: map['notes'] as String? ?? '',
    );
  }

  FinanceTransaction copyWith({
    String? id,
    double? amount,
    TransactionType? type,
    TransactionCategory? category,
    DateTime? date,
    String? notes,
  }) {
    return FinanceTransaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() {
    return 'FinanceTransaction(id: $id, amount: $amount, type: $type, category: $category, date: $date, notes: $notes)';
  }
}
