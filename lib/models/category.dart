enum TransactionCategory {
  food,
  transport,
  shopping,
  entertainment,
  bills,
  health,
  other,
}

extension CategoryExtension on TransactionCategory {
  String get name {
    switch (this) {
      case TransactionCategory.food:
        return 'Food';
      case TransactionCategory.transport:
        return 'Transport';
      case TransactionCategory.shopping:
        return 'Shopping';
      case TransactionCategory.entertainment:
        return 'Entertainment';
      case TransactionCategory.bills:
        return 'Bills';
      case TransactionCategory.health:
        return 'Health';
      case TransactionCategory.other:
        return 'Other';
    }
  }
  
  String get icon {
    switch (this) {
      case TransactionCategory.food:
        return '🍔';
      case TransactionCategory.transport:
        return '🚗';
      case TransactionCategory.shopping:
        return '🛍️';
      case TransactionCategory.entertainment:
        return '🎮';
      case TransactionCategory.bills:
        return '💰';
      case TransactionCategory.health:
        return '🏥';
      case TransactionCategory.other:
        return '📦';
    }
  }
}

