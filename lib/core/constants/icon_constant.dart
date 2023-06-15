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
  String iconHomeTouched = '$asset' 'home_touched.svg';
  String iconLanguage = '$asset' 'language.svg';
  String iconLockClose = '$asset' 'lock_close.svg';
  String iconLockOpen = '$asset' 'lock_open.svg';
  String iconPerson = '$asset' 'person.svg';
  String iconProfileFill = '$asset' 'profile_fill.svg';
  String iconProfileTrophy = '$asset' 'profile_trophy.svg';
  String iconProfile = '$asset' 'profile.svg';
  String iconProfileTouched = '$asset' 'profile_touched.svg';
  String iconMessage = '$asset' 'message.svg';
  String iconMessageTouched = '$asset' 'message_touched.svg';
  String iconTerms = '$asset' 'terms.svg';
  String iconTrophy = '$asset' 'trophy.png';
  String iconWhiteTrophy = '$asset' 'white_trophy.svg';
  String iconWriteUs = '$asset' 'write_us.svg';
  String iconSend = '$asset' 'send.svg';
  String iconCharge = '$asset' 'charge.svg';
  String iconLogout = '$asset' 'logout.svg';
  String iconChatBubble = '$asset' 'chatbubbles.svg';
  String iconArrowDown = '$asset' 'arrow_down.svg';
  String iconPronunciation = '$asset' 'pronunciation.svg';
  String iconCorrect = '$asset' 'correct.svg';
  String iconWrong = '$asset' 'wrong.svg';
  String iconTranslate = '$asset' 'translate.svg';
  String iconVoice = '$asset' 'voice.svg';
  String iconArrowBack = '$asset' 'arrow_back.svg';
  String iconBubble = '$asset' 'bubble.svg';
  String iconRestart = '$asset' 'restart.svg';
  String iconKeyboard = '$asset' 'keyboard.svg';

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
