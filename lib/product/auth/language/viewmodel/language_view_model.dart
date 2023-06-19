// ignore_for_file: use_build_context_synchronously, unused_local_variable, no_leading_underscores_for_local_identifiers, iterable_contains_unrelated_type

import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/enum/preference_keys.dart';
import 'package:chatbot/product/auth/language/model/language_model.dart';
import 'package:chatbot/product/auth/register/service/register_service.dart';
import 'package:chatbot/product/auth/register/view/register_view.dart';
import 'package:chatbot/product/bottom_bar/view/bottom_bar_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/icon_constant.dart';
import '../../../../core/language/locale_keys.g.dart';

class LanguageViewModel extends ChangeNotifier {
  // TextEditingController searchController = TextEditingController();

  // FocusNode searchFocusNode = FocusNode();

  // String selectedLearnTitle = '';
  // String selectedLearnTitlePopular = '';

  // bool isCheck = false;
  // bool isCheckedValue = false;

  int selectedIndex = -1;
  // int selectedPopularIndex = -1;
  // int selectedLevelIndex = -1;

  int selectedLanguageId = -1;
  String selectedLanguageCode = "en";
  // int selectedPopularLanguageId = -1;

  // int selectedLearnIndex = -1;
  // int selectedLearnPopularIndex = -1;
  // int selectedLearnLevelIndex = -1;

  // int selectedLearnLanguageId = -1;
  // int selectedLearnPopularLanguageId = -1;
  // int selectedLanguageLevelId = -1;

  // String nativeLanguage = 'turkish';

  // LanguageService service = LanguageService();
  RegisterService registerService = RegisterService();

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
      code: "zh",
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
  // List<LanguageProficiencyLevels> languageLevels = [];

  // bool isGetLanguage = true;

  // bool isFullSearch = false;

  double sliderValue = 0.0;
  bool isActivePage = false;
  bool isActiveLevelPage = false;

  String learnLanguageProficiencyCefr = "A1";

  setActivePage() {
    Future.delayed(const Duration(milliseconds: 500), () {
      isActivePage = true;
      notifyListeners();
    });
  }

  setActiveLevelPage() {
    Future.delayed(const Duration(milliseconds: 500), () {
      isActiveLevelPage = true;
      notifyListeners();
    });
  }

  changeSliderValue(double value) {
    sliderValue = value;

    notifyListeners();
  }

  // List<Languages> searchLanguages = [];
  // searchLanguageFromList() {
  //   if (searchController.text.isNotEmpty) {
  //     for (var i = 0; i < languages.length; i++) {
  //       if (languages[i]
  //           .title!
  //           .toLowerCase()
  //           .contains(searchController.text.toLowerCase())) {
  //         searchLanguages.add(languages[i]);
  //       }
  //       print('length: ${searchLanguages.length}');
  //     }
  //   }
  // }

  // setSearchList() {
  //   print('girdi');
  //   searchLanguageFromList();
  //   isFullSearch = true;
  //   notifyListeners();
  // }

  // startFocusNode() {
  //   searchFocusNode.unfocus();
  // }

  changeCheckboxStatus({required int index}) {
    selectedIndex = index;
    notifyListeners();
  }

  Widget switchTextWidget(int sliderValue, {required BuildContext context}) {
    switch (sliderValue) {
      case 0:
        learnLanguageProficiencyCefr = "A1";
        return Text(
          LocaleKeys.a1.tr(),
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: ColorConstant.instance.additionalWhite,
                  ) ??
              const TextStyle(),
          textAlign: TextAlign.center,
        );
      case 1:
        learnLanguageProficiencyCefr = "A2";
        return Text(
          LocaleKeys.a2.tr(),
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: ColorConstant.instance.additionalWhite,
                  ) ??
              const TextStyle(),
          textAlign: TextAlign.center,
        );
      case 2:
        learnLanguageProficiencyCefr = "B1";
        return Text(
          LocaleKeys.b1.tr(),
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: ColorConstant.instance.additionalWhite,
                  ) ??
              const TextStyle(),
          textAlign: TextAlign.center,
        );
      case 3:
        learnLanguageProficiencyCefr = "B2";
        return Text(
          LocaleKeys.b2.tr(),
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: ColorConstant.instance.additionalWhite,
                  ) ??
              const TextStyle(),
          textAlign: TextAlign.center,
        );
      case 4:
        learnLanguageProficiencyCefr = "C1";
        return Text(
          LocaleKeys.c1.tr(),
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: ColorConstant.instance.additionalWhite,
                  ) ??
              const TextStyle(),
          textAlign: TextAlign.center,
        );
      case 5:
        learnLanguageProficiencyCefr = "C2";
        return Text(
          LocaleKeys.c2.tr(),
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: ColorConstant.instance.additionalWhite,
                  ) ??
              const TextStyle(),
          textAlign: TextAlign.center,
        );
      default:
        learnLanguageProficiencyCefr = "A1";
        return Text(
          LocaleKeys.c2.tr(),
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: ColorConstant.instance.additionalWhite,
                  ) ??
              const TextStyle(),
          textAlign: TextAlign.center,
        );
    }
  }

  Future register(Map<String, dynamic> user, BuildContext context) async {
    final response = await registerService.register(user);

    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    if (response.result == true) {
      await prefs.setString(
          PreferencesKeys.TOKEN.toString(), response.data!.token!);

      selectedIndex = -1;
      learnLanguageProficiencyCefr = "A1";
      sliderValue = 0;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => BottomBarView()));
    } else {
      selectedIndex = -1;
      learnLanguageProficiencyCefr = "A1";
      sliderValue = 0;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.validationError!.email![0]),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterView(),
        ),
      );
    }
  }
}
