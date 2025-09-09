import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/features/auth/logic/auth_cubit.dart';

// Enum to represent gender options
enum Gender { male, female }

class CompleteProfileController {
  // Controllers for form inputs
  final PageController pageController = PageController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  // Form keys for validation
  final List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  // State variables
  Gender? _selectedGender;
  XFile? _avatarImage;
  int _currentPage = 0;

  // Constants
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color primaryColor = Color(0xFF086473);
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png'];

  // Getters
  Gender? get selectedGender => _selectedGender;
  XFile? get avatarImage => _avatarImage;
  int get currentPage => _currentPage;

  // Helper method to parse age range into a single integer
  int? _parseAgeRange(String ageRange) {
    // Extract the numeric range (e.g., "6-8" from "6-8 (Early Primary Child)")
    final numericRange = ageRange.split('(')[0].trim(); // Get "6-8"

    // Handle "65+" case
    if (numericRange.endsWith('+')) {
      final baseAge = int.tryParse(numericRange.replaceAll('+', ''));
      return baseAge != null && baseAge > 0 ? baseAge : null;
    }

    // Split the range (e.g., "6-8" -> ["6", "8"])
    final rangeParts = numericRange.split('-');
    if (rangeParts.length != 2) return null;

    // Parse the start and end of the range
    final startAge = int.tryParse(rangeParts[0].trim());
    final endAge = int.tryParse(rangeParts[1].trim());

    if (startAge == null ||
        endAge == null ||
        startAge <= 0 ||
        endAge <= 0 ||
        startAge >= endAge) {
      return null;
    }

    // Return the average of the range
    return (startAge + endAge) ~/ 2;
  }

  // Initialize controller
  void initialize(BuildContext context) {
    context.read<AuthCubit>().checkAuthStatus();
  }

  // Navigate to the next page if the current form is valid
  void nextPage(BuildContext context) {
    if (formKeys[_currentPage].currentState!.validate()) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _currentPage++;
    } else {
      showSnackBar(context, 'Please fill all required fields.', isError: true);
    }
  }

  // Navigate to the previous page
  void previousPage() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _currentPage--;
  }

  // Save profile data to the backend
  Future<void> saveProfileData(BuildContext context, String userId) async {
    if (formKeys[_currentPage].currentState!.validate() &&
        _selectedGender != null) {
      // Parse the age range
      final ageText = ageController.text.trim();
      final age = _parseAgeRange(ageText);

      if (age == null || age <= 0) {
        showSnackBar(
          context,
          'Please select a valid age range.',
          isError: true,
        );
        return;
      }

      // Validate avatar file if provided
      if (_avatarImage != null) {
        final extension = _avatarImage!.path.split('.').last.toLowerCase();
        if (!allowedImageExtensions.contains(extension)) {
          showSnackBar(
            context,
            'Only JPG, JPEG, or PNG images are allowed.',
            isError: true,
          );
          return;
        }

        final file = File(_avatarImage!.path);
        if (!await file.exists()) {
          showSnackBar(
            context,
            'Selected image file does not exist: ${_avatarImage!.path}',
            isError: true,
          );
          return;
        }
        final fileLength = await file.length();
        if (fileLength == 0) {
          showSnackBar(
            context,
            'Selected image file is empty: ${_avatarImage!.path}',
            isError: true,
          );
          return;
        }
        debugPrint('🔹 Selected Avatar File Size: ${fileLength / 1024} KB');
        debugPrint(
          '🔹 Sending Avatar File Path to AuthCubit: ${_avatarImage!.path}',
        );
      } else {
        debugPrint('🔹 No Avatar File Selected');
      }

      context.read<AuthCubit>().completeProfile(
        userId: userId,
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        gender: _selectedGender!.toString().split('.').last,
        age: age,
        bio:
            bioController.text.trim().isNotEmpty
                ? bioController.text.trim()
                : null,
        location:
            locationController.text.trim().isNotEmpty
                ? locationController.text.trim()
                : null,
        avatarPath: _avatarImage?.path,
      );
    } else {
      showSnackBar(
        context,
        _selectedGender == null
            ? 'Please select your gender.'
            : 'Please fill all required fields.',
        isError: true,
      );
    }
  }

  // Pick an avatar image from the gallery
  Future<void> pickAvatar(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final extension = pickedFile.path.split('.').last.toLowerCase();
      if (!allowedImageExtensions.contains(extension)) {
        showSnackBar(
          context,
          'Please select a JPG, JPEG, or PNG image.',
          isError: true,
        );
        return;
      }

      final file = File(pickedFile.path);
      if (!await file.exists()) {
        showSnackBar(
          context,
          'Picked image file does not exist: ${pickedFile.path}',
          isError: true,
        );
        return;
      }
      final fileLength = await file.length();
      if (fileLength == 0) {
        showSnackBar(
          context,
          'Picked image file is empty: ${pickedFile.path}',
          isError: true,
        );
        return;
      }

      debugPrint('🔹 Picked Avatar File Path: ${pickedFile.path}');
      debugPrint('🔹 Picked Avatar File Size: ${fileLength / 1024} KB');

      _avatarImage = pickedFile;
    } else {
      debugPrint('🔹 No Image Picked');
    }
  }

  // Update selected gender
  void updateGender(Gender gender) {
    _selectedGender = gender;
  }

  // Show a snackbar with a message
  void showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Dispose controllers to prevent memory leaks
  void dispose() {
    pageController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    ageController.dispose();
    bioController.dispose();
    locationController.dispose();
  }
}
