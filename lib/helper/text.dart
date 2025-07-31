import 'package:flutter/material.dart';
import 'package:money_manager_3/helper/config.dart';

/* Use with Row, Column, Flex */
Widget flexibleEllipsisText(String text) {
  return Flexible(
    child: ellipsisText(text)
  );
}

Widget ellipsisText(String text) {
  return Tooltip(
      message: text,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        softWrap: false,
        style: AppConfig.fontStyle,
      ),
  );
}

/* Use with Row, Column, Flex */
Widget flexibleEllipsisHeaderText(String text) {
  return Flexible(
    child: ellipsisHeaderText(text)
  );
}

Widget ellipsisHeaderText(String text) {
  return Flexible(
    child: Tooltip(
      message: text,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        softWrap: false,
        style: TextStyle(fontSize: AppConfig.headerFontSize, fontWeight: FontWeight.bold, color: AppConfig.fontColor)
      ),
    ),
  );
}