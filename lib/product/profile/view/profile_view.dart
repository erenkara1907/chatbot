// ignore_for_file: use_key_in_widget_constructors, no_leading_underscores_for_local_identifiers, must_be_immutable, use_build_context_synchronously

import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/constants/icon_constant.dart';
import 'package:chatbot/core/enum/preference_keys.dart';
import 'package:chatbot/core/language/locale_keys.g.dart';
import 'package:chatbot/core/view/base/base_stateless.dart';
import 'package:chatbot/core/view/widget/button/profile_button.dart';
import 'package:chatbot/product/auth/login/view/login_view.dart';
import 'package:chatbot/product/bottom_bar/viewmodel/bottom_bar_view_model.dart';
import 'package:chatbot/product/profile/view/profile_edit_view.dart';
import 'package:chatbot/product/profile/viewmodel/profile_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/view/widget/button/language_button.dart';
import '../../../core/view/widget/button/language_level_button.dart';

class ProfileView extends BaseStateless {
  ProfileViewModel viewModel = ProfileViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.instance.additionalWhite,
      body: FutureBuilder(
        future: viewModel.getProfileInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 100.0,
                          height: 100.0,
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: ColorConstant.instance.greyScale300,
                                  blurRadius: 10.0,
                                  spreadRadius: 1.0,
                                  offset: const Offset(3, 3),
                                )
                              ],
                              color: ColorConstant.instance.additionalWhite,
                              borderRadius: BorderRadius.circular(50.0),
                              border: Border.all(
                                width: 1.0,
                                color: ColorConstant.instance.additionalWhite,
                              )),
                          child: Container(
                            width: 80.0,
                            height: 80.0,
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: Color.fromRGBO(
                                viewModel.profileModel.data!.user!.color![0],
                                viewModel.profileModel.data!.user!.color![1],
                                viewModel.profileModel.data!.user!.color![2],
                                1,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                image: DecorationImage(
                                  image: NetworkImage(viewModel
                                      .profileModel.data!.user!.profilePhoto!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        viewModel.profileModel.data!.user!.name!,
                        style: currentTextTheme(context).headline3?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: ColorConstant.instance.greyScale900,
                            ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        ProfileButton(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileEditView(
                                  languages: viewModel.languages,
                                  nativeLanguageId: viewModel.profileModel.data!
                                      .user!.nativeLanguage!.id!,
                                  avatars: viewModel.avatars,
                                  profilePhoto: viewModel
                                      .profileModel.data!.user!.profilePhoto!,
                                  email:
                                      viewModel.profileModel.data!.user!.email!,
                                  name:
                                      viewModel.profileModel.data!.user!.name!,
                                ),
                              ),
                            );
                          },
                          image: IconConstant.instance.iconPerson,
                          text: LocaleKeys.personal_information.tr(),
                        ),
                        ProfileButton(
                          onTap: () {
                            showModalBottomSheet(
                              isDismissible: false,
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return Consumer<ProfileViewModel>(
                                  builder: (context, state, child) {
                                    return FractionallySizedBox(
                                      heightFactor:
                                          state.isLanguageLevelBottomSheet
                                              ? 0.7
                                              : 0.9,
                                      child: state.isLanguageLevelBottomSheet
                                          ? languageLevels(
                                              context,
                                              viewModel.selectedLearnIndex != -1
                                                  ? viewModel
                                                      .learnNativeLanguage
                                                  : viewModel
                                                      .learnNativeLanguagePopular,
                                            )
                                          : languages(context),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          image: IconConstant.instance.iconLanguage,
                          text: LocaleKeys.language.tr(),
                          isEnglish: true,
                          language: viewModel.profileModel.data!.user!
                              .learnLanguages![0].title!,
                        ),
                        ProfileButton(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width:
                                            width(context: context, value: 1.0),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 28.0,
                                          horizontal: 30.0,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          color: ColorConstant
                                              .instance.additionalWhite,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              IconConstant.instance.iconStar,
                                              width: 55.0,
                                              height: 55.0,
                                            ),
                                            const SizedBox(height: 12.0),
                                            Text(
                                              LocaleKeys.write_us.tr(),
                                              style: currentTextTheme(context)
                                                  .headline1
                                                  ?.copyWith(
                                                    fontSize: 24.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: ColorConstant
                                                        .instance.greyScale900,
                                                  ),
                                            ),
                                            const SizedBox(height: 24.0),
                                            Text(
                                              LocaleKeys.write_us_content.tr(),
                                              style: currentTextTheme(context)
                                                  .headline4
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    color: ColorConstant
                                                        .instance.greyScale900,
                                                  ),
                                            ),
                                            Text(
                                              'info@ron.digital',
                                              style: currentTextTheme(context)
                                                  .headline4
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: ColorConstant
                                                        .instance.greyScale900,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          image: IconConstant.instance.iconWriteUs,
                          text: LocaleKeys.write_us.tr(),
                        ),
                        ProfileButton(
                          image: IconConstant.instance.iconTerms,
                          text: LocaleKeys.terms.tr(),
                        ),
                        ProfileButton(
                          onTap: () async {
                            final Future<SharedPreferences> _prefs =
                                SharedPreferences.getInstance();
                            final SharedPreferences prefs = await _prefs;
                            prefs.remove(PreferencesKeys.TOKEN.toString());
                            prefs.remove(
                                PreferencesKeys.IS_FIRST_APP.toString());

                            Provider.of<BottomBarViewModel>(context,
                                    listen: false)
                                .selectedIndex = 0;

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginView()),
                              (route) => false,
                            );
                          },
                          image: IconConstant.instance.iconLogout,
                          text: LocaleKeys.logout.tr(),
                          isLogout: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 17.0),
                          child: Divider(
                            thickness: 2,
                            color: ColorConstant.instance.greyScale200,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Text('error');
          }
        },
      ),
    );
  }

  SingleChildScrollView languages(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Container(
        width: width(context: context, value: 1.0),
        decoration: BoxDecoration(
          color: ColorConstant.instance.additionalWhite,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 15.0),
              Align(
                alignment: Alignment.centerRight,
                child: CircleAvatar(
                  radius: 15.0,
                  backgroundColor: ColorConstant.instance.greyScale300,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: ColorConstant.instance.greyScale900,
                      size: 15.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
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
                  return Consumer<ProfileViewModel>(
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
                              state.changeCheckboxLearnStatusPopular(
                                  index: index);
                              viewModel.selectedLearnPopularIndex = index;
                              state.changeBottomSheet(true);
                              viewModel.learnNativeLanguagePopular =
                                  viewModel.popularLanguageTitles[index];
                            },
                            widthValue: width(context: context, value: 1.0),
                            heightValue: height(context: context, value: 0.07),
                            backgroundColor:
                                ColorConstant.instance.additionalWhite,
                            borderRadius: 66.0,
                            text: viewModel.popularLanguageTitles[index],
                            textStyle: currentTextTheme(context)
                                    .headline3
                                    ?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: ColorConstant
                                            .instance.greyScale900) ??
                                const TextStyle(),
                            onChangedCheckBox: (_) {},
                          ),
                          SizedBox(
                              height: viewModel.popularLanguageTitles[index] ==
                                      "German"
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
                  return Consumer<ProfileViewModel>(
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
                              state.changeBottomSheet(true);
                              viewModel.learnNativeLanguage =
                                  viewModel.languages[index].title!;
                            },
                            widthValue: width(context: context, value: 1.0),
                            heightValue: height(context: context, value: 0.07),
                            backgroundColor:
                                ColorConstant.instance.additionalWhite,
                            borderRadius: 66.0,
                            text: viewModel.languages[index].title!,
                            textStyle: currentTextTheme(context)
                                    .headline3
                                    ?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: ColorConstant
                                            .instance.greyScale900) ??
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
        ),
      ),
    );
  }

  SingleChildScrollView languageLevels(BuildContext context, String title) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Container(
        width: width(context: context, value: 1.0),
        decoration: BoxDecoration(
          color: ColorConstant.instance.additionalWhite,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 15.0),
              IconButton(
                onPressed: () {
                  Provider.of<ProfileViewModel>(context, listen: false)
                      .changeBottomSheet(false);
                },
                icon: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.arrow_back,
                    color: ColorConstant.instance.greyScale900,
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              Text(
                'How would you rate your level of $title proficiency?',
                style: currentTextTheme(context).headline1?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: ColorConstant.instance.greyScale900,
                    ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20.0),
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: viewModel.languageLevels.length,
                itemBuilder: (context, index) {
                  return Consumer<ProfileViewModel>(
                    builder: (context, state, child) {
                      return Column(
                        children: [
                          LanguageLevelButton(
                            languageId: viewModel.languageLevels[index].id!,
                            selectedIndex: state.selectedLevelIndex,
                            onTap: () async {
                              viewModel.selectedLanguageLevelId =
                                  viewModel.languageLevels[index].id!;
                              state.changeCheckboxStatusLevels(index: index);
                              viewModel.selectedLevelIndex = index;
                              Future.delayed(const Duration(seconds: 1), () {
                                state.isLanguageLevelBottomSheet = false;
                                state.selectedLevelIndex = -1;
                                state.selectedLearnIndex = -1;
                                Navigator.pop(context);
                              });




                              await state.updateProfile(
                                context,
                                {
                                  'learn_language_id': viewModel
                                              .selectedLearnLanguageId ==
                                          -1 && viewModel.selectedLearnPopularLanguageId == -1
                                      ? viewModel.profileModel.data!.user!
                                          .learnLanguages![0].id
                                          .toString()
                                      : viewModel.selectedLearnIndex != -1
                                          ? viewModel.selectedLearnLanguageId
                                              .toString()
                                          : viewModel
                                              .selectedLearnPopularLanguageId
                                              .toString(),
                                  'learn_language_proficiency_id':
                                      viewModel.selectedLanguageLevelId == -1
                                          ? viewModel
                                              .profileModel
                                              .data!
                                              .user!
                                              .learnLanguages![0]
                                              .proficiencyLevel!
                                              .id
                                              .toString()
                                          : viewModel.selectedLanguageLevelId
                                              .toString(),
                                },
                              );
                            },
                            widthValue: width(context: context, value: 1.0),
                            heightValue: height(context: context, value: 0.07),
                            backgroundColor:
                                ColorConstant.instance.additionalWhite,
                            borderRadius: 66.0,
                            text: viewModel.languageLevels[index].title!,
                            textStyle: currentTextTheme(context)
                                    .headline3
                                    ?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: ColorConstant
                                            .instance.greyScale900) ??
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
            ],
          ),
        ),
      ),
    );
  }
}
