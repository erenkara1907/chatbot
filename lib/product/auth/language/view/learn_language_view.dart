// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:chatbot/core/view/base/base_state.dart';
import 'package:chatbot/product/auth/language/viewmodel/language_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import '../../../../core/constants/color_constant.dart';
import '../../../../core/language/locale_keys.g.dart';
import '../../../../core/view/widget/button/app_button.dart';
import '../../../../core/view/widget/button/language_button.dart';
import '../../../../core/view/widget/formfield/app_form_field.dart';
import '../model/language_model.dart';
import 'language_level_view.dart';

class LearnLanguageView extends StatefulWidget {
  final String email;
  final String password;
  final String name;
  final String nativeId;

  const LearnLanguageView({
    required this.email,
    required this.password,
    required this.name,
    required this.nativeId,
  });

  @override
  State<LearnLanguageView> createState() => _LearnLanguageViewState();
}

class _LearnLanguageViewState extends BaseState<LearnLanguageView> {
  LanguageViewModel viewModel = LanguageViewModel();

  List<Languages> items = [];
  bool isPage = false;

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
      body: Consumer<LanguageViewModel>(
        builder: (context, state, child) {
          viewModel.languages = state.languages;
          viewModel.popularLanguageIds = state.popularLanguageIds;
          viewModel.popularLanguageImages = state.popularLanguageImages;
          viewModel.popularLanguageTitles = state.popularLanguageTitles;
          return state.isGetLanguage
              ? isPage
                  ? SizedBox(
                      height: height(1.0),
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            child: languages(context),
                          ),
                          Positioned(
                            bottom: 40.0,
                            right: 0.0,
                            left: 0.0,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40.0),
                              child: AppButton(
                                onTap: () {
                                  if (state.selectedLearnLanguageId != -1 ||
                                      state.selectedLearnPopularLanguageId !=
                                          -1) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LanguageLevelView(
                                          learnLanguage: viewModel
                                                      .selectedLearnIndex !=
                                                  -1
                                              ? viewModel.selectedLearnTitle
                                              : viewModel
                                                  .selectedLearnTitlePopular,
                                          email: widget.email,
                                          password: widget.password,
                                          name: widget.name,
                                          nativeId: widget.nativeId,
                                          learnId: viewModel
                                                      .selectedLearnIndex !=
                                                  -1
                                              ? viewModel
                                                  .selectedLearnLanguageId
                                                  .toString()
                                              : viewModel
                                                  .selectedLearnPopularLanguageId
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
                                widthValue: width(1.0),
                                heightValue: height(0.07),
                                backgroundColor:
                                    ColorConstant.instance.greyScale900,
                                borderRadius: 66.0,
                                text: LocaleKeys.next.tr(),
                                textStyle: currentTextTheme.headline3?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: ColorConstant
                                            .instance.additionalWhite) ??
                                    const TextStyle(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Stack(
                      children: [
                        SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: languages(context),
                        ),
                        Positioned(
                          bottom: 40.0,
                          right: 0.0,
                          left: 0.0,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
                            child: AppButton(
                              onTap: () {
                                if (state.selectedLearnLanguageId != -1 ||
                                    state.selectedLearnPopularLanguageId !=
                                        -1) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LanguageLevelView(
                                        learnLanguage:
                                            state.selectedLearnIndex != -1
                                                ? state.selectedLearnTitle
                                                : state
                                                    .selectedLearnTitlePopular,
                                        email: widget.email,
                                        password: widget.password,
                                        name: widget.name,
                                        nativeId: widget.nativeId,
                                        learnId: state.selectedLearnIndex !=
                                                -1
                                            ? state.selectedLearnLanguageId
                                                .toString()
                                            : state
                                                .selectedLearnPopularLanguageId
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
                              widthValue: width(1.0),
                              heightValue: height(0.07),
                              backgroundColor:
                                  ColorConstant.instance.greyScale900,
                              borderRadius: 66.0,
                              text: LocaleKeys.next.tr(),
                              textStyle: currentTextTheme.headline3?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: ColorConstant
                                          .instance.additionalWhite) ??
                                  const TextStyle(),
                            ),
                          ),
                        ),
                      ],
                    )
              : skeletonLoading(context);
        },
      ),
    );
  }

