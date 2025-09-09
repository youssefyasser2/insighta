class AssetValueManager {
  static const String _baseUrlImage = 'assets/images';

  static const String logo = '$_baseUrlImage/logo.png';
  static const String background = '$_baseUrlImage/background.png';
  static const String profilePic = '$_baseUrlImage/profile_pic.png';
  static const String KOnBoardingImage1 = '$_baseUrlImage/on_boarding_image_1.svg';
  static const String KOnBoardingImage2 = '$_baseUrlImage/on_boarding_image_2.svg';
  static const String KOnBoardingImage3 = '$_baseUrlImage/on_boarding_image_3.svg';
  static const String KOnBoardingImage4 = '$_baseUrlImage/on_boarding_image_4.svg';


  static String getImagePath(String imageName) {
    return '$_baseUrlImage/$imageName';
  }
}
