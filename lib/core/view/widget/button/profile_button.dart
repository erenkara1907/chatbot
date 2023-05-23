// ignore_for_file: use_key_in_widget_constructors

import 'package:chatbot/core/view/base/base_stateless.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/color_constant.dart';

class ProfileButton extends BaseStateless {
  final String image;
  final String text;
  final bool isLogout;
  final bool isEnglish;
  final void Function()? onTap;
  final bool isDivider;
  final String language;
  final bool isIcon;
  final IconData icon;

  ProfileButton({
    this.image = "",
    required this.text,
    this.isLogout = false,
    this.isEnglish = false,
    this.onTap,
    this.isDivider = true,
    this.language = '',
    this.isIcon = false,
    this.icon = Icons.person,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width(context: context, value: 1.0),
      child: ElevatedButton(
        onPressed: onTap ?? () {},
        style: ElevatedButton.styleFrom(
            enableFeedback: false,
            backgroundColor: ColorConstant.instance.additionalWhite,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 0.0, color: ColorConstant.instance.additionalWhite),
            ),
            elevation: 0),
        child: Column(
          children: [
            isDivider
                ? Divider(
                    thickness: 2,
                    color: ColorConstant.instance.greyScale200,
                  )
                : const SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    isIcon
                        ? Icon(
                            icon,
                            size: 24.0,
                            color: ColorConstant.instance.additionalRed,
                          )
                        : SvgPicture.asset(
                            image,
                            color: isLogout
                                ? ColorConstant.instance.additionalRed
                                : ColorConstant.instance.greyScale900,
                          ),
                    const SizedBox(width: 20.0),
                    Text(
                      text,
                      style: currentTextTheme(context).headline4?.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: isLogout
                                ? ColorConstant.instance.additionalRed
                                : ColorConstant.instance.greyScale900,
                          ),
                    ),
                  ],
                ),
                isEnglish
                    ? Row(
                        children: [
                          Text(
                            language,
                            style: currentTextTheme(context)
                                .headline6
                                ?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: ColorConstant.instance.greyScale600,
                                ),
                          ),
                          Transform.scale(
                            scale: 0.7,
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: ColorConstant.instance.greyScale600,
                              ),
                            ),
                          ),
                        ],
                      )
                    : isLogout
                        ? Transform.scale(
                            scale: 0.7,
                            child: IconButton(
                              onPressed: () {},
                              icon: const SizedBox(),
                            ),
                          )
                        : Transform.scale(
                            scale: 0.7,
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: ColorConstant.instance.greyScale600,
                              ),
                            ),
                          ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
