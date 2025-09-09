import 'dart:io';
import 'package:flutter/material.dart';
import 'package:test_app/features/completeprofile/controller_completeprofile.dart';

class StepExtraPage extends StatefulWidget {
  final CompleteProfileController controller;
  final bool isLoading;

  const StepExtraPage({
    super.key,
    required this.controller,
    required this.isLoading,
  });

  @override
  State<StepExtraPage> createState() => _StepExtraPageState();
}

class _StepExtraPageState extends State<StepExtraPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(), // Smooth scrolling physics
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: widget.controller.formKeys[2],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24), // Reduced from 40
              // Page title
              Text(
                'Share More Details to Personalize Your Profile',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: CompleteProfileController.primaryColor,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 8),
              // Page subtitle
              Text(
                'Feel free to share additional information to make your profile stand out and reflect your personality.',
                style: textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16), // Reduced from 32
              // Bio field (optional)
              _buildLabel('Bio', textTheme),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, Colors.grey.shade50],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 10,
                      spreadRadius: 3,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: widget.controller.bioController,
                  enabled: !widget.isLoading,
                  maxLines: 3,
                  decoration: _buildInputDecoration(
                    'Tell us about yourself (optional)',
                    theme,
                    prefixIcon: Icon(
                      Icons.description,
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  style: textTheme.bodyLarge,
                  validator: (val) {
                    if (val != null && val.trim().isNotEmpty) {
                      return null; // No error if something is entered
                    }
                    return null; // No error if field is left empty
                  },
                ),
              ),
              const SizedBox(height: 16), // Reduced from 24
              // Location field (optional)
              _buildLabel('Location', textTheme),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, Colors.grey.shade50],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 10,
                      spreadRadius: 3,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: widget.controller.locationController,
                  enabled: !widget.isLoading,
                  decoration: _buildInputDecoration(
                    'Where are you based? (optional)',
                    theme,
                    prefixIcon: Icon(
                      Icons.location_on,
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  style: textTheme.bodyLarge,
                  validator: (val) {
                    if (val != null && val.trim().isNotEmpty) {
                      return null; // No error if something is entered
                    }
                    return null; // No error if field is left empty
                  },
                ),
              ),
              const SizedBox(height: 16), // Reduced from 24
              // Interests field (optional)
              _buildLabel('Interests', textTheme),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, Colors.grey.shade50],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 10,
                      spreadRadius: 3,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: TextEditingController(), // Temporary controller
                  enabled: !widget.isLoading,
                  maxLines: 2,
                  decoration: _buildInputDecoration(
                    'What are your interests? (e.g., Reading, Sports)',
                    theme,
                    prefixIcon: Icon(
                      Icons.favorite,
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  style: textTheme.bodyLarge,
                  validator: (val) {
                    if (val != null && val.trim().isNotEmpty) {
                      return null; // No error if something is entered
                    }
                    return null; // No error if field is left empty
                  },
                ),
              ),
              const SizedBox(height: 16), // Reduced from 24
              // Profile Picture section (optional)
              _buildLabel('Profile Picture', textTheme),
              const SizedBox(height: 12),
              _ProfilePictureSelector(
                controller: widget.controller,
                isLoading: widget.isLoading,
                theme: theme,
                textTheme: textTheme,
              ),
              const SizedBox(height: 24), // Reduced from 40
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, TextTheme textTheme) {
    return Text(
      text,
      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
    );
  }

  InputDecoration _buildInputDecoration(
    String hint,
    ThemeData theme, {
    Widget? prefixIcon,
  }) {
    final textTheme = theme.textTheme;
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.transparent, // Changed to transparent to show gradient
      prefixIcon: prefixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      hintStyle: textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.colorScheme.outline, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.colorScheme.outline, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: CompleteProfileController.primaryColor,
          width: 2.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.colorScheme.error, width: 2.5),
      ),
    );
  }
}

// Custom widget for profile picture selection with scale animation
class _ProfilePictureSelector extends StatefulWidget {
  final CompleteProfileController controller;
  final bool isLoading;
  final ThemeData theme;
  final TextTheme textTheme;

  const _ProfilePictureSelector({
    required this.controller,
    required this.isLoading,
    required this.theme,
    required this.textTheme,
  });

  @override
  _ProfilePictureSelectorState createState() => _ProfilePictureSelectorState();
}

class _ProfilePictureSelectorState extends State<_ProfilePictureSelector>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (!widget.isLoading) _animationController.forward();
      },
      onTapUp: (_) async {
        if (!widget.isLoading) {
          _animationController.reverse();
          await widget.controller.pickAvatar(context);
          setState(() {});
        }
      },
      onTapCancel: () {
        if (!widget.isLoading) _animationController.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  widget.controller.avatarImage != null
                      ? CompleteProfileController.primaryColor
                      : widget.theme.colorScheme.outline,
              width: widget.controller.avatarImage != null ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child:
              widget.controller.avatarImage == null
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo,
                          size: 32,
                          color: CompleteProfileController.primaryColor,
                          semanticLabel: 'Add Profile Picture',
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add Profile Picture (optional)',
                          style: widget.textTheme.bodyMedium?.copyWith(
                            color: widget.theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                  : Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(widget.controller.avatarImage!.path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 120,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Change Profile Picture',
                          style: widget.textTheme.bodyMedium?.copyWith(
                            color: CompleteProfileController.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
