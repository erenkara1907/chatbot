// ignore_for_file: no_leading_underscores_for_local_identifiers, must_be_immutable, use_key_in_widget_constructors

import 'package:chatbot/core/enum/preference_keys.dart';
import 'package:chatbot/core/language/localization_init.dart';
import 'package:chatbot/core/view/theme/theme.dart';
import 'package:chatbot/product/auth/language/viewmodel/language_view_model.dart';
import 'package:chatbot/product/auth/login/view/login_view.dart';
import 'package:chatbot/product/auth/login/viewmodel/login_view_model.dart';
import 'package:chatbot/product/auth/name/viewmodel/name_view_model.dart';
import 'package:chatbot/product/auth/register/viewmodel/register_view_model.dart';
import 'package:chatbot/product/bottom_bar/view/bottom_bar_view.dart';
import 'package:chatbot/product/bottom_bar/viewmodel/bottom_bar_view_model.dart';
import 'package:chatbot/product/conversation/viewmodel/conversation_room_view_model.dart';
import 'package:chatbot/product/conversation/viewmodel/conversation_view_model.dart';
import 'package:chatbot/product/home/viewmodel/home_view_model.dart';
import 'package:chatbot/product/onboard/viewmodel/onboard_view_model.dart';
import 'package:chatbot/product/profile/viewmodel/profile_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  final localizationInit = LocalizationInit();
  await localizationInit.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => OnboardViewModel()),
        ChangeNotifierProvider(create: (context) => NameViewModel()),
        ChangeNotifierProvider(create: (context) => RegisterViewModel()),
        ChangeNotifierProvider(create: (context) => LanguageViewModel()),
        ChangeNotifierProvider(create: (context) => ProfileViewModel()),
        ChangeNotifierProvider(create: (context) => BottomBarViewModel()),
        ChangeNotifierProvider(create: (context) => HomeViewModel()),
        ChangeNotifierProvider(create: (context) => ConversationViewModel()),
        ChangeNotifierProvider(create: (context) => LoginViewModel()),
        ChangeNotifierProvider(
            create: (context) => ConversationRoomViewModel()),
      ],
      child: EasyLocalization(
        supportedLocales: localizationInit.supportedLocales,
        path: localizationInit.localizationPath,
        fallbackLocale: localizationInit.fallBackLocale,
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String token = '';

  Future checkLoginStatus() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    token = prefs.getString(PreferencesKeys.TOKEN.toString())!;
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'ChatBot',
            theme: appTheme,
            localizationsDelegates: context.localizationDelegates,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            home: token.isNotEmpty ? BottomBarView() : LoginView(),
          );
        } else {
          return const Text('error');
        }
      },
    );
  }
}
