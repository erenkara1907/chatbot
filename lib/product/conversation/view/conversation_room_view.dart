// ignore_for_file: prefer_final_fields, unused_field, must_be_immutable, use_build_context_synchronously, unused_element

import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/constants/image_constant.dart';
import 'package:chatbot/core/utils/tts.dart';
import 'package:chatbot/core/view/base/base_state.dart';
import 'package:chatbot/product/conversation/view/text_widget.dart';
import 'package:chatbot/product/conversation/viewmodel/conversation_room_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../core/constants/icon_constant.dart';
import '../../../core/language/locale_keys.g.dart';
import '../../../core/view/widget/button/app_button.dart';
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
  SpeechToText speechToText = SpeechToText();
  bool _isTyping = false;
  bool? _isFirst;

  var isListening = false;

  ConversationRoomViewModel viewModel = ConversationRoomViewModel();

  late TextEditingController sendTextController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;
  bool isEnabledPermission = false;

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

  setComplete(ConversationRoomViewModel chatProvider) {
    if (chatProvider.endChat == 1) {
      Provider.of<ConversationRoomViewModel>(context, listen: false)
          .setIsComplete();
    }
  }

  Future<void> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    final isAvailable = await speechToText.initialize();

    if (status.isGranted && isAvailable) {
      // Kullanıcı izin verdi, devam edebilirsiniz.
      isEnabledPermission = true;
    } else if (status.isDenied || !isAvailable) {
      // Kullanıcı izni reddetti, kullanıcıyı bilgilendirebilirsiniz.
      showAlertDialog(context);
    } else if (status.isPermanentlyDenied || !isAvailable) {
      // Kullanıcı izinleri kalıcı olarak reddetti, ayarlara yönlendirebilirsiniz.
      showAlertDialog(context);
    }
  }

  showAlertDialog(context) => showCupertinoDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('Permission Denied'),
          content: const Text('Allow access to gallery and photos'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => openAppSettings(),
              child: const Text('Settings'),
            ),
          ],
        ),
      );

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
    return GestureDetector(
      onTap: () => viewModel.startFocusNode(),
      child: Scaffold(
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
                    color: chatProvider.isActive == 0 ||
                            chatProvider.endChat == 1 ||
                            chatProvider.endChat == 3
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
        body: chatProvider.endChat != 1
            ? chatBody(chatProvider, context)
            : chatProvider.isActive == 0
                ? chatBody(chatProvider, context)
                : Stack(
                    children: [
                      chatBody(chatProvider, context),
                      completeDialog(chatProvider)
                    ],
                  ),
      ),
    );
  }

  Align completeDialog(ConversationRoomViewModel chatProvider) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: SizedBox(
            width: width(0.6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 125.0,
                  height: 125.0,
                  child: Lottie.asset("assets/lottie/lottie_finish_chat.json",
                      fit: BoxFit.fill),
                ),
                Text(
                  "Do you want to complete the conversation?",
                  style: currentTextTheme.headline3?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: ColorConstant.instance.greyScale900,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25.0),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            chatProvider.endChat = 3;
                          });
                        },
                        child: Text(
                          "Continue",
                          style: currentTextTheme.headline4?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: ColorConstant.instance.greyScale900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15.0),
                    Expanded(
                      child: AppButton(
                        onTap: () async {
                          await chatProvider.sendToBackendRateId(
                            context,
                            conversationId: widget.conversationId,
                            endConversationId: 1,
                          );
                          rateDialog(context, chatProvider);
                        },
                        widthValue: width(1.0),
                        heightValue: height(0.05),
                        backgroundColor: ColorConstant.instance.greyScale900,
                        borderRadius: 16.0,
                        text: "Complete",
                        textStyle: currentTextTheme.headline4?.copyWith(
                                fontWeight: FontWeight.w400,
                                color:
                                    ColorConstant.instance.additionalWhite) ??
                            const TextStyle(),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  SafeArea chatBody(
      ConversationRoomViewModel chatProvider, BuildContext context) {
    return SafeArea(
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
                  chatProvider.endChat == 1 || chatProvider.endChat == 3
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                  Consumer<ConversationRoomViewModel>(
                    builder: (context, state, child) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: SizedBox(
                          width: width(1.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: SizedBox(
                                  width: width(1.0),
                                  // height: height(0.075),
                                  child: TextField(
                                    maxLines: null,
                                    enabled: chatProvider.isActive == 0
                                        ? false
                                        : true,
                                    controller: sendTextController,
                                    focusNode: viewModel.sendMessageFocusNode,
                                    style: currentTextTheme.headline3?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color:
                                          ColorConstant.instance.greyScale900,
                                    ),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: ColorConstant
                                          .instance.additionalWhite,
                                      suffixIcon: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          width: 44.0,
                                          height: 44.0,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              color: ColorConstant
                                                  .instance.greyScale300),
                                          child: Center(
                                            child: IconButton(
                                              onPressed: () async {
                                                await sendMessage(
                                                    chatProvider: chatProvider);
                                              },
                                              icon: SvgPicture.asset(
                                                  IconConstant
                                                      .instance.iconSend),
                                            ),
                                          ),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        borderSide: BorderSide(
                                          width: 1.0,
                                          color: ColorConstant
                                              .instance.greyScale400,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        borderSide: BorderSide(
                                          width: 1.0,
                                          color: ColorConstant
                                              .instance.greyScale400,
                                        ),
                                      ),
                                      hintText: chatProvider.isActive == 0
                                          ? 'Chat is completed'
                                          : LocaleKeys.ask.tr(),
                                      hintStyle:
                                          currentTextTheme.headline3?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color:
                                            ColorConstant.instance.greyScale500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15.0),
                              Expanded(
                                child: SizedBox(
                                  height: 70.0,
                                  child: AvatarGlow(
                                    endRadius: 95.0,
                                    animate: isListening,
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    glowColor: Colors.blue,
                                    repeat: true,
                                    repeatPauseDuration:
                                        const Duration(milliseconds: 100),
                                    showTwoGlows: true,
                                    child: GestureDetector(
                                      onLongPressUp: () {
                                        HapticFeedback.mediumImpact();
                                        setState(() {
                                          isListening = false;
                                        });
                                        speechToText.stop();
                                      },
                                      onLongPressDown: (_) {
                                        if (isEnabledPermission) {
                                          HapticFeedback.mediumImpact();
                                          setState(() {
                                            isListening = true;
                                            speechToText.listen(
                                              onResult: (result) {
                                                sendTextController.text =
                                                    result.recognizedWords;
                                              },
                                            );
                                          });
                                        }
                                      },
                                      onTap: () =>
                                          requestMicrophonePermission(),
                                      child: CircleAvatar(
                                        backgroundColor:
                                            ColorConstant.instance.greyScale900,
                                        radius: 25.0,
                                        child: Icon(
                                          isListening
                                              ? Icons.mic
                                              : Icons.mic_none,
                                          color: ColorConstant
                                              .instance.additionalWhite,
                                          size: 25.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )
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
        child: chatProvider.chatList[index].role == 'user'
            ? chats(chatProvider, index)
            : SizedBox(
                width: width(1.0),
                child: Row(
                  children: [
                    Expanded(child: chats(chatProvider, index)),
                    const SizedBox(width: 15.0),
                    Consumer<TextToSpeechViewModel>(
                      builder: (context, state, child) {
                        return state.isCompleted
                            ? const Center()
                            : index == state.selectedIndex
                                ? CircleAvatar(
                                    backgroundColor:
                                        ColorConstant.instance.greyScale400,
                                    radius: 15.0,
                                    child: IconButton(
                                      onPressed: () async {
                                        HapticFeedback.heavyImpact();
                                        state.stop();
                                      },
                                      icon: Icon(
                                        Icons.mic_off,
                                        color: ColorConstant
                                            .instance.additionalRed,
                                        size: 15.0,
                                      ),
                                    ),
                                  )
                                : const Center();
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Container chats(ConversationRoomViewModel chatProvider, int index) {
    return Container(
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
                    : SizedBox(
                        width: width(0.2),
                        height: 50.0,
                        child: Row(
                          children: [
                            Expanded(
                              child: CircleAvatar(
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
                            ),
                            const SizedBox(width: 10.0),
                            Consumer<TextToSpeechViewModel>(
                              builder: (context, state, child) {
                                return state.isCompleted
                                    ? Expanded(
                                        child: CircleAvatar(
                                          backgroundColor: ColorConstant
                                              .instance.greyScale400,
                                          radius: 15.0,
                                          child: IconButton(
                                            onPressed: () async {
                                              HapticFeedback.heavyImpact();
                                              state.speak(chatProvider
                                                  .chatList[index].message);
                                              state.changeSelectedIndex(index);
                                            },
                                            icon: Icon(
                                              Icons.mic,
                                              color: ColorConstant
                                                  .instance.greyScale600,
                                              size: 15.0,
                                            ),
                                          ),
                                        ),
                                      )
                                    : index == state.selectedIndex
                                        ? Expanded(
                                            child: AvatarGlow(
                                              showTwoGlows: true,
                                              endRadius: 35.0,
                                              animate: !state.isCompleted,
                                              duration: const Duration(
                                                  milliseconds: 1500),
                                              glowColor: Colors.blue,
                                              repeat: true,
                                              repeatPauseDuration:
                                                  const Duration(
                                                      milliseconds: 100),
                                              child: CircleAvatar(
                                                backgroundColor: ColorConstant
                                                    .instance.greyScale400,
                                                radius: 15.0,
                                                child: IconButton(
                                                  onPressed: () async {
                                                    state.speak(chatProvider
                                                        .chatList[index]
                                                        .message);
                                                    state.changeSelectedIndex(
                                                        index);
                                                  },
                                                  icon: Center(
                                                    child: Icon(
                                                      Icons.mic,
                                                      color: ColorConstant
                                                          .instance
                                                          .greyScale600,
                                                      size: 15.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Expanded(
                                            child: CircleAvatar(
                                              backgroundColor: ColorConstant
                                                  .instance.greyScale400,
                                              radius: 15.0,
                                              child: IconButton(
                                                onPressed: () async {
                                                  HapticFeedback.heavyImpact();
                                                  state.speak(chatProvider
                                                      .chatList[index].message);
                                                  state.changeSelectedIndex(
                                                      index);
                                                },
                                                icon: Icon(
                                                  Icons.mic,
                                                  color: ColorConstant
                                                      .instance.greyScale600,
                                                  size: 15.0,
                                                ),
                                              ),
                                            ),
                                          );
                              },
                            )
                          ],
                        ),
                      ),
              ],
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
                    vertical: 24.0,
                  ),
                  child: FutureBuilder(
                    future: viewModel.translate(
                      conversationId: widget.conversationId,
                      messageId: state.chatList[index].id,
                      translateTitle: viewModel.nativeLanguage,
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
                                                                      languageId:
                                                                          index +
                                                                              1,
                                                                      selectedIndex:
                                                                          state
                                                                              .selectedIndex,
                                                                      onTap:
                                                                          () {
                                                                        viewModel.selectedLanguageId = viewModel
                                                                            .languages[index]
                                                                            .id!;
                                                                        viewModel.selectedLanguageCode = viewModel
                                                                            .languages[index]
                                                                            .code!;
                                                                        state.changeCheckboxStatus(
                                                                            index:
                                                                                index);
                                                                        viewModel.selectedIndex =
                                                                            index;
                                                                        viewModel.nativeLanguage = viewModel
                                                                            .languages[index]
                                                                            .title!;
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
                                        viewModel.nativeLanguage == ''
                                            ? state.conversationModel
                                                .nativeLanguage!.title!
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
