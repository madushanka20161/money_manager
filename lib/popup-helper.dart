import 'package:flutter/material.dart';
import 'package:money_manager_3/helper/config.dart';

class PopupHelper {
  static final PopupHelper _instance = PopupHelper._internal();

  factory PopupHelper() {
    return _instance;
  }

  PopupHelper._internal();

  static void showPopup(BuildContext context, List<Widget> content) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.all(AppConfig.popupRadius),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.borderRadius)
          ),
          children: content,
        );
      },
    );
  }
}
