import 'package:money_manager_3/dto/default_dto.dart';

class UserStateService {
  // Private constructor
  UserStateService._privateConstructor();

  // The single instance of the class
  static final UserStateService instance = UserStateService._privateConstructor();

  String? _defaultTimePeriod;
  int? _defaultDecimalPlace;
  String? _defaultCurrency;
  String? _defaultNumberSeperationStyle;


  void init(DefaultDto defaultDto) {
    _defaultTimePeriod = defaultDto.defaultTimePeriod;
    _defaultDecimalPlace = defaultDto.defaultDecimalPlace;
    _defaultCurrency = defaultDto.defaultCurrency;
    _defaultNumberSeperationStyle = defaultDto.defaultNumberSeperationStyle;
  }

  void setDefaultCurrency(String currency) {
    _defaultCurrency = currency;
  }

  void setDefaultTimePeriod(String timePeriod) {
    _defaultTimePeriod = timePeriod;
  }

  void setDefaultDecimalPlaces(String decimalPlaces) {
    _defaultDecimalPlace = int.parse(decimalPlaces);
  }

  void setDefaultNumberFormatStyle(String numberFormat) {
    _defaultNumberSeperationStyle = numberFormat;
  }

  String? get defaultTimePeriod => _defaultTimePeriod;
  String? get defaultCurrency => _defaultCurrency;
  String? get defaultNumberSeperationStyle => _defaultNumberSeperationStyle;
  int? get defaultDecimalPlace => _defaultDecimalPlace;
  DefaultDto get defaultDto => DefaultDto(
    defaultTimePeriod: _defaultTimePeriod!, 
    defaultCurrency: defaultCurrency!, 
    defaultDecimalPlace: defaultDecimalPlace!, 
    defaultNumberSeperationStyle: defaultNumberSeperationStyle!
  );
}
