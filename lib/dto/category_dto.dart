import 'package:flutter/material.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/helper/index.dart';

// id|name|type|icon|iconColor

class CategoryDTO {
  final String id;
  final String name;
  final TransactionType type;
  final IconData icon;
  final Color iconColor;

  CategoryDTO({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    this.iconColor = Colors.blue,
  });

  factory CategoryDTO.fromJson(Map<String, dynamic> json) {
    return CategoryDTO(
      id: json['id'],
      name: json['name'],
      type: json['type'] == 'income' ? TransactionType.income : TransactionType.expenses,
      icon: iconMap[json['icon']] ?? Icons.error,
      iconColor: colorMap[json['iconColor']] ?? Colors.blue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.displayName,
      'icon': iconToString(icon),
      'iconColor': colorToString(iconColor),
    };
  }

  String iconToString(IconData icon) {
    for (var entry in iconMap.entries) {
      if (entry.value == icon) {
        return entry.key;
      }
    }
   
    throw Exception('[category dto - icon to string] No $icon in iconMap');
  }

  String colorToString(Color color) {
    for (var entry in colorMap.entries) {
      if (entry.value == color) {
        return entry.key;
      }
    }
   
    throw Exception('[category dto - color to string] No $color in colorMap');
  }
}