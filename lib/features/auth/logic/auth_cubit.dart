import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/core/config/api_config.dart';
import 'package:test_app/core/services/storage_service.dart';
import 'package:test_app/core/utils/validators.dart';
import 'package:test_app/features/auth/logic/auth_state.dart';
import 'package:test_app/features/profile/data/models/user_model.dart';
import 'package:test_app/core/services/dio_client.dart';

/// Manages the authentication state and operations such as login, registration, and logout.
class AuthCubit extends Cubit<AuthState> {
  final DioClient _dioClient;
  final StorageService _storageService;
  bool _stayConnected = false;

  AuthCubit({
    required DioClient dioClient,
    required StorageService storageService,
  }) : _dioClient = dioClient,
       _storageService = storageService,
       super(AuthInitial());

  /// Checks if there is an active internet connection.
  Future<bool> _isInternetAvailable() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      print('❌ Failed to check internet connectivity: $e');
      return false;
    }
  }

  /// Logs in a user with the provided email and password, and determines navigation based on profile completion.
  Future<void> login(String email, String password) async {
    // Validate input fields before proceeding
    final error = _validateLoginFields(email, password);
    if (error != null) {
      emit(AuthFailure(error));
      return;
    }

    // Ensure there is an active internet connection
    if (!await _isInternetAvailable()) {
      emit(AuthFailure(ApiConfig.noInternet));
      return;
    }

    emit(AuthLoading());
    try {
      // Send login request to the backend
      final response = await _dioClient.dio.post(
        ApiConfig.login,
        data: {
          'email': email.trim().toLowerCase(),
          'password': password.trim(),
        },
      );

      print('🔹 Login Response: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final data = Map<String, dynamic>.from(response.data);
        final accessToken = data['accessToken'] as String?;
        final refreshToken = data['refreshToken'] as String?;
        final expiresInSeconds = data['expiresIn'] as int?;
        final userData = data['user'] as Map<String, dynamic>?;

        // Validate that access token is present
        if (accessToken == null || accessToken.isEmpty) {
          emit(AuthFailure('No access token received'));
          return;
        }

        // Calculate token expiration with a default fallback
        final expiresIn =
            expiresInSeconds != null
                ? DateTime.now()
                    .add(Duration(seconds: expiresInSeconds))
                    .toIso8601String()
                : DateTime.now()
                    .add(const Duration(days: 30))
                    .toIso8601String();

        // Save authentication tokens to secure storage
        await _storageService.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken ?? '',
          expiresIn: expiresIn,
        );

        // Process user data from login response or fetch it separately
        late UserModel userModel;
        if (userData != null) {
          userModel = UserModel.fromJson(userData);
        } else {
          // Fetch user data if not included in login response
          final userResponse = await _dioClient.dio.get(ApiConfig.me);
          print('🔹 /users/me Response: ${userResponse.data}');

          if (userResponse.statusCode == 200 && userResponse.data != null) {
            userModel = UserModel.fromJson(
              userResponse.data as Map<String, dynamic>,
            );
          } else {
            emit(AuthFailure('Failed to fetch user data after login'));
            return;
          }
        }

        // Save user ID to storage
        await _storageService.saveUserId(userModel.id);

        // Check if the user's profile is completed for this specific user
        final bool isProfileCompleted = await _storageService
            .isProfileCompleted(userModel.id);

        // Emit success state with profile completion status to guide navigation
        emit(
          AuthSuccess(
            userId: userModel.id,
            user: userModel,
            isLogin: true,
            isProfileCompleted: isProfileCompleted,
          ),
        );
      } else {
        emit(AuthFailure(ApiConfig.invalidCredentials));
      }
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      emit(AuthFailure('Login failed: $e'));
    }
  }

  /// Registers a new user and triggers navigation to VerifyCodeScreen on success.
  Future<void> register(
    String username,
    String email,
    String password,
    String confirmPassword,
  ) async {
    // Validate input fields before sending to backend
    final error = _validateRegistrationFields(
      username,
      email,
      password,
      confirmPassword,
    );
    if (error != null) {
      print('❌ Validation Error: $error');
      emit(AuthFailure(error));
      return;
    }

    // Ensure there is internet connectivity
    if (!await _isInternetAvailable()) {
      print('❌ No Internet Connection: ${ApiConfig.noInternet}');
      emit(AuthFailure(ApiConfig.noInternet));
      return;
    }

    emit(AuthLoading());
    try {
      // Prepare and sanitize registration payload
      final data = {
        'name': username.trim(),
        'email': email.trim().toLowerCase(),
        'password': password.trim(),
        'confirmPassword': confirmPassword.trim(),
      };

      // Log the payload for debugging
      print('🔹 Sending Registration Payload: $data');

      // Send registration request to the backend
      final response = await _dioClient.dio.post(
        ApiConfig.register,
        data: data,
      );

      // Log the response for debugging
      print(
        '✅ Registration Response: Status ${response.statusCode}, Data: ${response.data}',
      );

      // Validate response status and data
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        final responseData = response.data as Map<String, dynamic>;

        // Check if the registration was successful
        if (responseData['success'] != true) {
          final errorMessage =
              _extractErrorMessage(responseData) ??
              ApiConfig.registrationFailed;
          print('❌ Registration Failed: $errorMessage');
          emit(AuthFailure(errorMessage));
          return;
        }

        // Parse user data from the response
        final userModel = UserModel.fromRegisterResponse(responseData);

        // Validate user ID
        if (userModel.id.isEmpty) {
          print('❌ Error: User ID is missing in the response');
          emit(
            AuthFailure(
              'Registration succeeded, but user ID is missing in the response.',
            ),
          );
          return;
        }

        // Log success for debugging
        print(
          '✅ Emitting AuthSuccess: userId = ${userModel.id}, email = ${userModel.email}',
        );

        // Emit success state to trigger navigation to VerifyCodeScreen
        emit(
          AuthSuccess.register(
            userId: userModel.id,
            user: userModel,
            isProfileCompleted: false,
            message: 'تم التسجيل بنجاح',
          ),
        );
      } else {
        print('❌ Invalid Registration Response: Status ${response.statusCode}');
        emit(AuthFailure(ApiConfig.registrationFailed));
      }
    } on DioException catch (e) {
      print('❌ DioException in register: ${e.message}');
      _handleDioError(e);
    } catch (e) {
      print(
        '❌ Unexpected Error in register: Type: ${e.runtimeType}, Message: $e',
      );
      emit(AuthFailure('فشل التسجيل بشكل غير متوقع: ${e.toString()}'));
    }
  }

  /// Verifies the user's email with an OTP code and triggers navigation to LoginScreen.
  Future<void> verifyCode(String email, String code) async {
    // Validate input fields
    final error = _validateVerifyCodeFields(email, code);
    if (error != null) {
      emit(VerifyCodeFailure(error));
      return;
    }

    // Check internet connectivity
    if (!await _isInternetAvailable()) {
      emit(VerifyCodeFailure(ApiConfig.noInternet));
      return;
    }

    emit(AuthLoading());
    try {
      // Send verification request to the backend
      final response = await _dioClient.dio.post(
        ApiConfig.verifyEmail,
        data: {'email': email.trim().toLowerCase(), 'otp': code},
      );

      print('🔹 Verify Code Response: ${response.data}');

      if (response.statusCode == 200) {
        // Emit success state to trigger navigation to LoginScreen
        emit(VerifyCodeSuccess());
      } else {
        emit(VerifyCodeFailure('Invalid verification code'));
      }
    } on DioException catch (e) {
      _handleDioError(e, isVerifyCode: true);
    } catch (e) {
      emit(VerifyCodeFailure('Verification failed: $e'));
    }
  }

  /// Requests a new OTP code for the given email (temporary solution for email verification).
  Future<void> forgotPassword(String email) async {
    // Validate email
    final error = _validateEmail(email);
    if (error != null) {
      emit(AuthFailure(error));
      return;
    }

    // Check internet connectivity
    if (!await _isInternetAvailable()) {
      emit(AuthFailure(ApiConfig.noInternet));
      return;
    }

    emit(AuthLoading());
    try {
      final response = await _dioClient.dio.post(
        ApiConfig.requestOtp,
        data: {'email': email.trim().toLowerCase()},
      );

      print('🔹 Forgot Password Response: ${response.data}');

      // Validate response data
      if (response.statusCode == 200 && response.data != null) {
        emit(ForgotPasswordSuccess());
      } else {
        print(
          '❌ Invalid response: Status ${response.statusCode}, Data: ${response.data}',
        );
        emit(AuthFailure(ApiConfig.resetEmailFailed));
      }
    } on DioException catch (e) {
      print(
        '❌ DioException in forgotPassword: ${e.message}, Response: ${e.response?.data}',
      );
      _handleDioError(e);
    } catch (e) {
      print('❌ Unexpected error in forgotPassword: $e');
      emit(AuthFailure('Failed to send OTP: $e'));
    }
  }

  /// Changes the user's password using the provided email, OTP, and new password.
  Future<void> changePassword(
    String email,
    String otp,
    String newPassword,
  ) async {
    // Validate new password
    final error = _validatePassword(newPassword);
    if (error != null) {
      emit(AuthFailure(error));
      return;
    }

    // Check internet connectivity
    if (!await _isInternetAvailable()) {
      emit(AuthFailure(ApiConfig.noInternet));
      return;
    }

    emit(AuthLoading());
    try {
      final response = await _dioClient.dio.post(
        ApiConfig.resetPassword,
        data: {
          'email': email.trim().toLowerCase(),
          'otp': otp,
          'newPassword': newPassword,
        },
      );

      print('🔹 Change Password Response: ${response.data}');

      // Validate response status
      if (response.statusCode == 200) {
        emit(AuthSuccess(user: null, message: 'Password changed successfully'));
      } else {
        emit(AuthFailure(ApiConfig.passwordChangeFailed));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        emit(AuthSessionExpired());
      } else {
        _handleDioError(e);
      }
    } catch (e) {
      emit(AuthFailure('Failed to change password: $e'));
    }
  }

  Future<void> completeProfile({
    required String userId,
    required String firstName,
    required String lastName,
    required String gender,
    required int age,
    String? bio,
    String? location,
    String? avatarPath, // File path for the avatar (optional)
  }) async {
    // Validate the fields
    final error = _validateProfileFields(
      firstName: firstName,
      lastName: lastName,
      gender: gender,
      age: age,
      bio: bio,
      location: location,
      avatarPath: avatarPath,
    );
    if (error != null) {
      emit(AuthFailure(error));
      return;
    }

    // Check for internet connectivity
    if (!await _isInternetAvailable()) {
      emit(AuthFailure(ApiConfig.noInternet));
      return;
    }

    emit(AuthLoading());
    try {
      // Prepare the data as FormData for the request
      final formDataMap = {
        'firstName': firstName.trim(),
        'lastName': lastName.trim(),
        'gender': gender.trim(),
        'age': age,
        if (bio != null && bio.trim().isNotEmpty) 'bio': bio.trim(),
        if (location != null && location.trim().isNotEmpty)
          'location': location.trim(),
        if (avatarPath != null)
          'avatarOriginalPath': avatarPath, // Add the original file path
      };

      // Add the avatar field only if a file is provided
      if (avatarPath != null) {
        final file = File(avatarPath);
        try {
          // Ensure the file exists and is readable
          final fileExists = await file.exists();
          if (!fileExists) {
            emit(
              AuthFailure(
                'The image file does not exist at the path: $avatarPath',
              ),
            );
            return;
          }
          final fileLength = await file.length();
          print('🔹 Image file size: ${fileLength / 1024} KB');
          if (fileLength == 0) {
            emit(AuthFailure('The image file is empty'));
            return;
          }

          // Extract the extension and create a filename similar to what the server uses
          final extension = avatarPath.split('.').last.toLowerCase();
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final newFilename =
              'avatar-$timestamp.$extension'; // Matches the server's naming pattern

          print('🔹 Local file path: $avatarPath');
          print('🔹 Sent filename: $newFilename');

          formDataMap['avatar'] = await MultipartFile.fromFile(
            avatarPath,
            filename: newFilename, // Use a filename similar to the server's
          );
        } catch (e) {
          print('Error accessing the image file: $e');
          emit(AuthFailure('Failed to access the image file: $e'));
          return;
        }
      }

      final formData = FormData.fromMap(formDataMap);

      // Log the data being sent to the server
      print('🔹 Sent data: ${formData.fields}');
      if (formData.files.isNotEmpty) {
        final avatarFile = formData.files.first.value;
        print(
          '🔹 Image file: ${avatarFile.filename} (format: ${avatarFile.filename?.split('.').last})',
        );
      } else {
        print('🔹 No image file attached');
      }

      // Send the update request to the server
      final response = await _dioClient.dio.put(
        ApiConfig.profile,
        data: formData,
      );

      // Log the server response
      print('🔹 Profile update response: ${response.data}');

      // Check the response status
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        if (!data.containsKey('data') || data['data'] == null) {
          emit(AuthFailure('Invalid profile update response'));
          return;
        }

        // Parse the user data from the response
        final userModel = UserModel.fromJson(data['data']);

        // Display the full URL of the image if present in the response
        if (userModel.avatar != null && userModel.avatar!.isNotEmpty) {
          // Build the full URL based on the server address
          final baseUrl =
              _dioClient.dio.options.baseUrl; // e.g., http://10.0.2.2:5000
          final avatarFullUrl =
              '$baseUrl/${userModel.avatar!.replaceAll('\\', '/')}';
          print('🔹 Full URL for the image: $avatarFullUrl');
        } else {
          print('🔹 No image uploaded in the response');
        }

        // Save the profile completion status in storage
        try {
          await _storageService.setProfileCompleted(userId);
        } catch (e) {
          emit(AuthFailure('Failed to save profile completion status: $e'));
          return;
        }

        // Emit success state to navigate to HomeScreen
        emit(
          AuthSuccess.login(
            userId: userId,
            user: userModel,
            isProfileCompleted: true,
          ),
        );
      } else {
        emit(AuthFailure(ApiConfig.profileUpdateFailed));
      }
    } on DioException catch (e) {
      // Handle Dio errors
      if (e.response?.statusCode == 401) {
        emit(AuthSessionExpired());
      } else if (e.response?.statusCode == 500 && e.response?.data is Map) {
        final data = e.response!.data as Map;
        if (data['error'] == 'Only JPG, JPEG, and PNG files are allowed') {
          emit(
            AuthFailure(
              'Ensure the image is in a valid JPG, JPEG, or PNG format, or skip uploading an image.',
            ),
          );
        } else {
          emit(AuthFailure('Server error: ${data['message'] ?? e.message}'));
        }
      } else {
        _handleDioError(e);
      }
    } catch (e) {
      // Log unexpected errors
      print(
        'Unexpected error in completeProfile: Type: ${e.runtimeType}, Message: $e',
      );
      emit(AuthFailure('Failed to update the profile: ${e.toString()}'));
    }
  }

  /// Logs in a user using a social platform (e.g., Google, Facebook).
  Future<void> socialLogin(String platform) async {
    // Check internet connectivity
    if (!await _isInternetAvailable()) {
      emit(AuthFailure(ApiConfig.noInternet));
      return;
    }

    emit(AuthSocialLogin(platform));
    try {
      final response = await _dioClient.dio.post(
        '/api/auth/social-login', // Use ApiConfig if endpoint exists
        data: {'platform': platform},
      );

      print('🔹 Social Login Response: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final userModel = UserModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        await _saveUserTokens(userModel);
        // Check if the user's profile is completed for this specific user
        final bool isProfileCompleted = await _storageService
            .isProfileCompleted(userModel.id);
        emit(
          AuthSuccess(
            userId: userModel.id,
            user: userModel,
            isLogin: true,
            isProfileCompleted: isProfileCompleted,
          ),
        );
      } else {
        emit(AuthFailure('Social login failed'));
      }
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      emit(AuthFailure('Social login failed: $e'));
    }
  }

  /// Checks the current authentication status and determines initial navigation.
  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    try {
      final token = await _storageService.getAccessToken();
      if (token == null || token.isEmpty) {
        emit(AuthInitial());
        return;
      }

      // Fetch user data to check authentication status
      final response = await _dioClient.dio.get(ApiConfig.me);
      print('🔹 Check Auth Status Response: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final userModel = UserModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        // Check if the user's profile is completed for this specific user
        final bool isProfileCompleted = await _storageService
            .isProfileCompleted(userModel.id);

        // Emit success state with profile completion status
        emit(
          AuthSuccess(
            userId: userModel.id,
            user: userModel,
            isProfileCompleted: isProfileCompleted,
          ),
        );
      } else {
        emit(AuthInitial());
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        emit(AuthSessionExpired());
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthInitial());
    }
  }

  /// Logs out the user and clears all stored data.
  Future<void> logout() async {
    try {
      // Get the user ID before clearing data
      final userId = await _storageService.getUserId();

      // Call the logout API
      await _dioClient.dio.post(ApiConfig.logout);

      // Clear all stored data
      if (userId != null) {
        await _storageService.clearProfileCompleted(userId);
      }
      await _storageService.clearTokens();
      await _storageService.clearUserId();
      await _storageService.clearLoginInfo();

      _stayConnected = false;
      emit(AuthLogoutSuccess());
    } catch (e) {
      emit(AuthFailure(ApiConfig.logoutFailed));
    }
  }

  /// Toggles the stay connected option.
  void toggleStayConnected(bool value) {
    _stayConnected = value;
    emit(AuthStayConnectedChanged(_stayConnected));
  }

  /// Saves user tokens to secure storage.
  Future<void> _saveUserTokens(UserModel user) async {
    if (user.accessToken == null || user.accessToken!.isEmpty) {
      emit(AuthFailure('Invalid authentication tokens received'));
      return;
    }
    try {
      await _storageService.saveTokens(
        accessToken: user.accessToken!,
        refreshToken: user.refreshToken ?? '',
        expiresIn:
            user.expiresIn?.toIso8601String() ??
            DateTime.now().add(const Duration(days: 30)).toIso8601String(),
      );
    } catch (e) {
      emit(AuthFailure('Failed to save authentication tokens: $e'));
    }
  }

  /// Validates login fields (email and password).
  String? _validateLoginFields(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      return 'Email and password cannot be empty';
    }
    if (!Validators.isValidEmail(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates registration fields (username, email, password, confirm password).
  String? _validateRegistrationFields(
    String username,
    String email,
    String password,
    String confirmPassword,
  ) {
    if ([username, email, password, confirmPassword].any((e) => e.isEmpty)) {
      return 'All fields are required';
    }
    if (!Validators.isValidEmail(email)) {
      return 'Invalid email address';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    if (!Validators.isValidPassword(password)) {
      return 'Password must be at least 8 characters, include a letter, number, and special character';
    }
    return null;
  }

  /// Validates verify code fields (email and code).
  String? _validateVerifyCodeFields(String email, String code) {
    if (email.isEmpty || code.isEmpty) {
      return 'Email and code cannot be empty';
    }
    return null;
  }

  /// Validates an email address.
  String? _validateEmail(String email) {
    if (!Validators.isValidEmail(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates a password.
  String? _validatePassword(String password) {
    if (!Validators.isValidPassword(password)) {
      return 'Password must be at least 8 characters, include a letter, number, and special character';
    }
    return null;
  }

  /// Validates profile fields (firstName, lastName, gender, age, bio, location, avatarPath).
  /// Returns an error message if validation fails, or null if all fields are valid.
  String? _validateProfileFields({
    required String firstName,
    required String lastName,
    required String gender,
    required int age,
    String? bio,
    String? location,
    String? avatarPath,
  }) {
    // Validate required fields
    if (firstName.trim().isEmpty) {
      return 'First name is required';
    }
    if (lastName.trim().isEmpty) {
      return 'Last name is required';
    }
    if (gender.trim().isEmpty) {
      return 'Gender is required';
    }
    if (age <= 0) {
      return 'Age must be a positive number';
    }

    // Optional: Validate bio and location if provided
    if (bio != null && bio.trim().isEmpty) {
      return 'Bio cannot be empty if provided';
    }
    if (location != null && location.trim().isEmpty) {
      return 'Location cannot be empty if provided';
    }

    // Optional: Validate avatar file existence and type if provided
    if (avatarPath != null) {
      try {
        final file = File(avatarPath);
        if (!file.existsSync()) {
          return 'Avatar file does not exist';
        }
        final extension = avatarPath.split('.').last.toLowerCase();
        if (!['jpg', 'jpeg', 'png'].contains(extension)) {
          return 'Avatar must be a JPG, JPEG, or PNG file';
        }
      } catch (e) {
        return 'Invalid avatar file path: $e';
      }
    }

    return null;
  }

  /// Handles Dio errors and emits the appropriate failure state.
  void _handleDioError(DioException e, {bool isVerifyCode = false}) {
    String errorMessage;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Request timed out. Please try again.';
        break;
      case DioExceptionType.badResponse:
        errorMessage =
            _extractErrorMessage(e.response?.data) ??
            'Server error: ${e.response?.statusCode}';
        break;
      case DioExceptionType.connectionError:
        errorMessage = ApiConfig.noInternet;
        break;
      default:
        errorMessage = 'An unexpected error occurred: ${e.message}';
    }
    print('❌ Dio Error: $errorMessage');
    emit(
      isVerifyCode
          ? VerifyCodeFailure(errorMessage)
          : AuthFailure(errorMessage),
    );
  }

  /// Extracts error message from API response, simplified for better performance.
  String? _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['error']?.toString() ??
          data['message']?.toString() ??
          (data['errors'] is List
              ? (data['errors'] as List).join(', ')
              : data['errors']?.toString());
    }
    return data?.toString();
  }
}
