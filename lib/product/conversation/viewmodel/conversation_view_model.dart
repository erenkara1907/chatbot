// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:chatbot/product/conversation/model/conversation_store_model.dart';
import 'package:chatbot/product/conversation/model/message_model.dart';
import 'package:chatbot/product/conversation/service/conversation_service.dart';
import 'package:chatbot/product/profile/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/enum/preference_keys.dart';
import '../../profile/service/profile_service.dart';
import '../model/conversation_model.dart';

class ConversationViewModel extends ChangeNotifier {
  ConversationService service = ConversationService();
  ProfileService profileService = ProfileService();

  // List<Conversations> conversationModel = [];
  List<Messages> messages = [];
  // List<Conversations> completedMessages = [];

  List<Conversations> completedMessageTemp = [];
  List<Conversations> conversationModelTemp = [];

  Conversation conversation = Conversation();
  ProfileModel profileModel = ProfileModel();

  bool isActivePage = false;

  setActivePage() {
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        isActivePage = true;
        notifyListeners();
      },
    );
  }

  Future getProfileInfo() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    String token = prefs.getString(PreferencesKeys.TOKEN.toString())!;

    final profileResponse = await profileService.getProfileInfo(token);

    if (profileResponse.result == true) {
      profileModel = profileResponse;
    }
  }

  Future getAllConversation() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    String token = prefs.getString(PreferencesKeys.TOKEN.toString())!;

    final response = await service.getConversations(token);
    await getProfileInfo();

    if (response.result == true) {
      completedMessageTemp.clear();
      conversationModelTemp.clear();

      for (var i = 0; i < response.data!.conversations!.length; i++) {
        if (response.data!.conversations![i].isActive == 0) {
          if (response.data!.conversations![i].scenario != null) {
            completedMessageTemp.add(response.data!.conversations![i]);
          }
        } else {
          if (response.data!.conversations![i].scenario != null) {
            conversationModelTemp.add(response.data!.conversations![i]);
          }
        }
      }
    }
  }
}
