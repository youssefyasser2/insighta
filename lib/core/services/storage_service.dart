import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A service for securely storing and retrieving user data such as tokens, user ID, and login info.
/// Uses [SharedPreferences] for non-sensitive data and [FlutterSecureStorage] for sensitive data.
class StorageService {
  final SharedPreferences prefs;
  final FlutterSecureStorage secureStorage;

  /// Constructor with named parameters to ensure proper dependency injection.
  StorageService({required this.prefs, required this.secureStorage}) {
    // Ensure dependencies are not null
  }

  // Define keys for storing data as constants
  static const String _userIdKey = 'userId';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _expiresInKey = 'expires_in';
  static const String _emailKey = 'email';
  static const String _passwordKey = 'password';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _stayConnectedKey = 'stay_connected';

  // Cache for frequently accessed values
  String? _userIdCache;
  String? _accessTokenCache;
  String? _refreshTokenCache;
  bool? _isLoggedInCache;
  bool? _isStayConnectedCache;

  /// Helper method to handle secure storage operations with error handling.
  /// [operation] is the storage operation to perform.
  /// [operationName] is a descriptive name for logging purposes.
  Future<void> _secureStorageOperation(
    Future<void> Function() operation,
    String operationName,
  ) async {
    try {
      await operation();
    } catch (e) {
      print('❌ StorageService: Failed to $operationName: $e');
      rethrow; // Allow the caller to handle the error
    }
  }

  /// Helper method to read from secure storage with error handling.
  /// Returns null if the key is not found or if an error occurs.
  /// [key] is the key to read from secure storage.
  /// [operationName] is a descriptive name for logging purposes.
  Future<String?> _readSecureStorage(String key, String operationName) async {
    try {
      final value = await secureStorage.read(key: key);
      return value;
    } catch (e) {
      print('❌ StorageService: Failed to $operationName: $e');
      return null; // Return null instead of throwing to allow graceful fallback
    }
  }

  // --- User ID ---

  /// Saves the user ID securely and updates the logged-in status.
  /// [userId] is the user's unique identifier.
  Future<void> saveUserId(String userId) async {
    await _secureStorageOperation(() async {
      await Future.wait([
        secureStorage.write(key: _userIdKey, value: userId),
        prefs.setBool(_isLoggedInKey, true),
      ]);
      _userIdCache = userId; // Update cache
      _isLoggedInCache = true; // Update cache
    }, 'save userId');
  }

  /// Retrieves the user ID from secure storage.
  /// Returns null if the user ID is not found or if an error occurs.
  Future<String?> getUserId() async {
    if (_userIdCache != null) {
      return _userIdCache; // Return cached value if available
    }
    final userId = await _readSecureStorage(_userIdKey, 'retrieve userId');
    _userIdCache = userId; // Update cache
    return userId;
  }

  /// Clears the user ID and updates the logged-in status.
  Future<void> clearUserId() async {
    await _secureStorageOperation(() async {
      await Future.wait([
        secureStorage.delete(key: _userIdKey),
        prefs.setBool(_isLoggedInKey, false),
      ]);
      _userIdCache = null; // Clear cache
      _isLoggedInCache = false; // Update cache
    }, 'clear userId');
  }

  // --- Access & Refresh Tokens ---

