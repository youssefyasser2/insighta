import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test_app/controllers/user_controller.dart';
import 'package:test_app/app/app_config.dart';
import 'package:test_app/core/theme_provider.dart';
import 'package:test_app/features/auth/logic/auth_cubit.dart';
import 'package:test_app/core/services/storage_service.dart';
import 'package:test_app/core/services/dio_client.dart'; // أضفنا استيراد DioClient
import 'package:test_app/features/screens/error_screen.dart';

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  _AppInitializerState createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  late Future<AppConfig> _appConfig;

  @override
  void initState() {
    super.initState();
    _appConfig = initializeApp();
  }

  Future<AppConfig> initializeApp() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      const secureStorage = FlutterSecureStorage();
      final storageService = StorageService(
        prefs: prefs,
        secureStorage: secureStorage,
      );

      // ✅ إنشاء وتهيئة DioClient
      final dioClient = DioClient();
      dioClient.initialize(storageService: storageService);

      final bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
      final bool isLoggedIn = await storageService.isLoggedIn();

      // ✅ استعادة آخر مسار (إن وجد) أو تحديد المسار بناءً على حالة تسجيل الدخول
      final String? lastRoute = prefs.getString('lastRoute');
      final String initialRoute =
          isLoggedIn
              ? (lastRoute?.isNotEmpty == true ? lastRoute! : '/home')
              : '/';

      return AppConfig(
        storageService: storageService,
        isDarkMode: isDarkMode,
        initialRoute: initialRoute,
        sharedPreferences: prefs,
      );
    } catch (error) {
      throw Exception("Failed to initialize app: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppConfig>(
      future: _appConfig,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        } else if (snapshot.hasError) {
          return const MaterialApp(home: ErrorScreen());
        }

        final config = snapshot.data!;
        return MultiProvider(
          providers: [
            Provider<StorageService>.value(value: config.storageService),
            Provider<DioClient>.value(
              value: DioClient(),
            ), // ✅ أضفنا DioClient كـ Provider
            ChangeNotifierProvider(
              create: (context) => ThemeProvider(config.isDarkMode),
            ),
            ChangeNotifierProvider(
              create: (context) => UserController(config.sharedPreferences),
            ),
            BlocProvider(
              create:
                  (context) => AuthCubit(
                    dioClient:
                        context.read<DioClient>(), // ✅ تمرير DioClient هنا
                    storageService: config.storageService,
                  ),
            ),
          ],
          child:
              const SizedBox(), // ✅ مؤقتًا، لأننا بنرجع الـ child في السطر التالي
        );
      },
    );
  }
}
