// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/view/base/base_stateless.dart';
import 'package:chatbot/product/auth/forgot_password/viewmodel/forgot_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../core/constants/image_constant.dart';
import '../../../../core/view/widget/button/app_button.dart';
import '../../../../core/view/widget/formfield/app_form_field.dart';

class PasswordView extends BaseStateless {
  ForgotPasswordViewModel viewModel = ForgotPasswordViewModel();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        viewModel.passwordFocusNode.unfocus();
        viewModel.rePasswordFocusNode.unfocus();
      },
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
            SizedBox(
              width: width(context: context, value: 1.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Password Reset",
                      style: currentTextTheme(context).displaySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: ColorConstant.instance.greyScale600,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      "Please enter your new password",
                      style: currentTextTheme(context).displayLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: ColorConstant.instance.additionalWhite,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20.0),
                    Selector<ForgotPasswordViewModel, bool>(
                      builder: (context, isObscure, child) {
                        return AppFormField(
                          controller: viewModel.passwordController,
                          focusNode: viewModel.passwordFocusNode,
                          isPrefix: false,
                          isSuffix: true,
                          isObscure: isObscure,
                          suffixIconValue: IconButton(
                            onPressed: () =>
                                Provider.of<ForgotPasswordViewModel>(context,
                                        listen: false)
                                    .changeObscureText(),
                            icon: isObscure
                                ? Icon(
                                    Icons.visibility_off,
                                    color: ColorConstant.instance.greyScale600,
                                  )
                                : Icon(
                                    Icons.visibility,
                                    color: ColorConstant.instance.greyScale600,
                                  ),
                          ),
                          hintText: 'Password',
                        );
                      },
                      selector: (context, state) => state.isObscure,
                    ),
                    const SizedBox(height: 5.0),
                    Selector<ForgotPasswordViewModel, bool>(
                      builder: (context, isReObscure, child) {
                        return AppFormField(
                          controller: viewModel.rePasswordController,
                          focusNode: viewModel.rePasswordFocusNode,
                          isPrefix: false,
                          isSuffix: true,
                          isObscure: isReObscure,
                          suffixIconValue: IconButton(
                            onPressed: () =>
                                Provider.of<ForgotPasswordViewModel>(context,
                                        listen: false)
                                    .changeReObscureText(),
                            icon: isReObscure
                                ? Icon(
                                    Icons.visibility_off,
                                    color: ColorConstant.instance.greyScale600,
                                  )
                                : Icon(
                                    Icons.visibility,
                                    color: ColorConstant.instance.greyScale600,
                                  ),
                          ),
                          hintText: 'Confirm Password',
                        );
                      },
                      selector: (context, state) => state.isReObscure,
                    ),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: AppButton(
                        onTap: () {
                          if (viewModel.passwordController.text.isNotEmpty &&
                              viewModel.passwordController.text ==
                                  viewModel.rePasswordController.text) {
                            viewModel.resetPasswordAPI(
                              viewModel.passwordController.text,
                              context,
                            );
                          } else if (viewModel
                              .passwordController.text.isEmpty) {
                            showTopSnackBar(
                              Overlay.of(context),
                              const CustomSnackBar.error(
                                message: "Please enter your password",
                              ),
                              displayDuration:
                                  const Duration(milliseconds: 100),
                            );
                          } else {
                            showTopSnackBar(
                              Overlay.of(context),
                              const CustomSnackBar.error(
                                message: "Passwords entered do not match",
                              ),
                              displayDuration:
                                  const Duration(milliseconds: 100),
                            );
                          }
                        },
                        widthValue: width(context: context, value: 1.0),
                        heightValue: height(context: context, value: 0.07),
                        backgroundColor: const Color.fromRGBO(47, 67, 141, 0.5),
                        borderRadius: 66.0,
                        text: "Reset Password",
                        textStyle: currentTextTheme(context)
                                .displaySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: ColorConstant.instance.additionalWhite,
                                ) ??
                            const TextStyle(),
                        borderColor: ColorConstant.instance.paletteBlue,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
