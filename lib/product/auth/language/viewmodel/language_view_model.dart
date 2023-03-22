// ignore_for_file: use_build_context_synchronously, unused_local_variable, no_leading_underscores_for_local_identifiers

import 'package:chatbot/core/enum/preference_keys.dart';
import 'package:chatbot/product/auth/language/model/language_model.dart';
import 'package:chatbot/product/auth/language/service/language_service.dart';
import 'package:chatbot/product/auth/register/service/register_service.dart';
import 'package:chatbot/product/auth/register/view/register_view.dart';
import 'package:chatbot/product/bottom_bar/view/bottom_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/language_level_model.dart';

class LanguageViewModel extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();

  FocusNode searchFocusNode = FocusNode();

  String selectedLearnTitle = '';
  String selectedLearnTitlePopular = '';

  bool isCheck = false;
  bool isCheckedValue = false;

  int selectedIndex = -1;
  int selectedPopularIndex = -1;
  int selectedLevelIndex = -1;

  int selectedLanguageId = -1;
  int selectedPopularLanguageId = -1;

  int selectedLearnIndex = -1;
  int selectedLearnPopularIndex = -1;
  int selectedLearnLevelIndex = -1;

  int selectedLearnLanguageId = -1;
  int selectedLearnPopularLanguageId = -1;
  int selectedLanguageLevelId = -1;

  String nativeLanguage = 'turkish';

  LanguageService service = LanguageService();
  RegisterService registerService = RegisterService();

  List<Languages> languages = [];
  List<Languages> searchLanguages = [];
  List<String> popularLanguageTitles = [];
  List<String> popularLanguageImages = [];
  List<int> popularLanguageIds = [];
  List<LanguageProficiencyLevels> languageLevels = [];

  startFocusNode() {
    searchFocusNode.unfocus();
  }

  changeCheckboxStatus({required int index}) {
    selectedPopularIndex = -1;
    selectedIndex = index;
    notifyListeners();
  }

  changeCheckboxStatusPopular({required int index}) {
    selectedIndex = -1;
    selectedPopularIndex = index;
    notifyListeners();
  }

  changeCheckboxLearnStatus({required int index}) {
    selectedLearnPopularIndex = -1;
    selectedLearnIndex = index;
    notifyListeners();
  }

  changeCheckboxLearnStatusPopular({required int index}) {
    selectedLearnIndex = -1;
    selectedLearnPopularIndex = index;
    notifyListeners();
  }

  changeCheckboxStatusLevels({required int index}) {
    selectedIndex = -1;
    selectedPopularIndex = -1;
    selectedLevelIndex = index;
    notifyListeners();
  }

  Future getLanguages() async {
    final model = await service.getLanguages();

    if (model.result == true) {
      for (var i = 0; i < model.data!.languages!.length; i++) {
        if (model.data!.languages![i].isPopular == 1) {
          if (popularLanguageTitles.length != 4) {
            popularLanguageTitles.add(model.data!.languages![i].title!);
            popularLanguageIds.add(model.data!.languages![i].id!);
            popularLanguageImages.add(model.data!.languages![i].flag!);
          }
        } else {
          languages.clear();
          languages.addAll(model.data!.languages!);
        }
      }
      languages.clear();
      languages.addAll(model.data!.languages!);
    }
  }

  Future getLanguageLevels() async {
    final model = await service.getLanguageLevels();

    if (model.result == true) {
      languageLevels = model.data!.languageProficiencyLevels!;
    }
  }

  Future register(Map<String, dynamic> user, BuildContext context) async {
    final response = await registerService.register(user);

    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    if (response.result == true) {
      await prefs.setString(
          PreferencesKeys.TOKEN.toString(), response.data!.token!);

      Navigator.push(
          context, MaterialPageRoute(builder:   (context) => BottomBarView()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The email has already been taken')),
      );

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterView(),
          ),
          (route) => false);
    }
  }
}
