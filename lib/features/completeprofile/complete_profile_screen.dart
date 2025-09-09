import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app/features/completeprofile/ui/step_extra.dart';
import 'package:test_app/features/completeprofile/ui/step_info.dart';
import 'package:test_app/features/completeprofile/ui/step_name.dart';
import 'controller_completeprofile.dart';
import 'package:test_app/features/auth/logic/auth_cubit.dart';
import 'package:test_app/features/auth/logic/auth_state.dart';

class CompleteProfileScreen extends StatefulWidget {
  final String userId;

  const CompleteProfileScreen({super.key, required this.userId});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  late final CompleteProfileController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CompleteProfileController();
    _controller.initialize(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess && state.isProfileCompleted) {
              context.go('/home');
            } else if (state is AuthFailure) {
              _controller.showSnackBar(context, state.message, isError: true);
            } else if (state is AuthSessionExpired || state is AuthInitial) {
              _controller.showSnackBar(
                context,
                'Session expired. Please log in again.',
                isError: true,
              );
              context.go('/login');
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return Column(
              children: [
                // Progress indicator (dots) - Enlarged dots
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 6,
                        ), // More space between dots
                        width:
                            _controller.currentPage == index
                                ? 45
                                : 40, // Larger active dot
                        height:
                            _controller.currentPage == index
                                ? 11
                                : 7, // Larger active dot
                        decoration: BoxDecoration(
                          color:
                              _controller.currentPage == index
                                  ? CompleteProfileController.primaryColor
                                  : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(
                            8,
                          ), // Rounded corners for bigger dots
                        ),
                      );
                    }),
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _controller.pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) => setState(() {}),
                    children: [
                      StepNamePage(
                        controller: _controller,
                        isLoading: isLoading,
                      ),
                      StepInfoPage(
                        controller: _controller,
                        isLoading: isLoading,
                      ),
                      StepExtraPage(
                        controller: _controller,
                        isLoading: isLoading,
                      ),
                    ],
                  ),
                ),
                // Navigation buttons with extra space below
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          if (_controller.currentPage > 0)
                            Expanded(
                              child: OutlinedButton(
                                onPressed:
                                    isLoading ? null : _controller.previousPage,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color:
                                        CompleteProfileController.primaryColor,
                                  ),
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Back',
                                  style: TextStyle(
                                    color:
                                        CompleteProfileController.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          if (_controller.currentPage > 0)
                            const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed:
                                  isLoading
                                      ? null
                                      : (_controller.currentPage < 2
                                          ? () => _controller.nextPage(context)
                                          : () => _controller.saveProfileData(
                                            context,
                                            widget.userId,
                                          )),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    CompleteProfileController.primaryColor,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child:
                                  isLoading
                                      ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                      : Text(
                                        _controller.currentPage < 2
                                            ? 'Next'
                                            : 'Continue',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16), // Add extra space here
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
