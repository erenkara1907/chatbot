// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';

// class TextToSpeechViewModel extends ChangeNotifier {
//   static FlutterTts tts = FlutterTts();

//   bool isCompleted = true;
//   int selectedIndex = -1;
//   bool isSpeaking = false;

//   changeSelectedIndex(int index) {
//     selectedIndex = index;
//     notifyListeners();
//   }

//   static initTTS() async {
//     tts.setLanguage("en-US");
//     tts.setPitch(1.0);
//     tts.setSpeechRate(0.4);
//     await tts.setVoice({"name": "Aaron", "locale": "en-US"});
//   }

//   stop() {
//     tts.stop();
//     isCompleted = true;
//     notifyListeners();
//   }

//   speak(String text) async {
//     final response = await tts.setIosAudioCategory(
//         IosTextToSpeechAudioCategory.playAndRecord,
//         [IosTextToSpeechAudioCategoryOptions.defaultToSpeaker]);

//     await tts.setIosAudioCategory(IosTextToSpeechAudioCategory.playAndRecord,
//         [IosTextToSpeechAudioCategoryOptions.defaultToSpeaker]);
//     tts.setStartHandler(() {
//       isCompleted = false;
//       notifyListeners();
//     });

//     tts.setCompletionHandler(() {
//       isCompleted = true;
//       isSpeaking = true;
//       notifyListeners();
//     });

//     await tts.awaitSpeakCompletion(true);

//     tts.speak(text);
//   }
// }
