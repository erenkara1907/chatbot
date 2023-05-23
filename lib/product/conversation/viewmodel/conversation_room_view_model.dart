// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_final_fields, use_build_context_synchronously

import 'dart:async';

import 'package:chatbot/product/auth/language/model/language_model.dart';
import 'package:chatbot/product/conversation/model/translate_model.dart';
import 'package:chatbot/product/conversation/service/conversation_service.dart';
import 'package:chatbot/product/profile/model/profile_model.dart';
import 'package:chatbot/product/profile/service/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/icon_constant.dart';
import '../../../core/enum/preference_keys.dart';
import '../model/chat_model.dart';
import '../model/conversation_room_model.dart';
import '../model/rate_model.dart';

class ConversationRoomViewModel extends ChangeNotifier {
  ConversationService service = ConversationService();
  ProfileService profileService = ProfileService();
  // LanguageService languageService = LanguageService();

  TextEditingController sendMessageController = TextEditingController();

  FocusNode sendMessageFocusNode = FocusNode();

  bool isTap = false;

  String translateMessage = '';

  TranslateMessage translateModel = TranslateMessage();
  ProfileModel profileModel = ProfileModel();

  int endChat = 0;
  int isActive = 0;
  bool isData = false;

  List<LanguageModel> languages = [
    LanguageModel(
      id: 1,
      code: "en",
      title: "English",
      flag: IconConstant.instance.flagEnglish,
    ),
    LanguageModel(
      id: 2,
      code: "tr",
      title: "Turkish",
      flag: IconConstant.instance.flagTurkish,
    ),
    LanguageModel(
      id: 3,
      code: "de",
      title: "German",
      flag: IconConstant.instance.flagDeutsch,
    ),
    LanguageModel(
      id: 4,
      code: "ch",
      title: "Chinese",
      flag: IconConstant.instance.flagChinese,
    ),
    LanguageModel(
      id: 5,
      code: "fr",
      title: "French",
      flag: IconConstant.instance.flagFrench,
    ),
    LanguageModel(
      id: 6,
      code: "pt",
      title: "Portuguese",
      flag: IconConstant.instance.flagPortoguese,
    ),
    LanguageModel(
      id: 7,
      code: "ru",
      title: "Russian",
      flag: IconConstant.instance.flagRussian,
    ),
    LanguageModel(
      id: 8,
      code: "es",
      title: "Spanish",
      flag: IconConstant.instance.flagSpanish,
    ),
  ];
  // List<String> popularLanguageTitles = [];
  // List<String> popularLanguageImages = [];
  // List<int> popularLanguageIds = [];

  int selectedIndex = -1;
  // int selectedPopularIndex = -1;

  int selectedLanguageId = -1;
  String selectedLanguageCode = "en";
  // int selectedPopularLanguageId = -1;

  String nativeLanguage = '';
  // String nativePopularLanguage = '';

  // ignore: unused_field
  // StreamController? _streamController;

  startFocusNode() {
    sendMessageFocusNode.unfocus();
  }

  // List<Messages> messages = [];
  Conversation conversationModel = Conversation();
  String conversationCompleteCount = "0.0";
  List<Rates> rates = [];

  List<ChatModel> chatList = [];
  List<ChatModel> tempList = [];
  List<ChatModel> get getChatList => chatList;

