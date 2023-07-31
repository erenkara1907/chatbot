// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/view/base/base_stateless.dart';
import 'package:chatbot/product/auth/forgot_password/viewmodel/forgot_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_view/pin_code_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/icon_constant.dart';
import '../../../../core/constants/image_constant.dart';
import '../../../../core/enum/preference_keys.dart';

class PinCodeView extends BaseStateless {
  ForgotPasswordViewModel viewModel = ForgotPasswordViewModel();
  @override
  Widget build(BuildContext context) {
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
              width: width(context: context, value: 1.0),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Image.asset(
              ImageConstant.instance.imageBottomEllipse,
              width: width(context: context, value: 1.0),
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 50.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
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
                    TextButton(
                      onPressed: () async {
                        final Future<SharedPreferences> _prefs =
                            SharedPreferences.getInstance();
                        final SharedPreferences prefs = await _prefs;

                        String email =
                            prefs.getString(PreferencesKeys.EMAIL.toString())!;
                        viewModel.forgotPasswordAPI(email, context,
                            isPinView: true);
                      },
                      child: Text(
                        "Send mail again",
                        style: currentTextTheme(context).bodyLarge?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: ColorConstant.instance.paletteBlue,
                              fontSize: 16.0,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PinCode(
                  backgroundColor: Colors.transparent,
                  title: "Password Reset",
                  titleTextStyle:
                      currentTextTheme(context).displaySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: ColorConstant.instance.greyScale600,
                          ),
                  subtitleTextStyle:
                      currentTextTheme(context).displayLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: ColorConstant.instance.additionalWhite,
                          ),
                  subtitle: "Please enter PIN code",
                  onChange: (String code) {
                    if (code.length == 6) {
                      viewModel.verifyResetTokenAPI(code, context);
                    }
                  },
                  obscurePin: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
