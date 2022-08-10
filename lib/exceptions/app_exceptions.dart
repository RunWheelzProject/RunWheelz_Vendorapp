class OTPException implements Exception {

  final String message;
  const OTPException([this.message = ""]);

  @override
  String toString() => "OTPException: $message";

}