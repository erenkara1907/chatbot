// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, deprecated_member_use

import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/view/base/base_state.dart';
import 'package:chatbot/core/view/widget/button/app_button.dart';
import 'package:chatbot/product/auth/language/viewmodel/language_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/icon_constant.dart';
import '../../../../core/constants/image_constant.dart';
import '../../../../core/language/locale_keys.g.dart';

class LanguageLevelView extends StatefulWidget {
  final String email;
  final String password;
  final String name;
  final String languageCode;
  const LanguageLevelView({
    required this.email,
    required this.password,
    required this.name,
    required this.languageCode,
  });

  @override
  State<LanguageLevelView> createState() => _LanguageLevelViewState();
}

class _LanguageLevelViewState extends BaseState<LanguageLevelView>
    with TickerProviderStateMixin {
  LanguageViewModel viewModel = LanguageViewModel();

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat(reverse: true);

  @override
  Widget build(BuildContext context) {
    Provider.of<LanguageViewModel>(context, listen: false).setActiveLevelPage();
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
          languageLevel(),
        ],
      ),
    );
  }

  Consumer<LanguageViewModel> languageLevel() {
    return Consumer<LanguageViewModel>(
      builder: (context, state, child) {
        return AnimatedPadding(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 68.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      border:
                          Border.all(color: ColorConstant.instance.paletteGrey),
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
              const SizedBox(height: 35.0),
              Text(
                LocaleKeys.welcome_stranger.tr(),
                style: currentTextTheme.displayLarge?.copyWith(
                  color: const Color.fromRGBO(155, 150, 161, 1),
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                LocaleKeys.help_us.tr(),
                style: currentTextTheme.displaySmall?.copyWith(
                  color: ColorConstant.instance.additionalWhite,
                  fontWeight: FontWeight.w500,
                  fontSize: 22.0,
                ),
                textAlign: TextAlign.center,
              ),
              // Expanded(
              //   flex: 2,
              //   child: Image.asset(ImageConstant.instance.imageAI),
              // ),
              Expanded(
                flex: 5,
                  child: Image.asset("assets/images/image_circle_loop.gif")),
              Consumer<LanguageViewModel>(
                builder: (context, state, child) {
                  return SizedBox(
                    height: height(0.16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          state.sliderValue == 0
                              ? 'A1'
                              : state.sliderValue == 1
                                  ? "A2"
                                  : state.sliderValue == 2
                                      ? "B1"
                                      : state.sliderValue == 3
                                          ? "B2"
                                          : state.sliderValue == 4
                                              ? "C1"
                                              : "C2",
                          style: currentTextTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.instance.additionalWhite,
                            fontSize: 24.0,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Expanded(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: state.switchTextWidget(
                                state.sliderValue.toInt(),
                                context: context),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 10.0,
                  trackShape: const RoundedRectSliderTrackShape(),
                  activeTrackColor: ColorConstant.instance.greyScale700,
                  inactiveTrackColor: ColorConstant.instance.greyScale300,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 14.0,
                    pressedElevation: 8.0,
                  ),
                  thumbColor: const Color.fromRGBO(174, 175, 177, 0.6),
                  overlayColor: const Color.fromRGBO(174, 175, 177, 0.6),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 32.0),
                  tickMarkShape: const RoundSliderTickMarkShape(),
                  activeTickMarkColor: ColorConstant.instance.additionalWhite,
                  inactiveTickMarkColor: const Color.fromRGBO(32, 33, 35, 1),
                  valueIndicatorShape: const RoundSliderOverlayShape(),
                  valueIndicatorTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                child: Consumer<LanguageViewModel>(
                  builder: (context, state, child) {
                    return SizedBox(
                      width: double.maxFinite,
                      child: Slider(
                        inactiveColor: const Color.fromRGBO(32, 33, 35, 1),
                        activeColor: const Color.fromRGBO(32, 33, 35, 1),
                        thumbColor: const Color.fromRGBO(174, 175, 177, 0.6),
                        overlayColor: MaterialStateProperty.all(
                            const Color.fromRGBO(174, 175, 177, 0.6)),
                        divisions: 5,
                        max: 5,
                        label: state.sliderValue == 0
                            ? 'A1'
                            : state.sliderValue == 1
                                ? "A2"
                                : state.sliderValue == 2
                                    ? "B1"
                                    : state.sliderValue == 3
                                        ? "B2"
                                        : state.sliderValue == 4
                                            ? "C1"
                                            : "C2",
                        value: state.sliderValue,
                        onChanged: (value) => state.changeSliderValue(value),
                      ),
                    );
                  },
                ),
              ),
              AnimatedPadding(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(
                    horizontal: state.isActiveLevelPage ? 43.0 : 0.0),
                child: AppButton(
                  widthValue: width(1.0),
                  heightValue: height(0.07),
                  backgroundColor: const Color.fromRGBO(47, 67, 141, 0.5),
                  borderRadius: 66.0,
                  borderColor: ColorConstant.instance.paletteBlue,
                  text: LocaleKeys.next.tr(),
                  textStyle: currentTextTheme.displaySmall!.copyWith(
                    color: ColorConstant.instance.additionalWhite,
                    fontWeight: FontWeight.w400,
                  ),
                  onTap: () async {
                    await viewModel.register({
                      "email": widget.email,
                      "password": widget.password,
                      "name": widget.name,
                      "native_language_code": widget.languageCode,
                      // "learn_language_id": learnId.toString(),
                      "learn_language_proficiency_cefr":
                          state.learnLanguageProficiencyCefr,
                    }, context);
                  },
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        );
      },
    );
  }
}
