// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:chatbot/core/view/base/base_stateless.dart';
import 'package:chatbot/product/auth/language/view/language_level_view.dart';
import 'package:chatbot/product/auth/language/viewmodel/language_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/color_constant.dart';
import '../../../../core/language/locale_keys.g.dart';
import '../../../../core/view/widget/button/app_button.dart';
import '../../../../core/view/widget/button/language_button.dart';

class LearnLanguageView extends BaseStateless {
  final String email;
  final String password;
  final String name;
  final String nativeId;

  LearnLanguageView({
    required this.email,
    required this.password,
    required this.name,
    required this.nativeId,
  });

  LanguageViewModel viewModel = LanguageViewModel();
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
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: FutureBuilder(
              future: viewModel.getLanguages(),
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
          Positioned(
            bottom: 40.0,
            right: 0.0,
            left: 0.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: AppButton(
                onTap: () {
                  if (viewModel.selectedLearnLanguageId != -1 ||
                      viewModel.selectedLearnPopularLanguageId != -1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LanguageLevelView(
                          learnLanguage: viewModel.selectedLearnIndex != -1
                              ? viewModel.selectedLearnTitle
                              : viewModel.selectedLearnTitlePopular,
                          email: email,
                          password: password,
                          name: name,
                          nativeId: nativeId,
                          learnId: viewModel.selectedLearnIndex != -1
                              ? viewModel.selectedLearnLanguageId.toString()
                              : viewModel.selectedLearnPopularLanguageId
                                  .toString(),
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          LocaleKeys.language_blank.tr(),
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
          ),
        ],
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
              LocaleKeys.great.tr(),
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
              LocaleKeys.what_learn_language.tr(),
              style: currentTextTheme(context).headline1?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.instance.greyScale900,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            LocaleKeys.popular_lang.tr(),
            style: currentTextTheme(context).headline3?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: ColorConstant.instance.greyScale600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15.0),
          ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: viewModel.popularLanguageIds.length,
            itemBuilder: (context, index) {
              return Consumer<LanguageViewModel>(
                builder: (context, state, child) {
                  return Column(
                    children: [
                      LanguageButton(
                        image: viewModel.popularLanguageImages[index],
                        languageId: viewModel.popularLanguageIds[index],
                        selectedIndex: state.selectedLearnPopularIndex,
                        onTap: () {
                          viewModel.selectedLearnPopularLanguageId =
                              viewModel.popularLanguageIds[index];
                          state.changeCheckboxLearnStatusPopular(index: index);
                          viewModel.selectedLearnPopularIndex = index;
                          viewModel.selectedLearnTitlePopular =
                              viewModel.popularLanguageTitles[index];
                        },
                        widthValue: width(context: context, value: 1.0),
                        heightValue: height(context: context, value: 0.07),
                        backgroundColor: ColorConstant.instance.additionalWhite,
                        borderRadius: 66.0,
                        text: viewModel.popularLanguageTitles[index],
                        textStyle: currentTextTheme(context)
                                .headline3
                                ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color:
                                        ColorConstant.instance.greyScale900) ??
                            const TextStyle(),
                        onChangedCheckBox: (_) {},
                      ),
                      SizedBox(
                          height:
                              viewModel.popularLanguageTitles[index] == "German"
                                  ? 0.0
                                  : 15.0),
                    ],
                  );
                },
              );
            },
          ),
          Text(
            LocaleKeys.all_lang.tr(),
            style: currentTextTheme(context).headline3?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: ColorConstant.instance.greyScale600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15.0),
          ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: viewModel.languages.length,
            itemBuilder: (context, index) {
              return Consumer<LanguageViewModel>(
                builder: (context, state, child) {
                  return Column(
                    children: [
                      LanguageButton(
                        image: viewModel.languages[index].flag!,
                        languageId: viewModel.languages[index].id!,
                        selectedIndex: state.selectedLearnIndex,
                        onTap: () {
                          viewModel.selectedLearnLanguageId =
                              viewModel.languages[index].id!;
                          state.changeCheckboxLearnStatus(index: index);
                          viewModel.selectedLearnIndex = index;
                          viewModel.selectedLearnTitle =
                              viewModel.languages[index].title!;
                        },
                        widthValue: width(context: context, value: 1.0),
                        heightValue: height(context: context, value: 0.07),
                        backgroundColor: ColorConstant.instance.additionalWhite,
                        borderRadius: 66.0,
                        text: viewModel.languages[index].title!,
                        textStyle: currentTextTheme(context)
                                .headline3
                                ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color:
                                        ColorConstant.instance.greyScale900) ??
                            const TextStyle(),
                        onChangedCheckBox: (value) {},
                      ),
                      const SizedBox(height: 15.0),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(height: 70.0),
        ],
      ),
    );
  }
}
