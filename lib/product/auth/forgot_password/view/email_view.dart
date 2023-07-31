// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/view/base/base_stateless.dart';
import 'package:chatbot/core/view/widget/button/app_button.dart';
import 'package:chatbot/core/view/widget/formfield/app_form_field.dart';
import 'package:chatbot/product/auth/forgot_password/viewmodel/forgot_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../core/constants/icon_constant.dart';
import '../../../../core/constants/image_constant.dart';

class EmailView extends BaseStateless {
  ForgotPasswordViewModel viewModel = ForgotPasswordViewModel();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        viewModel.emailFocusNode.unfocus();
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
                  children: [
                    const SizedBox(height: 50.0),
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
                    const Expanded(child: SizedBox()),
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
                      "Please enter your e-mail address",
                      style: currentTextTheme(context).displayLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: ColorConstant.instance.additionalWhite,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20.0),
                    AppFormField(
                      controller: viewModel.emailController,
                      focusNode: viewModel.emailFocusNode,
                      isPrefix: false,
                    ),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: AppButton(
                        onTap: () {
                          if (viewModel.emailController.text.isNotEmpty) {
                            // some code
                            viewModel.forgotPasswordAPI(
                                viewModel.emailController.text, context);
                          } else {
                            showTopSnackBar(
                              Overlay.of(context),
                              const CustomSnackBar.error(
                                message: "Please enter your email",
                              ),
                            );
                          }
                        },
                        widthValue: width(context: context, value: 1.0),
                        heightValue: height(context: context, value: 0.07),
                        backgroundColor: const Color.fromRGBO(47, 67, 141, 0.5),
                        borderRadius: 66.0,
                        text: "Send Mail",
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
                    const Expanded(flex: 2, child: SizedBox()),
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
