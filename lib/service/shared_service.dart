import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/account_dto.dart';
import 'package:money_manager_3/dto/account_trnsaction_dto.dart';
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
      case 'AC':
        isExit = appState?.accounts[uniqueKey] == null ? false : true;
        break;
      case 'AT':
        isExit = appState?.accountTrnsactions[uniqueKey] == null ? false : true;
        break;
      default:
        throw Exception('[shared service - generate unique id] Invalid Prefix');
    }

    if (isExit) {
      uniqueKey = generateUniqueId(prefix); 
    }

    return uniqueKey;
  }

  void createCategory(String name, IconData icon, Color iconColor, TransactionType type, CategoryLimitDTO limit) {
    CategoryDTO category = CategoryDTO(
      id: generateUniqueId('CA'), 
      name: name, 
      type: type, 
      icon: icon,
      iconColor: iconColor,
      limit: limit,
    );
    
    appState!.addCategory(category.id, category);
    _updateCategoryStore();
  }

  void updateCategoryLimit(String categoryId, CategoryLimitType limitType, double limit) {
    CategoryDTO category = appState!.categories[categoryId]!;
    
    category.limit.type = limitType;
    category.limit.limit = limit;

    appState!.addCategory(category.id, category);
    _updateCategoryStore();
  }

  void createTransaction(TransactionType type, String accountId, double amount, String category, DateTime date, String? description, String? transactionId) {
    AccountDto account = appState!.accounts[accountId]!;

    if (transactionId == null) {
      account.balance = account.balance - amount;
    } else {
      TransactionDto oldTrnsaction = appState!.transactions[transactionId]!;
      account.balance = account.balance + oldTrnsaction.amount - amount;
    }

    TransactionDto transaction = TransactionDto(
      id: transactionId ?? generateUniqueId('TA'), 
      account: account, 
      amount: amount, 
      category: appState!.categories[category]!, 
      type: type, 
      date: date, 
      description: description ?? ''
    );

    appState!.addAccount(account.id, account);
    _updateAccountStore();

    appState!.addTransaction(transaction.id, transaction);
    _updateTransactionStore();
  }

  void deleteTransaction(TransactionDto trnsaction) {
    AccountDto account = trnsaction.account;
    account.balance = account.balance + trnsaction.amount;

    appState!.removeTransaction(trnsaction.id);
    appState!.addAccount(account.id, account);
    
    _updateTransactionStore();
    _updateAccountStore();
  }

  void createAccount(String name, double balance, String currency, bool isAddToTotal, Color iconColor, IconData icon, String? accountId) {
    AccountDto account = AccountDto(
      id: accountId ?? generateUniqueId('AC'), 
      name: name,
      balance: balance,
      currency: currency,
      isAddToTotal: isAddToTotal,
      iconColor: iconColor,
      icon: icon
    );

    appState!.addAccount(account.id, account);
    _updateAccountStore();
  }

  void createAccounttrnsaction(String fromId, String toId, double amount, double toAmount, DateTime date, String? description, String? id) {
    Map<String, AccountDto> accounts = appState!.accounts;
    AccountDto fromAccount = accounts[fromId]!;
    AccountDto toAccount = accounts[toId]!;

    if (id == null) {
      fromAccount.balance = fromAccount.balance - amount;
      toAccount.balance = toAccount.balance + toAmount;
    } else {
      AccountTransactionDTO oldAccountTrnsaction = appState!.accountTrnsactions[id]!;
      fromAccount.balance = fromAccount.balance + oldAccountTrnsaction.amount - amount;
      toAccount.balance = toAccount.balance - oldAccountTrnsaction.amount + toAmount;
    }
    
    AccountTransactionDTO accountTrnsaction = AccountTransactionDTO(
      id: id ?? generateUniqueId('AT'),
      fromAccount: fromAccount, 
      toAccount: toAccount, 
      amount: amount, 
      toAmount: toAmount, 
      date: date, 
      description: description ?? ''
    );

    appState!.addAccountTrnsaction(accountTrnsaction.id, accountTrnsaction);
    appState!.addAccount(fromAccount.id, fromAccount);
    appState!.addAccount(toAccount.id, toAccount);

    _updateAccountTransactionStore();
    _updateAccountStore();
  }

  void deleteAccounttrnsaction(String id) {
    Map<String, AccountTransactionDTO> trnsactions = appState!.accountTrnsactions;

    if (trnsactions[id] != null) {
      AccountTransactionDTO trnsaction = trnsactions[id]!;
      Map<String, AccountDto> accounts = appState!.accounts;
      AccountDto fromAccount = accounts[trnsaction.fromAccount.id]!;
      AccountDto toAccount = accounts[trnsaction.toAccount.id]!;

      fromAccount.balance = fromAccount.balance + trnsaction.amount;
      toAccount.balance = toAccount.balance - trnsaction.toAmount;

      appState!.addAccount(fromAccount.id, fromAccount);
      appState!.addAccount(toAccount.id, toAccount); 
      appState!.removeAccountTrnsaction(id);

      _updateAccountTransactionStore();
      _updateAccountStore();
    }
  }

  void _updateCategoryStore() {
    String categoryString = jsonEncode(appState!.categories);
    databaseService!.saveData('category', categoryString);
  }

  void _updateAccountStore() {
    String accountsString = jsonEncode(appState!.accounts);
    databaseService!.saveData('account', accountsString);
  }

  void _updateTransactionStore() {
    String transactionString = jsonEncode(appState!.transactions);
    databaseService!.saveData('transaction', transactionString);
  }

  void _updateAccountTransactionStore() {
    String accountTransactionString = jsonEncode(appState!.accountTrnsactions);
    databaseService!.saveData('account-trnsaction', accountTransactionString);
  }
}