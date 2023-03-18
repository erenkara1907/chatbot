String asset = 'assets/images/image_';

class ImageConstant {
  static ImageConstant? _instance;
  static ImageConstant get instance {
    _instance ??= ImageConstant._init();
    return _instance!;
  }

  ImageConstant._init();

  // Svg
  String imageNoMessage = '$asset' 'no_message.svg';

  // Png
  String avatarFour = '$asset' 'avatar_four.png';
  String avatarThree = '$asset' 'avatar_three.png';
  String avatarTwo = '$asset' 'avatar_two.png';
  String avatarOne = '$asset' 'avatar_one.png';
  String robot = '$asset' 'robot.png';
  String trophyBeginner = '$asset' 'trophy_beginner.png';
  String trophyChampion = '$asset' 'trophy_champion.png';
  String trophyFighter = '$asset' 'trophy_fighter.png';
  String trophyLegendary = '$asset' 'trophy_legendary.png';
  String trophyScholar = '$asset' 'trophy_scholar.png';
  String trophyStable = '$asset' 'trophy_stable.png';
  String trophyStruggle = '$asset' 'trophy_struggle.png';
  String trophyWise = '$asset' 'trophy_wise.png';
  String uploadImage = '$asset' 'upload_image.png';
  String avatarBig = '$asset' 'avatar_big.png';
  String avatarHome = '$asset' 'home_avatar.png';
}
