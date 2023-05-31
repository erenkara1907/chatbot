// class TextToSpeech extends ChangeNotifier {
//   static FlutterTts tts = FlutterTts();
//   bool isCompleted = false;

//   static initTTS() async {
//     tts.setLanguage("hi-IN");
//     tts.setPitch(1.0);
//     tts.setSpeechRate(0.5);
//   }

//   static speak(String text) async {
//     tts.setStartHandler(() {
//       isCompleted =
//     });

//     tts.setCompletionHandler(() {
//       print("TTS IS COMPLETED");
//     });

//     // tts.setErrorHandler((message) {
//     //   print("TTS ERROR : $message");
//     // });

//     await tts.awaitSpeakCompletion(true);

//     tts.speak(text);
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechViewModel extends ChangeNotifier {
  static FlutterTts tts = FlutterTts();

  bool isCompleted = true;
  int selectedIndex = -1;

  changeSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  static initTTS() async {
    tts.setLanguage("en-US");
    tts.setPitch(1.0);
    tts.setSpeechRate(0.4);
  }

  stop() {
    tts.stop();
    isCompleted = true;
    notifyListeners();
  }

  speak(String text) async {
    await tts.setIosAudioCategory(IosTextToSpeechAudioCategory.playAndRecord,
        [IosTextToSpeechAudioCategoryOptions.defaultToSpeaker]);
    tts.setStartHandler(() {
      isCompleted = false;
      notifyListeners();
    });

    tts.setCompletionHandler(() {
      isCompleted = true;
      notifyListeners();
    });

    // tts.setErrorHandler((message) {
    //   print("TTS ERROR : $message");
    // });

    await tts.awaitSpeakCompletion(true);

    tts.speak(text);
  }
}
