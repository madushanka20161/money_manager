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
        return 'Fixed Amount';
      case CategoryLimitType.percentage:
        return 'Percentage';
    }
  }
}

enum NumberSelectionStyleType {
  plane,
  us,
  eu,
}

extension NumberSelectionStyleTypeExtension on NumberSelectionStyleType {
  String get displayName {
    switch (this) {
      case NumberSelectionStyleType.plane:
        return '1000 (Plain)';
      case NumberSelectionStyleType.us:
        return '1,000.00 (US Style)';
      case NumberSelectionStyleType.eu:
        return '1.000,00 (EU Style)';
    }
  }
}
