// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/view/base/base_stateless.dart';
import 'package:chatbot/product/bottom_bar/viewmodel/bottom_bar_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/icon_constant.dart';
import '../../../core/language/locale_keys.g.dart';

class BottomBarView extends BaseStateless {
  BottomBarViewModel viewModel = BottomBarViewModel();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConstant.instance.additionalWhite,
      child: SafeArea(
        child: Consumer<BottomBarViewModel>(
          builder: (context, state, child) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  width: width(context: context, value: 1.0),
                  height: height(context: context, value: 0.09),
                  decoration: BoxDecoration(
                      color: ColorConstant.instance.additionalWhite,
                      borderRadius: BorderRadius.circular(66.0),
                      boxShadow: [
                        BoxShadow(
                          color: ColorConstant.instance.greyScale300,
                          spreadRadius: 1.0,
                          blurRadius: 10.0,
                          offset: const Offset(0, 3),
                        )
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => state.changeSelectedIndex(0),
                        child: menuIcon(
                          context,
                          text: LocaleKeys.home.tr(),
                          icon: state.selectedIndex == 0
                              ? IconConstant.instance.iconHomeFill
                              : IconConstant.instance.iconHome,
                          style: currentTextTheme(context)
                                  .headline4
                                  ?.copyWith(
                                    fontWeight: state.selectedIndex == 0
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: state.selectedIndex == 0
                                        ? ColorConstant.instance.greyScale900
                                        : ColorConstant.instance.greyScale600,
                                  ) ??
                              const TextStyle(),
                        ),
                      ),
                      InkWell(
                        onTap: () => state.changeSelectedIndex(1),
                        child: menuIcon(
                          context,
                          text: LocaleKeys.chat.tr(),
                          icon: state.selectedIndex == 1
                              ? IconConstant.instance.iconChatFill
                              : IconConstant.instance.iconChat,
                          style: currentTextTheme(context)
                                  .headline4
                                  ?.copyWith(
                                    fontWeight: state.selectedIndex == 1
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: state.selectedIndex == 1
                                        ? ColorConstant.instance.greyScale900
                                        : ColorConstant.instance.greyScale600,
                                  ) ??
                              const TextStyle(),
                        ),
                      ),
                      InkWell(
                        onTap: () => state.changeSelectedIndex(2),
                        child: menuIcon(
                          context,
                          text: LocaleKeys.profile.tr(),
                          icon: state.selectedIndex == 2
                              ? IconConstant.instance.iconProfileFill
                              : IconConstant.instance.iconProfile,
                          style: currentTextTheme(context)
                                  .headline4
                                  ?.copyWith(
                                    fontWeight: state.selectedIndex == 2
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: state.selectedIndex == 2
                                        ? ColorConstant.instance.greyScale900
                                        : ColorConstant.instance.greyScale600,
                                  ) ??
                              const TextStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: state.views.elementAt(state.selectedIndex),
            );
          },
        ),
      ),
    );
  }

  Column menuIcon(BuildContext context,
      {required String text, required String icon, required TextStyle style}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          icon,
          width: 29.0,
          height: 29.0,
        ),
        const SizedBox(height: 5.0),
        Text(
          text,
          style: style,
        ),
      ],
    );
  }
}
