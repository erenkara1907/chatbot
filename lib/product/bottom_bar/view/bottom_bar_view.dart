// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/view/base/base_stateless.dart';
import 'package:chatbot/product/bottom_bar/viewmodel/bottom_bar_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/icon_constant.dart';

class BottomBarView extends BaseStateless {
  BottomBarViewModel viewModel = BottomBarViewModel();
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Container(
        color: ColorConstant.instance.additionalWhite,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Consumer<BottomBarViewModel>(
            builder: (context, state, child) {
              return Stack(
                children: [
                  state.views.elementAt(state.selectedIndex),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Material(
                      child: Container(
                        width: width(context: context, value: 1.0),
                        height: height(context: context, value: 0.12),
                        decoration: BoxDecoration(
                          color: ColorConstant.instance.paletteBackground,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () => state.changeSelectedIndex(0),
                              child: state.selectedIndex == 0
                                  ? CircleAvatar(
                                      radius: 26.0,
                                      backgroundColor: ColorConstant
                                          .instance.additionalWhite,
                                      child: menuIcon(context,
                                          icon: IconConstant
                                              .instance.iconHomeTouched),
                                    )
                                  : menuIcon(
                                      context,
                                      icon: IconConstant.instance.iconHome,
                                    ),
                            ),
                            InkWell(
                              onTap: () => state.changeSelectedIndex(1),
                              child: state.selectedIndex == 1
                                  ? CircleAvatar(
                                      radius: 26.0,
                                      backgroundColor: ColorConstant
                                          .instance.additionalWhite,
                                      child: menuIcon(context,
                                          icon: IconConstant
                                              .instance.iconMessageTouched),
                                    )
                                  : menuIcon(
                                      context,
                                      icon: IconConstant.instance.iconMessage,
                                    ),
                            ),
                            InkWell(
                              onTap: () => state.changeSelectedIndex(2),
                              child: state.selectedIndex == 2
                                  ? CircleAvatar(
                                      radius: 26.0,
                                      backgroundColor: ColorConstant
                                          .instance.additionalWhite,
                                      child: menuIcon(context,
                                          icon: IconConstant
                                              .instance.iconProfileTouched),
                                    )
                                  : menuIcon(
                                      context,
                                      icon: IconConstant.instance.iconProfile,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget menuIcon(BuildContext context, {required String icon}) {
    return SvgPicture.asset(
      icon,
      width: 29.0,
      height: 29.0,
    );
  }
}
