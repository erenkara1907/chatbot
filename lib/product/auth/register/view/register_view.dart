// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'dart:ui';

import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/constants/image_constant.dart';
import 'package:chatbot/core/extension/regex_extension.dart';
import 'package:chatbot/core/utils/page_transition.dart';
import 'package:chatbot/core/view/base/base_state.dart';
import 'package:chatbot/product/auth/register/viewmodel/register_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/language/locale_keys.g.dart';
import '../../../../core/view/widget/button/app_button.dart';
import '../../../../core/view/widget/formfield/app_form_field.dart';
import '../../login/view/login_view.dart';

class RegisterView extends StatefulWidget {
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends BaseState<RegisterView> {
  RegisterViewModel viewModel = RegisterViewModel();
  FirebaseAnalytics analyticInstance = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    analyticInstance.logEvent(name: "opened_register_view");
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
                      InkWell(
                        onTap: () {
                          analyticInstance.logEvent(name: "clicked_name_textfield_in_register_view");
                        },
                        child: AppFormField(
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
                      ),
                      const SizedBox(height: 3.0),
                      InkWell(
                        onTap: () {
                          analyticInstance.logEvent(name: "clicked_email_textfield_in_register_view");
                        },
                        child: AppFormField(
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
                      ),
                      const SizedBox(height: 3.0),
                      Consumer<RegisterViewModel>(
                        builder: (context, state, child) {
                          return InkWell(
                            onTap: () {
                              analyticInstance.logEvent(name: "clicked_password_textfield_in_register_view");
                            },
                            child: AppFormField(
                              heightValue: height(0.06),
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
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    Consumer<RegisterViewModel>(
                      builder: (context, state, child) {
                        return Checkbox(
                          activeColor: ColorConstant.instance.additionalWhite,
                          checkColor: ColorConstant.instance.paletteBackground,
                          shape: const CircleBorder(),
                          side: BorderSide(
                            color: state.errorTerms
                                ? ColorConstant.instance.additionalRed
                                : ColorConstant.instance.paletteGrey,
                          ),
                          value: state.termsValue,
                          onChanged: (value) {
                            analyticInstance.logEvent(name: "clicked_terms_checkbox_in_register_view");
                            state.checkTermsValue(value!);
                            state.checkErrorTerms(false);
                          },
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                        );
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        analyticInstance.logEvent(name: "clicked_terms_modal_in_register_view");
                        showModalBottomSheet(
                          isDismissible: true,
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return DraggableScrollableSheet(
                              expand: false,
                              initialChildSize: 0.8,
                              builder: (BuildContext context,
                                  ScrollController scrollController) {
                                return BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 10.0,
                                    sigmaY: 10.0,
                                  ),
                                  child: Container(
                                    height: height(0.8),
                                    width: width(1.0),
                                    decoration: BoxDecoration(
                                      color: ColorConstant
                                          .instance.paletteBackground,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20.0),
                                        topRight: Radius.circular(20.0),
                                      ),
                                    ),
                                    child: SingleChildScrollView(
                                      controller: scrollController,
                                      physics: const ClampingScrollPhysics(),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24.0,
                                          vertical: 24.0,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 4.0,
                                              width: 50.0,
                                              decoration: BoxDecoration(
                                                color: ColorConstant
                                                    .instance.additionalWhite,
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                            ),
                                            const SizedBox(height: 35.0),
                                            Text(
                                              "Talkios Privacy Policy \nThis Privacy Policy applies to the collection, use, disclosure, and protection of personal data of users ('Users') of the Talkios application ('Application'). By using the Application, you accept this Privacy Policy. \n \nCollected Information \nThe Application may collect users' personal information such as voice recordings, chat history, username, email address, and performance data, including usage statistics.\n \nUse of Information \nThe collected information may be used for the following purposes: \n\n \na. Improving user experience \nb. Providing and enhancing the service \nc. Providing support to users \nd. Complying with legal obligations \n\n \nSharing of Information \nTalkios does not share user data with third parties, except when required by a legal request or necessary to protect the rights, safety, or property of users.\n \nSecurity \nTalkios takes appropriate technical and organizational measures to ensure the security of user data. However, please note that no transmission over the internet can be guaranteed as completely secure.\n \nChildren \nThe Application is not intended for use by individuals under the age of 13, and it does not knowingly collect personal information from this age group.\n \nChanges \nTalkios reserves the right to update this Privacy Policy from time to time. When changes are made, we will update the 'Last Updated' date at the top of this page.\n \nContact \nIf you have any questions or comments, please email [info@ron.digital].\n \nLast Updated: [03.07.2023]\n \nUser Rights\n \nUsers have the right to access, correct, delete, or restrict the processing of their collected personal data. Users also have the right to object to data processing. These rights are subject to applicable data protection laws.\n \nThird-Party Services\n \nTalkios may integrate third-party services within the application. The privacy practices of these third-party services are not covered by this agreement, and users are encouraged to review the privacy policies of these services.\n \nCookies and Similar Technologies\n \nThe Application may use cookies and similar technologies to enhance the user experience, perform statistical analysis, and personalize services. Users can manage these features through their device settings.\n \nOpt-Out and Account Deletion\n \nUsers can refuse the processing of their personal data or delete their Talkios accounts at any time. In the case of account deletion, user data may be retained for the appropriate legal period.\n \nInternational Data Transfers\n \nTalkios may store and process data on servers located in different jurisdictions. By using the Application, users consent to the processing and transfer of their data outside their jurisdiction.\n \nLaw and Jurisdiction\n \nThis Privacy Policy is governed by the laws of [Applicable Country/Jurisdiction], and users accept the jurisdiction of the [Applicable Country/Jurisdiction] courts.\n \nOn behalf of Talkios, \n[Ron Digital] \n[23 Nisan Mah, 242. Sok, Ata Bulvarı No:17 Guzell Tower İş Merkezi, 16230 Nilüfer/Bursa/Turkey] \n[info@ron.digital]",
                                              style: currentTextTheme.bodyLarge
                                                  ?.copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: ColorConstant
                                                    .instance.additionalWhite,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Provider.of<RegisterViewModel>(
                                                        context,
                                                        listen: false)
                                                    .checkTermsValue(true);
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                  "Accept The User Privacy Agreement"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Text(
                        "User Privacy Agreement",
                        style: currentTextTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: ColorConstant.instance.paletteBlue,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21.0),
                  child: Column(
                    children: [
                      AppButton(
                        onTap: () {
                          analyticInstance.logEvent(name: "clicked_register_button_in_register_view");
                          var checkValue = Provider.of<RegisterViewModel>(
                                  context,
                                  listen: false)
                              .termsValue;
                          if (viewModel.registerFormKey.currentState!
                                  .validate() &&
                              checkValue) {
                            viewModel.register(
                              {
                                "email": viewModel.emailController.text,
                                "name": viewModel.nameController.text,
                                "password": viewModel.passwordController.text,
                              },
                              context,
                            );
                          } else {
                            Provider.of<RegisterViewModel>(context,
                                    listen: false)
                                .checkErrorTerms(true);
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
                          analyticInstance.logEvent(name: "clicked_go_to_login");
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
