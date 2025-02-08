import 'package:money_manager_3/dto/account_dto.dart';

class AccountTransactionDTO {
  final String id;
  final AccountDto fromAccount;
  final AccountDto toAccount;
  final double amount;
  final double toAmount;
  final DateTime date;
  final String description;

  AccountTransactionDTO({
    required this.id,
    required this.fromAccount,
    required this.toAccount,
    required this.amount,
    required this.toAmount,
    required this.date,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromAccount': fromAccount.id,
      'toAccount': toAccount.id,
      'fromAmount': amount,
      'toAmount': toAmount,
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  factory AccountTransactionDTO.fromJson(Map<String, dynamic> json) {
    return AccountTransactionDTO(
      id: json['id'],
      fromAccount: json['fromAccount'],
      toAccount: json['toAccount'],
      amount: json['fromAmount'],
      toAmount: json['toAmount'],
      date: DateTime.parse(json['date']),
      description: json['description'],
    );
  }
}