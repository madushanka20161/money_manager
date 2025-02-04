import 'package:money_manager_3/dto/account_dto.dart';
import 'package:money_manager_3/dto/category_dto.dart';
import 'package:money_manager_3/enum/index.dart';

// id|account|amount|category|type|date|description

class TransactionDto {
  String id;
  AccountDto account;
  double amount;
  CategoryDTO category;
  TransactionType type;
  DateTime date;
  String description;

  TransactionDto({
    required this.id,
    required this.account,
    required this.amount,
    required this.category,
    required this.type,
    required this.date,
    required this.description,
  });

  factory TransactionDto.fromJson(Map<String, dynamic> json) {
    return TransactionDto(
      id: json['id'],
      account: json['account'],
      amount: json['amount'],
      category: json['category'],
      type: json['type'] == 'income' ? TransactionType.income : TransactionType.expenses,
      date: DateTime.parse(json['date']),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account': account.id,
      'amount': amount,
      'category': category.id,
      'type': type.displayName,
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  // factory TransactionDto.fromPipedString(String pipedString) {
  //   List<String> parts = pipedString.split('|');
    
  //   return TransactionDto(
  //     id: parts[0],
  //     account: parts[1],
  //     amount: double.parse(parts[2]),
  //     category: parts[3],
  //     type: parts[4] == 'income' ? TransactionType.income : TransactionType.expenses,
  //     date: DateTime.parse(parts[5]),
  //     description: parts[6],
  //   );
  // }
}