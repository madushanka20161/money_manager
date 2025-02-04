import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/category_dto.dart';
import 'package:money_manager_3/dto/transaction_dto.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/service/database_service.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:uuid/uuid.dart';

class SharedService {
  SharedService._privateConstructor();
  static final SharedService instance = SharedService._privateConstructor();

  DatabaseService? databaseService;
  AppState? appState;
  int count = 1;

  void init(AppState appState) {
    databaseService = DatabaseService.instance;
    this.appState = appState;
  }

  String generateUniqueId(String prefix) {
    String uniqueKey = Uuid().v4();
    bool isExit = false;

    switch (prefix) {
      case 'CA':
        isExit = appState?.categories[uniqueKey] == null ? false : true;
        break;
      case 'TA':
        isExit = appState?.transactions[uniqueKey] == null ? false : true;
        break;
      default:
        throw Exception('[shared service - generate unique id] Invalid Prefix');
    }

    if (isExit) {
      uniqueKey = generateUniqueId(prefix); 
    }

    return uniqueKey;
  }

  void createCategory(String name, IconData icon, Color iconColor, TransactionType type) {
    CategoryDTO category = CategoryDTO(
      id: generateUniqueId('CA'), 
      name: name, 
      type: type, 
      icon: icon,
      iconColor: iconColor
    );
    
    appState!.addCategory(category.id, category);
    String categoryString = jsonEncode(appState!.categories);
    databaseService!.saveData('category', categoryString);
  }

  void createTransaction(TransactionType type, String accountId, double amount, String category, DateTime date, String? description) {
    TransactionDto transaction = TransactionDto(
      id: generateUniqueId('TA'), 
      account: accountId, 
      amount: amount, 
      category: category, 
      type: type, 
      date: date, 
      description: description ?? ''
    );

    appState!.addTransaction(transaction.id, transaction);
    String transactionString = jsonEncode(appState!.transactions);
    databaseService!.saveData('transaction', transactionString);
  }
}