  FutureBuilder<dynamic> futures() {
    return FutureBuilder(
      future: viewModel.getLanguages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return skeletonLoading(context);
        } else if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: languages(context),
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
                              email: widget.email,
                              password: widget.password,
                              name: widget.name,
                              nativeId: widget.nativeId,
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
                    widthValue: width(1.0),
                    heightValue: height(0.07),
                    backgroundColor: ColorConstant.instance.greyScale900,
                    borderRadius: 66.0,
                    text: LocaleKeys.next.tr(),
                    textStyle: currentTextTheme.headline3?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: ColorConstant.instance.additionalWhite) ??
                        const TextStyle(),
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Text('error');
        }
      },
    );
  }

  Padding skeletonLoading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: SkeletonParagraph(
                style: const SkeletonParagraphStyle(
                  lines: 1,
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: SkeletonParagraph(
                style: const SkeletonParagraphStyle(
                  lines: 2,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Align(
              alignment: Alignment.centerLeft,
              child: SkeletonParagraph(
                style: SkeletonParagraphStyle(
                  lines: 1,
                  lineStyle: SkeletonLineStyle(
                    width: width(0.2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: 12,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            const Expanded(
                              child: SkeletonAvatar(
                                style: SkeletonAvatarStyle(
                                  width: 35.0,
                                  height: 35.0,
                                  shape: BoxShape.rectangle,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              flex: 3,
                              child: SkeletonParagraph(
                                style: const SkeletonParagraphStyle(
                                  lines: 1,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Expanded(
                        child: SkeletonAvatar(
                          style: SkeletonAvatarStyle(
                            width: 35.0,
                            height: 35.0,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void filterSearchResults(String query) {
    List<Languages> dummySearchList = [];
    dummySearchList.addAll(viewModel.languages);

    if (query.isNotEmpty) {
      List<Languages> dummyListData = [];

      for (var i = 0; i < dummySearchList.length; i++) {
        if (dummySearchList[i].title!.toLowerCase().contains(
              query.toLowerCase(),
            )) {
          dummyListData.add(dummySearchList[i]);
        }

        setState(() {
          isPage = true;
          items.clear();
          items.addAll(dummyListData);
        });
      }
    } else {
      setState(() {
        isPage = true;
        items.clear();
      });
    }
  }

  Padding languages(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Consumer<LanguageViewModel>(
        builder: (context, state, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  LocaleKeys.great.tr(),
                  style: currentTextTheme.headline3?.copyWith(
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
                  style: currentTextTheme.headline1?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.instance.greyScale900,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20.0),
              AppFormField(
                autoFocus: true,
                onChanged: (_) {
                  filterSearchResults(viewModel.searchController.text);
                  state.selectedIndex = -1;
                  viewModel.selectedPopularIndex = -1;
                },
                controller: viewModel.searchController,
                focusNode: viewModel.searchFocusNode,
                isPrefix: true,
                prefixIconValue: const Icon(Icons.search, color: Colors.black),
                textAlign: TextAlign.left,
                hintText: LocaleKeys.search_language.tr(),
              ),
              const SizedBox(height: 20.0),
              Text(
                items.isNotEmpty
                    ? LocaleKeys.all_lang.tr()
                    : LocaleKeys.popular_lang.tr(),
                style: currentTextTheme.headline3?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: ColorConstant.instance.greyScale600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15.0),
              items.isNotEmpty
                  ? Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                LanguageButton(
                                  image: items[index].flag!,
                                  languageId: index + 1,
                                  selectedIndex: state.selectedLearnIndex,
                                  onTap: () {
                                    viewModel.selectedLearnLanguageId =
                                        items[index].id!;
                                    state.changeCheckboxLearnStatus(
                                        index: index);
                                    viewModel.selectedLearnIndex = index;
                                    viewModel.selectedLearnTitle =
                                        items[index].title!;
                                  },
                                  widthValue: width(1.0),
                                  heightValue: height(0.07),
                                  backgroundColor:
                                      ColorConstant.instance.additionalWhite,
                                  borderRadius: 66.0,
                                  text: items[index].title!,
                                  textStyle: currentTextTheme.headline3
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
                        ),
                        const SizedBox(height: 70.0),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: viewModel.popularLanguageIds.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                LanguageButton(
                                  image: viewModel.popularLanguageImages[index],
                                  languageId: index + 1,
                                  selectedIndex:
                                      state.selectedLearnPopularIndex,
                                  onTap: () {
                                    state.selectedLearnPopularLanguageId =
                                        viewModel.popularLanguageIds[index];
                                    state.changeCheckboxLearnStatusPopular(
                                        index: index);
                                    viewModel.selectedLearnPopularIndex = index;
                                    viewModel.selectedLearnTitlePopular =
                                        viewModel.popularLanguageTitles[index];
                                  },
                                  widthValue: width(1.0),
                                  heightValue: height(0.07),
                                  backgroundColor:
                                      ColorConstant.instance.additionalWhite,
                                  borderRadius: 66.0,
                                  text: viewModel.popularLanguageTitles[index],
                                  textStyle: currentTextTheme.headline3
                                          ?.copyWith(
                                              fontWeight: FontWeight.w400,
                                              color: ColorConstant
                                                  .instance.greyScale900) ??
                                      const TextStyle(),
                                  onChangedCheckBox: (_) {},
                                ),
                                SizedBox(
                                    height: viewModel
                                                .popularLanguageTitles[index] ==
                                            "Turkish"
                                        ? 0.0
                                        : 15.0),
                              ],
                            );
                          },
                        ),
                        Text(
                          LocaleKeys.all_lang.tr(),
                          style: currentTextTheme.headline3?.copyWith(
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
                            return Column(
                              children: [
                                LanguageButton(
                                  image: viewModel.languages[index].flag!,
                                  languageId: index + 1,
                                  selectedIndex: state.selectedLearnIndex,
                                  onTap: () {
                                    state.selectedLearnLanguageId =
                                        viewModel.languages[index].id!;
                                    state.changeCheckboxLearnStatus(
                                        index: index);
                                    viewModel.selectedLearnIndex = index;
                                    viewModel.selectedLearnTitle =
                                        viewModel.languages[index].title!;
                                  },
                                  widthValue: width(1.0),
                                  heightValue: height(0.07),
                                  backgroundColor:
                                      ColorConstant.instance.additionalWhite,
                                  borderRadius: 66.0,
                                  text: viewModel.languages[index].title!,
                                  textStyle: currentTextTheme.headline3
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
                        ),
                        const SizedBox(height: 70.0),
                      ],
                    )
            ],
          );
        },
      ),
    );
  }
}
