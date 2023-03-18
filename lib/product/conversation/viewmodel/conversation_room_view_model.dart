// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_final_fields, use_build_context_synchronously

import 'dart:async';

import 'package:chatbot/product/bottom_bar/view/bottom_bar_view.dart';
import 'package:chatbot/product/conversation/model/translate_model.dart';
import 'package:chatbot/product/conversation/service/conversation_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/enum/preference_keys.dart';
import '../model/message_model.dart';
import '../model/rate_model.dart';

class ConversationRoomViewModel extends ChangeNotifier {
  ConversationService service = ConversationService();

  TextEditingController sendMessageController = TextEditingController();

  FocusNode sendMessageFocusNode = FocusNode();

  bool isTap = false;

  String translateMessage = '';

  TranslateMessage translateModel = TranslateMessage();

  int isActive = 0;

  // ignore: unused_field
  // StreamController? _streamController;

  startFocusNode() {
    sendMessageFocusNode.unfocus();
  }

  List<Messages> messages = [];
  List<Rates> rates = [];

  Future getRates(String token) async {
    final response = await service.getRates(token);

    if (response.result == true) {
      rates.clear();
      rates.addAll(response.data!.rates!);
    }
  }

  Future sendToBackendRateId(
    BuildContext context, {
    required int conversationId,
    required int endConversationId,
    required int rateId,
  }) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    String token = prefs.getString(PreferencesKeys.TOKEN.toString())!;

    final response = await service.conversationUpdate(
      token,
      conversationId: conversationId,
      endConversationId: endConversationId,
      rateId: rateId,
    );

    if (response.result == true) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BottomBarView()));
    }
  }

  Future getAllMessages({required int conversationId}) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    String token = prefs.getString(PreferencesKeys.TOKEN.toString())!;

    final response =
        await service.getAllMessages(token, conversationId: conversationId);
    await getRates(token);

    if (response.result == true) {
      messages = response.data!.messages!;
      isActive = response.data!.conversation!.isActive!;
    }
  }

  Future sendMessage({required int conversationId}) async {
    changeSendIcon();
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    String token = prefs.getString(PreferencesKeys.TOKEN.toString())!;

    final response = await service.sendMessage(token,
        message: sendMessageController.text, conversationId: conversationId);

    if (response.result == true) {
      messages = response.data!.messages!;
      sendMessageController.text = '';
      changeSendIcon();
    }

    notifyListeners();
  }

  changeSendIcon() {
    isTap = !isTap;
    notifyListeners();
  }

  Future translate(
      {required int conversationId,
      required int messageId,
      required String translateLanguage}) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    String token = prefs.getString(PreferencesKeys.TOKEN.toString())!;

    final response = await service.translate(
      token,
      conversationId: conversationId,
      messageId: messageId,
      translateLanguage: translateLanguage,
    );

    if (response.result == true) {
      translateModel = response.data!.message!;
    }
  }
}
