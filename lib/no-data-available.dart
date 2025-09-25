import 'package:flutter/material.dart';
import 'package:money_manager_3/helper/config.dart';

class NoDataAvailable extends StatelessWidget {
  final String message;

  const NoDataAvailable({Key? key, this.message = "No Data Available"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon(
          //   Icons.info_outline,
          //   size: 48,
          //   color: Colors.grey,
          // ),
          // SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: AppConfig.fontSize,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
