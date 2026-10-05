class ApiException implements Exception {
  final String code;
  final String message;

  ApiException({
    required this.code,
    required this.message,
  });
}