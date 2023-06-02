// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:chatbot/core/enum/preference_keys.dart';
import 'package:chatbot/product/conversation/service/conversation_service.dart';
import 'package:chatbot/product/home/model/category_model.dart';
import 'package:chatbot/product/home/model/profile_home_model.dart';
import 'package:chatbot/product/home/model/scenario_model.dart';
import 'package:chatbot/product/home/service/home_service.dart';
import 'package:flutter/material.dart';
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

  Conversation conversation = Conversation();

  bool isCreatedConversation = true;
  int selectedCategory = 1;

  bool isFirst = true;
  bool barrierDismissible = true;
  bool isActivePage = false;

  bool isBig = false;

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
    final scenarioResponse = await service.getAllScenarios();

    if (scenarioResponse.result == true) {
      scenarios = scenarioResponse.data!.scenarios!;
      for (var i = 0; i < scenarios.length; i++) {
        scenariosTemp = scenarios
            .where((element) => element.category!.id == selectedCategory)
            .toList();
      }
    }
  }

  selectCategory(List<Scenarios> scenario) {
    for (var i = 0; i < scenario.length; i++) {
      scenariosTemp = scenario
          .where((element) => element.category!.id == selectedCategory)
          .toList();
    }

    notifyListeners();
  }

  Future getCategories() async {
    final categoryResponse = await service.getAllCategories();

    if (categoryResponse.result == true) {
      categories = categoryResponse.data!.categories!;
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

  Future<ConversationStoreModel> createConversation(BuildContext context,
      {required String scenarioId}) async {
    print('id : ${scenarioId}');
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    String token = prefs.getString(PreferencesKeys.TOKEN.toString())!;

    final response = await conversationService.createConversation(token,
        scenarioId: scenarioId);

    if (response.result == true) {
      conversation = response.data!.conversation!;
    }

    return response;
  }
}
