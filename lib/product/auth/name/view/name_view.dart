// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/language/locale_keys.g.dart';
import 'package:chatbot/core/view/base/base_stateless.dart';
import 'package:chatbot/core/view/widget/button/app_button.dart';
import 'package:chatbot/core/view/widget/formfield/app_form_field.dart';
import 'package:chatbot/product/auth/language/view/native_language_view.dart';
import 'package:chatbot/product/auth/name/viewmodel/name_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NameView extends BaseStateless {
  NameViewModel viewModel = NameViewModel();

  final String email;
  final String password;

  NameView({
    required this.email,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => viewModel.startFocusNode(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 40.0,
          leadingWidth: 50.0,
          titleSpacing: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: ColorConstant.instance.greyScale100),
              child: Center(
                child: IconButton(
                  padding: const EdgeInsets.all(0.0),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: ColorConstant.instance.greyScale900,
                    size: 20.0,
                  ),
                ),
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: ColorConstant.instance.additionalWhite,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 68.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      LocaleKeys.my_name.tr(),
                      style: currentTextTheme(context).headline3?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: ColorConstant.instance.greyScale600,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      LocaleKeys.what_name.tr(),
                      style: currentTextTheme(context).headline1?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: ColorConstant.instance.greyScale900,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20.0),
                    Form(
                      key: viewModel.nameFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppFormField(
                            validator: (_) {
                              if (viewModel.nameController.text.isEmpty) {
                                return LocaleKeys.name_blank_regex.tr();
                              }
                              return null;
                            },
                            isPrefix: false,
                            controller: viewModel.nameController,
                            focusNode: viewModel.nameFocusNode,
                            hintText: LocaleKeys.name.tr(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21.0),
                  child: AppButton(
                    onTap: () {
                      if (viewModel.nameFormKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NativeLanguageView(
                              email: email,
                              password: password,
                              name: viewModel.nameController.text,
                            ),
                          ),
                        );
                      }
                    },
                    widthValue: width(context: context, value: 1.0),
                    heightValue: height(context: context, value: 0.07),
                    backgroundColor: ColorConstant.instance.greyScale900,
                    borderRadius: 66.0,
                    text: LocaleKeys.sign_up.tr(),
                    textStyle: currentTextTheme(context).headline3?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: ColorConstant.instance.additionalWhite,
                            ) ??
                        const TextStyle(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
