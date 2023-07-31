import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LocalizationInit {
  final List<Locale> supportedLocales = [const Locale("en", "US")];

  final String localizationPath = "assets/translations";
  final Locale fallBackLocale = const Locale("en", "US");

  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    // TextToSpeechViewModel.initTTS();
    await EasyLocalization.ensureInitialized();
    await Firebase.initializeApp();
  }
}
