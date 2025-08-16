class GeneralException implements Exception {
  final String message;
  final String? details;

  GeneralException(this.message, [this.details]);

  @override
  String toString() {
    return '$message${details != null ? ' — $details' : ''}';
  }
}

// import 'package:flutter/material.dart';

// void debugError(String error, String clasName, String methodName) {
//   debugPrint("🔴🔴🔴🔴🔴🔴🔴🔴🔴 ERROR: $error");
//   debugPrint("FROM: $clasName -->> $methodName");
//   debugPrint("-----------------------------");
// }

// // debugPrint("🟢 SUCCESS: Everything looks good");
// // debugPrint("⚠️ WARNING: Check this value");