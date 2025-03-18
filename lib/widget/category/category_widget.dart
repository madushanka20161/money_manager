import 'package:flutter/material.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/helper/index.dart';

class CategoryWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final double? width;
  final double? height;
  final bool isSelected;
  final Color iconColor;
  final double? fontSize;
  final double? iconColorOpacity;
  final bool isTooltip;


  const CategoryWidget({
    required this.icon,
    required this.text,
    this.width,
    this.height,
    this.isSelected = false,
    required this.iconColor,
    this.fontSize,
    this.iconColorOpacity,
    this.isTooltip = false,
  });

  @override
  Widget build(BuildContext context) {
    return isTooltip
        ? Tooltip(
            message: capitalizeFirstLetter(text),
            decoration: BoxDecoration(
              color: AppConfig.tooltipBackgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: AppConfig.fontStyle,
            child: renderCategory(),
          )
        : renderCategory();
  }

  Widget renderCategory() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        color: isSelected ? iconColor : iconColor.withOpacity(iconColorOpacity ?? 0.4),
      ),
      padding: EdgeInsets.symmetric(horizontal: AppConfig.padding),
      width: width ?? 50,
      height: height ?? 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon, 
            color: AppConfig.fontColor, 
            size: AppConfig.iconSize,
          ),
          Container(
            padding: EdgeInsets.only(top: AppConfig.paddingSmall),
              child: Text(
              capitalizeFirstLetter(text),
              overflow: TextOverflow.fade,
              softWrap: false,
              maxLines: 1,
              style: TextStyle(
                color: AppConfig.fontColor, 
                fontSize: fontSize ?? AppConfig.fontSize * 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}