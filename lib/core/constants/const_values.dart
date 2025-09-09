import 'package:test_app/features/onboarding/data/models/model.dart';

class ConstValue {
  static const String kOnBoardingText1 =
      'Analyze your social media interactions to uncover your emotional state—happiness, stress, or loneliness';
  static const String kOnBoardingText2 =
      'Receive personalized content suggestions like videos, books, or activities to boost your well-being';
  static const String kOnBoardingText3 =
      'Easily connect with licensed therapists for additional support whenever you need it';
}

const List<OnboardingItem> onboardingItems = [
  OnboardingItem(
    svgAssetPath: 'assets/images/on_boarding_image_1.svg',
    description: ConstValue.kOnBoardingText1,
  ),
  OnboardingItem(
    svgAssetPath: 'assets/images/on_boarding_image_2.svg',
    description: ConstValue.kOnBoardingText2,
  ),
  OnboardingItem(
    svgAssetPath: 'assets/images/on_boarding_image_3.svg',
    description: ConstValue.kOnBoardingText3,
  ),
];

class ApiConstants {
  static const String baseUrl =
      'https://67b8b14a699a8a7baef4f48b.mockapi.io/api';
}
