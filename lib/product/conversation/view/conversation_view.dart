// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, use_build_context_synchronously

import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/language/locale_keys.g.dart';
import 'package:chatbot/core/view/base/base_stateless.dart';
import 'package:chatbot/product/conversation/viewmodel/conversation_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import 'conversation_room_view.dart';

class ConversationView extends BaseStateless {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
              future: state.getAllConversation(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 8,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            const SkeletonAvatar(
                              style: SkeletonAvatarStyle(
                                width: 35.0,
                                height: 35.0,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SkeletonParagraph(
                                    style: SkeletonParagraphStyle(
                                      lines: 1,
                                      lineStyle: SkeletonLineStyle(
                                        maxLength:
                                            width(context: context, value: 0.2),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                  SkeletonParagraph(
                                    style: const SkeletonParagraphStyle(
                                      lines: 2,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 80.0,
                    ),
                    child: Column(
                      children: [
                        TabBar(
                          isScrollable: true,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: ColorConstant.instance.greyScale900,
                          labelStyle:
                              currentTextTheme(context).headline4?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(15, 23, 42, 1),
                                  ),
                          unselectedLabelStyle:
                              currentTextTheme(context).headline4?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: const Color.fromRGBO(15, 23, 42, 1),
                                  ),
                          tabs: const [
                            Tab(
                              text: 'Messages',
                            ),
                            Tab(
                              text: 'Completed Messages',
                            )
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              state.conversationModel.isNotEmpty
                                  ? messages(state)
                                  : noMessage(context),
                              state.completedMessages.isNotEmpty
                                  ? completedMessages(state)
                                  : noMessage(context),
                            ],
                          ),
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
      ),
    );
  }

  Padding noMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 108.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            LocaleKeys.no_message.tr(),
            style: currentTextTheme(context).headline3?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: ColorConstant.instance.greyScale600,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  ListView messages(ConversationViewModel state) {
    return ListView.builder(
      itemCount: state.conversationModel.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 20.0,
            top: 25.0,
          ),
          child: Column(
            children: [
              SizedBox(
                width: width(context: context, value: 1.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: ColorConstant.instance.additionalWhite,
                  ),
                  onPressed: () async {
                    // await state.getAllMessages(
                    //     conversationId: state.conversationModel[index].id!);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConversationRoomView(
                          // messages: state.messages,
                          conversationId: state.conversationModel[index].id!,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child: Image.network(
                          state.conversationModel[index].topic!.icon!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: width(context: context, value: 0.7),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  state.conversationModel[index].topic!.title!,
                                  style: currentTextTheme(context)
                                      .headline3
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color:
                                            ColorConstant.instance.greyScale900,
                                      ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: ColorConstant.instance.greyScale900,
                                  size: 12.0,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: width(context: context, value: 0.7),
                            child: Text(
                              state.conversationModel[index].lastMessage!,
                              style: currentTextTheme(context)
                                  .headline3
                                  ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: ColorConstant.instance.greyScale600,
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
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(
                  thickness: 1.0,
                  color: ColorConstant.instance.greyScale300,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ListView completedMessages(ConversationViewModel state) {
    return ListView.builder(
      itemCount: state.completedMessages.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 20.0,
            top: 25.0,
          ),
          child: Column(
            children: [
              SizedBox(
                width: width(context: context, value: 1.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: ColorConstant.instance.additionalWhite,
                  ),
                  onPressed: () async {
                    // await state.getAllMessages(
                    //     conversationId: state.conversationModel[index].id!);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConversationRoomView(
                          // messages: state.messages,
                          conversationId: state.completedMessages[index].id!,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child: Image.network(
                          state.completedMessages[index].topic!.icon!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: width(context: context, value: 0.7),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  state.completedMessages[index].topic!.title!,
                                  style: currentTextTheme(context)
                                      .headline3
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color:
                                            ColorConstant.instance.greyScale900,
                                      ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: ColorConstant.instance.greyScale900,
                                  size: 12.0,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: width(context: context, value: 0.7),
                            child: Text(
                              state.completedMessages[index].lastMessage!,
                              style: currentTextTheme(context)
                                  .headline3
                                  ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: ColorConstant.instance.greyScale600,
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
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(
                  thickness: 1.0,
                  color: ColorConstant.instance.greyScale300,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
