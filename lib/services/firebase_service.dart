import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction.dart';
import '../models/category.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get _transactions => _firestore.collection('transactions');

  // Ajouter
  Future<void> addTransaction(ExpenseTransaction transaction) async {
    await _transactions.add(transaction.toMap());
  }

  // Stream (Temps réel)
  Stream<List<ExpenseTransaction>> getTransactions() {
    return _transactions
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ExpenseTransaction(
          id: doc.id, // ID original de Firebase (String)
          title: data['title'] ?? '',
          amount: (data['amount'] ?? 0).toDouble(),
          category: TransactionCategory.values[data['category'] ?? 0],
          date: (data['date'] as Timestamp).toDate(),
          note: data['note'],
        );
      }).toList();
    });
  }

  // Update efficace b-String ID
  Future<void> updateTransaction(ExpenseTransaction transaction) async {
    if (transaction.id != null) {
      await _transactions.doc(transaction.id).update(transaction.toMap());
    }
  }

  // Delete efficace b-String ID
  Future<void> deleteTransaction(String id) async {
    await _transactions.doc(id).delete();
  }
}