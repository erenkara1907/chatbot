// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_final_fields, use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:chatbot/product/auth/language/model/language_model.dart';
import 'package:chatbot/product/conversation/model/translate_model.dart';
import 'package:chatbot/product/conversation/service/conversation_service.dart';
import 'package:chatbot/product/profile/model/profile_model.dart';
import 'package:chatbot/product/profile/service/profile_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/icon_constant.dart';
import '../../../core/enum/preference_keys.dart';
import '../model/chat_model.dart';
import '../model/conversation_room_model.dart';
import '../model/one_message_model.dart';
import '../model/rate_model.dart';

class ConversationRoomViewModel extends ChangeNotifier {
  ConversationService service = ConversationService();
  ProfileService profileService = ProfileService();
  // LanguageService languageService = LanguageService();

  FocusNode sendMessageFocusNode = FocusNode();

  bool isTap = false;
  bool isTyping = false;

  String translateMessage = '';

  TranslateMessage translateModel = TranslateMessage();
  ProfileModel profileModel = ProfileModel();
  List<Message> oneMessage = [];

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

  bool isTapped = false;
  bool isRecording = false;
  bool isComplete = false;

  bool isSelectVoice = true;
  bool isSpeaking = false;

  bool isAvatarSelected = false;
  bool isAvatarAISelected = false;

  setAvatarSelect(bool value) {
    isAvatarSelected = value;
    notifyListeners();
  }

  setAvatarAISelect(bool value) {
    isAvatarAISelected = value;
    notifyListeners();
  }

  setSpeaking() {
    isSpeaking = !isSpeaking;
    notifyListeners();
  }

  selectVoice(bool value) {
    isSelectVoice = value;
    notifyListeners();
  }

  setIsRecord() {
    isRecording = !isRecording;
    notifyListeners();
  }

  setIsComplete() {
    isComplete = !isComplete;
    notifyListeners();
  }

  setTapped() {
    isTapped = !isTapped;
    notifyListeners();
  }

  startFocusNode() {
    sendMessageFocusNode.unfocus();
  }

  // List<Messages> messages = [];
  Conversation conversationModel = Conversation();
  String conversationCompleteCount = "0.0";
  List<Rates> rates = [];

  List<ChatModel> chatList = [];
  // List<ChatModel> tempList = [];
  List<ChatModel> get getChatList => chatList;

  void addUserMessage({
    required String message,
    required String betterSentence,
    required String correctSentence,
    required String sound,
    required String soundRatio,
  }) {
    chatList.add(
      ChatModel(
        message: message,
        role: 'user',
        id: 1,
        endConversation: 0,
        conversationCompletionCount: "0.0",
        betterSentence: betterSentence,
        correctSentence: correctSentence,
        sound: sound,
        soundRatio: soundRatio,
      ),
    );
    notifyListeners();
  }

  // addMessage(String text) {
  //   sendMessageController.text = text;
  //   print("viewmodel : ${sendMessageController.text}");
  //   notifyListeners();
  // }

  bool isListening = false;
  late TextEditingController sendTextController;

  showAlertDialog(context) => showCupertinoDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('Permission Denied'),
          content: const Text('Allow access to gallery and photos'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => openAppSettings(),
              child: const Text('Settings'),
            ),
          ],
        ),
      );

  bool isReadMessage = false;

  Future<void> sendMessageAndGetAnswers({
    required String message,
    required int conversationId,
    required String soundRatio,
    required String sound,
  }) async {
    final player = AudioPlayer();
    chatList.add(
      ChatModel(
        id: 92761,
        message: "Load",
        role: "assistant",
        conversationCompletionCount: "1",
        endConversation: 1,
        betterSentence: '',
        correctSentence: '',
        sound: null,
        soundRatio: null,
      ),
    );
    await player.play(AssetSource("sound/sound_assistant_bubble.wav"));
    final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    final SharedPreferences _prefs = await prefs;
    File file = File(sound);
    // String fileName = file.path.split('/').last;
    // File newFile = File('${file.parent.path}/$fileName.wav');
    // await file.copy(newFile.path);
    String token = _prefs.getString(PreferencesKeys.TOKEN.toString())!;
    final response = await service.sendMessage(
      soundFile: file,
      soundRatio: soundRatio,
      message: message,
      conversationId: conversationId,
      token: token,
    );

    chatList.removeLast();
    chatList.addAll(response);
    isReadMessage = true;

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

  setData(bool data) {
    notifyListeners();
  }

  String voiceMessage = "";

  selectLanguageText(String text) {
    nativeLanguage = text;
    notifyListeners();
  }

  setText(String text) {
    voiceMessage = text;
    notifyListeners();
  }

  bool isGetMessage = false;

  Future getAllMessages({required int conversationId}) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    String token = prefs.getString(PreferencesKeys.TOKEN.toString())!;

    await getRates(token);

    final response =
        await service.getAllMessages(token, conversationId: conversationId);

    if (response.result == true) {
      chatList = List.generate(
        response.data!.messages!.length,
        (index) => ChatModel(
          message: response.data!.messages![index].message!,
          role: response.data!.messages![index].role!,
          id: response.data!.messages![index].id!,
          conversationCompletionCount: "0.0",
          endConversation: response.data!.messages![index].endConversation!,
          betterSentence: response.data!.messages![index].betterSentence ?? "",
          correctSentence:
              response.data!.messages![index].correctSentence ?? "",
          sound: response.data!.messages![index].sound ?? "",
          soundRatio: response.data!.messages![index].soundRatio ?? "",
        ),
      );

      endChat = response.data!.messages!.last.endConversation!;

      isActive = response.data!.conversation!.isActive!;

      conversationCompleteCount =
          response.data!.conversation!.conversationCompletionCount!;
      conversationModel = response.data!.conversation!;
    }
    isGetMessage = true;
    notifyListeners();
  }

  Future getMessage(
      {required int conversationId, required int messageId}) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    String token = prefs.getString(PreferencesKeys.TOKEN.toString())!;

    await getRates(token);

    final response = await service.getMessage(token,
        conversationId: conversationId, messageId: messageId);

    if (response.result == true) {
      oneMessage.removeLast();
      oneMessage.add(response.data!.message!);
    }
    isGetMessage = true;
    notifyListeners();
  }

  changeSendIcon() {
    isTap = !isTap;
    notifyListeners();
  }

  setTranslateMessage(String message) {
    translateMessage = message;
    notifyListeners();
  }

  Future translate({
    required int conversationId,
    required int messageId,
    String? translateTitle,
  }) async {
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
