// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Speech {
  static final _speech = SpeechToText();

  static Future<bool> toggleRecording(
      {required Function(String text) onResult,
      required ValueChanged<bool> onListening}) async {
    final isAvailable = await _speech.initialize(
        onStatus: (status) => onListening(_speech.isListening),
        onError: (error) => print('Error $error'));

    if (_speech.isListening) {
      _speech.stop();
      return true;
    }

    var status = await Permission.microphone.status;

    if (isAvailable && status != PermissionStatus.denied) {
      _speech.listen(onResult: (value) => onResult(value.recognizedWords));
    } else {
      openAppSettings();
    }

    return isAvailable;
  }
}
