// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, use_build_context_synchronously

import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/extension/regex_extension.dart';
import 'package:chatbot/core/utils/page_transition.dart';
import 'package:chatbot/core/view/base/base_stateless.dart';
import 'package:chatbot/product/auth/forgot_password/view/email_view.dart';
import 'package:chatbot/product/auth/login/viewmodel/login_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/image_constant.dart';
import '../../../../core/language/locale_keys.g.dart';
import '../../../../core/view/widget/button/app_button.dart';
import '../../../../core/view/widget/formfield/app_form_field.dart';
import '../../register/view/register_view.dart';

class LoginView extends BaseStateless {
  LoginViewModel viewModel = LoginViewModel();
  FirebaseAnalytics analyticInstance = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    analyticInstance.logEvent(name: "opened_login_view");
    Provider.of<LoginViewModel>(context, listen: false).setActivePage();
    return GestureDetector(
      onTap: () => viewModel.startFocusNode(),
      child: Scaffold(
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
            loginForm(),
          ],
        ),
      ),
    );
  }

  Padding loginForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Consumer<LoginViewModel>(
        builder: (context, state, child) {
          return AnimatedPadding(
            duration: const Duration(milliseconds: 500),
            padding: EdgeInsets.only(top: state.isActivePage ? 0.0 : 80.0),
            curve: Curves.easeInOut,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(flex: 1, child: SizedBox()),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      LocaleKeys.sign_in.tr(),
                      style: currentTextTheme(context).displaySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: ColorConstant.instance.greyScale600,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      LocaleKeys.enter_information.tr(),
                      style: currentTextTheme(context).displayLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: ColorConstant.instance.additionalWhite,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20.0),
                    Form(
                      key: viewModel.loginFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppFormField(
                            validator: (_) {
                              if (viewModel.emailController.text.isEmpty) {
                                return LocaleKeys.email_blank_regex.tr();
                              } else if (!viewModel.emailController.text
                                  .isValidEmail()) {
                                return LocaleKeys.email_wrong_regex.tr();
                              }
                              return null;
                            },
                            isPrefix: false,
                            controller: viewModel.emailController,
                            focusNode: viewModel.emailFocusNode,
                          ),
                          const SizedBox(height: 3.0),
                          Consumer<LoginViewModel>(
                            builder: (context, state, child) {
                              return AppFormField(
                                isSuffix: true,
                                isObscure: state.isObscure,
                                suffixIconValue: IconButton(
                                  onPressed: () => state.changeObscureText(),
                                  icon: state.isObscure
                                      ? Icon(
                                          Icons.visibility_off,
                                          color: ColorConstant
                                              .instance.greyScale600,
                                        )
                                      : Icon(
                                          Icons.visibility,
                                          color: ColorConstant
                                              .instance.greyScale600,
                                        ),
                                ),
                                validator: (_) {
                                  if (viewModel
                                      .passwordController.text.isEmpty) {
                                    return LocaleKeys.password_blank_regex.tr();
                                  }
                                  return null;
                                },
                                isPrefix: false,
                                controller: viewModel.passwordController,
                                focusNode: viewModel.passwordFocusNode,
                                hintText: LocaleKeys.password.tr(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context, createRoute(page: EmailView()));
                          analyticInstance.logEvent(
                              name: "forgot_password_button");
                        },
                        overlayColor: MaterialStateProperty.all(
                            ColorConstant.instance.paletteBackground),
                        child: Text(
                          "I forgot my password",
                          style: currentTextTheme(context).bodyLarge?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: ColorConstant.instance.paletteBlue,
                                fontSize: 14.0,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 21.0),
                      child: AppButton(
                        onTap: () async {
                          analyticInstance.logEvent(
                              name: "clicked_login_button__login_view");
                          await viewModel.login({
                            'email': viewModel.emailController.text,
                            'password': viewModel.passwordController.text,
                          }, context);
                          analyticInstance.logEvent(name: "user_login");
                        },
                        widthValue: width(context: context, value: 1.0),
                        heightValue: height(context: context, value: 0.07),
                        backgroundColor: const Color.fromRGBO(47, 67, 141, 0.5),
                        borderRadius: 66.0,
                        borderColor: ColorConstant.instance.paletteBlue,
                        text: LocaleKeys.sign_in.tr(),
                        textStyle: currentTextTheme(context)
                                .displaySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: ColorConstant.instance.additionalWhite,
                                ) ??
                            const TextStyle(),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    InkWell(
                      onTap: () {
                        analyticInstance.logEvent(
                            name: "clicked_go_to_register");
                        Navigator.of(context)
                            .push(createRoute(page: RegisterView()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            LocaleKeys.dont_account.tr(),
                            style: currentTextTheme(context)
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: ColorConstant.instance.additionalWhite,
                                ),
                          ),
                          const SizedBox(width: 6.0),
                          Text(
                            LocaleKeys.sign_up.tr(),
                            style:
                                currentTextTheme(context).titleLarge?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: ColorConstant.instance.paletteBlue,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Expanded(flex: 3, child: SizedBox()),
              ],
            ),
          );
        },
      ),
    );
  }
}
