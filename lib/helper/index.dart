import 'package:flutter/material.dart';
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

const Map<String, IconData> iconMap = {
  'attach_money': Icons.attach_money,
  'shopping_cart': Icons.shopping_cart,
  'home': Icons.home,
  'accessible': Icons.accessible,
  'safety_check': Icons.safety_check,
  'sailing': Icons.sailing,
  'abc_outlined': Icons.abc_outlined,
  'hail': Icons.hail
};

const Map<String, Color> colorMap = {
  'blue': Colors.blue,
  'black': Colors.black,
  'green': Colors.green,
  'yellow': Colors.yellow,
  'orange': Colors.orange,
  'pink': Colors.pink,
  'red': Colors.red,
  'lightBlueAccent': Colors.lightBlueAccent
};
