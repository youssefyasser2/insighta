import 'package:dio/dio.dart';
import 'dart:io'
    show Platform; // To detect the platform (emulator, device, etc.)

/// Configuration class for API-related settings, including base URL, endpoints, and error messages.
class ApiConfig {
  // Determine the base URL based on the environment and platform
  static String get baseUrl {
    // Check if BASE_URL is provided via environment variables (e.g., --dart-define)
    const definedBaseUrl = String.fromEnvironment('BASE_URL', defaultValue: '');

    // If BASE_URL is defined in environment variables, use it
    if (definedBaseUrl.isNotEmpty) {
      return definedBaseUrl;
    }

    // Fallback: Determine base URL based on the platform
    if (Platform.isAndroid) {
      // For Android Emulator: Use 10.0.2.2 to access localhost on the host machine
      // For real devices: Replace with the actual IP of the machine running the backend
      return 'http://10.0.2.2:5000'; // Use this for emulator
      // return 'http://192.168.1.8:5000'; // Uncomment and update this for real devices
    } else {
      // For other platforms (e.g., iOS, web, or running on the same machine)
      return 'http://localhost:5000';
    }
  }

  // Timeout durations for API requests
  static const int connectTimeout = 10000; // 30 seconds in milliseconds
  static const int receiveTimeout = 15000; // 30 seconds in milliseconds

  // Default content type for requests
  static const String contentType = Headers.jsonContentType;

  // List of public endpoints that don't require authentication
  static const List<String> publicEndpoints = [
    '/api/auth/register',
    '/api/auth/login',
    '/api/auth/logout',
    '/api/auth/verify-email',
    '/api/otpCode/request',
    '/api/otpCode/verify',
    '/api/otpCode/reset-password',
  ];

  // Authentication Endpoints
  /// POST: Registers a new user
  static const String register = '/api/auth/register';

  /// POST: Authenticates an existing user
  static const String login = '/api/auth/login';

  /// POST: Logs out the current user
  static const String logout = '/api/auth/logout';

  /// POST: Verifies user's email with OTP
  static const String verifyEmail = '/api/auth/verify-email';

  // OTP and Password Reset Endpoints
  /// POST: Requests an OTP for password reset
  static const String requestOtp = '/api/otpCode/request';

  /// POST: Verifies the OTP for password reset
  static const String verifyOtp = '/api/otpCode/verify';

  /// POST: Resets the password using OTP
  static const String resetPassword = '/api/otpCode/reset-password';

  // User and Profile Endpoints
  /// GET/PUT: Retrieves or updates user profile
  static const String profile = '/api/profile';

  /// GET: Retrieves current user details
  static const String me = '/api/users/me';

  // Notification Endpoints
  /// GET: Fetches notifications with pagination
  static const String notifications = '/api/notifications';

  /// POST: Creates a new notification
  static const String createNotification = '/api/notifications/create';

  /// PATCH: Marks notifications as read
  static const String readNotifications = '/api/notifications/read';

  /// DELETE: Clears old notifications
  static const String clearNotifications = '/api/notifications/clear';

  // Log Endpoints
  /// POST: Creates a new log entry
  static const String logs = '/api/logs';

  /// GET: Fetches logs with pagination and filters (same as logs)
  static const String fetchLogs = '/api/logs';

  /// DELETE: Removes old logs
  static const String cleanupLogs = '/api/logs/cleanup';

  // Default headers for API requests
  static const Map<String, String> defaultHeaders = {
    'Content-Type': contentType,
  };

  // Common error messages with more specificity
  static const String sessionExpired = 'Session expired. Please log in again.';
  static const String invalidCredentials = 'Invalid email or password.';
  static const String registrationFailedEmailTaken = 'Email already in use.';
  static const String registrationFailedGeneric =
      'Failed to register. Please try again.';
  static const String profileUpdateFailed =
      'Failed to update profile. Please try again.';
  static const String passwordChangeFailed =
      'Failed to change password. Please try again.';
  static const String verificationFailed =
      'Verification failed. Invalid or expired code.';
  static const String resetEmailFailed =
      'Failed to send reset email. Please try again.';
  static const String logoutFailed = 'Failed to log out. Please try again.';
  static const String noInternet =
      'No internet connection. Please check your network.';
  static const String serverNotFound =
      'Server not found. Please try again later.';
  static String get registrationFailed =>
      'Registration failed. Please try again.';

  /// Constructs the full URL for a given endpoint
  static String getFullUrl(String endpoint) => '$baseUrl$endpoint';
}
