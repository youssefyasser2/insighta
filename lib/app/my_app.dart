import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:test_app/core/theme_provider.dart';
import 'package:test_app/navigation/app_router.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key, required bool showPerformanceOverlay});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoRouter? _router;
  ThemeProvider? _themeProvider;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final router = await AppRouter.getRouter();
      final themeProvider = await ThemeProvider.loadTheme();

      if (mounted) {
        setState(() {
          _router = router;
          _themeProvider = themeProvider;
        });
      }
    } catch (e) {
      // عرض رسالة خطأ أو معالجة الفشل هنا
      print("Error initializing app: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_themeProvider == null || _router == null) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
        debugShowCheckedModeBanner: false,
      );
    }

    return ChangeNotifierProvider(
      create: (_) => _themeProvider!,
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme:
                themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
