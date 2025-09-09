class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => "AuthException: $message";
}

class InvalidEmailException extends AuthException {
  InvalidEmailException() : super("Invalid email address.");
}

class InvalidPasswordException extends AuthException {
  InvalidPasswordException() : super("Invalid password.");
}

class UserNotFoundException extends AuthException {
  UserNotFoundException() : super("User not found.");
}

class EmailAlreadyInUseException extends AuthException {
  EmailAlreadyInUseException() : super("Email is already in use.");
}

class WeakPasswordException extends AuthException {
  WeakPasswordException() : super("The password is too weak.");
}

class NetworkException extends AuthException {
  NetworkException() : super("Network error. Please check your connection.");
}

class UnknownAuthException extends AuthException {
  UnknownAuthException() : super("An unknown error occurred.");
}
