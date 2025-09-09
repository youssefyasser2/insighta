import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends ChangeNotifier {
  final SharedPreferences prefs;
  String _userId = '';

  UserController(this.prefs) {
    loadUserId();
  }

  String get userId => _userId;

  void loadUserId() {
    _userId = prefs.getString('userId') ?? '';
    notifyListeners(); // إشعار الواجهة بالتغيير
  }

  Future<void> setUserId(String id) async {
    bool isSaved = await prefs.setString('userId', id);
    if (isSaved) {
      _userId = id;
      notifyListeners();
    } else {
      if (kDebugMode) print("❌ Failed to save userId");
    }
  }

  Future<void> clearUserId() async {
    await prefs.remove('userId');
    _userId = '';
    notifyListeners();
  }
}
