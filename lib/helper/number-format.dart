import 'package:intl/intl.dart';
import 'package:money_manager_3/service/userstate_service.dart';

String formatNumber(double value) {
  String style = UserStateService.instance.defaultNumberSeperationStyle!;
  int decimalPlace = UserStateService.instance.defaultDecimalPlace!;

  switch (style) {
    case 'NumberSelectionStyleType.plane':
      return value.toStringAsFixed(decimalPlace);
    case 'NumberSelectionStyleType.us':
      String pattern = '#,##0.${'0' * decimalPlace}';
      return NumberFormat(pattern, 'en_US').format(value);
    case 'NumberSelectionStyleType.eu':
      String pattern = '#,##0.${'0' * decimalPlace}';
      return NumberFormat(pattern, 'de_DE').format(value);
    default:
      return '---';
  }
}