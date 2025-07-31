import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/user_dto.dart';

class UserState with ChangeNotifier {
  UserDTO? _user;
  String? _selectedTimePeriod;
  String? _defaultTimePeriod;
  int? _defaultDecimalPlace;
  String? _defaultNumberFormat;
  String? _defaultCurrency;

  UserDTO? get user => _user;
  String? get selectedTimePeriod => _selectedTimePeriod;
  String? get defaultTimePeriod => _defaultTimePeriod;
  int? get defaultDecimalPlace => _defaultDecimalPlace;
  String? get defaultNumberFormat => _defaultNumberFormat;
  String? get defaultCurrency => _defaultCurrency;

  void setUser(UserDTO user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  void setSelectedTimePeriod(String value) {
    _selectedTimePeriod = value;
    notifyListeners();
  }

  void setDefaultTimePeriod(String timePeriod) {
    _defaultTimePeriod = timePeriod;
    notifyListeners();
  }

  void setDefaultDecimalPlace(String value) {
    _defaultDecimalPlace = int.parse(value);
    notifyListeners();
  }

  void setDefaultNumberFormat(String value) {
    _defaultNumberFormat = value;
    notifyListeners();
  }

  void setDefaultCurrency(String value) {
    _defaultCurrency = value;
    notifyListeners();
  }
}