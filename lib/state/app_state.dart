import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/account_dto.dart';
import 'package:money_manager_3/dto/category_dto.dart';
import 'package:money_manager_3/dto/transaction_dto.dart';

class AppState with ChangeNotifier {
  final Map<String, AccountDto> _accounts = {};
  final Map<String, TransactionDto> _transactions = {};
  final Map<String, CategoryDTO> _categories = {};

  Map<String, AccountDto> get accounts => _accounts;
  Map<String, TransactionDto> get transactions => _transactions;
  Map<String, CategoryDTO> get categories => _categories;

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
}