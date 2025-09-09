import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../core/services/storage_service.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  _DeleteAccountScreenState createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  StorageService? _storageService;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeStorageService();
  }

  Future<void> _initializeStorageService() async {
    final prefs = await SharedPreferences.getInstance();
    const secureStorage = FlutterSecureStorage();
    
    setState(() {
      _storageService = StorageService(prefs: prefs, secureStorage: secureStorage);
    });
  }

  /// حذف الحساب من الـ API باستخدام `DELETE`
  Future<bool> deleteAccountFromAPI(String userId) async {
    final url = Uri.parse(
      'https://67b8b14a699a8a7baef4f48b.mockapi.io/api/login/$userId',
    );

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true; // تم الحذف بنجاح
      } else {
        debugPrint("Error: ${response.statusCode} - ${response.body}");
        return false; // فشل الحذف
      }
    } catch (e) {
      debugPrint("Exception: $e");
      return false; // خطأ في الاتصال
    }
  }

  Future<void> _deleteAccount() async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete", style: TextStyle(color: Colors.red)),
          content: const Text(
            "Are you sure you want to delete your account? This action is irreversible.",
            textAlign: TextAlign.center,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(false), // عند الإلغاء، نعيد `false`
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => context.pop(true), // عند التأكيد، نعيد `true`
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmDelete != true) return; // ✅ التعامل مع حالة الإلغاء

    setState(() {
      _isLoading = true;
    });

    if (_storageService == null) {
      _showSnackBar("Error: Storage service not initialized.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    String? userId = await _storageService!.getUserId();
    if (userId == null) {
      _showSnackBar("Error: No user ID found.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    bool success = await deleteAccountFromAPI(userId);
    if (success) {
      await _storageService!.clearAllData();
      if (mounted) {
        context.go('/login'); // ✅ إعادة التوجيه بعد الحذف
      }
    } else {
      _showSnackBar("Failed to delete account. Try again later.");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black54),
                onPressed: () => context.pop(),
              ),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.warning_amber_rounded, size: 80, color: Colors.red),
            const SizedBox(height: 20),
            const Text(
              "Delete Account",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Once you delete your account, there is no going back. Please be certain.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 40),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _deleteAccount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      "Delete My Account",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
