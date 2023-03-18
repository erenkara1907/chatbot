// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:chatbot/product/conversation/model/conversation_store_model.dart';
import 'package:chatbot/product/conversation/service/conversation_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/enum/preference_keys.dart';
import '../model/conversation_model.dart';

class ConversationViewModel extends ChangeNotifier {
  ConversationService service = ConversationService();

  List<Conversations> conversationModel = [];

  Conversation conversation = Conversation();

  Future getAllMessages() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    String token = prefs.getString(PreferencesKeys.TOKEN.toString())!;

    final response = await service.getConversations(token);

    if (response.result == true) {
      conversationModel.clear();
      conversationModel.addAll(response.data!.conversations!);
    }
  }
}
