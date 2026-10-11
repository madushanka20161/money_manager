import 'package:flutter/material.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/helper/index.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.iconColor,
    this.width,
    this.height,
    this.isSelected = false,
    this.fontSize,
    this.iconColorOpacity,
    this.isTooltip = false,
    this.onClick,
  });

  final IconData icon;
  final String text;
  final double? width;
  final double? height;
  final bool isSelected;
  final Color iconColor;
  final double? fontSize;
  final double? iconColorOpacity;
  final bool isTooltip;
  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context) {
    final category = _buildCategory();

    return isTooltip
      ? Tooltip(
        message: capitalizeFirstLetter(text),
        decoration: BoxDecoration(
          color: AppConfig.tooltipBackgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: AppConfig.fontStyle,
        child: category,
      )
      : 
      category;
  }

  Widget _buildCategory() {
    final content = Container(
      padding: EdgeInsets.symmetric(horizontal: AppConfig.padding),
      width: width ?? 80,
      height: height ?? 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppConfig.fontColor,
            size: AppConfig.iconSize,
          ),
          Padding(
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

    return Material(
      color: isSelected ? iconColor : iconColor.withOpacity(iconColorOpacity ?? 0.4),
      borderRadius: BorderRadius.circular(AppConfig.borderRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        onTap: onClick,
        child: content,
      ),
    );
  }
}