// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/constants/image_constant.dart';
import 'package:chatbot/core/extension/regex_extension.dart';
import 'package:chatbot/core/utils/page_transition.dart';
import 'package:chatbot/core/view/base/base_state.dart';
import 'package:chatbot/product/auth/register/viewmodel/register_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/language/locale_keys.g.dart';
import '../../../../core/view/widget/button/app_button.dart';
import '../../../../core/view/widget/formfield/app_form_field.dart';
import '../../language/view/native_language_view.dart';
import '../../login/view/login_view.dart';

class RegisterView extends StatefulWidget {
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends BaseState<RegisterView> {
  RegisterViewModel viewModel = RegisterViewModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<RegisterViewModel>(context, listen: false).setActivePage();
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
            registerForm(),
          ],
        ),
      ),
    );
  }

  Padding registerForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Consumer<RegisterViewModel>(
        builder: (context, state, child) {
          return AnimatedPadding(
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 500),
            padding: EdgeInsets.only(top: state.isActivePage ? 0.0 : 80.0),
            child: Column(
              children: [
                const Expanded(flex: 1, child: SizedBox()),
                Column(
                  children: [
                    Text(
                      LocaleKeys.sign_up.tr(),
                      style: currentTextTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: ColorConstant.instance.greyScale600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      LocaleKeys.enter_information.tr(),
                      style: currentTextTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: ColorConstant.instance.additionalWhite,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Form(
                  key: viewModel.registerFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppFormField(
                        hintText: LocaleKeys.name.tr(),
                        validator: (_) {
                          if (viewModel.nameController.text.isEmpty) {
                            return LocaleKeys.name_blank_regex.tr();
                          }
                          return null;
                        },
                        isPrefix: false,
                        controller: viewModel.nameController,
                        focusNode: viewModel.nameFocusNode,
                      ),
                      const SizedBox(height: 3.0),
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
                      Consumer<RegisterViewModel>(
                        builder: (context, state, child) {
                          return AppFormField(
                            isSuffix: true,
                            isObscure: state.isObscure,
                            suffixIconValue: IconButton(
                              onPressed: () => state.changeObscureText(),
                              icon: state.isObscure
                                  ? Icon(
                                      Icons.visibility_off,
                                      color:
                                          ColorConstant.instance.greyScale600,
                                    )
                                  : Icon(
                                      Icons.visibility,
                                      color:
                                          ColorConstant.instance.greyScale600,
                                    ),
                            ),
                            validator: (_) {
                              if (viewModel.passwordController.text.isEmpty) {
                                return LocaleKeys.password_blank_regex.tr();
                              } else if (viewModel
                                      .passwordController.text.length <
                                  6) {
                                return 'Password must be at least 6 digits';
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
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21.0),
                  child: Column(
                    children: [
                      AppButton(
                        onTap: () {
                          if (viewModel.registerFormKey.currentState!
                              .validate()) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                createRoute(
                                    page: NativeLanguageView(
                                  name: viewModel.nameController.text,
                                  email: viewModel.emailController.text,
                                  password: viewModel.passwordController.text,
                                )),
                                (route) => false);
                          }
                        },
                        widthValue: width(1.0),
                        heightValue: height(0.07),
                        backgroundColor: const Color.fromRGBO(47, 67, 141, 0.5),
                        borderRadius: 66.0,
                        borderColor: ColorConstant.instance.paletteBlue,
                        text: LocaleKeys.sign_up.tr(),
                        textStyle: currentTextTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: ColorConstant.instance.additionalWhite,
                            ) ??
                            const TextStyle(),
                      ),
                      const SizedBox(height: 8.0),
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(createRoute(page: LoginView()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              LocaleKeys.already_account.tr(),
                              style: currentTextTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: ColorConstant.instance.additionalWhite,
                              ),
                            ),
                            const SizedBox(width: 6.0),
                            Text(
                              LocaleKeys.sign_in.tr(),
                              style: currentTextTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: ColorConstant.instance.paletteBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(flex: 2, child: SizedBox()),
              ],
            ),
          );
        },
      ),
    );
  }
}
