abstract class OnboardingState {}

class OnboardingInitial extends OnboardingState {}

class OnboardingPageChanged extends OnboardingState {
  final int currentPage;
  OnboardingPageChanged(this.currentPage);
}

class OnboardingCompleted extends OnboardingState {}
