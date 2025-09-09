import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:test_app/core/services/storage_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String? userId;
  late StorageService storageService;
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isLoading = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _initializeStorageService();
  }

  Future<void> _initializeStorageService() async {
    final prefs = await SharedPreferences.getInstance();
    final secureStorage = FlutterSecureStorage();
    storageService = StorageService(prefs: prefs, secureStorage: secureStorage);
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    String? id = await storageService.getUserId();
    setState(() {
      userId = id ?? "Not Found";
    });
  }

  Future<void> _changePassword() async {
    if (userId == null || userId == "Not Found") {
      _showMessage('⚠️ User ID not found!');
      return;
    }

    String newPassword = newPasswordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      _showMessage('⚠️ All fields are required!');
      return;
    }

    if (newPassword != confirmPassword) {
      _showMessage('⚠️ Passwords do not match!');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.patch(
        Uri.parse(
          'https://67b8b14a699a8a7baef4f48b.mockapi.io/api/login/$userId',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'password': newPassword}),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        _showMessage('✅ Password updated successfully!');
        _clearFields();
        Future.delayed(Duration(seconds: 1), () {
          _navigateToHomeWithAnimation();
        });
      } else {
        _showMessage('❌ Failed to update: ${responseData.toString()}');
      }
    } catch (e) {
      _showMessage('❌ Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _clearFields() {
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _navigateToHomeWithAnimation() {
    context.go('/home');
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      appBar: AppBar(
        title: Text(
          "Change Password",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Color(0xFF076372),
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, size: 80, color: Color(0xFF076372)),
            SizedBox(height: 20),
            Text(
              "Reset Your Password",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF076372),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Enter a new password below to update your account security.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 30),
            _buildPasswordField(
              "New Password",
              newPasswordController,
              isPasswordVisible,
              () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            ),
            SizedBox(height: 15),
            _buildPasswordField(
              "Confirm Password",
              confirmPasswordController,
              isConfirmPasswordVisible,
              () {
                setState(() {
                  isConfirmPasswordVisible = !isConfirmPasswordVisible;
                });
              },
            ),
            SizedBox(height: 30),
            isLoading
                ? CircularProgressIndicator(color: Color(0xFF076372))
                : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF076372),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _changePassword,
                    child: Text(
                      "Change Password",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool isVisible,
    VoidCallback toggleVisibility,
  ) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      style: TextStyle(fontSize: 18), // تكبير الخط
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.black87,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ), // زيادة التباعد الداخلي
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF076372), width: 2.5),
        ),
        suffixIcon: Padding(
          padding: EdgeInsets.only(
            right: 10,
          ), // تقليل المسافة بين الأيقونة والنص
          child: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: Color(0xFF076372),
              size: 26, // تكبير الأيقونة
            ),
            onPressed: toggleVisibility,
          ),
        ),
      ),
    );
  }
}
