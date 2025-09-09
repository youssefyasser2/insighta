import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/features/auth/presentation/register/register_screen.dart';
import 'package:test_app/features/booking/booking_screen.dart';
import 'package:test_app/features/completeprofile/complete_profile_screen.dart';
import 'package:test_app/features/auth/presentation/forget_password/forgot_password_screen.dart';
import 'package:test_app/features/auth/presentation/login/login_screen.dart';
import 'package:test_app/features/auth/presentation/verify_code/verify_code_screen.dart';
import 'package:test_app/features/home/home_screen.dart';
import 'package:test_app/features/onboarding/logic/cubit/onboarding_cubit.dart';
import 'package:test_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:test_app/features/linkedaccount/domain/entities/linked_account.dart';
import 'package:test_app/features/linkedaccount/presentation/pages/account_report_page.dart';
import 'package:test_app/features/linkedaccount/presentation/pages/account_usage_page.dart';
import 'package:test_app/features/linkedaccount/presentation/pages/linked_accounts_screen.dart';
import 'package:test_app/features/profile/view/profile_screen.dart';
import 'package:test_app/features/report/ui/report_card_details_screen.dart';
import 'package:test_app/features/report/ui/report_screen.dart';
import 'package:test_app/features/setting/settings_screen.dart';
import 'package:test_app/features/setting/change_password_screen.dart';
import 'package:test_app/features/setting/delete_account_screen.dart';
import 'package:test_app/features/setting/privacy_policy_screen.dart';
import 'package:test_app/features/setting/notifications_screen.dart';
import 'package:test_app/features/suggest/suggest_screen.dart';
import 'package:test_app/features/therapy/data/repositories/therapy_repository_impl.dart';
import 'package:test_app/features/therapy/domain/entities/therapist.dart';
import 'package:test_app/features/therapy/presentation/cubit/therapy_cubit.dart';
import 'package:test_app/features/therapy/presentation/pages/best_therapy_page.dart';
import 'package:test_app/features/timeslot/presentation/pages/timesheet_confirmation_dialog.dart';
import 'package:test_app/features/timeslot/presentation/pages/timesheet_page.dart';
import 'package:test_app/features/usage/usage_screen.dart';
import 'routes.dart';

class AppRouter {
  static SharedPreferences? _prefs;
  static late GoRouter _router;
  static bool _isInitialized = false;

  static Future<void> init() async {
    if (_isInitialized) return;
    try {
      _prefs = await SharedPreferences.getInstance();
      final String lastRoute = _prefs?.getString('lastRoute') ?? Routes.root;
      if (!Routes.isValid(lastRoute)) {
        print(
          'Warning: Invalid last route: $lastRoute, defaulting to ${Routes.root}',
        );
      }
      _router = GoRouter(
        initialLocation: Routes.isValid(lastRoute) ? lastRoute : Routes.root,
        routes: _routes,
        errorBuilder: (context, state) => _buildNotFoundScreen(state),
      );
      _isInitialized = true;
    } catch (e) {
      print('Error initializing SharedPreferences: $e');
      _router = GoRouter(
        initialLocation: Routes.root,
        routes: _routes,
        errorBuilder: (context, state) => _buildNotFoundScreen(state),
      );
      _isInitialized = true;
    }
  }

  static Future<GoRouter> getRouter() async {
    if (!_isInitialized) await init();
    return _router;
  }

  static GoRouter get router {
    if (!_isInitialized) {
      throw Exception(
        'Router has not been initialized. Call `await AppRouter.init()` first.',
      );
    }
    return _router;
  }

