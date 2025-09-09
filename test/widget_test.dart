import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart'; // ✅ Import GoRouter
import 'package:test_app/features/auth/presentation/login/login_screen.dart';
import 'package:test_app/navigation/app_router.dart';
import 'package:test_app/features/home/home_screen.dart';
import 'package:test_app/core/services/storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FakeFlutterSecureStorage extends FlutterSecureStorage {
  final Map<String, String> _storage = {};

  @override
  Future<String?> read({
    required String key,
    AndroidOptions? aOptions,
    IOSOptions? iOptions,
    LinuxOptions? lOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  }) async {
    return _storage[key];
  }

  @override
  Future<void> write({
    required String key,
    required String? value,
    AndroidOptions? aOptions,
    IOSOptions? iOptions,
    LinuxOptions? lOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  }) async {
    if (value != null) {
      _storage[key] = value;
    }
  }

  @override
  Future<void> delete({
    required String key,
    AndroidOptions? aOptions,
    IOSOptions? iOptions,
    LinuxOptions? lOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  }) async {
    _storage.remove(key);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  late SharedPreferences prefs;
  late StorageService storageService;
  late bool isLoggedIn;
  late GoRouter testRouter;

  setUpAll(() async {
    prefs = await SharedPreferences.getInstance();
    final secureStorage = FakeFlutterSecureStorage();
    storageService = StorageService(prefs: prefs, secureStorage: secureStorage);

    await secureStorage.write(key: 'userId', value: '123');
    final userId = await storageService.getUserId();
    isLoggedIn = userId != null;

    // ✅ Fetch the router dynamically
testRouter = await AppRouter.getRouter();
  });

  testWidgets('🔍 App loads the correct screen', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: testRouter));

    await tester.pumpAndSettle();

    // ✅ Explicit type comparison
    expect(find.byType(isLoggedIn ? HomeScreen : LoginScreen), findsOneWidget);
  });
}
