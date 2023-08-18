import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SpeechProvider with ChangeNotifier {
  final platform = const MethodChannel("text_to_speech");
  final _speechStatus = const EventChannel("speech_status");

  int _messageIndex = -1;
  int get messageIndex => _messageIndex;

  bool _isSpeaking = false;
  bool get isSpeaking => _isSpeaking;

  late StreamSubscription _speechStatusSubscription;

  SpeechProvider() {
    initializeSpeechStatusListener();
  }

  void initializeSpeechStatusListener() {
    _speechStatusSubscription =
        _speechStatus.receiveBroadcastStream().listen((event) {
      if (event == "finished") {
        _isSpeaking = false;
        notifyListeners();
      }
    });
  }

  Future<void> speak(String text, int index) async {  
    try {
      await platform.invokeMethod("speakText", {"text": text});
      _isSpeaking = true;
      _messageIndex = index;
      notifyListeners();
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future<void> stop() async {
    try {
      await platform.invokeMethod("stopText");
      _isSpeaking = false;
      notifyListeners();
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  @override
  void dispose() {
    _speechStatusSubscription.cancel();
    super.dispose();
  }
}
