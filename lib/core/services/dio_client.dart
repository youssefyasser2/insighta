import 'dart:io' show Platform, File;
import 'package:dio/dio.dart';
import 'package:test_app/core/config/api_config.dart';
import 'package:test_app/core/services/storage_service.dart';
import 'package:http_parser/http_parser.dart' show MediaType;

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio _dio;
  StorageService? _storageService;
  int _refreshRetryCount = 0;
  static const int _maxRefreshRetries = 2;

  factory DioClient() => _instance;

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _determineBaseUrl(),
        connectTimeout: const Duration(milliseconds: ApiConfig.connectTimeout),
        receiveTimeout: const Duration(milliseconds: ApiConfig.receiveTimeout),
        validateStatus: (status) => status != null && status < 500,
      ),
    );
  }

  String _determineBaseUrl() {
    String baseUrl;
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      baseUrl = ApiConfig.baseUrl;
      print('🔍 Using test base URL: $baseUrl');
    } else if (Platform.isAndroid &&
        !Platform.environment.containsKey('FLUTTER_TEST')) {
      baseUrl = 'http://10.0.2.2:5000';
      print('🔍 Using emulator base URL: $baseUrl');
    } else if (Platform.isAndroid) {
      baseUrl = 'http://192.168.1.8:5000';
      print('🔍 Using real device base URL: $baseUrl');
    } else {
      baseUrl = ApiConfig.baseUrl;
      print('🔍 Using default base URL: $baseUrl');
    }
    return baseUrl;
  }

  void initialize({required StorageService storageService}) {
    if (_storageService != null) {
      print('⚠️ DioClient already initialized. Ignoring new initialization.');
      return;
    }
    _storageService = storageService;
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.clear();
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_storageService == null) {
            throw Exception(
              'DioClient not initialized. Call initialize() first.',
            );
          }

          const publicEndpoints = [
            '/api/auth/register',
            '/api/auth/login',
            '/api/auth/refresh-token',
            '/api/auth/verify-email',
            '/api/otpCode/request',
            '/api/otpCode/verify',
            '/api/otpCode/reset-password',
            '/api/auth/social-login',
          ];

          if (!publicEndpoints.contains(options.path)) {
            final token = await _storageService!.getAccessToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            } else {
              print('⚠️ No access token found for ${options.path}');
            }
          }

          if (options.data is FormData) {
            options.headers['Content-Type'] = 'multipart/form-data';
            final formData = options.data as FormData;

            // Find the avatar file and the original file path
            final avatarFileEntry = formData.files.firstWhere(
              (e) => e.key == 'avatar',
              orElse: () => MapEntry('avatar', MultipartFile.fromBytes([])),
            );
            if (avatarFileEntry.value.filename != null) {
              // Extract the original file path from the fields
              final originalFilePathEntry = formData.fields.firstWhere(
                (e) => e.key == 'avatarOriginalPath',
                orElse: () => MapEntry('avatarOriginalPath', ''),
              );
              final originalFilePath = originalFilePathEntry.value;
              print('🔹 Original File Path: $originalFilePath');

              // Verify the file exists
              if (originalFilePath.isEmpty ||
                  !await File(originalFilePath).exists()) {
                print('❌ File does not exist at path: $originalFilePath');
                throw Exception(
                  'Avatar file not found at path: $originalFilePath',
                );
              }

              // Extract the file extension from the original path
              final extension = originalFilePath.split('.').last.toLowerCase();
              String contentTypeString;
              switch (extension) {
                case 'jpg':
                case 'jpeg':
                  contentTypeString = 'image/jpeg';
                  break;
                case 'png':
                  contentTypeString = 'image/png';
                  break;
                default:
                  contentTypeString = 'application/octet-stream';
              }
              print('🔹 Setting Content-Type for avatar: $contentTypeString');

              // Convert contentTypeString to DioMediaType
              final contentType = MediaType.parse(contentTypeString);

              // Create a new MultipartFile using the original file path
              final updatedAvatarFile = MultipartFile.fromFileSync(
                originalFilePath,
                filename:
                    'avatar-${DateTime.now().millisecondsSinceEpoch}.$extension',
                contentType: contentType,
              );

              // Update FormData with the new file
              formData.files.removeWhere((e) => e.key == 'avatar');
              formData.files.add(MapEntry('avatar', updatedAvatarFile));

              // Remove the avatarOriginalPath field from FormData to avoid sending it to the server
              formData.fields.removeWhere((e) => e.key == 'avatarOriginalPath');
            }
          } else {
            options.headers['Content-Type'] = ApiConfig.contentType;
          }

          print('🔹 Request: ${options.method} ${options.uri}');
          print('🔗 Full URL: ${options.baseUrl}${options.path}');
          if (options.data is FormData) {
            final formData = options.data as FormData;
            final fields = formData.fields
                .map((e) => '${e.key}: ${e.value}')
                .join(', ');
            final files = formData.files
                .map((e) {
                  final filename = e.value.filename ?? 'unknown';
                  final extension = filename.split('.').last.toLowerCase();
                  return '${e.key}: $filename (extension: $extension)';
                })
                .join(', ');
            print('🔹 FormData Fields: $fields');
            if (files.isNotEmpty) print('🔹 FormData Files: $files');
            final specificFields = [
              'firstName',
              'lastName',
              'gender',
              'age',
              'bio',
              'location',
            ];
            final specificData = formData.fields
                .where((e) => specificFields.contains(e.key))
                .map((e) => '${e.key}: ${e.value}')
                .join(', ');
            if (specificData.isNotEmpty) {
              print('🔹 Specific Fields: $specificData');
            }

            final avatarFile = formData.files.firstWhere(
              (e) => e.key == 'avatar',
              orElse: () => MapEntry('avatar', MultipartFile.fromBytes([])),
            );
            if (avatarFile.value.filename != null) {
              final filePath = avatarFile.value.filename;
              print('🔹 Avatar File Path Before Upload: $filePath');
            }
          } else {
            print('🔹 Payload: ${options.data}');
            if (options.data is Map) {
              final data = options.data as Map;
              final specificFields = [
                'firstName',
                'lastName',
                'gender',
                'age',
                'bio',
                'location',
              ];
              final specificData = specificFields
                  .where((key) => data.containsKey(key))
                  .map((key) => '$key: ${data[key]}')
                  .join(', ');
              if (specificData.isNotEmpty) {
                print('🔹 Specific Fields: $specificData');
              }
            }
          }
          print('🔹 Headers: ${options.headers}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print(
            '✅ Response: ${response.statusCode} ${response.requestOptions.path}',
          );
          print('📋 Response Data: ${response.data}');
          if (response.data is Map) {
            final data = response.data as Map;
            if (data.containsKey('data')) {
              final userData = data['data'] as Map?;
              if (userData != null) {
                final specificFields = [
                  'firstName',
                  'lastName',
                  'avatar',
                  'gender',
                  'age',
                  'bio',
                  'location',
                ];
                final specificData = specificFields
                    .where((key) => userData.containsKey(key))
                    .map((key) => '$key: ${userData[key]}')
                    .join(', ');
                if (specificData.isNotEmpty) {
                  print('📋 Specific Fields: $specificData');
                }

                if (userData.containsKey('avatar') &&
                    userData['avatar'] != null) {
                  final avatarPath = userData['avatar'].replaceAll('\\', '/');
                  final baseUrl = response.requestOptions.baseUrl;
                  final fullAvatarUrl = '$baseUrl/$avatarPath';
                  print('🔹 Full Avatar URL: $fullAvatarUrl');
                } else {
                  print('🔹 No Avatar URL in Response');
                }
              }
            }
          }
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          print('❌ Dio Error: ${error.message ?? "No error message provided"}');
          print('❌ Error Type: ${error.type}');
          print(
            '📋 Error Response Data: ${error.response?.data ?? "No response data"}',
          );
          print('📋 Failed URL: ${error.requestOptions.uri}');

          switch (error.type) {
            case DioExceptionType.connectionTimeout:
            case DioExceptionType.sendTimeout:
            case DioExceptionType.receiveTimeout:
              print(
                '⚠️ Network Error: Timeout occurred. Check your connection or server availability.',
              );
              break;
            case DioExceptionType.connectionError:
              print(
                '⚠️ Network Error: Unable to connect to the server. Verify server status or base URL.',
              );
              break;
            case DioExceptionType.badResponse:
              final statusCode = error.response?.statusCode;
              print('⚠️ Server Error: Status Code $statusCode');
              if (statusCode == 404) {
                print('''
🚫 404 - Route Not Found!
🔎 Endpoint: ${error.requestOptions.path}
📍 Full URL: ${error.requestOptions.uri}
📦 Payload: ${error.requestOptions.data}
📨 Headers: ${error.requestOptions.headers}
💡 Please ensure the following:
   1. The route exists on the server.
   2. The path requested by Flutter matches the backend.
   3. There are no extra or missing slashes in the URL.
   4. The server is actually running on http://192.168.1.8:5000 or the IP you are using.

📚 Review the backend code or test with Postman to verify the matching routes.
''');
              } else if (statusCode == 400) {
                print(
                  '⚠️ Bad Request: Check request payload or server requirements.',
                );
              } else if (statusCode == 500) {
                print(
                  '⚠️ Internal Server Error: Check server logs for details.',
                );
                if (error.response?.data is Map) {
                  final data = error.response!.data as Map;
                  print(
                    '⚠️ Server Error Details: ${data['error'] ?? data['message']}',
                  );
                }
              }
              break;
            case DioExceptionType.cancel:
              print('⚠️ Request Cancelled: ${error.requestOptions.path}');
              break;
            default:
              print('⚠️ Unknown Error: Check logs for details.');
          }

          if (error.response?.statusCode == 401) {
            print('⚠️ Unauthorized: Token might be expired or invalid');
            final refreshToken = await _storageService?.getRefreshToken();
            if (refreshToken != null && refreshToken.isNotEmpty) {
              if (_refreshRetryCount >= _maxRefreshRetries) {
                print('❌ Max refresh retries reached. Aborting.');
                _refreshRetryCount = 0;
                return handler.next(error);
              }

              try {
                _refreshRetryCount++;
                final newToken = await _refreshToken(refreshToken);
                if (newToken != null) {
                  error.requestOptions.headers['Authorization'] =
                      'Bearer $newToken';
                  _refreshRetryCount = 0;
                  return handler.resolve(
                    await _dio.fetch(error.requestOptions),
                  );
                }
              } catch (e) {
                print('❌ Token Refresh Failed: $e');
              }
            }
            return handler.next(error);
          }

          return handler.next(error);
        },
      ),
    );
  }

  Future<String?> _refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        '/api/auth/refresh-token',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final newAccessToken = data['accessToken'] as String?;
        final newRefreshToken = data['refreshToken'] as String?;
        final expiresInSeconds = data['expiresIn'] as int?;

        if (newAccessToken == null || newAccessToken.isEmpty) {
          print('❌ Refresh Token Response: Missing accessToken');
          return null;
        }
        if (newRefreshToken == null || newRefreshToken.isEmpty) {
          print('❌ Refresh Token Response: Missing refreshToken');
          return null;
        }

        final expiresAt =
            expiresInSeconds != null
                ? DateTime.now()
                    .add(Duration(seconds: expiresInSeconds))
                    .toIso8601String()
                : DateTime.now()
                    .add(const Duration(days: 30))
                    .toIso8601String();

        await _storageService!.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
          expiresIn: expiresAt,
        );
        print('✅ Refresh Token Success: New access token saved');
        return newAccessToken;
      }

      print('⚠️ Refresh Token Response Invalid: ${response.data}');
      return null;
    } on DioException catch (e) {
      print('❌ Refresh Token Error: ${e.response?.data ?? e.message}');
      return null;
    } catch (e) {
      print('❌ Unexpected Refresh Token Error: $e');
      return null;
    }
  }

  void updateBaseUrl(String newBaseUrl) {
    print('🔍 Updating base URL to: $newBaseUrl');
    _dio.options.baseUrl = newBaseUrl;
  }

  Dio get dio => _dio;
}
