// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, use_build_context_synchronously

import 'package:auto_animated/auto_animated.dart';
import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/language/locale_keys.g.dart';
import 'package:chatbot/core/view/base/base_stateless.dart';
import 'package:chatbot/product/conversation/viewmodel/conversation_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import '../../home/viewmodel/home_view_model.dart';
import 'conversation_room_view.dart';

class ConversationView extends BaseStateless {
  HomeViewModel viewModel = HomeViewModel();
  @override
  Widget build(BuildContext context) {
    Provider.of<ConversationViewModel>(context, listen: false).setActivePage();
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
        body: FutureBuilder(
          future: Provider.of<ConversationViewModel>(context, listen: false)
              .getAllConversation(),
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
                      labelStyle: currentTextTheme(context).headline4?.copyWith(
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
                      child: Consumer<ConversationViewModel>(
                        builder: (context, state, child) {
                          return TabBarView(
                            children: [
                              state.conversationModelTemp.isNotEmpty
                                  ? messages(state)
                                  : noMessage(context),
                              state.completedMessageTemp.isNotEmpty
                                  ? completedMessages(state)
                                  : noMCompleteessage(context),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Text('error');
            }
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
          createMessage(context),
          const SizedBox(height: 30.0),
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

  Padding noMCompleteessage(BuildContext context) {
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

  CircleAvatar createMessage(BuildContext context) {
    return CircleAvatar(
      backgroundColor: ColorConstant.instance.greyScale900,
      radius: 25.0,
      child: IconButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return FractionallySizedBox(
                heightFactor: 0.88,
                child: Container(
                  width: width(context: context, value: 1.0),
                  decoration: BoxDecoration(
                    color: ColorConstant.instance.additionalWhite,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 15.0,
                      right: 24.0,
                      left: 24.0,
                    ),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: CircleAvatar(
                              backgroundColor:
                                  ColorConstant.instance.greyScale300,
                              radius: 15.0,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.close,
                                  size: 15.0,
                                  color: ColorConstant.instance.greyScale900,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            LocaleKeys.topics.tr(),
                            style: currentTextTheme(context)
                                .headline2
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstant.instance.greyScale900,
                                ),
                          ),
                          const SizedBox(height: 24.0),
                          FutureBuilder(
                            future: viewModel.getTopics(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: ColorConstant.instance.greyScale900,
                                  ),
                                );
                              } else if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: viewModel.topics.length,
                                  physics: const ClampingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                  ),
                                  itemBuilder: (context, index) {
                                    return topicCard(context, index);
                                  },
                                );
                              } else {
                                return const Text('error');
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        icon: Icon(
          Icons.add,
          color: ColorConstant.instance.additionalWhite,
        ),
      ),
    );
  }

  InkWell topicCard(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        topicDialog(context, index);
      },
      child: Container(
        width: width(context: context, value: 0.4),
        height: height(context: context, value: 0.2),
        decoration: BoxDecoration(
            color: ColorConstant.instance.greyScale50,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              width: 1.0,
              color: ColorConstant.instance.greyScale300,
            )),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 24.0,
            horizontal: 21.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                viewModel.topics[index].title!,
                style: currentTextTheme(context).headline3?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: ColorConstant.instance.greyScale900,
                    ),
              ),
              Image.network(
                viewModel.topics[index].icon!,
                width: 50.0,
                height: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> topicDialog(BuildContext context, int index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(42.0),
                width: width(context: context, value: 1.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: ColorConstant.instance.additionalWhite,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Image.network(viewModel.topics[index].icon!)),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        viewModel.topics[index].title!,
                        style: currentTextTheme(context).headline1?.copyWith(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                              color: ColorConstant.instance.greyScale900,
                            ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Text(
                      viewModel.topics[index].description![0],
                      style: currentTextTheme(context).headline4?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: ColorConstant.instance.greyScale900,
                          ),
                    ),
                    const SizedBox(height: 15.0),
                    ListView.builder(
                      itemCount:
                          viewModel.topics[index].description!.length - 1,
                      addAutomaticKeepAlives: false,
                      addRepaintBoundaries: false,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (context, i) {
                        return Text(
                          viewModel.topics[index].description![i + 1],
                          style: currentTextTheme(context).headline4?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: ColorConstant.instance.greyScale900,
                              ),
                        );
                      },
                    ),
                    const SizedBox(height: 24.0),
                    Consumer<HomeViewModel>(
                      builder: (context, state, child) {
                        return SizedBox(
                          width: width(context: context, value: 1.0) - 132.0,
                          height: height(context: context, value: 0.07),
                          child: ElevatedButton(
                            onPressed: () {
                              state.chnageConversationStatus(false);
                              state.setFirstLogin();
                              final response = viewModel.createConversation(
                                context,
                                topicId: viewModel.topics[index].id!.toString(),
                              );

                              response.then((value) {
                                if (value.result == true) {
                                  state.chnageConversationStatus(true);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ConversationRoomView(
                                        conversationId:
                                            viewModel.conversation.id!,
                                      ),
                                    ),
                                  );
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  ColorConstant.instance.greyScale400,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(66.0),
                              ),
                              elevation: 0,
                            ),
                            child: state.isCreatedConversation
                                ? Text(
                                    LocaleKeys.let_start.tr(),
                                    style: currentTextTheme(context)
                                        .headline3
                                        ?.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: ColorConstant
                                              .instance.greyScale900,
                                        ),
                                  )
                                : Center(
                                    child: CircularProgressIndicator(
                                      color: ColorConstant
                                          .instance.additionalWhite,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget Function(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) animationItemBuilder(
    Widget Function(int index, BuildContext context) child, {
    EdgeInsets padding = EdgeInsets.zero,
  }) =>
      (
        BuildContext context,
        int index,
        Animation<double> animation,
      ) =>
          FadeTransition(
            opacity: Tween<double>(
              begin: 0,
              end: 1,
            ).animate(animation),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -0.1),
                end: Offset.zero,
              ).animate(animation),
              child: Padding(
                padding: padding,
                child: child(index, context),
              ),
            ),
          );

  Padding messages(ConversationViewModel state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, right: 16.0, left: 16.0),
      child: LiveList(
        itemBuilder: animationItemBuilder(
          (index, context) {
            return Padding(
              padding: const EdgeInsets.only(
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
                              conversationId:
                                  state.conversationModelTemp[index].id!,
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
                              state.conversationModelTemp[index].topic!.icon!,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      state.conversationModelTemp[index].topic!
                                          .title!,
                                      style: currentTextTheme(context)
                                          .headline3
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: ColorConstant
                                                .instance.greyScale900,
                                          ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color:
                                          ColorConstant.instance.greyScale900,
                                      size: 12.0,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: width(context: context, value: 0.7),
                                child: Text(
                                  state.conversationModelTemp[index]
                                      .lastMessage!,
                                  style: currentTextTheme(context)
                                      .headline3
                                      ?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color:
                                            ColorConstant.instance.greyScale600,
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
        ),
        itemCount: state.conversationModelTemp.length,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
      ),
    );
  }

  Widget completedMessages(ConversationViewModel state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, left: 16.0, right: 16.0),
      child: LiveList(
        itemBuilder: animationItemBuilder(
          (index, context) {
            return Padding(
              padding: const EdgeInsets.only(
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
                              conversationId:
                                  state.completedMessageTemp[index].id!,
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
                              state.completedMessageTemp[index].topic!.icon!,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      state.completedMessageTemp[index].topic!
                                          .title!,
                                      style: currentTextTheme(context)
                                          .headline3
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: ColorConstant
                                                .instance.greyScale900,
                                          ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color:
                                          ColorConstant.instance.greyScale900,
                                      size: 12.0,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: width(context: context, value: 0.7),
                                child: Text(
                                  state
                                      .completedMessageTemp[index].lastMessage!,
                                  style: currentTextTheme(context)
                                      .headline3
                                      ?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color:
                                            ColorConstant.instance.greyScale600,
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
        ),
        itemCount: state.completedMessageTemp.length,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
      ),
    );
  }
}
