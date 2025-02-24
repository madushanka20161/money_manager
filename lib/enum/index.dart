enum TransactionType {
  income,
  expenses,
}

extension TransactionTypeExtension on TransactionType {
  String get displayName {
    switch (this) {
      case TransactionType.income:
        return 'income';
      case TransactionType.expenses:
        return 'expenses';
    }
  }
}

enum TimePeriod {
  day,
  week,
  month,
  year,
  custom,
}

extension TimePeriodExtension on TimePeriod {
  String get displayName {
    switch (this) {
      case TimePeriod.day:
        return 'day';
      case TimePeriod.week:
        return 'week';
      case TimePeriod.month:
        return 'month';
      case TimePeriod.year:
        return 'year';
      case TimePeriod.custom:
        return 'custom';
    }
  }
}

enum CategoryLimitType {
  presentage,
  value,
}

extension CategoryLimitTypeExtension on CategoryLimitType {
  String get displayName {
    switch (this) {
      case CategoryLimitType.value:
        return 'value';
      case CategoryLimitType.presentage:
        return 'presentage';
    }
  }
}