import 'package:money_manager_3/dto/category_dto.dart';
import 'package:money_manager_3/dto/transaction_dto.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/state/app_state.dart';

List<List<TransactionDto>> filterTrnsaction(AppState appState, CategoryDTO? category) {
  final transactions = appState.transactions;
  final selectedAccountId = appState.selectedAccountId;
  DateTime startDate = appState.startDate;
  DateTime endDate = appState.endDate;
  List<TransactionDto> filterTransactions = [];

  // filter transactions based on time period
  filterTransactions = transactions.values.where((transaction) => transaction.date == startDate || transaction.date.isAfter(startDate) && transaction.date.isBefore(endDate)).toList();

  if (selectedAccountId != '') {
    filterTransactions = filterTransactions.where((transaction) => transaction.account == selectedAccountId).toList();
  }

  if (category != null) {
    filterTransactions = filterTransactions.where((transaction) => transaction.category == category.id).toList();
  }

  filterTransactions.sort((a, b) => a.date.compareTo(b.date));
    
  List<TransactionDto> income = filterTransactions.where((transaction) => transaction.type == TransactionType.income).toList();
  List<TransactionDto> expenses = filterTransactions.where((transaction) => transaction.type == TransactionType.expenses).toList();
    
  return [income, expenses]; 
}