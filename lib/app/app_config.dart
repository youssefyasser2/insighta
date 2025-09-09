import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/core/services/storage_service.dart';

class AppConfig {
  final StorageService storageService;
  final bool isDarkMode;
  final String initialRoute;
  final SharedPreferences sharedPreferences;

  AppConfig({
    required this.storageService,
    required this.isDarkMode,
    required this.initialRoute,
    required this.sharedPreferences,
  });
}