  /// Saves the access token, refresh token, and expiration time securely.
  /// [accessToken] is the JWT access token.
  /// [refreshToken] is the JWT refresh token.
  /// [expiresIn] is the expiration time of the access token.
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String expiresIn,
  }) async {
    await _secureStorageOperation(() async {
      await Future.wait([
        secureStorage.write(key: _accessTokenKey, value: accessToken),
        secureStorage.write(key: _refreshTokenKey, value: refreshToken),
        secureStorage.write(key: _expiresInKey, value: expiresIn),
      ]);
      _accessTokenCache = accessToken; // Update cache
      _refreshTokenCache = refreshToken; // Update cache
    }, 'save tokens');
  }

  /// Retrieves the access token from secure storage.
  /// Returns null if the access token is not found or if an error occurs.
  Future<String?> getAccessToken() async {
    if (_accessTokenCache != null) {
      return _accessTokenCache; // Return cached value if available
    }
    final token = await _readSecureStorage(_accessTokenKey, 'retrieve access token');
    _accessTokenCache = token; // Update cache
    return token;
  }

  /// Retrieves the refresh token from secure storage.
  /// Returns null if the refresh token is not found or if an error occurs.
  Future<String?> getRefreshToken() async {
    if (_refreshTokenCache != null) {
      return _refreshTokenCache; // Return cached value if available
    }
    final token = await _readSecureStorage(_refreshTokenKey, 'retrieve refresh token');
    _refreshTokenCache = token; // Update cache
    return token;
  }

  /// Retrieves the expiration time from secure storage.
  /// Returns null if the expiration time is not found or if an error occurs.
  Future<String?> getExpiresIn() async {
    return await _readSecureStorage(_expiresInKey, 'retrieve expiresIn');
  }

  /// Clears the access token, refresh token, and expiration time.
  Future<void> clearTokens() async {
    await _secureStorageOperation(() async {
      await Future.wait([
        secureStorage.delete(key: _accessTokenKey),
        secureStorage.delete(key: _refreshTokenKey),
        secureStorage.delete(key: _expiresInKey),
      ]);
      _accessTokenCache = null; // Clear cache
      _refreshTokenCache = null; // Clear cache
    }, 'clear tokens');
  }

  // --- Login Info ---

  /// Saves the login credentials (email and password) securely and updates the stay connected status.
  /// [email] is the user's email address.
  /// [password] is the user's password.
  Future<void> saveLoginInfo(String email, String password) async {
    await _secureStorageOperation(() async {
      await Future.wait([
        secureStorage.write(key: _emailKey, value: email),
        secureStorage.write(key: _passwordKey, value: password),
        prefs.setBool(_stayConnectedKey, true),
      ]);
      _isStayConnectedCache = true; // Update cache
    }, 'save login info');
  }

  /// Retrieves the login credentials (email and password) from secure storage.
  /// Returns a map with email and password, or an empty map if retrieval fails.
  Future<Map<String, String?>> getLoginInfo() async {
    try {
      final results = await Future.wait([
        secureStorage.read(key: _emailKey),
        secureStorage.read(key: _passwordKey),
      ]);
      return {'email': results[0], 'password': results[1]};
    } catch (e) {
      print('❌ StorageService: Failed to retrieve login info: $e');
      return {'email': null, 'password': null}; // Fallback to empty values
    }
  }

  /// Clears the login credentials and updates the stay connected status.
  Future<void> clearLoginInfo() async {
    await _secureStorageOperation(() async {
      await Future.wait([
        secureStorage.delete(key: _emailKey),
        secureStorage.delete(key: _passwordKey),
        prefs.setBool(_stayConnectedKey, false),
      ]);
      _isStayConnectedCache = false; // Update cache
    }, 'clear login info');
  }

  // --- Stay Connected & Logged In Status ---

  /// Checks if the user has opted to stay connected.
  /// Uses caching to improve performance for frequent calls.
  Future<bool> isStayConnected() async {
    try {
      if (_isStayConnectedCache != null) {
        return _isStayConnectedCache!;
      }
      final result = prefs.getBool(_stayConnectedKey) ?? false;
      _isStayConnectedCache = result;
      return result;
    } catch (e) {
      print('❌ StorageService: Failed to check stay_connected: $e');
      return false; // Fallback to false if an error occurs
    }
  }

  /// Checks if the user is still logged in.
  /// Uses caching to improve performance for frequent calls.
  Future<bool> isLoggedIn() async {
    try {
      if (_isLoggedInCache != null) {
        return _isLoggedInCache!;
      }
      final result = prefs.getBool(_isLoggedInKey) ?? false;
      _isLoggedInCache = result;
      return result;
    } catch (e) {
      print('❌ StorageService: Failed to check is_logged_in: $e');
      return false; // Fallback to false if an error occurs
    }
  }

  // --- Clear All Data ---

  /// Wipes all stored data from both secure storage and SharedPreferences.
  Future<void> clearAllData() async {
    await _secureStorageOperation(() async {
      await Future.wait([secureStorage.deleteAll(), prefs.clear()]);
      // Reset all caches
      _userIdCache = null;
      _accessTokenCache = null;
      _refreshTokenCache = null;
      _isLoggedInCache = null;
      _isStayConnectedCache = null;
    }, 'clear all data');
  }

  // --- Profile Completion Methods ---

  /// Saves the profile completion status for a specific user.
  /// [userId] is the user's unique identifier.
  Future<void> setProfileCompleted(String userId) async {
    await _secureStorageOperation(() async {
      await prefs.setBool('profileCompleted_$userId', true);
    }, 'save profile completion status');
  }

  /// Checks if the profile is completed for a specific user.
  /// [userId] is the user's unique identifier.
  /// Returns false if an error occurs.
  Future<bool> isProfileCompleted(String userId) async {
    try {
      return prefs.getBool('profileCompleted_$userId') ?? false;
    } catch (e) {
      print('❌ StorageService: Failed to check profile completion for user $userId: $e');
      return false; // Fallback to false if an error occurs
    }
  }

  /// Clears the profile completion status for a specific user.
  /// [userId] is the user's unique identifier.
  Future<void> clearProfileCompleted(String userId) async {
    await _secureStorageOperation(() async {
      await prefs.remove('profileCompleted_$userId');
    }, 'clear profile completion status');
  }
}