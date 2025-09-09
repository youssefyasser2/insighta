import 'package:equatable/equatable.dart';
import 'package:test_app/features/profile/data/models/user_model.dart';

/// Base state for authentication operations.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the app starts or no authentication has occurred.
class AuthInitial extends AuthState {}

/// State emitted when an authentication operation is in progress.
class AuthLoading extends AuthState {}

/// State emitted when an authentication operation (login/register) succeeds.
class AuthSuccess extends AuthState {
  final String? userId;
  final UserModel? user;
  final String? message;
  final bool isLogin;
  final bool isRegister;
  final bool isProfileCompleted;
  final String? gender; // User's gender for direct access
  final int? age; // User's age for direct access
  final String? firstName; // Added: User's first name for direct access
  final String? lastName; // Added: User's last name for direct access
  final String? avatar; // Added: User's avatar for direct access

  const AuthSuccess({
    this.userId,
    this.user,
    this.message,
    this.isLogin = false,
    this.isRegister = false,
    this.isProfileCompleted = false,
    this.gender,
    this.age,
    this.firstName, // Added
    this.lastName, // Added
    this.avatar, // Added
  });

  /// Factory constructor for login success, including profile completion status.
  factory AuthSuccess.login({
    required String userId,
    required UserModel? user,
    required bool isProfileCompleted,
  }) => AuthSuccess(
    userId: userId,
    user: user,
    isLogin: true,
    isProfileCompleted: isProfileCompleted,
    gender: user?.gender,
    age: user?.age,
    firstName: user?.firstName, // Added: Extract firstName from UserModel
    lastName: user?.lastName, // Added: Extract lastName from UserModel
    avatar: user?.avatar, // Added: Extract avatar from UserModel
  );

  /// Factory constructor for registration success.
  factory AuthSuccess.register({
    required String userId,
    required UserModel user,
    required bool isProfileCompleted,
    String? message,
  }) {
    return AuthSuccess(
      userId: userId,
      user: user,
      isLogin: false,
      isRegister: true, // Fixed: Set isRegister to true for registration
      isProfileCompleted: isProfileCompleted,
      message: message,
      gender: user.gender,
      age: user.age,
      firstName: user.firstName, // Added: Extract firstName from UserModel
      lastName: user.lastName, // Added: Extract lastName from UserModel
      avatar: user.avatar, // Added: Extract avatar from UserModel
    );
  }

  @override
  List<Object?> get props => [
    userId,
    user,
    isLogin,
    isRegister,
    isProfileCompleted,
    message,
    gender,
    age,
    firstName, // Added: Include firstName in props
    lastName, // Added: Include lastName in props
    avatar, // Added: Include avatar in props
  ];
}

/// State emitted when an authentication operation fails.
class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// State emitted when verifying an OTP code succeeds.
class VerifyCodeSuccess extends AuthState {}

/// State emitted when verifying an OTP code fails.
class VerifyCodeFailure extends AuthState {
  final String message;

  const VerifyCodeFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// State emitted when requesting a password reset.
class AuthForgotPassword extends AuthState {}

/// State emitted when a password reset request succeeds.
class ForgotPasswordSuccess extends AuthState {}

/// State emitted during a social login operation.
class AuthSocialLogin extends AuthState {
  final String platform;

  const AuthSocialLogin(this.platform);

  @override
  List<Object?> get props => [platform];
}

/// State emitted when the authentication session expires (e.g., 401 error).
class AuthSessionExpired extends AuthState {}

/// State emitted when logout succeeds.
class AuthLogoutSuccess extends AuthState {}

/// State emitted when the "stay connected" option changes.
class AuthStayConnectedChanged extends AuthState {
  final bool stayConnected;

  const AuthStayConnectedChanged(this.stayConnected);

  @override
  List<Object?> get props => [stayConnected];
}
