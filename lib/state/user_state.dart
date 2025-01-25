import 'package:flutter/material.dart';
// import 'package:money_manager_3/dto/user_dto.dart';

class UserState with ChangeNotifier {
  // UserDTO? _user;
  String? _defaultTimePeriod;

  // UserDTO? get user => _user;
  String? get defaultTimePeriod => _defaultTimePeriod;

  // void setUser(UserDTO user) {
  //   _user = user;
  //   notifyListeners();
  // }

  // void clearUser() {
  //   _user = null;
  //   notifyListeners();
  // }

  void setDefaultTimePeriod(String timePeriod) {
    _defaultTimePeriod = timePeriod;
    notifyListeners();
  }
}