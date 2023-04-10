// ignore_for_file: prefer_final_fields, unused_field, must_be_immutable, use_build_context_synchronously

import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/constants/image_constant.dart';
import 'package:chatbot/core/view/base/base_state.dart';
import 'package:chatbot/product/conversation/view/text_widget.dart';
import 'package:chatbot/product/conversation/viewmodel/conversation_room_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import '../../../core/constants/icon_constant.dart';
import '../../../core/language/locale_keys.g.dart';
import '../../../core/view/widget/button/language_button.dart';
import '../../bottom_bar/view/bottom_bar_view.dart';

class ConversationRoomView extends StatefulWidget {
  final int conversationId;
  // final List<Messages> messages;

  const ConversationRoomView({
    Key? key,
    required this.conversationId,
    // this.messages = const [],
  }) : super(key: key);
  @override
// ignore: library_private_types_in_public_api
  _ConversationRoomViewState createState() => _ConversationRoomViewState();
}

class _ConversationRoomViewState extends BaseState<ConversationRoomView> {
  bool _isTyping = false;
  bool? _isFirst;

  ConversationRoomViewModel viewModel = ConversationRoomViewModel();

  late TextEditingController sendTextController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;

  @override
  void initState() {
    Provider.of<ConversationRoomViewModel>(context, listen: false)
        .getAllMessages(conversationId: widget.conversationId);
    _listScrollController = ScrollController();
    sendTextController = TextEditingController();
    focusNode = FocusNode();
    _isFirst = true;

    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    sendTextController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var chatProvider = Provider.of<ConversationRoomViewModel>(context);
    // widget.isFirst
    //     ? chatProvider.chatList = List.generate(
    //         widget.messages.length,
    //         (index) => ChatModel(
    //           message: widget.messages[index].message!,
    //           role: widget.messages[index].role!,
    //         ),
    //       )
    //     : null;
    return Scaffold(
      backgroundColor: ColorConstant.instance.additionalWhite,
      appBar: !chatProvider.isData
          ? AppBar(
              elevation: 0,
              backgroundColor: ColorConstant.instance.additionalWhite,
              leading: Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: CircleAvatar(
                  backgroundColor: ColorConstant.instance.greyScale300,
                  radius: 25.0,
                  child: Image.asset(
                    ImageConstant.instance.smallRobot,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              title: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
                child: LinearProgressIndicator(
                  backgroundColor: ColorConstant.instance.greyScale50,
                  color: chatProvider.isActive == 0 || chatProvider.endChat == 1
                      ? ColorConstant.instance.additionalGreen
                      : ColorConstant.instance.greyScale800,
                  minHeight: 6.0,
                  value: double.parse(chatProvider.conversationCompleteCount),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: CircleAvatar(
                    backgroundColor: ColorConstant.instance.greyScale300,
                    radius: 15.0,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BottomBarView()));
                        },
                        icon: Icon(
                          Icons.close,
                          color: ColorConstant.instance.greyScale900,
                          size: 15.0,
                        )),
                  ),
                ),
              ],
            )
          : AppBar(
              elevation: 0,
              backgroundColor: ColorConstant.instance.additionalWhite,
              leading: const Padding(
                  padding: EdgeInsets.only(left: 24.0),
                  child: SkeletonAvatar(
                    style: SkeletonAvatarStyle(
                      shape: BoxShape.circle,
                      width: 15.0,
                      height: 15.0,
                    ),
                  )),
              title: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
                child: SkeletonParagraph(
                  style: const SkeletonParagraphStyle(
                    lines: 1,
                  ),
                ),
              ),
              actions: const [
                Padding(
                    padding: EdgeInsets.only(right: 24.0),
                    child: SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                        shape: BoxShape.circle,
                        width: 35.0,
                        height: 35.0,
                      ),
                    )),
              ],
            ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: !chatProvider.isData
              ? Column(
                  children: [
                    Flexible(
                      child: ListView.builder(
                        controller: _listScrollController,
                        itemCount: chatProvider.getChatList.length,
                        addAutomaticKeepAlives: false,
                        addRepaintBoundaries: false,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return chatWidget(
                            chatProvider,
                            index,
                          );
                        },
                      ),
                    ),
                    if (_isTyping) ...[
                      const SpinKitThreeBounce(
                        color: Colors.black,
                        size: 18.0,
                      )
                    ],
                    chatProvider.endChat == 1
                        ? chatProvider.isActive == 0
                            ? const Center()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                    ),
                                    onPressed: () async {
                                      await chatProvider.sendToBackendRateId(
                                        context,
                                        conversationId: widget.conversationId,
                                        endConversationId: 1,
                                      );
                                      rateDialog(context, chatProvider);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.lock,
                                          color: ColorConstant
                                              .instance.additionalRed,
                                          size: 15.0,
                                        ),
                                        const SizedBox(width: 15.0),
                                        Text(
                                          LocaleKeys.endChat.tr(),
                                          style: currentTextTheme.headline3
                                              ?.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: ColorConstant
                                                .instance.additionalRed,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                        : const Center(),
                    const SizedBox(height: 5.0),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: SizedBox(
                        width: width(1.0),
                        height: height(0.075),
                        child: TextField(
                          enabled: chatProvider.isActive == 0 ? false : true,
                          controller: sendTextController,
                          focusNode: focusNode,
                          style: currentTextTheme.headline3?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: ColorConstant.instance.greyScale900,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: ColorConstant.instance.additionalWhite,
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                width: 44.0,
                                height: 44.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: ColorConstant.instance.greyScale300,
                                ),
                                child: Center(
                                  child: IconButton(
                                    onPressed: () async {
                                      await sendMessage(
                                          chatProvider: chatProvider);
                                    },
                                    icon: SvgPicture.asset(
                                        IconConstant.instance.iconSend),
                                  ),
                                ),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide(
                                width: 1.0,
                                color: ColorConstant.instance.greyScale400,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide(
                                width: 1.0,
                                color: ColorConstant.instance.greyScale400,
                              ),
                            ),
                            hintText: chatProvider.isActive == 0
                                ? 'Chat is completed'
                                : LocaleKeys.ask.tr(),
                            hintStyle: currentTextTheme.headline3?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: ColorConstant.instance.greyScale500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Flexible(
                      child: ListView.builder(
                        itemCount: 10,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: ColorConstant.instance.greyScale200,
                              ),
                              child: SkeletonParagraph(
                                style: SkeletonParagraphStyle(
                                    lines: 3,
                                    spacing: 6,
                                    lineStyle: SkeletonLineStyle(
                                      randomLength: true,
                                      height: 10,
                                      borderRadius: BorderRadius.circular(8),
                                      minLength:
                                          MediaQuery.of(context).size.width / 6,
                                      maxLength:
                                          MediaQuery.of(context).size.width / 3,
                                    )),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (_isTyping) ...[
                      const SpinKitThreeBounce(
                        color: Colors.black,
                        size: 18.0,
                      )
                    ],
                    const SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: SkeletonParagraph(
                            style: const SkeletonParagraphStyle(
                              lines: 1,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                              width: 35.0,
                              height: 35.0,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Align chatWidget(ConversationRoomViewModel chatProvider, int index) {
    return Align(
      alignment: chatProvider.chatList[index].role == 'user'
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            chatProvider.chatList[index].role == 'user' ? 94.0 : 0.0,
            10.0,
            chatProvider.chatList[index].role == 'user'
                ? 0.0
                : chatProvider.chatList[index].message == 'Please try again.'
                    ? 164.0
                    : 94.0,
            10.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: chatProvider.chatList[index].role == 'user'
                ? ColorConstant.instance.greyScale600
                : chatProvider.chatList[index].message == 'Please try again.'
                    ? ColorConstant.instance.additionalRed
                    : ColorConstant.instance.greyScale200,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0),
                bottomLeft: Radius.circular(
                    chatProvider.chatList[index].role == 'user' ? 20.0 : 0.0),
                bottomRight: Radius.circular(
                    chatProvider.chatList[index].role == 'user' ? 0.0 : 20.0)),
          ),
          child: chatProvider.chatList[index].role == 'user'
              ? Text(
                  chatProvider.chatList[index].message,
                  style: currentTextTheme.headline3?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: chatProvider.chatList[index].role == 'user'
                        ? ColorConstant.instance.additionalWhite
                        : ColorConstant.instance.greyScale900,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    chatProvider.chatList[index].role == 'user'
                        ? Text(
                            chatProvider.chatList[index].message,
                            style: currentTextTheme.headline3?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: ColorConstant.instance.additionalWhite,
                            ),
                          )
                        : DefaultTextStyle(
                            style: currentTextTheme.headline3?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: chatProvider.chatList[index].message ==
                                          'Please try again.'
                                      ? ColorConstant.instance.additionalWhite
                                      : ColorConstant.instance.greyScale900,
                                ) ??
                                const TextStyle(),
                            child: Text(chatProvider.chatList[index].message)),
                    const SizedBox(height: 10.0),
                    chatProvider.chatList[index].message == 'Please try again.'
                        ? const Center()
                        : CircleAvatar(
                            backgroundColor:
                                ColorConstant.instance.greyScale400,
                            radius: 15.0,
                            child: IconButton(
                              onPressed: () async {
                                chatProvider.translateMessage =
                                    chatProvider.chatList[index].message;

                                showTranslateMessage(context, index);
                              },
                              icon: Icon(
                                Icons.translate,
                                color: ColorConstant.instance.greyScale600,
                                size: 15.0,
                              ),
                            ),
                          ),
                  ],
                ),
        ),
      ),
    );
  }

  void scrollListToEND() {
    _listScrollController.animateTo(
      _listScrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOut,
    );
  }

  Future<void> sendMessage(
      {required ConversationRoomViewModel chatProvider}) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "You can't multiple messages at a time",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (sendTextController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "Please type a message",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      String msg = sendTextController.text;
      _isFirst = false;

      _isTyping = true;
      chatProvider.addUserMessage(message: msg);
      sendTextController.clear();
      focusNode.unfocus();

      await chatProvider.sendMessageAndGetAnswers(
        message: msg,
        conversationId: widget.conversationId,
      );

      chatProvider.tempList = chatProvider.chatList;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidget(
            label: error.toString(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      scrollListToEND();
      _isTyping = false;
      // Future.delayed(const Duration(seconds: 2), () {

      // });
    }
  }

  Future<dynamic> rateDialog(
      BuildContext context, ConversationRoomViewModel state) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
              ),
              child: Container(
                width: width(1.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: ColorConstant.instance.additionalWhite,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            LocaleKeys.rate_text.tr(),
                            style: currentTextTheme.headline3?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: ColorConstant.instance.greyScale900,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BottomBarView()));
                            },
                            child: Text(
                              LocaleKeys.skip.tr(),
                              style: currentTextTheme.headline4?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: ColorConstant.instance.greyScale600,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 60.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          addAutomaticKeepAlives: false,
                          addRepaintBoundaries: false,
                          itemCount: state.rates.length,
                          itemBuilder: (context, index) {
                            return Material(
                              child: InkWell(
                                onTap: () async {
                                  await state.sendToBackendRateId(
                                    context,
                                    conversationId: widget.conversationId,
                                    rateId: state.rates[index].id!,
                                    endConversationId: 1,
                                  );

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BottomBarView(),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    right: 10.0,
                                  ),
                                  child: SizedBox(
                                    width: 43.0,
                                    height: 43.0,
                                    child: Image.network(
                                      state.rates[index].icon!,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
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
    );
  }

  Future<dynamic> showTranslateMessage(BuildContext context, int index) {
    return showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Consumer<ConversationRoomViewModel>(
          builder: (context, state, child) {
            return FractionallySizedBox(
              heightFactor: 0.9,
              child: Container(
                width: width(1.0),
                decoration: BoxDecoration(
                  color: ColorConstant.instance.additionalWhite,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                  ),
                  child: FutureBuilder(
                    future: viewModel.translate(
                      conversationId: widget.conversationId,
                      messageId: state.chatList[index].id,
                      translateTitle: viewModel.nativeLanguage == ''
                          ? viewModel.nativePopularLanguage
                          : viewModel.nativeLanguage,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 25.0),
                            SkeletonParagraph(
                              style: SkeletonParagraphStyle(
                                lines: 1,
                                lineStyle: SkeletonLineStyle(
                                  width: width(0.15),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            SkeletonParagraph(
                              style: SkeletonParagraphStyle(
                                lines: 1,
                                lineStyle: SkeletonLineStyle(
                                  width: width(0.10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            SkeletonParagraph(
                              style: const SkeletonParagraphStyle(
                                lines: 4,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            SkeletonParagraph(
                              style: SkeletonParagraphStyle(
                                lines: 1,
                                lineStyle: SkeletonLineStyle(
                                  width: width(0.10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            SkeletonParagraph(
                              style: const SkeletonParagraphStyle(
                                lines: 4,
                              ),
                            ),
                          ],
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        return SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 15.0),
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
                                      color:
                                          ColorConstant.instance.greyScale900,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              Text(
                                LocaleKeys.translate.tr(),
                                style: currentTextTheme.headline1?.copyWith(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstant.instance.greyScale900,
                                ),
                              ),
                              const SizedBox(height: 24.0),
                              Text(
                                LocaleKeys.message.tr(),
                                style: currentTextTheme.headline1?.copyWith(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                  color: ColorConstant.instance.greyScale900,
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Text(
                                state.translateMessage,
                                style: currentTextTheme.headline1?.copyWith(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: ColorConstant.instance.greyScale600,
                                ),
                              ),
                              const SizedBox(height: 24.0),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    LocaleKeys.translate_to.tr(),
                                    style: currentTextTheme.headline1?.copyWith(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          ColorConstant.instance.greyScale900,
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  SizedBox(
                                    height: height(0.04),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              side: BorderSide(
                                                  width: 1.0,
                                                  color: ColorConstant
                                                      .instance.greyScale900))),
                                      onPressed: () {
                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return FractionallySizedBox(
                                              heightFactor: 0.88,
                                              child: Container(
                                                width: width(1.0),
                                                decoration: BoxDecoration(
                                                    color: ColorConstant
                                                        .instance
                                                        .additionalWhite,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20.0),
                                                      topRight:
                                                          Radius.circular(20.0),
                                                    )),
                                                child: SingleChildScrollView(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 24.0,
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const SizedBox(
                                                            height: 15.0),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                ColorConstant
                                                                    .instance
                                                                    .greyScale300,
                                                            radius: 15.0,
                                                            child: IconButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                icon: Icon(
                                                                  Icons.close,
                                                                  color: ColorConstant
                                                                      .instance
                                                                      .greyScale900,
                                                                  size: 15.0,
                                                                )),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 24.0),
                                                        Text(
                                                          LocaleKeys
                                                              .popular_lang
                                                              .tr(),
                                                          style:
                                                              currentTextTheme
                                                                  .headline3
                                                                  ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: ColorConstant
                                                                .instance
                                                                .greyScale600,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        const SizedBox(
                                                            height: 15.0),
                                                        ListView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              const ClampingScrollPhysics(),
                                                          itemCount: viewModel
                                                              .popularLanguageIds
                                                              .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Consumer<
                                                                ConversationRoomViewModel>(
                                                              builder: (context,
                                                                  state,
                                                                  child) {
                                                                return Column(
                                                                  children: [
                                                                    LanguageButton(
                                                                      image: viewModel
                                                                              .popularLanguageImages[
                                                                          index],
                                                                      languageId:
                                                                          viewModel
                                                                              .popularLanguageIds[index],
                                                                      selectedIndex:
                                                                          state
                                                                              .selectedPopularIndex,
                                                                      onTap:
                                                                          () {
                                                                        viewModel
                                                                            .selectedPopularLanguageId = viewModel
                                                                                .popularLanguageIds[
                                                                            index];
                                                                        state.changeCheckboxStatusPopular(
                                                                            index:
                                                                                index);
                                                                        viewModel.selectedPopularIndex =
                                                                            index;
                                                                        viewModel
                                                                            .nativePopularLanguage = viewModel
                                                                                .popularLanguageTitles[
                                                                            index];
                                                                        viewModel.nativeLanguage =
                                                                            '';
                                                                      },
                                                                      widthValue:
                                                                          width(
                                                                              1.0),
                                                                      heightValue:
                                                                          height(
                                                                              0.07),
                                                                      backgroundColor: ColorConstant
                                                                          .instance
                                                                          .additionalWhite,
                                                                      borderRadius:
                                                                          66.0,
                                                                      text: viewModel
                                                                              .popularLanguageTitles[
                                                                          index],
                                                                      textStyle: currentTextTheme.headline3?.copyWith(
                                                                              fontWeight: FontWeight.w400,
                                                                              color: ColorConstant.instance.greyScale900) ??
                                                                          const TextStyle(),
                                                                      onChangedCheckBox:
                                                                          (_) {},
                                                                    ),
                                                                    SizedBox(
                                                                        height: viewModel.popularLanguageTitles[index] ==
                                                                                "German"
                                                                            ? 0.0
                                                                            : 15.0),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          },
                                                        ),
                                                        Text(
                                                          LocaleKeys.all_lang
                                                              .tr(),
                                                          style:
                                                              currentTextTheme
                                                                  .headline3
                                                                  ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: ColorConstant
                                                                .instance
                                                                .greyScale600,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        const SizedBox(
                                                            height: 15.0),
                                                        ListView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              const ClampingScrollPhysics(),
                                                          itemCount: viewModel
                                                              .languages.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Consumer<
                                                                ConversationRoomViewModel>(
                                                              builder: (context,
                                                                  state,
                                                                  child) {
                                                                return Column(
                                                                  children: [
                                                                    LanguageButton(
                                                                      image: viewModel
                                                                          .languages[
                                                                              index]
                                                                          .flag!,
                                                                      languageId: viewModel
                                                                          .languages[
                                                                              index]
                                                                          .id!,
                                                                      selectedIndex:
                                                                          state
                                                                              .selectedIndex,
                                                                      onTap:
                                                                          () {
                                                                        viewModel.selectedLanguageId = viewModel
                                                                            .languages[index]
                                                                            .id!;
                                                                        state.changeCheckboxStatus(
                                                                            index:
                                                                                index);
                                                                        viewModel.selectedIndex =
                                                                            index;
                                                                        viewModel.nativeLanguage = viewModel
                                                                            .languages[index]
                                                                            .title!;
                                                                        viewModel.nativePopularLanguage =
                                                                            '';
                                                                      },
                                                                      widthValue:
                                                                          width(
                                                                              1.0),
                                                                      heightValue:
                                                                          height(
                                                                              0.07),
                                                                      backgroundColor: ColorConstant
                                                                          .instance
                                                                          .additionalWhite,
                                                                      borderRadius:
                                                                          66.0,
                                                                      text: viewModel
                                                                          .languages[
                                                                              index]
                                                                          .title!,
                                                                      textStyle: currentTextTheme.headline3?.copyWith(
                                                                              fontWeight: FontWeight.w400,
                                                                              color: ColorConstant.instance.greyScale900) ??
                                                                          const TextStyle(),
                                                                      onChangedCheckBox:
                                                                          (value) {},
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            15.0),
                                                                  ],
                                                                );
                                                              },
                                                            );
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
                                      child: Text(
                                        viewModel.nativeLanguage == '' &&
                                                viewModel
                                                        .nativePopularLanguage ==
                                                    ''
                                            ? state.conversationModel
                                                .nativeLanguage!.title!
                                            : viewModel.nativeLanguage == ''
                                                ? viewModel
                                                    .nativePopularLanguage
                                                : viewModel.nativeLanguage,
                                        style: currentTextTheme.headline3
                                            ?.copyWith(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
                                          color: ColorConstant
                                              .instance.greyScale900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              Text(
                                viewModel.translateModel.message!,
                                style: currentTextTheme.headline1?.copyWith(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: ColorConstant.instance.greyScale600,
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
              ),
            );
          },
        );
      },
    );
  }
}
