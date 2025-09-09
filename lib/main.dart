import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/app/my_app.dart';
import 'package:test_app/core/services/storage_service.dart';
import 'package:test_app/core/services/dio_client.dart';
import 'package:test_app/features/auth/logic/auth_cubit.dart';
import 'package:test_app/features/booking/logic/date_select_cubit/date_select_cubit.dart'; // استيراد DateSelectCubit
import 'package:test_app/features/booking/logic/time_select_cubit/time_select_cubit.dart'; // استيراد TimeSelectCubit
import 'package:flutter_bloc/flutter_bloc.dart'; // استيراد flutter_bloc
import 'dart:developer' as developer; // For logging control

/// Entry point of the application.
/// Initializes dependencies and sets up the app with providers.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Reduce log verbosity to suppress minor warnings
  developer.log('Starting app initialization...', name: 'Main');
  FlutterError.onError = (FlutterErrorDetails details) {
    if (!details.exceptionAsString().contains('OpenGL ES') &&
        !details.exceptionAsString().contains('EGL_emulation')) {
      developer.log(details.exceptionAsString(), name: 'FlutterError');
    }
  };

  try {
    // Initialize ScreenUtil dynamically based on device screen size
    final mediaQuery = MediaQueryData.fromView(WidgetsBinding.instance.window);
    await ScreenUtil.ensureScreenSize(); // Ensure screen dimensions are available

    // Use a dynamic design size based on the smaller dimension of the screen
    final designWidth = mediaQuery.size.width;
    final designHeight = mediaQuery.size.height;
    final designSize = Size(designWidth, designHeight);

    // SharedPreferences
    final sharedPreferences = await SharedPreferences.getInstance();
    developer.log('✅ SharedPreferences initialized successfully', name: 'Main');

    // FlutterSecureStorage
    const secureStorage = FlutterSecureStorage();
    developer.log(
      '✅ FlutterSecureStorage initialized successfully',
      name: 'Main',
    );

    // StorageService
    final storageService = StorageService(
      prefs: sharedPreferences,
      secureStorage: secureStorage,
    );
    developer.log('✅ StorageService initialized successfully', name: 'Main');

    // DioClient
    final dioClient = DioClient();
    dioClient.initialize(storageService: storageService);
    developer.log('✅ DioClient initialized successfully', name: 'Main');

    // Run the app with MultiProvider and enable performance overlay
    runApp(
      ScreenUtilInit(
        designSize: designSize, // Dynamic design size based on device
        minTextAdapt: true, // Ensure text scales responsively
        builder:
            (context, child) => MultiProvider(
              providers: [
                Provider<StorageService>.value(value: storageService),
                Provider<DioClient>.value(value: dioClient),
                Provider<AuthCubit>(
                  create:
                      (_) => AuthCubit(
                        dioClient: dioClient,
                        storageService: storageService,
                      ),
                ),
                // إضافة DateSelectCubit كـ BlocProvider
                BlocProvider<DateSelectCubit>(create: (_) => DateSelectCubit()),
                // إضافة TimeSelectCubit كـ BlocProvider مع الاعتماد على DateSelectCubit
                BlocProvider<TimeSelectCubit>(
                  create:
                      (context) => TimeSelectCubit(
                        dateSelectCubit: context.read<DateSelectCubit>(),
                      ),
                ),
              ],
              child: const MyApp(
                showPerformanceOverlay: true, // Enable performance overlay
              ),
            ),
      ),
    );
  } catch (e) {
    developer.log('❌ Failed to initialize app: $e', name: 'Main');
    runApp(const InitializationErrorApp());
  }
}

/// A fallback widget to display if the app fails to initialize.
class InitializationErrorApp extends StatelessWidget {
  const InitializationErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Failed to initialize the app.',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => main(), // Retry initialization
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
