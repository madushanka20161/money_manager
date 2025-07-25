import 'package:flutter/material.dart';
import 'package:money_manager_3/helper/config.dart';

class PopupHelper {
  static final PopupHelper _instance = PopupHelper._internal();

  factory PopupHelper() {
    return _instance;
  }

  PopupHelper._internal();

  static void showPopup(BuildContext context, List<Widget> content, {bool? isFullWidth}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          insetPadding: (isFullWidth == true)
              ? const EdgeInsets.symmetric(horizontal: 5.0, vertical: 24.0)
              : const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
          backgroundColor: AppConfig.popupBKColor,
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
