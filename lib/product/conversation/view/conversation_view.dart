// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/language/locale_keys.g.dart';
import 'package:chatbot/core/view/base/base_stateless.dart';
import 'package:chatbot/product/conversation/viewmodel/conversation_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'conversation_room_view.dart';

class ConversationView extends BaseStateless {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.instance.additionalWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          LocaleKeys.chat.tr(),
          style: currentTextTheme(context).headline3?.copyWith(
                fontWeight: FontWeight.w500,
                color: ColorConstant.instance.greyScale900,
              ),
        ),
      ),
      body: Consumer<ConversationViewModel>(
        builder: (context, state, child) {
          return FutureBuilder(
            future: state.getAllMessages(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                return state.conversationModel.isNotEmpty
                    ? Padding(
                      padding: const EdgeInsets.only(bottom: 80.0),
                      child: ListView.builder(
                          itemCount: state.conversationModel.length,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          addAutomaticKeepAlives: false,
                          addRepaintBoundaries: false,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: width(context: context, value: 1.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: ColorConstant
                                            .instance.additionalWhite,
                                      ),
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ConversationRoomView(
                                              conversationId: state
                                                  .conversationModel[index].id!,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 40.0,
                                            height: 40.0,
                                            child: Image.network(
                                              state.conversationModel[index]
                                                  .topic!.icon!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(width: 12.0),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: width(
                                                    context: context, value: 0.7),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      state
                                                          .conversationModel[
                                                              index]
                                                          .topic!
                                                          .title!,
                                                      style: currentTextTheme(
                                                              context)
                                                          .headline3
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: ColorConstant
                                                                .instance
                                                                .greyScale900,
                                                          ),
                                                    ),
                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: ColorConstant
                                                          .instance.greyScale900,
                                                      size: 12.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: width(
                                                    context: context, value: 0.7),
                                                child: Text(
                                                  state.conversationModel[index]
                                                      .lastMessage!,
                                                  style: currentTextTheme(context)
                                                      .headline3
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: ColorConstant
                                                            .instance
                                                            .greyScale600,
                                                      ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Divider(
                                      thickness: 1.0,
                                      color: ColorConstant.instance.greyScale300,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 108.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              LocaleKeys.no_message.tr(),
                              style: currentTextTheme(context)
                                  .headline3
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: ColorConstant.instance.greyScale600,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
              } else {
                return const Text('error');
              }
            },
          );
        },
      ),
    );
  }
}
