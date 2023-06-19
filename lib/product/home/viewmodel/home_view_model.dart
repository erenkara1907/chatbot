// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:io';

import 'package:chatbot/core/enum/preference_keys.dart';
import 'package:chatbot/product/conversation/service/conversation_service.dart';
import 'package:chatbot/product/conversation/view/conversation_room_view.dart';
import 'package:chatbot/product/home/model/category_model.dart';
import 'package:chatbot/product/home/model/language_proficiency_model.dart';
import 'package:chatbot/product/home/model/profile_home_model.dart';
import 'package:chatbot/product/home/model/scenario_model.dart';
import 'package:chatbot/product/home/service/home_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../conversation/model/conversation_store_model.dart';

class HomeViewModel extends ChangeNotifier {
  HomeService service = HomeService();
  ConversationService conversationService = ConversationService();

  // List<Topics> topics = [];
  List<Scenarios> scenarios = [];
  List<Scenarios> scenariosTemp = [];
  List<Categories> categories = [];
  ProfileHomeModel profileModel = ProfileHomeModel();
  ProfileHomeModel profileModelTemp = ProfileHomeModel();

  List<LanguageProficiencyModel> languageProficiency = [
    LanguageProficiencyModel(id: 1, title: "Beginner", code: "A1"),
    LanguageProficiencyModel(id: 2, title: "Pre-Indermediate", code: "A2"),
    LanguageProficiencyModel(id: 3, title: "Indermediate", code: "B1"),
    LanguageProficiencyModel(id: 4, title: "Upper-Indermediate", code: "B2"),
    LanguageProficiencyModel(id: 5, title: "Advanced", code: "C1"),
    LanguageProficiencyModel(id: 6, title: "Mastery", code: "C2"),
  ];

  Conversation conversation = Conversation();

  bool isCreatedConversation = true;
  int selectedCategory = 1;
  int selectedScenarioId = -1;
  int selectedScenarioIndex = -1;

  bool isFirst = true;
  bool barrierDismissible = true;
  bool isActivePage = false;

  int selectedTab = 0;

  bool isBig = false;
  bool isChangingData = false;

  // checkChangeData() {
  //   User userModel = profileModel.data!.user!;
  //   User userModelTemp = profileModelTemp.data!.user!;
  //   if (userModelTemp.name != userModel.name) {
  //     isChangingData = true;
  //   }

  //   notifyListeners();
  // }

  String selectedLevel = "";
  int selectedLevelId = -1;
  String selectedCefr = "A1";

  selectCefr(String cefr) {
    selectedCefr = cefr;
    notifyListeners();
  }

  selectTab(int index) {
    selectedTab = index;
    notifyListeners();
  }

  selectLevel(String level, int levelId) {
    selectedLevel = level;
    selectedLevelId = levelId;
    notifyListeners();
  }

  setScenarioIndex(int index) {
    selectedScenarioIndex = index;
    notifyListeners();
  }

  setIsBig() {
    isBig = !isBig;
    notifyListeners();
  }

  setActivePage() {
    Future.delayed(
      const Duration(milliseconds: 1500),
      () {
        isActivePage = true;
        notifyListeners();
      },
    );
  }

  changeBarrierDismissible() {
    barrierDismissible = !barrierDismissible;
    notifyListeners();
  }

  Future setFirstLogin() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(PreferencesKeys.IS_FIRST_APP.toString(), false);

