// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:chatbot/core/view/base/base_stateless.dart';
import 'package:chatbot/core/view/widget/button/language_level_button.dart';
import 'package:chatbot/product/auth/language/viewmodel/language_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/color_constant.dart';
import '../../../../core/language/locale_keys.g.dart';
import '../../../../core/view/widget/button/app_button.dart';

class LanguageLevelView extends BaseStateless {
  LanguageViewModel viewModel = LanguageViewModel();

  final String email;
  final String password;
  final String name;
  final String nativeId;
  final String learnId;
  final String learnLanguage;

  LanguageLevelView({
    required this.email,
    required this.password,
    required this.name,
    required this.nativeId,
    required this.learnId,
    required this.learnLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.instance.additionalWhite,
      appBar: AppBar(
        toolbarHeight: 40.0,
        leadingWidth: 50.0,
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: ColorConstant.instance.greyScale100),
            child: Center(
              child: IconButton(
                padding: const EdgeInsets.all(0.0),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: ColorConstant.instance.greyScale900,
                  size: 20.0,
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: FutureBuilder(
          future: viewModel.getLanguageLevels(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.done) {
              return languages(context);
            } else {
              return const Text("Error");
            }
          },
        ),
      ),
    );
  }

  Padding languages(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              LocaleKeys.had_very.tr(),
              style: currentTextTheme(context).headline3?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.instance.greyScale600,
                  ),
            ),
          ),
          const SizedBox(height: 4.0),
          Align(
            alignment: Alignment.center,
            child: Text(
              'How would you rate your level of $learnLanguage proficiency?',
              style: currentTextTheme(context).headline1?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.instance.greyScale900,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20.0),
          ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: viewModel.languageLevels.length,
            itemBuilder: (context, index) {
              return Consumer<LanguageViewModel>(
                builder: (context, state, child) {
                  return Column(
                    children: [
                      LanguageLevelButton(
                        languageId: viewModel.languageLevels[index].id!,
                        selectedIndex: state.selectedLevelIndex,
                        onTap: () {
                          viewModel.selectedLanguageLevelId =
                              viewModel.languageLevels[index].id!;
                          state.changeCheckboxStatusLevels(index: index);
                          viewModel.selectedLevelIndex = index;
                        },
                        widthValue: width(context: context, value: 1.0),
                        heightValue: height(context: context, value: 0.07),
                        backgroundColor: ColorConstant.instance.additionalWhite,
                        borderRadius: 66.0,
                        text: viewModel.languageLevels[index].title!,
                        textStyle: currentTextTheme(context)
                                .headline3
                                ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color:
                                        ColorConstant.instance.greyScale900) ??
                            const TextStyle(),
                        onChangedCheckBox: (_) {},
                      ),
                      const SizedBox(height: 15.0),
                    ],
                  );
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: AppButton(
              onTap: () async {
                // mainViewModel.languageLevelId =
                //     viewModel.selectedLanguageLevelId;

                if (viewModel.selectedLanguageLevelId != -1) {
                  await viewModel.register({
                    "email": email,
                    "password": password,
                    "name": name,
                    "native_language_id": nativeId.toString(),
                    "learn_language_id": learnId.toString(),
                    "learn_language_proficiency_id":
                        viewModel.selectedLanguageLevelId.toString(),
                  }, context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        LocaleKeys.language_level.tr(),
                      ),
                    ),
                  );
                }
              },
              widthValue: width(context: context, value: 1.0),
              heightValue: height(context: context, value: 0.07),
              backgroundColor: ColorConstant.instance.greyScale900,
              borderRadius: 66.0,
              text: LocaleKeys.next.tr(),
              textStyle: currentTextTheme(context).headline3?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: ColorConstant.instance.additionalWhite) ??
                  const TextStyle(),
            ),
          ),
        ],
      ),
    );
  }
}
