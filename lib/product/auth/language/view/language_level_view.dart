// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/view/base/base_state.dart';
import 'package:chatbot/core/view/widget/button/app_button.dart';
import 'package:chatbot/product/auth/language/viewmodel/language_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      backgroundColor: ColorConstant.instance.additionalWhite,
      body: Consumer<LanguageViewModel>(
        builder: (context, state, child) {
          return AnimatedPadding(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: state.isActiveLevelPage ? 44.0 : 0.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(child: SizedBox()),
                AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, 30 * _controller.value),
                        child: Center(
                          child: Image.network(
                            "https://cdn.icon-icons.com/icons2/1371/PNG/512/robot02_90810.png",
                            width: 150.0,
                            height: 150.0,
                          ),
                        ),
                      );
                    }),
                const SizedBox(height: 20.0),
                Text(
                  LocaleKeys.welcome_stranger.tr(),
                  style: currentTextTheme.headline1?.copyWith(
                    color: ColorConstant.instance.greyScale900,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(LocaleKeys.help_us.tr(),
                    style: currentTextTheme.headline3?.copyWith(
                      color: ColorConstant.instance.greyScale900,
                    ),
                    textAlign: TextAlign.center),
                const Expanded(flex: 2, child: SizedBox()),
                Consumer<LanguageViewModel>(
                  builder: (context, state, child) {
                    return SizedBox(
                      height: height(0.25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
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
                              style: currentTextTheme.headline1?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstant.instance.greyScale900),
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Expanded(
                            flex: 3,
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
                    thumbColor: ColorConstant.instance.greyScale900,
                    overlayColor:
                        ColorConstant.instance.greyScale800.withOpacity(0.2),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 32.0),
                    tickMarkShape: const RoundSliderTickMarkShape(),
                    activeTickMarkColor: ColorConstant.instance.additionalWhite,
                    inactiveTickMarkColor: Colors.white,
                    valueIndicatorShape: const RoundSliderOverlayShape(),
                    valueIndicatorColor: Colors.black,
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
                const Expanded(child: SizedBox()),
                AnimatedPadding(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(
                      horizontal: state.isActiveLevelPage ? 16.0 : 0.0),
                  child: AppButton(
                    widthValue: width(1.0),
                    heightValue: height(0.07),
                    backgroundColor: ColorConstant.instance.greyScale900,
                    borderRadius: 66.0,
                    text: LocaleKeys.next.tr(),
                    textStyle: currentTextTheme.headline3!.copyWith(
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
              ],
            ),
          );
        },
      ),
    );
  }
}
