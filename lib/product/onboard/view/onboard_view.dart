// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/constants/image_constant.dart';
import 'package:chatbot/core/language/locale_keys.g.dart';
import 'package:chatbot/core/view/base/base_stateless.dart';
import 'package:chatbot/product/auth/register/view/register_view.dart';
import 'package:chatbot/product/onboard/viewmodel/onboard_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OnboardView extends BaseStateless {
  OnboardViewModel viewModel = OnboardViewModel();
  @override
  Widget build(BuildContext context) {
    return onboardView(context);
  }

  Scaffold onboardView(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.instance.greyScale300,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image.asset(ImageConstant.instance.robot),
          Expanded(
            flex: 2,
            child: Container(
              width: width(context: context, value: 1.0),
              height: height(context: context, value: 0.7),
              decoration: BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                    image: AssetImage(ImageConstant.instance.robot),
                    fit: BoxFit.cover),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 80.0),
                      child: Chip(
                        label: Text(
                          LocaleKeys.hi.tr(),
                          style: currentTextTheme(context).headline4?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(0, 0, 0, 1),
                              ),
                        ),
                        backgroundColor: Colors.white24,
                        side: const BorderSide(width: 1.0, color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 95.0),
                      child: Chip(
                        label: Text(
                          LocaleKeys.my_name.tr(),
                          style: currentTextTheme(context).headline4?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(0, 0, 0, 1),
                              ),
                        ),
                        backgroundColor: Colors.white24,
                        side: const BorderSide(width: 1.0, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  LocaleKeys.welcome.tr(),
                  style: currentTextTheme(context).headline2?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: ColorConstant.instance.greyScale600,
                      ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  LocaleKeys.welcome_description.tr(),
                  style: currentTextTheme(context).headline2?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 26.0,
                        color: ColorConstant.instance.greyScale900,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24.0),
                SizedBox(
                  width: width(context: context, value: 1.0) - 132.0,
                  height: height(context: context, value: 0.07),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterView()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.instance.greyScale400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(66.0),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      LocaleKeys.welcome_button.tr(),
                      style: currentTextTheme(context).headline3?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: ColorConstant.instance.greyScale900,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
