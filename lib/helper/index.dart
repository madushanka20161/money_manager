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

List<CategoryDTO> getCategoryByTypeOrderByIndex(Map<String, CategoryDTO> categories, TransactionType type) {
  List<CategoryDTO> categoryList = getCategoryByType(categories, type);
  categoryList.sort((a, b) => a.index.compareTo(b.index));

  return categoryList;
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
  'Food|fastfood|orange|expenses|0',
  'Transport|directions_car|blueGrey|expenses|1',
  'Shopping|shopping_bag|purple|expenses|2',
  'Health|healing|red|expenses|3',
  'Bills|receipt_long|teal|expenses|4',
  'Entertainment|movie|indigo|expenses|5',
  'Travel|flight|deepPurple|expenses|6',
  'Education|school|green|expenses|7',
  'Savings|savings|lightGreen|expenses|8',
  'Others|category|grey|expenses|9',
  // income
  'Salary|attach_money|green|income|10',
  'Business|business_center|blue|income|11',
  'Investments|trending_up|purple|income|12',
  'Gifts|card_giftcard|pink|income|13',
  'Others|add_box|grey|income|14',
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

const List<Map<String, String>> currencyList = [
  {"country": "United States dollar", "code": "USD"},
  {"country": "Euro", "code": "EUR"},
  {"country": "Japanese yen", "code": "JPY"},
  {"country": "Pound sterling", "code": "GBP"},
  {"country": "United Arab Emirates dirham", "code": "AED"},
  {"country": "Afghan afghani", "code": "AFN"},
  {"country": "Albanian lek", "code": "ALL"},
  {"country": "Armenian dram", "code": "AMD"},
  {"country": "Netherlands Antillean guilder", "code": "ANG"},
  {"country": "Angolan kwanza", "code": "AOA"},
  {"country": "Argentine peso", "code": "ARS"},
  {"country": "Australian dollar", "code": "AUD"},
  {"country": "Aruban florin", "code": "AWG"},
  {"country": "Azerbaijani manat", "code": "AZN"},
  {"country": "Bosnia and Herzegovina convertible mark", "code": "BAM"},
  {"country": "Barbadian dollar", "code": "BBD"},
  {"country": "Bangladeshi taka", "code": "BDT"},
  {"country": "Bulgarian lev", "code": "BGN"},
  {"country": "Bahraini dinar", "code": "BHD"},
  {"country": "Burundian franc", "code": "BIF"},
  {"country": "Bermudian dollar", "code": "BMD"},
  {"country": "Brunei dollar", "code": "BND"},
  {"country": "Bolivian boliviano", "code": "BOB"},
  {"country": "Brazilian real", "code": "BRL"},
  {"country": "Bahamian dollar", "code": "BSD"},
  {"country": "Bhutanese ngultrum", "code": "BTN"},
  {"country": "Botswana pula", "code": "BWP"},
  {"country": "Belarusian ruble", "code": "BYN"},
  {"country": "Belize dollar", "code": "BZD"},
  {"country": "Canadian dollar", "code": "CAD"},
  {"country": "Congolese franc", "code": "CDF"},
  {"country": "Swiss franc", "code": "CHF"},
  {"country": "Chilean peso", "code": "CLP"},
  {"country": "Chinese yuan", "code": "CNY"},
  {"country": "Colombian peso", "code": "COP"},
  {"country": "Costa Rican colón", "code": "CRC"},
  {"country": "Cuban convertible peso", "code": "CUC"},
  {"country": "Cuban peso", "code": "CUP"},
  {"country": "Cape Verdean escudo", "code": "CVE"},
  {"country": "Czech koruna", "code": "CZK"},
  {"country": "Djiboutian franc", "code": "DJF"},
  {"country": "Danish krone", "code": "DKK"},
  {"country": "Dominican peso", "code": "DOP"},
  {"country": "Algerian dinar", "code": "DZD"},
  {"country": "Egyptian pound", "code": "EGP"},
  {"country": "Eritrean nakfa", "code": "ERN"},
  {"country": "Ethiopian birr", "code": "ETB"},
  {"country": "Fijian dollar", "code": "FJD"},
  {"country": "Falkland Islands pound", "code": "FKP"},
  {"country": "British pound", "code": "GBP"},
  {"country": "Georgian lari", "code": "GEL"},
  {"country": "Guernsey pound", "code": "GGP"},
  {"country": "Ghanaian cedi", "code": "GHS"},
  {"country": "Gibraltar pound", "code": "GIP"},
  {"country": "Gambian dalasi", "code": "GMD"},
  {"country": "Guinean franc", "code": "GNF"},
  {"country": "Guatemalan quetzal", "code": "GTQ"},
  {"country": "Guyanese dollar", "code": "GYD"},
  {"country": "Hong Kong dollar", "code": "HKD"},
  {"country": "Honduran lempira", "code": "HNL"},
  {"country": "Croatian kuna", "code": "HRK"},
  {"country": "Haitian gourde", "code": "HTG"},
  {"country": "Hungarian forint", "code": "HUF"},
  {"country": "Indonesian rupiah", "code": "IDR"},
  {"country": "Israeli new shekel", "code": "ILS"},
  {"country": "Indian rupee", "code": "INR"},
  {"country": "Iraqi dinar", "code": "IQD"},
  {"country": "Iranian rial", "code": "IRR"},
  {"country": "Icelandic króna", "code": "ISK"},
  {"country": "Jamaican dollar", "code": "JMD"},
  {"country": "Jordanian dinar", "code": "JOD"},
  {"country": "Japanese yen", "code": "JPY"},
  {"country": "Kenyan shilling", "code": "KES"},
  {"country": "Kyrgyzstani som", "code": "KGS"},
  {"country": "Cambodian riel", "code": "KHR"},
  {"country": "Kazakhstani tenge", "code": "KZT"},
  {"country": "Lebanese pound", "code": "LBP"},
  {"country": "Sri Lankan rupee", "code": "LKR"},
  {"country": "Liberian dollar", "code": "LRD"},
  {"country": "Lesotho loti", "code": "LSL"},
  {"country": "Libyan dinar", "code": "LYD"},
  {"country": "Moroccan dirham", "code": "MAD"},
  {"country": "Moldovan leu", "code": "MDL"},
  {"country": "Malagasy ariary", "code": "MGA"},
  {"country": "Macedonian denar", "code": "MKD"},
  {"country": "Burmese kyat", "code": "MMK"},
  {"country": "Mongolian tögrög", "code": "MNT"},
  {"country": "Macanese pataca", "code": "MOP"},
  {"country": "Mauritanian ouguiya", "code": "MRU"},
  {"country": "Mauritian rupee", "code": "MUR"},
  {"country": "Maldivian rufiyaa", "code": "MVR"},
  {"country": "Malawian kwacha", "code": "MWK"},
  {"country": "Mexican peso", "code": "MXN"},
  {"country": "Malaysian ringgit", "code": "MYR"},
  {"country": "Mozambican metical", "code": "MZN"},
  {"country": "Namibian dollar", "code": "NAD"},
  {"country": "Nigerian naira", "code": "NGN"},
  {"country": "Nicaraguan córdoba", "code": "NIO"},
  {"country": "Norwegian krone", "code": "NOK"},
  {"country": "Nepalese rupee", "code": "NPR"},
  {"country": "New Zealand dollar", "code": "NZD"},
  {"country": "Omani rial", "code": "OMR"},
  {"country": "Panamanian balboa", "code": "PAB"},
  {"country": "Peruvian sol", "code": "PEN"},
  {"country": "Papua New Guinean kina", "code": "PGK"},
  {"country": "Philippine peso", "code": "PHP"},
  {"country": "Pakistani rupee", "code": "PKR"},
  {"country": "Polish złoty", "code": "PLN"},
  {"country": "Transnistrian ruble", "code": "PRB"},
  {"country": "Paraguayan guaraní", "code": "PYG"},
  {"country": "Qatari riyal", "code": "QAR"},
  {"country": "Romanian leu", "code": "RON"},
  {"country": "Serbian dinar", "code": "RSD"},
  {"country": "Russian ruble", "code": "RUB"},
  {"country": "Rwandan franc", "code": "RWF"},
  {"country": "Saudi riyal", "code": "SAR"},
  {"country": "Swedish krona", "code": "SEK"},
  {"country": "Singapore dollar", "code": "SGD"},
  {"country": "Saint Helena pound", "code": "SHP"},
  {"country": "Sierra Leonean leone", "code": "SLL"},
  {"country": "Somaliland shilling", "code": "SLS"},
  {"country": "Somali shilling", "code": "SOS"},
  {"country": "Surinamese dollar", "code": "SRD"},
  {"country": "South Sudanese pound", "code": "SSP"},
  {"country": "São Tomé and Príncipe dobra", "code": "STN"},
  {"country": "Syrian pound", "code": "SYP"},
  {"country": "Swazi lilangeni", "code": "SZL"},
  {"country": "Thai baht", "code": "THB"},
  {"country": "Tajikistani somoni", "code": "TJS"},
  {"country": "Turkmenistan manat", "code": "TMT"},
  {"country": "Tunisian dinar", "code": "TND"},
  {"country": "Tongan paʻanga", "code": "TOP"},
  {"country": "Turkish lira", "code": "TRY"},
  {"country": "Trinidad and Tobago dollar", "code": "TTD"},
  {"country": "Tuvaluan dollar", "code": "TVD"},
  {"country": "New Taiwan dollar", "code": "TWD"},
  {"country": "Tanzanian shilling", "code": "TZS"},
  {"country": "Ukrainian hryvnia", "code": "UAH"},
  {"country": "Ugandan shilling", "code": "UGX"},
  {"country": "United States dollar", "code": "USD"},
  {"country": "Uruguayan peso", "code": "UYU"},
  {"country": "Uzbekistani soʻm", "code": "UZS"},
  {"country": "Venezuelan bolívar soberano", "code": "VES"},
  {"country": "Vietnamese đồng", "code": "VND"},
  {"country": "Vanuatu vatu", "code": "VUV"},
  {"country": "Samoan tālā", "code": "WST"},
  {"country": "Central African CFA franc", "code": "XAF"},
  {"country": "Eastern Caribbean dollar", "code": "XCD"},
  {"country": "West African CFA franc", "code": "XOF"},
  {"country": "CFP franc", "code": "XPF"},
  {"country": "South African rand", "code": "ZAR"},
  {"country": "Zambian kwacha", "code": "ZMW"},
  {"country": "Zimbabwean bonds", "code": "ZWB"},
];
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