import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../models/category.dart';
import 'package:intl/intl.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  void _showCategoryTransactions(BuildContext context, TransactionCategory category) {
    final provider = context.read<TransactionProvider>();
    
    // Filtrer les transactions par catégorie
    final categoryTransactions = provider.transactions
        .where((t) => t.category == category)
        .toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(category.icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Text(category.name),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: categoryTransactions.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'No transactions in this category',
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: categoryTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = categoryTransactions[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: Text(
                          category.icon,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      title: Text(transaction.title),
                      subtitle: Text(
                        DateFormat('MMM dd, yyyy').format(transaction.date),
                      ),
                      trailing: Text(
                        '\$${transaction.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          final categoryTotals = provider.getTotalByCategory();

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.95, // ← Ajusté pour donner plus d'espace
            ),
            itemCount: TransactionCategory.values.length,
            itemBuilder: (context, index) {
              final category = TransactionCategory.values[index];
              final total = categoryTotals[category] ?? 0.0;

              return Card(
                elevation: 2,
                clipBehavior: Clip.antiAlias, // ← Ajouté pour bien gérer les bordures
                child: InkWell(
                  onTap: () => _showCategoryTransactions(context, category),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Icône avec Flexible pour éviter le débordement
                        Flexible(
                          flex: 2,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              category.icon,
                              style: const TextStyle(fontSize: 40),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Nom de la catégorie
                        Flexible(
                          flex: 1,
                          child: Text(
                            category.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 2),
                        // Prix
                        Text(
                          '\$${total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}