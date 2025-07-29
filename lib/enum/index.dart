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
  percentage,
  value,
}

extension CategoryLimitTypeExtension on CategoryLimitType {
  String get displayName {
    switch (this) {
      case CategoryLimitType.value:
        return 'value';
      case CategoryLimitType.percentage:
        return 'percentage';
    }
  }
}

enum NumberSelectionStyleType {
  none,
  comma,
  dot,
}

extension NumberSelectionStyleTypeExtension on NumberSelectionStyleType {
  String get displayName {
    switch (this) {
      case NumberSelectionStyleType.none:
        return 'none';
      case NumberSelectionStyleType.comma:
        return 'comma';
      case NumberSelectionStyleType.dot:
        return 'dot';
    }
  }
}
