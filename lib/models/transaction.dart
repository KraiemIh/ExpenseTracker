import 'category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseTransaction {
  final String? id; // String mouch int
  final String title;
  final double amount;
  final TransactionCategory category;
  final DateTime date;
  final String? note;

  ExpenseTransaction({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
  });

  // Convertir pour Firebase
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'category': category.index,
      'date': Timestamp.fromDate(date),
      'note': note,
    };
  }

  // CopyWith pour faciliter la gestion de l'ID
  ExpenseTransaction copyWith({
    String? id,
    String? title,
    double? amount,
    TransactionCategory? category,
    DateTime? date,
    String? note,
  }) {
    return ExpenseTransaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }
}