/// Defines all navigation routes in the app as constants.
class Routes {
  // ✅ Authentication routes
  /// Navigates to the login screen.
  static const String login = '/login';

  /// Navigates to the registration screen.
  static const String register = '/register';

  /// Navigates to the forgot password screen.
  static const String forgotPassword = '/forgot-password';

  /// Navigates to the verification code screen.
  static const String verifyCode = '/verify-code';

  /// Navigates to the onboarding screen (app entry point).
  static const String onboarding = '/';

  // ✅ Home and profile routes
  /// Navigates to the home screen.
  static const String home = '/home';

  /// Navigates to the user profile screen.
  static const String profile = '/profile';

  /// Navigates to the settings screen.
  static const String settings = '/settings';

  // ✅ Settings and security routes
  /// Navigates to the change password screen.
  static const String changePassword = '/change-password';

  /// Navigates to the account deletion screen.
  static const String deleteAccount = '/delete-account';

  /// Navigates to the privacy policy screen.
  static const String privacyPolicy = '/privacy-policy';

  /// Navigates to the notifications settings screen.
  static const String notifications = '/notifications';

  // ✅ Additional routes
  /// Navigates to the therapy screen.
  static const String therapy = '/therapy';

  /// Navigates to the ideas screen.
  static const String ideas = '/ideas';

  /// Navigates to the complete profile screen.
  static const String completeProfile = '/complete-profile';

  /// Navigates to the parent dashboard screen.
  static const String parent = '/parent';

  /// Navigates to the linked accounts screen.
  static const String linkedAccounts = '/linked-accounts';

  /// Navigates to the report generation screen.
  static const String report = '/report';

  /// Navigates to the booking screen.
  static const String booking = '/booking';

  /// Navigates to the booking success screen.
  static const String bookingSuccess = 'bookingSuccess'; // Use the route name
  /// Navigates to the time slot selection screen.
  static const String selectTimeSlotsScreen = '/select-time-slots';

  /// Navigates to the usage statistics screen.
  static const String usage = '/usage';

  /// Navigates to the suggestion submission screen.
  static const String suggest = '/suggest';

  /// Navigates to the time slot  screen.
  static const String timeSlot = '/timeSlot';

  /// Navigates to the report card details screen.
  static const String reportCardDetailsScreen = '/report-card-details';

  // ✅ List of all routes for easy validation
  static const List<String> all = [
    login,
    register,
    forgotPassword,
    verifyCode,
    onboarding,
    home,
    profile,
    settings,
    changePassword,
    deleteAccount,
    privacyPolicy,
    notifications,
    therapy,
    ideas,
    completeProfile,
    parent,
    linkedAccounts,
    report,
    booking,
    bookingSuccess,
    selectTimeSlotsScreen,
    usage,
    suggest,
    reportCardDetailsScreen,
    timeSlot,
  ];

  /// Checks if a route is valid and logs a warning if it is not.
  static bool isValid(String route) {
    final isValid = all.contains(route);
    if (!isValid) {
      print('Warning: Invalid route: $route');
    }
    return isValid;
  }

  /// Returns the root route of the app.
  static String get root => onboarding;
}
