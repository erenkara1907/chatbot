// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, use_build_context_synchronously

import 'package:auto_animated/auto_animated.dart';
import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/language/locale_keys.g.dart';
import 'package:chatbot/core/view/base/base_stateless.dart';
import 'package:chatbot/product/conversation/viewmodel/conversation_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import '../../../core/constants/image_constant.dart';
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
        backgroundColor: ColorConstant.instance.paletteBackground,
        body: Stack(
          children: [
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: Image.asset(
                ImageConstant.instance.imageTopEllipse,
                width: width(context: context, value: 1.0),
                fit: BoxFit.cover,
              ),
            ),
            messageList(context),
          ],
        ),
      ),
    );
  }

  FutureBuilder<dynamic> messageList(BuildContext context) {
    return FutureBuilder(
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
                                maxLength: width(context: context, value: 0.2),
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
              top: 68.0,
              left: 24.0,
              right: 24.0,
            ),
            child: Column(
              children: [
                Text(
                  LocaleKeys.chat.tr(),
                  style: currentTextTheme(context).headline3?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: ColorConstant.instance.additionalWhite,
                        fontSize: 18.0,
                      ),
                ),
                const SizedBox(height: 20.0),
                Consumer<HomeViewModel>(
                  builder: (context, state, child) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: TabBar(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.tab,
                        unselectedLabelColor:
                            ColorConstant.instance.additionalWhite,
                        labelStyle: currentTextTheme(context)
                            .headline4
                            ?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: ColorConstant.instance.paletteBackground,
                            ),
                        indicator: BoxDecoration(
                          color:
                              state.selectedTab == 0 || state.selectedTab == 1
                                  ? ColorConstant.instance.additionalWhite
                                  : ColorConstant.instance.additionalRed,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        unselectedLabelStyle:
                            currentTextTheme(context).headline4?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: ColorConstant.instance.additionalWhite,
                                ),
                        onTap: (index) {
                          state.selectTab(index);
                        },
                        tabs: const [
                          Tab(
                            text: 'Messages',
                          ),
                          Tab(
                            text: 'Completed Messages',
                          ),
                        ],
                      ),
                    );
                  },
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
                  color: ColorConstant.instance.additionalWhite,
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
                  color: ColorConstant.instance.additionalWhite,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  CircleAvatar createMessage(BuildContext context) {
    return CircleAvatar(
      radius: 50.0,
      backgroundColor: const Color.fromRGBO(120, 122, 124, 0.2),
      child: CircleAvatar(
        radius: 35.0,
        backgroundColor: const Color.fromRGBO(120, 122, 124, 0.4),
        child: CircleAvatar(
          backgroundColor: const Color.fromRGBO(172, 173, 177, 0.6),
          radius: 25.0,
          child: IconButton(
            onPressed: () {
              showScenarios(context);
            },
            icon: Icon(
              Icons.add,
              color: ColorConstant.instance.additionalWhite,
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showScenarios(BuildContext context) {
    return showModalBottomSheet(
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
                        backgroundColor: ColorConstant.instance.greyScale300,
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
                      "Scenarios",
                      style: currentTextTheme(context).headline2?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.instance.greyScale900,
                          ),
                    ),
                    const SizedBox(height: 24.0),
                    FutureBuilder(
                      future: viewModel.getScenario(),
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
                            itemCount: viewModel.scenarios.length,
                            physics: const ClampingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                            itemBuilder: (context, index) {
                              return scenarioCard(context, index);
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
  }

  InkWell scenarioCard(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        scenarioDialog(context, index);
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
            ),
            image: DecorationImage(
              image: NetworkImage(viewModel.scenarios[index].photo!),
              fit: BoxFit.cover,
            )),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 19.0, left: 9.0, right: 9.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 19.0,
                left: 8.0,
                right: 8.0,
              ),
              child: Text(
                viewModel.scenarios[index].title!,
                style: currentTextTheme(context).caption?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.instance.additionalWhite,
                      fontSize: 12.0,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> scenarioDialog(BuildContext context, int index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            width: width(context: context, value: 1.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: ColorConstant.instance.additionalWhite,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.red,
                  width: width(context: context, value: 1.0),
                  height: height(context: context, value: 0.15),
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.network(
                      viewModel.scenarios[index].icon!,
                      fit: BoxFit.fill,
                      width: width(context: context, value: 1.0),
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    viewModel.scenarios[index].title!,
                    style: currentTextTheme(context).headline1?.copyWith(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                          color: ColorConstant.instance.greyScale900,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24.0),
                Text(
                  viewModel.scenarios[index].scenario!,
                  style: currentTextTheme(context).headline4?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: ColorConstant.instance.greyScale900,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15.0),
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
                            scenarioId:
                                viewModel.scenarios[index].id!.toString(),
                          );

                          response.then((value) {
                            if (value.result == true) {
                              state.chnageConversationStatus(true);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ConversationRoomView(
                                    profilePhoto: state
                                        .profileModel.data!.user!.profilePhoto!,
                                    conversationId: viewModel.conversation.id!,
                                    scenarioTitle:
                                        viewModel.scenarios[index].title!,
                                  ),
                                ),
                              );
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstant.instance.greyScale400,
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
                                      color:
                                          ColorConstant.instance.greyScale900,
                                    ),
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                  color: ColorConstant.instance.additionalWhite,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
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
      padding: const EdgeInsets.only(bottom: 40.0),
      child: LiveList(
        padding: EdgeInsets.zero,
        itemBuilder: animationItemBuilder(
          (index, context) {
            return Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: width(context: context, value: 1.0),
                    height: 102.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: ColorConstant.instance.paletteCard,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                      onPressed: () async {
                        // await state.getAllMessages(
                        //     conversationId: state.conversationModel[index].id!);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConversationRoomView(
                              profilePhoto:
                                  state.profileModel.data!.user!.profilePhoto!,
                              conversationId:
                                  state.conversationModelTemp[index].id!,
                              scenarioTitle: state.conversationModelTemp[index]
                                  .scenario!.title!,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 13.0,
                          horizontal: 12.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 40.0,
                              height: 40.0,
                              child: SvgPicture.network(
                                state.conversationModelTemp[index].scenario!
                                    .icon!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 18.0),
                            Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: width(context: context, value: 0.7),
                                    child: SizedBox(
                                      width:
                                          width(context: context, value: 0.5),
                                      child: Text(
                                        state.conversationModelTemp[index]
                                            .scenario!.title!,
                                        style: currentTextTheme(context)
                                            .headline3
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: ColorConstant
                                                  .instance.additionalWhite,
                                              fontSize: 16.0,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6.0),
                                  SizedBox(
                                    width: width(context: context, value: 0.7),
                                    child: Text(
                                      state.conversationModelTemp[index]
                                          .lastMessage!,
                                      style: currentTextTheme(context)
                                          .headline3
                                          ?.copyWith(
                                            fontWeight: FontWeight.w300,
                                            color: ColorConstant
                                                .instance.additionalWhite,
                                            fontSize: 14.0,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
      padding: const EdgeInsets.only(bottom: 40.0),
      child: LiveList(
        padding: EdgeInsets.zero,
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
                    height: 102.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: ColorConstant.instance.paletteCard,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                      onPressed: () async {
                        // await state.getAllMessages(
                        //     conversationId: state.conversationModel[index].id!);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConversationRoomView(
                              profilePhoto:
                                  state.profileModel.data!.user!.profilePhoto!,
                              // messages: state.messages,
                              conversationId:
                                  state.completedMessageTemp[index].id!,
                              scenarioTitle: state
                                  .completedMessageTemp[index].scenario!.title!,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 13.0,
                          horizontal: 12.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 40.0,
                              height: 40.0,
                              child: SvgPicture.network(
                                state.completedMessageTemp[index].scenario!
                                    .icon!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 18.0),
                            Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: width(context: context, value: 0.7),
                                    child: SizedBox(
                                      width:
                                          width(context: context, value: 0.5),
                                      child: Text(
                                        state.completedMessageTemp[index]
                                            .scenario!.title!,
                                        style: currentTextTheme(context)
                                            .headline3
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: ColorConstant
                                                  .instance.additionalWhite,
                                              fontSize: 16.0,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6.0),
                                  SizedBox(
                                    width: width(context: context, value: 0.7),
                                    child: Text(
                                      state.completedMessageTemp[index]
                                          .lastMessage!,
                                      style: currentTextTheme(context)
                                          .headline3
                                          ?.copyWith(
                                            fontWeight: FontWeight.w300,
                                            color: ColorConstant
                                                .instance.additionalWhite,
                                            fontSize: 14.0,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
