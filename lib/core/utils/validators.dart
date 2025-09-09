class Validators {
  /// Validates email format (example@mail.com)
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email.trim());
  }

  /// Validates password strength:
  /// - At least 8 characters
  /// - Contains at least one letter (A-Z or a-z)
  /// - Contains at least one digit (0-9)
  /// - Contains at least one special character (@, #, !, etc.)
  static bool isValidPassword(String password) {
    final passwordRegex = RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );
    return passwordRegex.hasMatch(password.trim());
  }

  /// Checks if the input is not empty
  static bool isNotEmpty(String value) {
    return value.trim().isNotEmpty;
  }

  /// Checks if password and confirm password match
  static bool passwordsMatch(String password, String confirmPassword) {
    return password.trim() == confirmPassword.trim();
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
