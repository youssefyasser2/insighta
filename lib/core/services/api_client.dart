import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:test_app/core/utils/auth_storage.dart';
import 'package:test_app/core/utils/error_handling.dart';
import 'package:test_app/features/auth/data/models/user_model.dart';

class AuthService {
  // Define base URLs for different environments
  static const String _baseUrlLocalhost =
      'http://localhost:5000/api'; // For local development (e.g., web, iOS simulator)
  static const String _baseUrlEmulator =
      'http://10.0.2.2:5000/api'; // For Android emulator to access localhost
  static const String _baseUrlDevice =
      'http://192.168.1.8:5000/api'; // Replace with your machine's IP for real devices

  // Dynamically select the API URL based on the environment
  String get apiUrl {
    if (Platform.isAndroid &&
        !Platform.environment.containsKey('FLUTTER_TEST')) {
      // Running on Android emulator
      return _baseUrlEmulator;
    } else if (Platform.isAndroid) {
      // Running on a real device
      return _baseUrlDevice;
    }
    // Default to localhost for other platforms (e.g., iOS simulator or web)
    return _baseUrlLocalhost;
  }

  /// Processes the API response for login and extracts tokens and user data.
  /// Returns a UserModel with tokens on success or throws an exception on failure.
  Future<UserModel?> _processLoginResponse(http.Response response) async {
    // Log the API response for debugging
    print("🔹 API Response: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = json.decode(response.body);

      // Extract required fields from the response
      final String? accessToken = responseData["accessToken"];
      final String? refreshToken = responseData["refreshToken"];
      final Map<String, dynamic>? userData = responseData["user"];
      final int? expiresInSeconds = responseData["expiresIn"];

      // Validate all required fields are present
      if (accessToken == null ||
          refreshToken == null ||
          userData == null ||
          expiresInSeconds == null) {
        throw Exception(
          "❌ API response missing required fields: accessToken, refreshToken, userData, or expiresIn.",
        );
      }

      // Calculate the expiration date for the token
      final String expiresAt =
          DateTime.now()
              .add(Duration(seconds: expiresInSeconds))
              .toIso8601String();

      // Store tokens and expiration in AuthStorage
      await AuthStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresIn: expiresAt,
      );

      // Create and return a UserModel with the response data
      return UserModel.fromJson({
        ...userData,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'expiresIn': expiresAt,
      });
    } else {
      // Throw an exception for unexpected API responses
      throw HttpException(
        response.statusCode,
        "❌ Unexpected Error: ${response.body}",
      );
    }
  }

  /// Processes the API response for register and extracts user data (no tokens expected).
  /// Returns a UserModel without tokens on success or throws an exception on failure.
  Future<UserModel?> _processRegisterResponse(http.Response response) async {
    // Log the API response for debugging
    print("🔹 Register API Response: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = json.decode(response.body);

      // Extract user data from the response
      final Map<String, dynamic>? userData = responseData["user"];

      // Validate that user data is present
      if (userData == null) {
        throw Exception(
          "❌ Register API response missing required field: user.",
        );
      }

      // Create and return a UserModel without tokens
      return UserModel.fromJson(userData);
    } else {
      // Throw an exception for unexpected API responses
      throw HttpException(
        response.statusCode,
        "❌ Register Failed: ${response.body}",
      );
    }
  }

  /// Logs in a user with the provided email and password.
  /// Returns a UserModel with tokens on success or throws an exception on failure.
  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$apiUrl/auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      return await _processLoginResponse(response);
    } catch (e, stackTrace) {
      // Log the error and stack trace for debugging
      print("❌ Login Exception: $e");
      print("🔍 Stack Trace: $stackTrace");
      throw handleException(e);
    }
  }

  /// Registers a new user with the provided username, email, and password.
  /// Returns a UserModel (without tokens) on success or throws an exception on failure.
  Future<UserModel?> register(
    String username,
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$apiUrl/auth/register"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        }),
      );

      return await _processRegisterResponse(response);
    } catch (e, stackTrace) {
      // Log the error and stack trace for debugging
      print("❌ Register Exception: $e");
      print("🔍 Stack Trace: $stackTrace");
      throw handleException(e);
    }
  }

  /// Logs out the current user by clearing stored tokens.
  Future<void> logout() async {
    await AuthStorage.clearTokens();
  }
}
