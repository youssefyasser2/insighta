import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class AuthStorage {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _expiresInKey = 'expires_in';

  /// ✅ حفظ Access Token, Refresh Token, و تاريخ الانتهاء
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String expiresIn,
  }) async {
    try {
      await _secureStorage.write(key: _accessTokenKey, value: accessToken);
      await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
      await _secureStorage.write(key: _expiresInKey, value: expiresIn);
    } catch (e) {
      debugPrint("Error saving tokens: \$e");
      rethrow;
    }
  }

  // Method to get the token from secure storage
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  static Future<DateTime?> getAccessTokenExpiry() async {
    final expiresIn = await _secureStorage.read(key: 'expiresIn');
    if (expiresIn == null) return null;

    final expiryTimestamp = int.tryParse(expiresIn);
    if (expiryTimestamp == null) return null;

    return DateTime.fromMillisecondsSinceEpoch(expiryTimestamp);
  }

  /// ✅ جلب Access Token فقط إذا كان صالحًا
  static Future<String?> getValidAccessToken() async {
    try {
      final accessToken = await _secureStorage.read(key: _accessTokenKey);
      final expiresIn = await _secureStorage.read(key: _expiresInKey);

      if (accessToken == null || expiresIn == null) return null;

      final expiryDate = _parseExpiryDate(expiresIn);
      if (expiryDate.isBefore(DateTime.now())) {
        return null; // التوكن منتهي الصلاحية
      }

      return accessToken;
    } catch (e) {
      debugPrint("Error retrieving valid access token: \$e");
      return null;
    }
  }

  /// ✅ جلب Access Token بدون التحقق من الصلاحية
  static Future<String?> getAccessToken() async {
    try {
      return await _secureStorage.read(key: _accessTokenKey);
    } catch (e) {
      debugPrint("Error retrieving access token: \$e");
      return null;
    }
  }

  /// ✅ جلب Refresh Token
  static Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: _refreshTokenKey);
    } catch (e) {
      debugPrint("Error retrieving refresh token: \$e");
      return null;
    }
  }

  /// ✅ تحديث Access Token فقط
  static Future<void> updateAccessToken(
    String newAccessToken,
    String expiresIn,
  ) async {
    try {
      await _secureStorage.write(key: _accessTokenKey, value: newAccessToken);
      await _secureStorage.write(key: _expiresInKey, value: expiresIn);
    } catch (e) {
      debugPrint("Error updating access token: \$e");
      rethrow;
    }
  }

  /// ✅ حذف جميع التوكنات
  static Future<void> clearTokens() async {
    try {
      await _secureStorage.delete(key: _accessTokenKey);
      await _secureStorage.delete(key: _refreshTokenKey);
      await _secureStorage.delete(key: _expiresInKey);
    } catch (e) {
      debugPrint("Error clearing tokens: \$e");
      rethrow;
    }
  }

  /// ✅ التحقق مما إذا كان المستخدم مسجلاً الدخول
  static Future<bool> isAuthenticated() async {
    try {
      final accessToken = await getValidAccessToken();
      final refreshToken = await getRefreshToken();
      return accessToken != null && refreshToken != null;
    } catch (e) {
      debugPrint("Error checking authentication: \$e");
      return false;
    }
  }

  /// ✅ حفظ بيانات غير حساسة باستخدام SharedPreferences
  static Future<void> savePreference(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } catch (e) {
      debugPrint("Error saving preference: \$e");
      rethrow;
    }
  }

  /// ✅ جلب بيانات غير حساسة من SharedPreferences
  static Future<String?> getPreference(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } catch (e) {
      debugPrint("Error retrieving preference: \$e");
      return null;
    }
  }

  /// ✅ حذف بيانات غير حساسة من SharedPreferences
  static Future<void> clearPreference(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } catch (e) {
      debugPrint("Error clearing preference: \$e");
      rethrow;
    }
  }

  /// ✅ حذف جميع البيانات (بما في ذلك التوكنات) عند تسجيل الخروج
  static Future<void> clearAll() async {
    try {
      await clearTokens();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      debugPrint("Error clearing all data: \$e");
      rethrow;
    }
  }

  /// ✅ تحويل تاريخ انتهاء التوكن إلى `DateTime`
  static DateTime _parseExpiryDate(String? expiresIn) {
    if (expiresIn == null) {
      return DateTime.now().add(const Duration(hours: 1));
    }

    try {
      final expiry = DateTime.parse(expiresIn);
      return expiry.isBefore(DateTime.now())
          ? DateTime.now().add(const Duration(hours: 1))
          : expiry;
    } catch (_) {
      return DateTime.now().add(const Duration(hours: 1));
    }
  }

  /// ✅ حفظ واسترجاع بيانات المستخدم
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _secureStorage.write(key: 'user', value: jsonEncode(userData));
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final userData = await _secureStorage.read(key: 'user');
    if (userData == null) return null;
    return jsonDecode(userData);
  }

  Future<void> clear() async {
    await _secureStorage.deleteAll();
  }
}
