// ignore_for_file: use_key_in_widget_constructors

import 'package:chatbot/core/view/base/base_stateless.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../constants/color_constant.dart';
import '../../../language/locale_keys.g.dart';

class AppFormField extends BaseStateless {
  final double? widthValue;
  final double? heightValue;
  final TextEditingController controller;
  final String? hintText;
  final FocusNode focusNode;
  final TextAlign? textAlign;
  final Widget? prefixIconValue;
  final void Function(String)? onChanged;
  final bool isPrefix;
  final String? Function(String?)? validator;
  final Widget? suffixIconValue;
  final bool isSuffix;
  final bool isObscure;
  final bool enabled;
  final bool autoFocus;

  AppFormField({
    this.widthValue,
    this.heightValue,
    required this.controller,
    this.hintText,
    required this.focusNode,
    this.textAlign,
    this.prefixIconValue,
    this.onChanged,
    required this.isPrefix,
    this.validator,
    this.suffixIconValue,
    this.isSuffix = false,
    this.isObscure = false,
    this.enabled = false,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widthValue ?? width(context: context, value: 1.0),
      height: heightValue ?? height(context: context, value: 0.08),
      child: TextFormField(
        readOnly: enabled,
        autofocus: autoFocus,
        obscureText: isObscure,
        validator: validator ??
            (_) {
              return null;
            },
        onChanged: onChanged ?? (_) {},
        focusNode: focusNode,
        controller: controller,
        textAlign: textAlign ?? TextAlign.center,
        style: currentTextTheme(context).headline3?.copyWith(
              fontWeight: FontWeight.w400,
              color: ColorConstant.instance.additionalWhite,
            ),
        cursorColor: ColorConstant.instance.additionalWhite,
        decoration: isPrefix || isSuffix
            ? InputDecoration(
                prefixIcon: prefixIconValue ?? const SizedBox(),
                suffixIcon: suffixIconValue ?? const SizedBox(),
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                hintText: hintText ?? LocaleKeys.email.tr(),
                hintStyle: currentTextTheme(context).headline3?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: ColorConstant.instance.greyScale400,
                    ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    66.0,
                  ),
                  borderSide: BorderSide(
                    width: 1.0,
                    color: ColorConstant.instance.greyScale400,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    66.0,
                  ),
                  borderSide: BorderSide(
                    width: 1.0,
                    color: ColorConstant.instance.greyScale400,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    66.0,
                  ),
                  borderSide: BorderSide(
                    width: 1.0,
                    color: ColorConstant.instance.additionalRed,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    66.0,
                  ),
                  borderSide: BorderSide(
                    width: 1.0,
                    color: ColorConstant.instance.additionalRed,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    66.0,
                  ),
                  borderSide: BorderSide(
                    width: 1.0,
                    color: ColorConstant.instance.additionalRed,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    66.0,
                  ),
                  borderSide: BorderSide(
                    width: 1.0,
                    color: ColorConstant.instance.additionalRed,
                  ),
                ),
              )
            : InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                hintText: hintText ?? LocaleKeys.email.tr(),
                hintStyle: currentTextTheme(context).headline3?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: ColorConstant.instance.greyScale400,
                    ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    66.0,
                  ),
                  borderSide: BorderSide(
                    width: 1.0,
                    color: ColorConstant.instance.greyScale400,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    66.0,
                  ),
                  borderSide: BorderSide(
                    width: 1.0,
                    color: ColorConstant.instance.greyScale400,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    66.0,
                  ),
                  borderSide: BorderSide(
                    width: 1.0,
                    color: ColorConstant.instance.additionalRed,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    66.0,
                  ),
                  borderSide: BorderSide(
                    width: 1.0,
                    color: ColorConstant.instance.additionalRed,
                  ),
                ),
              ),
      ),
    );
  }
}
