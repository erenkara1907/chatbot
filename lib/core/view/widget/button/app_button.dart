// ignore_for_file: use_key_in_widget_constructors

import 'package:chatbot/core/view/base/base_stateless.dart';
import 'package:flutter/material.dart';

class AppButton extends BaseStateless {
  final double widthValue;
  final double heightValue;
  final Color backgroundColor;
  final double borderRadius;
  final String text;
  final TextStyle textStyle;
  final void Function()? onTap;
  AppButton({
    required this.widthValue,
    required this.heightValue,
    required this.backgroundColor,
    required this.borderRadius,
    required this.text,
    required this.textStyle,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widthValue,
      height: heightValue,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: onTap ?? () {},
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}
