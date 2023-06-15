// ignore_for_file: use_key_in_widget_constructors

import 'package:chatbot/core/view/base/base_stateless.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/color_constant.dart';

class LanguageButton extends BaseStateless {
  final double widthValue;
  final double heightValue;
  final Color backgroundColor;
  final double borderRadius;
  final String text;
  final TextStyle textStyle;
  final void Function()? onTap;
  final String image;
  final void Function(bool?)? onChangedCheckBox;
  final int selectedIndex;
  final int languageId;

  LanguageButton({
    required this.widthValue,
    required this.heightValue,
    required this.backgroundColor,
    required this.borderRadius,
    required this.text,
    required this.textStyle,
    required this.selectedIndex,
    required this.languageId,
    required this.image,
    this.onTap,
    this.onChangedCheckBox,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widthValue,
      height: heightValue,
      child: ElevatedButton(
        onPressed: onTap ?? () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(
              width: 1.0,
              color: selectedIndex == languageId - 1
                  ? ColorConstant.instance.additionalWhite
                  : ColorConstant.instance.paletteGrey,
            ),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  image,
                  width: 32.0,
                  height: 24.0,
                ),
                const SizedBox(width: 16.0),
                Text(
                  text,
                  style: currentTextTheme(context).headline3?.copyWith(
                        fontWeight: selectedIndex == languageId - 1
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: ColorConstant.instance.additionalWhite,
                      ),
                ),
              ],
            ),
            Transform.scale(
              scale: 1.3,
              child: Checkbox(
                activeColor: ColorConstant.instance.additionalWhite,
                checkColor: ColorConstant.instance.paletteBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                side: BorderSide(color: ColorConstant.instance.paletteGrey),
                value: selectedIndex == languageId - 1,
                onChanged: onChangedCheckBox ?? (_) {},
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
