import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/features/onboarding/logic/cubit/onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  int currentPage = 0;
  final int totalPages;

  OnboardingCubit({this.totalPages = 3}) : super(OnboardingInitial());

  void updatePage(int page) {
    currentPage = page;
    emit(OnboardingPageChanged(currentPage));
  }

  void nextPage() {
    if (currentPage < totalPages - 1) {
      currentPage++;
      emit(OnboardingPageChanged(currentPage));
    } else {
      emit(OnboardingCompleted());
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      currentPage--;
      emit(OnboardingPageChanged(currentPage));
    }
  }
}
