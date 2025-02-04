class UserStateService {
  // Private constructor
  UserStateService._privateConstructor();

  // The single instance of the class
  static final UserStateService instance = UserStateService._privateConstructor();

  String? _defaultTimePeriod;

  Future<void> init(String timePeriod) async {
    _defaultTimePeriod = timePeriod;
  }

  String? get defaultTimePeriod => _defaultTimePeriod;
}