    isFirst = false;
    notifyListeners();
  }

  // Future getTopics() async {
  //   final topicResponse = await service.getTopics();

  //   if (topicResponse.result == true) {
  //     topics = topicResponse.data!.topics!;
  //   }
  // }

  Future getScenario() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    String token = prefs.getString(PreferencesKeys.TOKEN.toString())!;
    final scenarioResponse = await service.getAllScenarios(token);

    if (scenarioResponse.result == true) {
      scenarios = scenarioResponse.data!.scenarios!;
      for (var i = 0; i < scenarios.length; i++) {
        scenariosTemp = scenarios
            .where((element) => element.category!.id == selectedCategory)
            .toList();
      }
    }
  }

  String selectedCategoryName = "Life";

  selectCategory(List<Scenarios> scenario, String categoryName) {
    for (var i = 0; i < scenario.length; i++) {
      scenariosTemp = scenario
          .where((element) => element.category!.id == selectedCategory)
          .toList();
    }

    selectedCategoryName = categoryName;

    notifyListeners();
  }

  File? compressedImageFile;

  // API'den aldığınız bir resmi boyutlandırma ve sıkıştırma örneği
  Future<void> optimizeAndCompressImage(String imageUrl) async {
    final compressedImageBytes = await FlutterImageCompress.compressWithFile(
      imageUrl,
      minWidth: 126, // Boyutu istediğiniz ölçüde ayarlayabilirsiniz
      minHeight: 173,
      quality: 85, // Kaliteyi istediğiniz ölçüde ayarlayabilirsiniz
    );

    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/compressed_image.jpg';

    final compressedImageFile = File(filePath);
    await compressedImageFile.writeAsBytes(compressedImageBytes!);

    this.compressedImageFile = compressedImageFile;
    notifyListeners();

    // Sıkıştırılmış resmi kullanabilirsiniz
    // Örneğin, sıkıştırılmış resmi ön belleğe alabilirsiniz
    // veya doğrudan Flutter Image widget'ıyla gösterebilirsiniz
  }

  Future getCategories() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    String token = prefs.getString(PreferencesKeys.TOKEN.toString())!;
    final categoryResponse = await service.getAllCategories(token);

    await getScenario();
    await getProfileInfo();

    if (categoryResponse.result == true) {
      categories = categoryResponse.data.categories;
    }
  }

  Future getScenarioAndCategories() async {
    await getCategories();
    await getScenario();

    notifyListeners();
  }

  Future getProfileInfo() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    String token = prefs.getString(PreferencesKeys.TOKEN.toString())!;
    final profileResponse = await service.getProfileInfo(token);

    if (profileResponse.result == true) {
      profileModel = profileResponse;
    }

    profileModelTemp = profileModel;
  }

  Future updateProfile(BuildContext context, Map<String, dynamic> user) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    String token = prefs.getString(PreferencesKeys.TOKEN.toString())!;
    final profileResponse = await service.updateProfile(token, user);

    if (profileResponse.result == true) {
      // profileModel = profileResponse;
      Future.delayed(const Duration(milliseconds: 250), () {
        Navigator.of(context).pop();
      });
    }

    profileModelTemp = profileModel;
  }

  // Future getTopics() async {
  //   final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  //   final SharedPreferences prefs = await _prefs;

  //   String token = prefs.getString(PreferencesKeys.TOKEN.toString())!;
  //   isFirst = prefs.getBool(PreferencesKeys.IS_FIRST_APP.toString())!;

  //   final topicResponse = await service.getTopics();

  //   if (topicResponse.result == true) {
  //     topics = topicResponse.data!.topics!;
  //   }
  // }

  chnageConversationStatus(bool status) {
    isCreatedConversation = status;
    notifyListeners();
  }

  Future<ConversationStoreModel> createConversation(
    BuildContext context, {
    required String scenarioId,
    required String cefr,
    required String scenarioTitle,
    required String profilePhoto,
  }) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    String token = prefs.getString(PreferencesKeys.TOKEN.toString())!;

    final response = await conversationService.createConversation(
      token,
      scenarioId: scenarioId,
      cefr: cefr,
    );

    if (response.result == true) {
      conversation = response.data!.conversation!;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ConversationRoomView(
            conversationId: conversation.id!,
            scenarioTitle: scenarioTitle,
            profilePhoto: profilePhoto,
          ),
        ),
      );
    }

    return response;
  }
}
