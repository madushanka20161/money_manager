import 'package:flutter/material.dart';
import 'package:money_manager_3/enum/index.dart';

// id|name|type|icon

class CategoryDTO {
  final String id;
  final String name;
  final TransactionType type;
  final IconData icon;

  CategoryDTO({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
  });

  factory CategoryDTO.fromJson(Map<String, dynamic> json) {
    return CategoryDTO(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'icon': icon,
    };
  }

  factory CategoryDTO.fromPipedString(String str) {
    final parts = str.split('|');
    return CategoryDTO(
      id: parts[0],
      name: parts[1],
      type: parts[2] == 'income' ? TransactionType.income : TransactionType.expenses,
      icon: iconMap[parts[3]] ?? Icons.error,
    );
  }

  static const Map<String, IconData> iconMap = {
    'Icons.attach_money': Icons.attach_money,
    'Icons.shopping_cart': Icons.shopping_cart,
    'Icons.home': Icons.home,
  };
}