// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, deprecated_member_use

import 'package:auto_animated/auto_animated.dart';
import 'package:chatbot/core/utils/page_transition.dart';
import 'package:chatbot/core/view/base/base_state.dart';
import 'package:chatbot/product/auth/language/viewmodel/language_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/color_constant.dart';
import '../../../../core/constants/icon_constant.dart';
import '../../../../core/constants/image_constant.dart';
import '../../../../core/language/locale_keys.g.dart';
import '../../../../core/view/widget/button/app_button.dart';
import '../../../../core/view/widget/button/language_button.dart';
import 'language_level_view.dart';

class NativeLanguageView extends StatefulWidget {
  final String email;
  final String password;
  final String name;

  const NativeLanguageView({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  State<NativeLanguageView> createState() => _NativeLanguageViewState();
}

class _NativeLanguageViewState extends BaseState<NativeLanguageView> {
  LanguageViewModel viewModel = LanguageViewModel();

  @override
  Widget build(BuildContext context) {
    Provider.of<LanguageViewModel>(context, listen: false).setActivePage();
    return Scaffold(
      backgroundColor: ColorConstant.instance.paletteBackground,
      body: Stack(
        children: [
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: Image.asset(
              ImageConstant.instance.imageTopEllipse,
              width: width(1.0),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Image.asset(
              ImageConstant.instance.imageBottomEllipse,
              width: width(1.0),
              fit: BoxFit.cover,
            ),
          ),
          language(),
        ],
      ),
    );
  }

  Consumer<LanguageViewModel> language() {
    return Consumer<LanguageViewModel>(
      builder: (context, state, child) {
        return Stack(
          children: [
            SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: languages(context),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              bottom: state.isActivePage ? 40.0 : 0.0,
              right: 0.0,
              left: 0.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80.0),
                child: AppButton(
                  onTap: () {
                    if (state.selectedLanguageId != -1) {
                      Navigator.of(context).push(createRoute(
                        page: LanguageLevelView(
                          email: widget.email,
                          password: widget.password,
                          name: widget.name,
                          languageCode: state.selectedLanguageCode,
                        ),
                      ));
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
                  backgroundColor: const Color.fromRGBO(47, 67, 141, 0.6),
                  borderRadius: 66.0,
                  borderColor: ColorConstant.instance.paletteBlue,
                  text: LocaleKeys.next.tr(),
                  textStyle: currentTextTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: ColorConstant.instance.additionalWhite) ??
                      const TextStyle(),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget Function(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) animationItemBuilder(
    Widget Function(int index) child, {
    EdgeInsets padding = EdgeInsets.zero,
  }) =>
      (
        BuildContext context,
        int index,
        Animation<double> animation,
      ) =>
          FadeTransition(
            opacity: Tween<double>(
              begin: 0,
              end: 1,
            ).animate(animation),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -0.1),
                end: Offset.zero,
              ).animate(animation),
              child: Padding(
                padding: padding,
                child: child(index),
              ),
            ),
          );

  Padding languages(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Consumer<LanguageViewModel>(
        builder: (context, state, child) {
          return Padding(
            padding: const EdgeInsets.only(top: 68.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 25.0,
                      height: 25.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(
                            color: ColorConstant.instance.paletteGrey),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          IconConstant.instance.iconArrowBack,
                          color: ColorConstant.instance.paletteGrey,
                          width: 10.0,
                          height: 10.0,
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedAlign(
                  duration: const Duration(milliseconds: 500),
                  alignment: state.isActivePage
                      ? Alignment.center
                      : Alignment.centerLeft,
                  child: Text(
                    LocaleKeys.can_answer.tr(),
                    style: currentTextTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(155, 150, 161, 1),
                    ),
                  ),
                ),
                const SizedBox(height: 4.0),
                AnimatedAlign(
                  duration: const Duration(milliseconds: 500),
                  alignment: state.isActivePage
                      ? Alignment.center
                      : Alignment.centerLeft,
                  child: Text(
                    LocaleKeys.what_native.tr(),
                    style: currentTextTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.0,
                      color: ColorConstant.instance.additionalWhite,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40.0),
                Text(
                  LocaleKeys.all_lang.tr(),
                  style: currentTextTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.instance.additionalWhite,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15.0),
                LiveList(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: animationItemBuilder((index) {
                    return Column(
                      children: [
                        LanguageButton(
                          image: viewModel.languages[index].flag!,
                          languageId: index + 1,
                          selectedIndex: state.selectedIndex,
                          onTap: () {
                            state.selectedLanguageId =
                                viewModel.languages[index].id!;

                            state.selectedLanguageCode =
                                viewModel.languages[index].code!;

                            state.changeCheckboxStatus(index: index);
                            viewModel.selectedIndex = index;
                          },
                          widthValue: width(1.0),
                          heightValue: height(0.07),
                          backgroundColor: Colors.transparent,
                          borderRadius: 66.0,
                          text: viewModel.languages[index].title!,
                          textStyle: currentTextTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: ColorConstant.instance.greyScale900) ??
                              const TextStyle(),
                          onChangedCheckBox: (value) {
                            state.selectedLanguageId =
                                viewModel.languages[index].id!;

                            state.selectedLanguageCode =
                                viewModel.languages[index].code!;

                            state.changeCheckboxStatus(index: index);
                            viewModel.selectedIndex = index;
                          },
                        ),
                        const SizedBox(height: 15.0),
                      ],
                    );
                  }),
                  itemCount: viewModel.languages.length,
                ),
                const SizedBox(height: 95.0),
              ],
            ),
          );
        },
      ),
    );
  }
}
