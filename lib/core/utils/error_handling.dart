class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class HttpException implements Exception {
  final int statusCode;
  final String responseBody;
  HttpException(this.statusCode, this.responseBody);
}

Exception handleException(dynamic e) {
  if (e is AuthException) {
    return e;
  } else if (e is HttpException) {
    return AuthException("HTTP Error: ${e.statusCode}");
  } else {
    return AuthException("An unexpected error occurred");
  }
}
