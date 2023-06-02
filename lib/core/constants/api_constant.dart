String baseUrl = "https://dev-talkios.rondigital.ai/api/v2";

class ApiConstant {
  static ApiConstant? _instance;
  static ApiConstant get instance {
    _instance ??= ApiConstant._init();
    return _instance!;
  }

  ApiConstant._init();

  // Auth
  String registerUrl = "$baseUrl/auth/register";
  String loginUrl = "$baseUrl/auth/login";

  // Profile
  String profilUrl = "$baseUrl/profile";

  // // Language
  // String languageInfoUrl = "$baseUrl/languages";
  // String languageLevelsUrl = "$baseUrl/language-proficiency-levels";

  // Topic
  String topicsUrl = "$baseUrl/topics";

  // Conversation
  String conversationUrl = '$baseUrl/conversation';

  // Avatar
  String avatarUrl = '$baseUrl/avatars';

  // Rate
  String rateUrl = '$baseUrl/rates';

  // Scenario
  String scenarioUrl = '$baseUrl/scenarios';

  // Category
  String categoryUrl = '$baseUrl/categories';
}
