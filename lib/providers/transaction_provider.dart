import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../services/firebase_service.dart';
import 'dart:async';

class TransactionProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  List<ExpenseTransaction> _transactions = [];
  TransactionCategory? _selectedCategory;
  bool _isLoading = false;
  StreamSubscription<List<ExpenseTransaction>>? _transactionSubscription;

  TransactionProvider() {
    _loadTransactions();
  }

  List<ExpenseTransaction> get transactions {
    if (_selectedCategory == null) return _transactions;
    return _transactions.where((t) => t.category == _selectedCategory).toList();
  }

  TransactionCategory? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  void _loadTransactions() {
    _isLoading = true;
    _transactionSubscription = _firebaseService.getTransactions().listen(
      (data) {
        _transactions = data;
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        print('Error: $e');
        _isLoading = false;
        notifyListeners();
      },
    );
  }
  Map<TransactionCategory, double> getTotalByCategory() {
  // Initialisi l-map b-zero l-kol
  final Map<TransactionCategory, double> totals = {
    for (var cat in TransactionCategory.values) cat: 0.0
  };


  for (var t in _transactions) {
    totals[t.category] = (totals[t.category] ?? 0.0) + t.amount;
  }
  return totals;
}

Map<String, double> getSpendingByMonth() {
    final Map<String, double> monthly = {};
    
    for (var transaction in _transactions) {
      // Key format: "2024-05"
      final key = '${transaction.date.year}-${transaction.date.month.toString().padLeft(2, '0')}';
      monthly[key] = (monthly[key] ?? 0) + transaction.amount;
    }
    
    return monthly;
  }

  Future<void> addTransaction(ExpenseTransaction transaction) async {
    await _firebaseService.addTransaction(transaction);
  }

  Future<void> updateTransaction(ExpenseTransaction transaction) async {
    await _firebaseService.updateTransaction(transaction);
  }

  Future<void> deleteTransaction(String id) async {
    await _firebaseService.deleteTransaction(id);
  }

  void filterByCategory(TransactionCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  double get totalSpending => _transactions.fold(0.0, (sum, t) => sum + t.amount);

  @override
  void dispose() {
    _transactionSubscription?.cancel();
    super.dispose();
  }
}