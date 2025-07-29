class DefaultDto {
  final String defaultTimePeriod;
  final String defaultCurrency;
  final int defaultDecimalPlace;
  final String defaultNumberSeperationStyle;

  DefaultDto({
    required this.defaultTimePeriod,
    required this.defaultCurrency,
    required this.defaultDecimalPlace,
    required this.defaultNumberSeperationStyle,
  });

  factory DefaultDto.fromJson(Map<String, dynamic> json) {
    return DefaultDto(
      defaultTimePeriod: json['defaultTimePeriod'],
      defaultCurrency: json['defaultCurrency'],
      defaultDecimalPlace: json['defaultDecimalPlace'],
      defaultNumberSeperationStyle: json['defaultNumberSeperationStyle'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'defaultTimePeriod': defaultTimePeriod,
      'defaultCurrency': defaultCurrency,
      'defaultDecimalPlace': defaultDecimalPlace,
      'defaultNumberSeperationStyle': defaultNumberSeperationStyle,
    };
  }
}