  void addUserMessage({required String message}) {
    chatList.add(
      ChatModel(
        message: message,
        role: 'user',
        id: 1,
        endConversation: 0,
        conversationCompletionCount: "0.0",
      ),
    );
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswers(
      {required String message, required int conversationId}) async {
    final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    final SharedPreferences _prefs = await prefs;

    String token = _prefs.getString(PreferencesKeys.TOKEN.toString())!;

    final response = await service.sendMessage(
        message: message, conversationId: conversationId, token: token);

    chatList.addAll(response);

    conversationCompleteCount = response[0].conversationCompletionCount;
    endChat = response[0].endConversation;

    notifyListeners();
  }

  Future getRates(String token) async {
    final response = await service.getRates(token);

    if (response.result == true) {
      rates.clear();
      rates.addAll(response.data!.rates!);
    }
  }

  // Future getLanguages() async {
  //   final model = await languageService.getLanguages();

  //   if (model.result == true) {
  //     for (var i = 0; i < model.data!.languages!.length; i++) {
  //       if (model.data!.languages![i].isPopular == 1) {
  //         if (popularLanguageTitles.length != 4) {
  //           popularLanguageTitles.add(model.data!.languages![i].title!);
  //           popularLanguageIds.add(model.data!.languages![i].id!);
  //           popularLanguageImages.add(model.data!.languages![i].flag!);
  //         }
  //       } else {
  //         languages.clear();
  //         languages.addAll(model.data!.languages!);
  //       }
  //     }
  //     languages.clear();
  //     languages.addAll(model.data!.languages!);
  //   }
  // }

  Future sendToBackendRateId(
    BuildContext context, {
    required int conversationId,
    int? endConversationId,
    int? rateId,
  }) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    String token = prefs.getString(PreferencesKeys.TOKEN.toString())!;
    await service.conversationUpdate(
      token,
      conversationId: conversationId,
      endConversationId: endConversationId,
      rateId: rateId ?? 2,
    );
  }

  changeCheckboxStatus({required int index}) {
    selectedIndex = index;
    notifyListeners();
  }

  // changeCheckboxStatusPopular({required int index}) {
  //   selectedIndex = -1;
  //   selectedPopularIndex = index;
  //   notifyListeners();
  // }

  Future getAllMessages({required int conversationId}) async {
    isData = true;
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    String token = prefs.getString(PreferencesKeys.TOKEN.toString())!;

    await getRates(token);

    final response =
        await service.getAllMessages(token, conversationId: conversationId);

    if (response.result == true) {
      // messages = response.data!.messages!;
      // chatList = response.data!.messages;
      chatList = List.generate(
        response.data!.messages!.length,
        (index) => ChatModel(
          message: response.data!.messages![index].message!,
          role: response.data!.messages![index].role!,
          id: response.data!.messages![index].id!,
          conversationCompletionCount: "0.0",
          endConversation: response.data!.messages![index].endConversation!,
        ),
      );

      endChat = response.data!.messages!.last.endConversation!;

      isActive = response.data!.conversation!.isActive!;

      conversationCompleteCount =
          response.data!.conversation!.conversationCompletionCount!;
      conversationModel = response.data!.conversation!;

      isData = false;
    }

    notifyListeners();
  }

  // Future sendMessage({required int conversationId}) async {
  //   changeSendIcon();
  //   final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  //   final SharedPreferences prefs = await _prefs;

  //   String token = prefs.getString(PreferencesKeys.TOKEN.toString())!;

  //   final response = await service.sendMessage(token,
  //       message: sendMessageController.text, conversationId: conversationId);

  //   if (response.result == true) {
  //     messages = response.data!.messages!;
  //     sendMessageController.text = '';
  //     changeSendIcon();
  //   }

  //   notifyListeners();
  // }

  changeSendIcon() {
    isTap = !isTap;
    notifyListeners();
  }

  Future translate(
      {required int conversationId,
      required int messageId,
      String? translateTitle}) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    String token = prefs.getString(PreferencesKeys.TOKEN.toString())!;

    final profileResponse = await profileService.getProfileInfo(token);
    // await getLanguages();

    if (profileResponse.result == true) {
      final response = await service.translate(
        token,
        conversationId: conversationId,
        messageId: messageId,
        translateLanguage: translateTitle!.isEmpty
            ? profileResponse.data!.user!.nativeLanguage!.title!
            : translateTitle,
      );

      if (response.result == true) {
        translateModel = response.data!.message!;
      }
    }
  }
}
