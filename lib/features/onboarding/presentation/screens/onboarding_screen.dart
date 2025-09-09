import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app/core/constants/const_values.dart';
import 'package:test_app/features/onboarding/logic/cubit/onboarding_cubit.dart';
import 'package:test_app/features/onboarding/logic/cubit/onboarding_state.dart';
import 'package:test_app/features/onboarding/presentation/screens/OnboardingItem.dart';
import 'package:test_app/features/onboarding/presentation/widgets/navigation_buttons.dart';
import 'package:test_app/navigation/routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<OnboardingCubit, OnboardingState>(
          listener: (context, state) {
            if (state is OnboardingCompleted) {
              context.go(Routes.login); // Fixed AppRoute to Routes
            }
          },
          child: BlocBuilder<OnboardingCubit, OnboardingState>(
            builder: (context, state) {
              int currentPage = 0;
              if (state is OnboardingPageChanged) {
                currentPage = state.currentPage;
                if (pageController.hasClients) {
                  pageController.animateToPage(
                    currentPage,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOutCubic,
                  );
                }
              }
              return Container(
                margin: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: pageController,
                        onPageChanged: (index) {
                          context.read<OnboardingCubit>().updatePage(index);
                        },
                        itemCount: onboardingItems.length,
                        itemBuilder: (context, index) {
                          return OnboardingPage(item: onboardingItems[index]);
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    NavigationRow(
                      currentPage: currentPage,
                      totalPages: onboardingItems.length,
                      pageController: pageController,
                      onNext: () => context.read<OnboardingCubit>().nextPage(),
                      onPrevious:
                          () => context.read<OnboardingCubit>().previousPage(),
                    ),
                    const SizedBox(height: 70),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
