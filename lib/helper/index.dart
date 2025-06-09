import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_3/dto/category_dto.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/state/app_state.dart';

List<DateTime> getDateRange(String period, AppState? appState) {
  final currentDate = DateTime.now();
  late DateTime startDate;
  late DateTime endDate;

  switch (period) {
    case 'day':
      startDate = DateTime(currentDate.year, currentDate.month, currentDate.day, 0, 0, 0);
      endDate = DateTime(currentDate.year, currentDate.month, currentDate.day, 23, 59, 59);
      break;
    case 'week':
      startDate = DateTime(currentDate.year, currentDate.month, currentDate.day - currentDate.weekday + 1, 0, 0, 0);
      endDate = DateTime(currentDate.year, currentDate.month, currentDate.day - currentDate.weekday + 7, 23, 59, 59);
      break;
    case 'month':
      startDate = DateTime(currentDate.year, currentDate.month, 1, 0, 0, 0);
      endDate = DateTime(currentDate.year, currentDate.month + 1, 0, 23, 59, 59);
      break;
    case 'year':
      startDate = DateTime(currentDate.year, 1, 1, 0, 0, 0);
      endDate = DateTime(currentDate.year, 12, 31, 23, 59, 59);
      break;
    case 'custom':
      startDate = appState!.startDate;
      endDate = appState.endDate;
      break;
    default:
      throw Exception('[helper - index] Invalid period');
  }

  return [startDate, endDate];
}

String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}

String formatNumber(double value) {
  return value.toStringAsFixed(AppConfig.decimalPlace);
}

String formatDate(DateTime value) {
  return DateFormat('yyyy-MM-dd').format(value);
}

List<CategoryDTO> getCategoryByType(Map<String, CategoryDTO> categories, TransactionType type) {
  return categories.values.where((CategoryDTO category) => category.type == type).toList();
}

const Map<String, IconData> iconMap = {
  'attach_money': Icons.attach_money,
  'shopping_cart': Icons.shopping_cart,
  'home': Icons.home,
  'accessible': Icons.accessible,
  'safety_check': Icons.safety_check,
  'sailing': Icons.sailing,
  'abc_outlined': Icons.abc_outlined,
  'hail': Icons.hail,
  'fastfood': Icons.fastfood,
  'directions_car': Icons.directions_car,
  'shopping_bag': Icons.shopping_bag,
  'healing': Icons.healing,
  'receipt_long': Icons.receipt_long,
  'movie': Icons.movie,
  'flight': Icons.flight,
  'school': Icons.school,
  'savings': Icons.savings,
  'category': Icons.category,
  'business_center': Icons.business_center,
  'trending_up': Icons.trending_up,
  'card_giftcard': Icons.card_giftcard,
  'add_box': Icons.add_box,
};

const defaultCategories = [
  // expenses
  'Food|fastfood|orange|expenses',
  'Transport|directions_car|blueGrey|expenses',
  'Shopping|shopping_bag|purple|expenses',
  'Health|healing|red|expenses',
  'Bills|receipt_long|teal|expenses',
  'Entertainment|movie|indigo|expenses',
  'Travel|flight|deepPurple|expenses',
  'Education|school|green|expenses',
  'Savings|savings|lightGreen|expenses',
  'Others|category|grey|expenses',
  // income
  'Salary|attach_money|green|income',
  'Business|business_center|blue|income',
  'Investments|trending_up|purple|income',
  'Gifts|card_giftcard|pink|income',
  'Others|add_box|grey|income',
];

const Map<String, IconData> accountIconMap = {
  'account_balance': Icons.account_balance,
  'account_balance_outlined': Icons.account_balance_outlined,
  'account_balance_rounded': Icons.account_balance_rounded,
  'account_balance_sharp': Icons.account_balance_sharp,
  'account_balance_wallet_rounded': Icons.account_balance_wallet_rounded,
};

const Map<String, Color> colorMap = {
  'blue': Colors.blue,
  'lightBlueAccent': Colors.lightBlueAccent,
  'blueGrey': Colors.blueGrey,
  'indigo': Colors.indigo,
  'deepPurple': Colors.deepPurple,
  'purple': Colors.purple,
  'pink': Colors.pink,
  'red': Colors.red,
  'orange': Colors.orange,
  'yellow': Colors.yellow,
  'lightGreen': Colors.lightGreen,
  'green': Colors.green,
  'teal': Colors.teal,
  'grey': Colors.grey,
  'black': Colors.black,
};

const List<String> currencyList = ['RS', 'USD', 'EUR', 'GBP', 'JPY'];
const Color defaultColur = Colors.blue;
const IconData defaultAccountIcon = Icons.account_balance;
const Color defaultCategoryColor = Colors.blue;
const IconData defaultCategoryIcon = Icons.attach_money;

const Map<String, double> currencyMap = {
  'USD': 1.0,
  'EUR': 10.0,
  'GBP': 0.25,
  'JPY': 2.0,
  'RS' : 290,
};

// TODO: [need to get this from user]
const defaultCurrency = 'RS';