  static final List<GoRoute> _routes = [
    // Onboarding
    GoRoute(
      path: Routes.onboarding,
      pageBuilder:
          (context, state) => _buildRoutePage(
            context,
            state,
            Routes.onboarding,
            BlocProvider(
              create: (context) => OnboardingCubit(),
              child: const OnboardingScreen(),
            ),
          ),
    ),

    // Authentication
    GoRoute(
      path: Routes.login,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final String? userId = extra?['userId'] as String?;
        return _buildRoutePage(
          context,
          state,
          Routes.login,
          LoginScreen(userId: userId),
        );
      },
    ),
    _buildRoute(Routes.register, const RegisterScreen()),
    _buildRoute(Routes.forgotPassword, const ForgotPasswordScreen()),
    GoRoute(
      path: Routes.verifyCode,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final String? email = extra?['email'] as String?;
        final String? userId = extra?['userId'] as String?;
        if (email == null || email.isEmpty) {
          return _buildRedirectPage(context, state, Routes.login);
        }
        return _buildRoutePage(
          context,
          state,
          Routes.verifyCode,
          VerifyCodeScreen(userId: userId, email: email),
        );
      },
    ),
    GoRoute(
      path: Routes.completeProfile,
      pageBuilder: (context, state) {
        final userId = state.extra as String?;
        if (userId == null || userId.isEmpty) {
          return _buildRedirectPage(context, state, Routes.login);
        }
        return _buildRoutePage(
          context,
          state,
          Routes.completeProfile,
          CompleteProfileScreen(userId: userId),
        );
      },
    ),

    // Main App Features
    _buildRoute(Routes.home, const HomeScreen()),
    GoRoute(
      path: '/therapy',
      builder:
          (context, state) => BlocProvider(
            create:
                (context) =>
                    TherapyCubit(TherapyRepositoryImpl())..loadBestTherapists(),
            child: const BestTherapyPage(),
          ),
    ),
    GoRoute(
      path: '/timesheet',
      name: 'timesheet',
      builder: (context, state) {
        final therapist = state.extra as Therapist?;
        if (therapist == null || therapist.id.isEmpty) {
          return Scaffold(body: Center(child: Text('Invalid therapist data')));
        }
        return TimesheetPage(therapist: therapist);
      },
    ),
    // booking success
    GoRoute(
      path: '/booking-success',
      name: 'bookingSuccess',
      builder: (context, state) {
        final extras = state.extra;
        if (extras is! Map<String, dynamic> ||
            extras['date'] == null ||
            extras['time'] == null) {
          return Scaffold(body: Center(child: Text('Invalid booking data')));
        }

        return BookingSuccessfulPage(
          date: extras['date'] as DateTime,
          time: extras['time'] as String,
        );
      },
    ),
    _buildRoute(Routes.booking, const BookingScreen()),
    _buildRoute(Routes.report, const ReportScreen()),
    GoRoute(
      path: Routes.reportCardDetailsScreen, // Use the defined constant
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final platform = extra?['platform'] as String?;
        final assetPath = extra?['assetPath'] as String?;
        if (platform == null ||
            assetPath == null ||
            platform.isEmpty ||
            assetPath.isEmpty) {
          return _buildRedirectPage(context, state, Routes.login);
        }
        return _buildRoutePage(
          context,
          state,
          Routes.reportCardDetailsScreen,
          ReportCardDetailsScreen(platform: platform, assetPath: assetPath),
        );
      },
    ),
    _buildRoute(Routes.usage, const UsageScreen()),
    _buildRoute(Routes.suggest, const SuggestScreen()),

    // Linked Accounts
    GoRoute(
      path: '/linked-accounts',
      name: 'linked-accounts',
      builder: (context, state) => const LinkedAccountsPage(),
    ),

    GoRoute(
      path: '/accounts/report',
      name: 'account-report',
      builder: (context, state) {
        final account = state.extra as LinkedAccount;
        return AccountReportPage(account: account);
      },
    ),
    GoRoute(
      path: '/accounts/usage',
      name: 'account-usage',
      builder: (context, state) {
        final account = state.extra as LinkedAccount;
        return AccountUsagePage(account: account);
      },
    ),

    // Profile and Settings
    _buildRoute(Routes.profile, const ProfileScreen()),
    _buildRoute(Routes.settings, const SettingsScreen()),
    _buildRoute(Routes.changePassword, const ChangePasswordScreen()),
    _buildRoute(Routes.deleteAccount, const DeleteAccountScreen()),
    _buildRoute(Routes.privacyPolicy, const PrivacyPolicyScreen()),
    _buildRoute(Routes.notifications, const NotificationsScreen()),
    _buildRoute(Routes.notifications, const NotificationsScreen()),
  ];

  static GoRoute _buildRoute(String path, Widget page) {
    return GoRoute(
      path: path,
      pageBuilder:
          (context, state) => _buildRoutePage(context, state, path, page),
    );
  }

  static CustomTransitionPage _buildRoutePage(
    BuildContext context,
    GoRouterState state,
    String path,
    Widget child,
  ) {
    _saveLastRoute(path);
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  static CustomTransitionPage _buildRedirectPage(
    BuildContext context,
    GoRouterState state,
    String redirectTo,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: _RedirectTo(redirectTo: redirectTo),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static Future<void> _saveLastRoute(String route) async {
    if (_prefs == null) return;
    try {
      if (Routes.isValid(route)) {
        await _prefs!.setString('lastRoute', route);
      } else {
        print('Warning: Attempted to save invalid route: $route');
      }
    } catch (e) {
      print('Error saving last route: $e');
    }
  }

  static Widget _buildNotFoundScreen(GoRouterState state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '404 - Page Not Found: ${state.uri}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => router.go(Routes.login),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RedirectTo extends StatefulWidget {
  final String redirectTo;
  const _RedirectTo({required this.redirectTo});

  @override
  _RedirectToState createState() => _RedirectToState();
}

class _RedirectToState extends State<_RedirectTo> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go(widget.redirectTo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
