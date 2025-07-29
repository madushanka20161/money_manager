import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/account_dto.dart';
import 'package:money_manager_3/dto/account_trnsaction_dto.dart';
import 'package:money_manager_3/dto/category_dto.dart';
import 'package:money_manager_3/dto/transaction_dto.dart';
import 'package:money_manager_3/enum/index.dart';

class AppState with ChangeNotifier {
  final Map<String, AccountDto> _accounts = {};
  final Map<String, TransactionDto> _transactions = {};
  final Map<String, CategoryDTO> _categories = {};
  String _selectedAccountId = '';
  TransactionType _selectedTransactionType = TransactionType.expenses;
  late DateTime _startDate;
  late DateTime _endDate;
  bool _isLoading = true;
  bool _isSignIn = false;
  bool _isFirstLogin = false;
  final Map<String, AccountTransactionDTO> _accountTrnsactions = {};

  Map<String, AccountDto> get accounts => _accounts;
  Map<String, TransactionDto> get transactions => _transactions;
  Map<String, CategoryDTO> get categories => _categories;
  String get selectedAccountId => _selectedAccountId;
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  bool get isLoading => _isLoading;
  bool get isSignIn => _isSignIn;
  bool get isFirstLogin => _isFirstLogin;
  TransactionType get selectedTransactionType => _selectedTransactionType;
  Map<String, AccountTransactionDTO> get accountTrnsactions => _accountTrnsactions;
  // to maintain a version for persisten data (user, category, trnsaction)
  int get userDataVersion => 1;

  void clearAll() {
    _accounts.clear();
    _transactions.clear();
    _categories.clear();
    _accountTrnsactions.clear();
    _selectedAccountId = '';
    _selectedTransactionType = TransactionType.expenses;
    // _startDate;
    // _endDate;
    // _isLoading = true;
    // _isSignIn = false;
  }

  void addAccount(String id, AccountDto account) {
    _accounts[id] = account;
    notifyListeners();
  }

  void removeAccount(String id) {
    _accounts.remove(id);
    notifyListeners();
  }

  void addTransaction(String id, TransactionDto transaction) {
    _transactions[id] = transaction;
    notifyListeners();
  }

  void removeTransaction(String id) {
    _transactions.remove(id);
    notifyListeners();
  }

  void addCategory(String id, CategoryDTO category) {
    _categories[id] = category;
    notifyListeners();
  }

  void removeCategory(String id) {
    _categories.remove(id);
    notifyListeners();
  }

  void setSelectedAccountId(String id) {
    _selectedAccountId = id;
    notifyListeners();
  }

  void setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void setIsSignIn(bool isSignIn) {
    _isSignIn = isSignIn;
    notifyListeners();
  }

  void setIsFirstLogin(bool isFirstLogin) {
    _isFirstLogin = isFirstLogin;
    notifyListeners();
  }

  void setDateRange(DateTime startDate, DateTime endDate) {
    _startDate = startDate;
    _endDate = endDate;
    notifyListeners();
  }

  void setSelectedTransactionType(TransactionType type) {
    _selectedTransactionType = type;
    notifyListeners();
  }

  void addAccountTrnsaction(String id, AccountTransactionDTO accountTrnsaction) {
    _accountTrnsactions[id] = accountTrnsaction;
    notifyListeners();
  }

  void removeAccountTrnsaction(String id) {
    _accountTrnsactions.remove(id);
    notifyListeners();
  }
}