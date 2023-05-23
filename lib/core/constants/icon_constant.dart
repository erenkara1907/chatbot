String asset = 'assets/icons/icon_';
String flagAsset = 'assets/icons/flag_';

class IconConstant {
  static IconConstant? _instance;
  static IconConstant get instance {
    _instance ??= IconConstant._init();
    return _instance!;
  }

  IconConstant._init();

  // Svg
  String iconChatFill = '$asset' 'chat_fill.svg';
  String iconChat = '$asset' 'chat.svg';
  String iconHomeFill = '$asset' 'home_fill.svg';
  String iconHome = '$asset' 'home.svg';
  String iconLanguage = '$asset' 'language.svg';
  String iconLockClose = '$asset' 'lock_close.svg';
  String iconLockOpen = '$asset' 'lock_open.svg';
  String iconPerson = '$asset' 'person.svg';
  String iconProfileFill = '$asset' 'profile_fill.svg';
  String iconProfileTrophy = '$asset' 'profile_trophy.svg';
  String iconProfile = '$asset' 'profile.svg';
  String iconTerms = '$asset' 'terms.svg';
  String iconTrophy = '$asset' 'trophy.png';
  String iconWhiteTrophy = '$asset' 'white_trophy.svg';
  String iconWriteUs = '$asset' 'write_us.svg';
  String iconSend = '$asset' 'send.svg';
  String iconCharge = '$asset' 'charge.svg';
  String iconLogout = '$asset' 'logout.svg';

  String flagTurkish = '$flagAsset' 'turkish.svg';
  String flagEnglish = '$flagAsset' 'english.svg';
  String flagChinese = '$flagAsset' 'chinese.svg';
  String flagFrench = '$flagAsset' 'french.svg';
  String flagPortoguese = '$flagAsset' 'portoguese.svg';
  String flagRussian = '$flagAsset' 'russian.svg';
  String flagSpanish = '$flagAsset' 'spanish.svg';
  String flagDeutsch = '$flagAsset' 'deutsch.svg';

  // Png
  String iconStar = '$asset' 'star.png';
}
