// ignore_for_file: use_key_in_widget_constructors

import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/view/base/base_stateless.dart';
import 'package:chatbot/product/conversation/viewmodel/conversation_room_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopupWidget extends BaseStateless {
  @override
  Widget build(BuildContext context) {
    return Selector<ConversationRoomViewModel, bool>(
      selector: (context, model) => model.showPopup,
      builder: (context, showPopup, _) {
        if (showPopup) {
          return Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              height: 30,
              decoration: BoxDecoration(
                color: ColorConstant.instance.paletteCard,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text('Please hold the button',
                    style: currentTextTheme(context).bodyLarge?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: ColorConstant.instance.additionalWhite,
                          fontSize: 12.0,
                        )),
              ),
            ),
          );
        } else {
          return const SizedBox(); // Uyarı popup'ı gizlenmiş durumda
        }
      },
    );
  }
}
