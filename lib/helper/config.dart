import 'package:flutter/material.dart';

class AppConfig {
  static int decimalPlace = 2;

  static double headerFontSize = 30.0;
  static double fontSize = 18.0;
  static Color fontColor = Colors.white;
  static Color buttonSelectedColor =  Color.fromARGB(144, 23, 96, 156);
  // icon
  static double iconSize = 30;
  static double iconSizeSmall = iconSize * 0.8;
  static Color iconColor = fontColor;
  // error
  static Color errorFontColor = Colors.red;
  static double errorFontSize = 12.0;
  // padding
  static double paddingSmall = 5;
  static double padding = 10;
  static double paddingXLarge = 20;
  // border
  static double borderRadius = 10;
  static Color borderColor = Colors.grey;
  static Color focusedBorderColor = buttonSelectedColor;
  static double borderWidth = 1.5;
  static BorderRadius borderRadiusAll = BorderRadius.all(Radius.circular(AppConfig.borderRadius));
  // popup
  static double popupRadius = borderRadius;
  // radio button
  static Color activeColor = Colors.white;

  static TextStyle fontStyle = TextStyle(fontSize: AppConfig.fontSize, color: AppConfig.fontColor);
  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    padding: EdgeInsets.zero,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConfig.borderRadius),
    ),
  );
}