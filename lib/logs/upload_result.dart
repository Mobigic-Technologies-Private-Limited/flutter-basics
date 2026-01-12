class UploadResult {
  final bool success;
  final int statusCode;
  final String message;

  UploadResult({
    required this.success,
    required this.statusCode,
    required this.message,
  });
}
