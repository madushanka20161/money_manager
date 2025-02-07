// id|name|currency|balance|createdDate|isAddToTotal|icon|iconColor

import 'package:flutter/material.dart';
import 'package:money_manager_3/helper/index.dart';

class AccountDto {
  final String id;
  final String name;
  double balance;
  final String currency;
  final DateTime createdDate;
  final bool isAddToTotal;
  final IconData icon;
  final Color iconColor;

  AccountDto({
    required this.id,
    required this.name, 
    this.balance = 0.0,
    this.currency = 'USD',
    DateTime? createdDate,
    this.isAddToTotal = true,
    this.icon = Icons.account_balance,
    this.iconColor = Colors.blue,
  }) : createdDate = createdDate ?? DateTime.now();

  factory AccountDto.fromJson(Map<String, dynamic> json) {
    return AccountDto(
      id: json['id'],
      name: json['name'],
      balance: json['balance'], 
      currency: json['currency'],
      createdDate: DateTime.parse(json['createdDate']),
      isAddToTotal: json['isAddToTotal'],
      icon: accountIconMap[json['icon']] ?? Icons.account_balance,
      iconColor: colorMap[json['iconColor']] ?? Colors.blue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'currency': currency,
      'createdDate': createdDate.toIso8601String(),
      'isAddToTotal': isAddToTotal,
      'icon': iconToString(icon),
      'iconColor': colorToString(iconColor),
    };
  }

  String iconToString(IconData icon) {
    for (var entry in accountIconMap.entries) {
      if (entry.value == icon) {
        return entry.key;
      }
    }
   
    throw Exception('[account dto - icon to string] No $icon in accountIconMap');
  }

  String colorToString(Color color) {
    for (var entry in colorMap.entries) {
      if (entry.value == color) {
        return entry.key;
      }
    }
   
    throw Exception('[account dto - color to string] No $color in colorMap');
  }

  // factory AccountDto.fromPipedString(String pipedString) {
  //   List<String> parts = pipedString.split('|');
  //   return AccountDto(
  //     id: parts[0],
  //     name: parts[1],
  //     currency: parts[2],
  //     balance: double.parse(parts[3]),
  //     createdDate: DateTime.parse(parts[4].isNotEmpty ? parts[4] : DateTime.now().toIso8601String()),
  //     isAddToTotal: parts[5].toLowerCase() == 'true',
  //   );
  // }
}