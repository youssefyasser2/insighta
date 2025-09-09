import 'package:dio/dio.dart';
import 'package:test_app/core/utils/auth_storage.dart' as auth_storage;
import 'package:test_app/features/profile/data/models/user_model.dart';

// Repository to handle authentication-related API calls
class AuthRepository {
  final Dio _dio;

  AuthRepository({required Dio dio}) : _dio = dio;

  // Perform login request
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {
          'email': email.trim().toLowerCase(),
          'password': password.trim(),
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return UserModel.fromLoginResponse(Map<String, dynamic>.from(response.data));
      }
      throw Exception('Invalid credentials');
    } catch (e) {
      rethrow;
    }
  }

  // Perform registration request
  Future<UserModel> register(String username, String email, String password) async {
    try {
      final response = await _dio.post(
        '/register',
        data: {
          'username': username.trim(),
          'email': email.trim().toLowerCase(),
          'password': password,
        },
      );

      if (response.statusCode == 201 && response.data != null) {
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw Exception(response.data['message'] ?? 'Registration failed');
    } catch (e) {
      rethrow;
    }
  }

  // Verify OTP code
  Future<void> verifyCode(String email, String code) async {
    try {
      final response = await _dio.post(
        '/verify-code',
        data: {'email': email.trim().toLowerCase(), 'code': code},
      );

      if (response.statusCode != 200) {
        throw Exception('Invalid verification code');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Request password reset
  Future<void> forgotPassword(String email) async {
    try {
      final response = await _dio.post(
        '/forgot-password',
        data: {'email': email.trim().toLowerCase()},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send reset link');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Change user password
  Future<UserModel> changePassword(String userId, String newPassword) async {
    try {
      final response = await _performAuthorizedRequest(
        '/users/$userId/password',
        data: {'password': newPassword},
        method: 'PUT',
      );

      if (response.statusCode == 200 && response.data != null) {
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw Exception('Failed to change password');
    } catch (e) {
      rethrow;
    }
  }

  // Update user profile
  Future<UserModel> completeProfile({
    required String userId,
    required String fullName,
    required String bio,
    required String profileImage,
  }) async {
    try {
      final response = await _performAuthorizedRequest(
        '/users/$userId',
        data: {
          'fullName': fullName.trim(),
          'bio': bio.trim(),
          'profileImage': profileImage,
        },
        method: 'PUT',
      );

      if (response.statusCode == 200 && response.data != null) {
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw Exception('Failed to update profile');
    } catch (e) {
      rethrow;
    }
  }

  // Perform social login
  Future<UserModel> socialLogin(String platform) async {
    try {
      final response = await _dio.post(
        '/social-login',
        data: {'platform': platform},
      );

      if (response.statusCode == 200 && response.data != null) {
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw Exception('Social login failed');
    } catch (e) {
      rethrow;
    }
  }

  // Check current user authentication status
  Future<UserModel?> checkAuthStatus() async {
    try {
      final response = await _performAuthorizedRequest('/me');
      if (response.statusCode == 200 && response.data != null) {
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Save user tokens to secure storage
  Future<void> saveUserTokens(UserModel user) async {
    if (user.accessToken == null || user.refreshToken == null) {
      throw Exception('Invalid authentication tokens received');
    }
    try {
      await auth_storage.AuthStorage.saveTokens(
        accessToken: user.accessToken!,
        refreshToken: user.refreshToken!,
        expiresIn: user.expiresIn?.toIso8601String() ?? '',
      );
    } catch (e) {
      throw Exception('Failed to save authentication tokens: $e');
    }
  }

  // Perform authorized API request
  Future<Response> _performAuthorizedRequest(
    String endpoint, {
    Map<String, dynamic>? data,
    String method = 'GET',
  }) async {
    final token = await auth_storage.AuthStorage.getAccessToken();
    if (token == null) {
      throw Exception('No access token available');
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    return await _dio.request(
      endpoint,
      data: data,
      options: Options(method: method.toUpperCase(), headers: headers),
    );
  }
}