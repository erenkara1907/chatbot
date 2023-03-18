// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:chatbot/core/enum/preference_keys.dart';
import 'package:chatbot/product/conversation/service/conversation_service.dart';
import 'package:chatbot/product/conversation/view/conversation_room_view.dart';
import 'package:chatbot/product/home/model/profile_home_model.dart';
import 'package:chatbot/product/home/service/home_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../conversation/model/conversation_store_model.dart';
import '../model/topic_model.dart';

class HomeViewModel extends ChangeNotifier {
  HomeService service = HomeService();
  ConversationService conversationService = ConversationService();

  List<Topics> topics = [];
  ProfileHomeModel profileModel = ProfileHomeModel();

  Conversation conversation = Conversation();

  bool isFirst = true;

  Future setFirstLogin() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(PreferencesKeys.IS_FIRST_APP.toString(), false);

    isFirst = false;
    notifyListeners();
  }

  Future getTopicsAndProfileInfo() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    String token = prefs.getString(PreferencesKeys.TOKEN.toString())!;
    isFirst = prefs.getBool(PreferencesKeys.IS_FIRST_APP.toString())!;

    final topicResponse = await service.getTopics();

    final profileResponse = await service.getProfileInfo(token);

    if (topicResponse.result == true && profileResponse.result == true) {
      topics = topicResponse.data!.topics!;
      profileModel = profileResponse;
    }
  }

  Future createConversation(BuildContext context,
      {required String topicId}) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    String token = prefs.getString(PreferencesKeys.TOKEN.toString())!;

    final response =
        await conversationService.createConversation(token, topicId: topicId);

    if (response.result == true) {
      conversation = response.data!.conversation!;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ConversationRoomView(
            conversationId: response.data!.conversation!.id!,
          ),
        ),
      );
    }
  }
}
