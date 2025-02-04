import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  // final Color color;
  final double? width;
  final bool isSelected;
  final Color iconColor;

  const CategoryWidget({
    required this.icon,
    required this.text,
    // required this.color
    this.width,
    this.isSelected = false,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 70,
      color: isSelected ? Colors.amber : Colors.transparent,
      child: Column(
        children: [
          Icon(icon, color: iconColor,),
          Text(
            text,
            overflow: TextOverflow.visible,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}