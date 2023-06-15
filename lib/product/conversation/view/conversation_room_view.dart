// ignore_for_file: prefer_final_fields, unused_field, must_be_immutable, use_build_context_synchronously, unused_element

import 'dart:io';
import 'dart:ui';

import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/utils/tts.dart';
import 'package:chatbot/core/view/base/base_state.dart';
import 'package:chatbot/product/conversation/viewmodel/conversation_room_view_model.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../core/constants/icon_constant.dart';
import '../../../core/constants/image_constant.dart';
import '../../../core/language/locale_keys.g.dart';
import '../../../core/view/widget/button/app_button.dart';
import '../../../core/view/widget/button/language_button.dart';
import '../../bottom_bar/view/bottom_bar_view.dart';

class ConversationRoomView extends StatefulWidget {
  final int conversationId;
  final String scenarioTitle;
  final String profilePhoto;
  // final List<Messages> messages;

  const ConversationRoomView({
    Key? key,
    required this.conversationId,
    required this.scenarioTitle,
    required this.profilePhoto,
    // this.messages = const [],
  }) : super(key: key);
  @override
// ignore: library_private_types_in_public_api
  _ConversationRoomViewState createState() => _ConversationRoomViewState();
}

class _ConversationRoomViewState extends BaseState<ConversationRoomView> {
  // SpeechToText speechToText = SpeechToText();

  bool? _isFirst;
  bool isScroll = true;

  // var isListening = false;

  ConversationRoomViewModel viewModel = ConversationRoomViewModel();
  TextToSpeechViewModel textViewModel = TextToSpeechViewModel();

  // late TextEditingController sendTextController;
  late ScrollController _listScrollController;
  // late TextEditingController sendMessageController;

  late FocusNode focusNode;
  late FlutterSoundRecorder _recorder;

  String _path = '';
  bool isData = false;

  @override
  void initState() {
    Provider.of<ConversationRoomViewModel>(context, listen: false)
        .getAllMessages(conversationId: widget.conversationId);
    requestPermission();
    _recorder = FlutterSoundRecorder();
    _listScrollController = ScrollController();
    // sendTextController = TextEditingController();
    Provider.of<ConversationRoomViewModel>(context, listen: false)
        .sendTextController = TextEditingController();
    focusNode = FocusNode();
    _isFirst = true;
    viewModel.sendTextController = TextEditingController();

    super.initState();
  }

  requestPermission() async {
    await Permission.microphone.request();
  }

  _startRecording(ConversationRoomViewModel chatProvider) async {
    final status = await Permission.microphone.request();
    // final myRecorder = FlutterSoundRecorder();
    final player = AudioPlayer();

    if (status.isGranted) {
      try {
        HapticFeedback.mediumImpact();
        await player.play(AssetSource("sound/sound_click.wav"));
        chatProvider.addUserMessage(message: "Yükleniyor");
        // Uygulamanın kendi dosya yolunu alıyoruz
        Directory appDocDirectory = await getApplicationDocumentsDirectory();
        await player.play(AssetSource("sound/sound_user_bubble.wav"));

        // Dosyanın kaydedileceği yolu belirliyoruz
        _path = '${appDocDirectory.path}/soundfile.wav';

        // Kaydediciyi başlatıyoruz
        await _recorder.openRecorder();
        await _recorder.startRecorder(toFile: _path);

        // await Future.delayed(
        //     const Duration(seconds: 20)); // Örnek olarak 10 saniye bekliyoruz

        // // Kaydediciyi durduruyoruz
        // await _recorder.stopRecorder();
        // // Kaydediciyi kapatıyoruz
        // await _recorder.closeRecorder();
      } catch (e) {
        await _recorder.stopRecorder();
        // Kaydediciyi kapatıyoruz
        await _recorder.closeRecorder();
        // chatProvider.chatList.removeLast();
        chatProvider.addUserMessage(message: "Please try again");
      }
    } else if (status.isDenied) {
      chatProvider.isRecording = false;
      viewModel.showAlertDialog(context);
    } else if (status.isPermanentlyDenied) {
      chatProvider.isRecording = false;
      viewModel.showAlertDialog(context);
    }
  }

  void _stopRecording(ConversationRoomViewModel chatProvider) async {
    final player = AudioPlayer();

    await _recorder.stopRecorder();
    await _recorder.closeRecorder();
    HapticFeedback.mediumImpact();
    await player.play(AssetSource("sound/sound_click.wav"));

    _uploadAudio(_path, chatProvider);
  }

  void _uploadAudio(
    String path,
    ConversationRoomViewModel chatProvider,
  ) async {
    Dio dio = Dio();
    String uploadUrl = "https://transcribe.whisperapi.com";
    try {
      var response = await dio.post(
        uploadUrl,
        data: FormData.fromMap({
          "file": await MultipartFile.fromFile(path, filename: 'audio.wav'),
          "diarization": "false",
          "numSpeakers": "2",
          "fileType": "wav",
          "language": "en",
          "task": "transcribe",
        }),
        options: Options(
          headers: {'Authorization': 'Bearer L62YXPXSBF57TZGF7U4NDFG6B45R8STX'},
        ),
      );

      if (response.statusCode == 200) {
        // provider.addMessage(response.data["text"]);
        viewModel.sendTextController.clear();
        chatProvider.chatList.removeLast();
        scrollListToEND();

        viewModel.sendTextController.text = response.data["text"];
        sendMessage(
            chatProvider:
                Provider.of<ConversationRoomViewModel>(context, listen: false),
            context);
      }
    } catch (e) {
      await _recorder.stopRecorder();
      // Kaydediciyi kapatıyoruz
      await _recorder.closeRecorder();
      // chatProvider.chatList.removeLast();
      chatProvider.addUserMessage(message: "Please try again");
    }
  }

  setComplete(ConversationRoomViewModel chatProvider) {
    if (chatProvider.endChat == 1) {
      Provider.of<ConversationRoomViewModel>(context, listen: false)
          .setIsComplete();
    }
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    Provider.of<ConversationRoomViewModel>(context, listen: false)
        .sendTextController
        .dispose();
    focusNode.dispose();
    _recorder.dispositionStream();
    viewModel.sendTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var chatProvider = Provider.of<ConversationRoomViewModel>(context);

    return GestureDetector(
      onTap: () => viewModel.startFocusNode(),
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
                width: width(1.0),
                fit: BoxFit.cover,
              ),
            ),
            chatProvider.isGetMessage
                ? chatProvider.endChat != 1
                    ? chatBody(chatProvider, context)
                    : chatProvider.isActive == 0
                        ? chatBody(chatProvider, context)
                        : Stack(
                            children: [
                              chatBody(chatProvider, context),
                              completeDialog(chatProvider)
                            ],
                          )
                : skeletonLoading(),
          ],
        ),
      ),
    );
  }

  ListView skeletonLoading() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: height(0.1),
                  width: width(0.5),
                  decoration: BoxDecoration(
                    color: ColorConstant.instance.greyScale200,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0),
                    ),
                  ),
                  child: Center(
                    child: SkeletonParagraph(
                      style: SkeletonParagraphStyle(
                        lines: 2,
                        lineStyle: SkeletonLineStyle(
                          width: width(0.4),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: height(0.07),
                  width: width(0.5),
                  decoration: BoxDecoration(
                    color: ColorConstant.instance.greyScale200,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                      bottomLeft: Radius.circular(16.0),
                    ),
                  ),
                  child: Center(
                    child: SkeletonParagraph(
                      style: SkeletonParagraphStyle(
                        lines: 1,
                        lineStyle: SkeletonLineStyle(
                          width: width(0.4),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
                          chatProvider.isGetMessage = false;
                          Provider.of<ConversationRoomViewModel>(context,
                                  listen: false)
                              .isReadMessage = false;
                          textViewModel.stop();
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_listScrollController.hasClients) {
        _listScrollController.animateTo(
          _listScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: !chatProvider.isData
            ? Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 25.0,
                        height: 25.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          border: Border.all(
                              color: ColorConstant.instance.paletteGrey),
                        ),
                        child: IconButton(
                          onPressed: () {
                            textViewModel.stop();
                            chatProvider.isGetMessage = false;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BottomBarView()));
                          },
                          icon: SvgPicture.asset(
                            IconConstant.instance.iconArrowBack,
                            color: ColorConstant.instance.paletteGrey,
                            width: 25.0,
                            height: 25.0,
                          ),
                        ),
                      ),
                      Text(
                        "Speaking to Talkios",
                        style: currentTextTheme.subtitle1?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: ColorConstant.instance.additionalWhite,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Expanded(
                    child: ListView.builder(
                      controller: _listScrollController,
                      itemCount: chatProvider.getChatList.length,
                      addAutomaticKeepAlives: false,
                      addRepaintBoundaries: false,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        // isScroll = false;
                        return chatWidget(
                          chatProvider,
                          index,
                        );
                      },
                    ),
                  ),
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
                      return state.isSelectVoice
                          ? voiceButton(context)
                          : sendMessageInput(chatProvider);
                    },
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
                  // if (_isTyping) ...[
                  //   const SpinKitThreeBounce(
                  //     color: Colors.black,
                  //     size: 18.0,
                  //   )
                  // ],
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

  SizedBox sendMessageInput(ConversationRoomViewModel chatProvider) {
    return SizedBox(
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
                enabled: chatProvider.isActive == 0 ? false : true,
                controller: viewModel.sendTextController,
                focusNode: viewModel.sendMessageFocusNode,
                style: currentTextTheme.headline3?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: ColorConstant.instance.greyScale900,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Provider.of<ConversationRoomViewModel>(context,
                                    listen: false)
                                .selectVoice(true);
                            speakModal(context);
                          },
                          child: SvgPicture.asset(
                            IconConstant.instance.iconVoice,
                            width: 24.0,
                            height: 24.0,
                            color: ColorConstant.instance.additionalWhite
                                .withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(width: 15.0),
                        Container(
                          width: 44.0,
                          height: 44.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: const Color.fromRGBO(56, 57, 59, 1),
                          ),
                          child: Center(
                            child: IconButton(
                              onPressed: () async {
                                // await sendMessage(
                                //     chatProvider:
                                //         chatProvider);
                                // sendTextController.clear();
                              },
                              icon: SvgPicture.asset(
                                IconConstant.instance.iconSend,
                                color: ColorConstant.instance.additionalWhite,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide: BorderSide(
                      width: 1.0,
                      color: ColorConstant.instance.additionalWhite,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide: BorderSide(
                      width: 1.0,
                      color: ColorConstant.instance.additionalWhite,
                    ),
                  ),
                  hintText: chatProvider.isActive == 0
                      ? 'Chat is completed'
                      : LocaleKeys.ask.tr(),
                  hintStyle: currentTextTheme.headline3?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: ColorConstant.instance.additionalWhite,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column voiceButton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: AvatarGlow(
            endRadius: 75.0,
            animate:
                Provider.of<ConversationRoomViewModel>(context).isRecording,
            duration: const Duration(milliseconds: 500),
            glowColor: const Color.fromRGBO(71, 115, 254, 1),
            repeat: true,
            repeatPauseDuration: const Duration(milliseconds: 100),
            showTwoGlows: true,
            curve: Curves.fastOutSlowIn,
            child: GestureDetector(
              onTap: () async {
                speakModal(context);
              },
              child: Consumer<ConversationRoomViewModel>(
                builder: (context, state, child) {
                  return Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 55.0,
                      backgroundColor: const Color.fromRGBO(120, 122, 124, 0.2),
                      child: CircleAvatar(
                        radius: 40.0,
                        backgroundColor:
                            const Color.fromRGBO(120, 122, 124, 0.4),
                        child: CircleAvatar(
                          backgroundColor: state.isRecording
                              ? ColorConstant.instance.additionalWhite
                              : const Color.fromRGBO(172, 173, 177, 1),
                          foregroundColor: Colors.red,
                          radius: 30.0,
                          child: state.isRecording
                              ? ColorFiltered(
                                  colorFilter: const ColorFilter.mode(
                                    Color.fromRGBO(71, 115, 254, 1),
                                    BlendMode.modulate,
                                  ),
                                  child: Lottie.asset(
                                    "assets/lottie/lottie_recording.json",
                                    width: 45.0,
                                    height: 45.0,
                                  ),
                                )
                              : SvgPicture.asset(
                                  IconConstant.instance.iconVoice),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Provider.of<ConversationRoomViewModel>(context, listen: false)
                .selectVoice(false);
          },
          child: Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(50.0),
              border: Border.all(
                color: ColorConstant.instance.additionalWhite,
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                IconConstant.instance.iconKeyboard,
                width: 15.0,
                height: 15.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<dynamic> speakModal(BuildContext context) {
    return showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: FractionallySizedBox(
            heightFactor: 1.0,
            child: Container(
              decoration: BoxDecoration(
                color: ColorConstant.instance.paletteBackground,
              ),
              width: width(1.0),
              child: Stack(
                children: [
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Image.asset(
                      ImageConstant.instance.imageTopEllipse,
                      width: width(1.0),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 68.0, right: 24.0, left: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            speakHeader(context),
                            const SizedBox(height: 17.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(width: 24.0),
                                Text(
                                  "Go ahead, I’m listening",
                                  style: currentTextTheme.caption?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color:
                                        const Color.fromRGBO(155, 150, 161, 1),
                                    fontSize: 14.0,
                                  ),
                                ),
                                const SizedBox(),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 39.0),
                        Image.asset(ImageConstant.instance.imageAI),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Text(
                            "I am going to the cinema, I am going to read a book.",
                            style: currentTextTheme.caption?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: ColorConstant.instance.additionalWhite,
                              fontSize: 20.0,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Expanded(
                          flex: 2,
                          child: SizedBox(),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: AvatarGlow(
                                endRadius: 75.0,
                                animate: Provider.of<ConversationRoomViewModel>(
                                        context)
                                    .isRecording,
                                duration: const Duration(milliseconds: 500),
                                glowColor:
                                    const Color.fromRGBO(71, 115, 254, 1),
                                repeat: true,
                                repeatPauseDuration:
                                    const Duration(milliseconds: 100),
                                showTwoGlows: true,
                                curve: Curves.fastOutSlowIn,
                                child: GestureDetector(
                                  onTap: () {
                                    textViewModel.isSpeaking = true;
                                    Provider.of<TextToSpeechViewModel>(context,
                                            listen: false)
                                        .selectedIndex = -1;
                                    textViewModel.stop();
                                    Provider.of<ConversationRoomViewModel>(
                                            context,
                                            listen: false)
                                        .setIsRecord();
                                    if (Provider.of<ConversationRoomViewModel>(
                                            context,
                                            listen: false)
                                        .isRecording) {
                                      _startRecording(Provider.of<
                                              ConversationRoomViewModel>(
                                          context,
                                          listen: false));
                                    } else {
                                      _stopRecording(Provider.of<
                                              ConversationRoomViewModel>(
                                          context,
                                          listen: false));
                                    }
                                  },
                                  child: Consumer<ConversationRoomViewModel>(
                                    builder: (context, state, child) {
                                      return Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: CircleAvatar(
                                          radius: 55.0,
                                          backgroundColor: const Color.fromRGBO(
                                              120, 122, 124, 0.2),
                                          child: CircleAvatar(
                                            radius: 40.0,
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    120, 122, 124, 0.4),
                                            child: CircleAvatar(
                                              backgroundColor: state.isRecording
                                                  ? ColorConstant
                                                      .instance.additionalWhite
                                                  : const Color.fromRGBO(
                                                      172, 173, 177, 1),
                                              foregroundColor: Colors.red,
                                              radius: 30.0,
                                              child: state.isRecording
                                                  ? ColorFiltered(
                                                      colorFilter:
                                                          const ColorFilter
                                                              .mode(
                                                        Color.fromRGBO(
                                                            71, 115, 254, 1),
                                                        BlendMode.modulate,
                                                      ),
                                                      child: Lottie.asset(
                                                        "assets/lottie/lottie_recording.json",
                                                        width: 45.0,
                                                        height: 45.0,
                                                      ),
                                                    )
                                                  : SvgPicture.asset(
                                                      IconConstant
                                                          .instance.iconVoice),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            InkWell(
                              onTap: () {
                                Provider.of<ConversationRoomViewModel>(context,
                                        listen: false)
                                    .selectVoice(false);
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(50.0),
                                  border: Border.all(
                                    color:
                                        ColorConstant.instance.additionalWhite,
                                  ),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    IconConstant.instance.iconKeyboard,
                                    width: 15.0,
                                    height: 15.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Row speakHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 25.0,
          height: 25.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            border: Border.all(color: ColorConstant.instance.paletteGrey),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              IconConstant.instance.iconArrowBack,
              color: ColorConstant.instance.paletteGrey,
              width: 25.0,
              height: 25.0,
            ),
          ),
        ),
        Column(
          children: [
            Text(
              "Speaking to Talkios",
              style: currentTextTheme.subtitle1?.copyWith(
                fontWeight: FontWeight.w500,
                color: ColorConstant.instance.additionalWhite,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
        const SizedBox(),
      ],
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

  Future<dynamic> pronunciationAndGrammer() {
    return showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: DefaultTabController(
            length: 2,
            child: FractionallySizedBox(
              heightFactor: 0.8,
              child: Container(
                width: width(1.0),
                decoration: BoxDecoration(
                  color: ColorConstant.instance.paletteBackground,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Stack(
                  children: [
                    proAndGrammer(context),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Image.asset(
                        ImageConstant.instance.imageBottomEllipse,
                        width: width(1.0),
                        fit: BoxFit.cover,
                      ),
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

  Padding proAndGrammer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 24.0,
      ),
      child: Column(
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70.0),
            child: segmentTabBar(),
          ),
          Expanded(
            child: TabBarView(children: [
              grammarView(),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  children: [
                    CircularPercentIndicator(
                      radius: 55.0,
                      lineWidth: 7.0,
                      percent: 0.8, // Yüzde değeri, 0.0 - 1.0 aralığında olmalı
                      center: Text(
                        '80',
                        style: currentTextTheme.subtitle1?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: ColorConstant.instance.additionalWhite,
                          fontSize: 32.0,
                        ),
                      ),
                      progressColor: ColorConstant.instance.palettePurple,
                      backgroundColor: ColorConstant.instance.paletteGrey,
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      "Good",
                      style: currentTextTheme.subtitle1?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.instance.additionalWhite,
                        fontSize: 20.0,
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    Text(
                      "I will go to the cinema",
                      style: currentTextTheme.subtitle1?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: ColorConstant.instance.paletteBlue,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        avatarButton(),
                        const SizedBox(width: 20.0),
                        avatarButton(),
                      ],
                    ),
                    const Expanded(child: SizedBox()),
                    Text(
                      "Practice",
                      style: currentTextTheme.caption?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: const Color.fromRGBO(155, 150, 161, 1),
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 55.0,
                        backgroundColor:
                            const Color.fromRGBO(120, 122, 124, 0.2),
                        child: CircleAvatar(
                          radius: 40.0,
                          backgroundColor:
                              const Color.fromRGBO(120, 122, 124, 0.4),
                          child: CircleAvatar(
                            backgroundColor:
                                const Color.fromRGBO(172, 173, 177, 1),
                            foregroundColor: Colors.red,
                            radius: 30.0,
                            child: SvgPicture.asset(
                                IconConstant.instance.iconVoice),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ]),
          )
        ],
      ),
    );
  }

  Widget avatarButton() {
    return SizedBox(
      width: 91.0,
      height: 51.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(60, 70, 72, 0.7),
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        onPressed: () {},
        child: Row(
          children: [
            CircleAvatar(
              radius: 13.0,
              backgroundColor: ColorConstant.instance.greyScale300,
            ),
            const SizedBox(width: 10.0),
            SvgPicture.asset(
              IconConstant.instance.iconVoice,
              width: 18.0,
              height: 22.0,
              color: ColorConstant.instance.additionalWhite,
            ),
          ],
        ),
      ),
    );
  }

  Padding grammarView() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "I want to go to cinema",
                style: currentTextTheme.caption?.copyWith(
                  fontWeight: FontWeight.w500,
                  color:
                      ColorConstant.instance.additionalWhite.withOpacity(0.6),
                  fontSize: 16.0,
                ),
              ),
              SvgPicture.asset(
                IconConstant.instance.iconWrong,
                width: 16.0,
                height: 16.0,
              )
            ],
          ),
          const SizedBox(height: 18.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "I want to go to the cinema.",
                style: currentTextTheme.caption?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: ColorConstant.instance.additionalWhite,
                  fontSize: 16.0,
                ),
              ),
              SvgPicture.asset(
                IconConstant.instance.iconCorrect,
                width: 16.0,
                height: 16.0,
              )
            ],
          ),
          const Expanded(child: SizedBox()),
          Text(
            "It's better to say",
            style: currentTextTheme.caption?.copyWith(
              fontWeight: FontWeight.w600,
              color: ColorConstant.instance.additionalWhite,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "I wanna go to cinema.",
                style: currentTextTheme.caption?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: ColorConstant.instance.additionalWhite,
                  fontSize: 14.0,
                ),
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 16.0,
                    backgroundColor: const Color.fromRGBO(60, 70, 72, 1),
                    child: IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        IconConstant.instance.iconTranslate,
                        width: 16.0,
                        height: 16.0,
                        color: ColorConstant.instance.additionalWhite,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  CircleAvatar(
                    radius: 16.0,
                    backgroundColor: const Color.fromRGBO(60, 70, 72, 1),
                    child: IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        IconConstant.instance.iconVoice,
                        width: 16.0,
                        height: 16.0,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 10.0),
          Text(
            "Sinemaya gitmek istiyorum",
            style: currentTextTheme.caption?.copyWith(
              fontWeight: FontWeight.w500,
              color: ColorConstant.instance.paletteBlue,
              fontSize: 14.0,
            ),
          ),
          const Expanded(flex: 2, child: SizedBox()),
        ],
      ),
    );
  }

  SegmentedTabControl segmentTabBar() {
    return SegmentedTabControl(
      textStyle: currentTextTheme.caption?.copyWith(
        fontWeight: FontWeight.w300,
        fontSize: 14.0,
      ),
      radius: const Radius.circular(30.0),
      backgroundColor: const Color.fromRGBO(60, 70, 72, 1),
      tabs: [
        SegmentTab(
          label: "Grammar",
          selectedTextColor: ColorConstant.instance.additionalWhite,
          color: const Color.fromRGBO(143, 143, 144, 1),
          textColor: ColorConstant.instance.additionalWhite,
        ),
        SegmentTab(
          label: "Diction",
          selectedTextColor: ColorConstant.instance.additionalWhite,
          color: const Color.fromRGBO(143, 143, 144, 1),
          textColor: ColorConstant.instance.additionalWhite,
        ),
      ],
    );
  }

  Container chats(ConversationRoomViewModel chatProvider, int index) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: chatProvider.chatList[index].role == 'user'
            ? ColorConstant.instance.paletteCard
            : chatProvider.chatList[index].message == 'Please try again.'
                ? ColorConstant.instance.additionalRed
                : const Color.fromRGBO(56, 57, 59, 1),
        borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20.0),
            topRight: const Radius.circular(20.0),
            bottomLeft: Radius.circular(
                chatProvider.chatList[index].role == 'user' ? 20.0 : 0.0),
            bottomRight: Radius.circular(
                chatProvider.chatList[index].role == 'user' ? 0.0 : 20.0)),
      ),
      child: chatProvider.chatList[index].role == 'user'
          ? (index + 1) == chatProvider.chatList.length
              ? SizedBox(
                  width: width(0.3),
                  child: SpinKitThreeBounce(
                    color: ColorConstant.instance.additionalWhite,
                    size: 18.0,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Text(
                              chatProvider.chatList[index].message,
                              style: currentTextTheme.headline3?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: ColorConstant.instance.additionalWhite,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Align(
                            alignment: Alignment.topRight,
                            child: CircleAvatar(
                              radius: 20.0,
                              backgroundImage:
                                  NetworkImage(widget.profilePhoto),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              chatProvider.translateMessage =
                                  chatProvider.chatList[index].message;
                              showTranslateMessage(context, index);
                            },
                            icon: Icon(
                              Icons.translate,
                              size: 14.0,
                              color: ColorConstant.instance.additionalWhite,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              pronunciationAndGrammer();
                            },
                            icon: SvgPicture.asset(
                              IconConstant.instance.iconPronunciation,
                              color: ColorConstant.instance.additionalWhite,
                              width: 14.0,
                              height: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
          : chatProvider.chatList[index].message == "Load"
              ? SizedBox(
                  width: width(0.1),
                  child: SpinKitThreeBounce(
                    color: ColorConstant.instance.greyScale600,
                    size: 18.0,
                  ),
                )
              : assistantMessage(chatProvider, index),
    );
  }

  Column assistantMessage(ConversationRoomViewModel chatProvider, int index) {
    if (index == chatProvider.getChatList.length - 1 &&
        !textViewModel.isSpeaking &&
        chatProvider.isReadMessage) {
      textViewModel.speak(chatProvider.chatList[index].message);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              ImageConstant.instance.imageAIProfile,
              width: 30.0,
              height: 30.0,
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: DefaultTextStyle(
                style: currentTextTheme.headline3?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                      color: chatProvider.chatList[index].message ==
                              'Please try again.'
                          ? ColorConstant.instance.additionalWhite
                          : ColorConstant.instance.additionalWhite,
                    ) ??
                    const TextStyle(),
                child: Text(chatProvider.chatList[index].message),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        chatProvider.chatList[index].message == 'Please try again.'
            ? const Center()
            : SizedBox(
                width: width(0.2),
                height: 50.0,
                child: Row(
                  children: [
                    Expanded(
                      child: IconButton(
                        iconSize: 18.0,
                        onPressed: () async {
                          chatProvider.translateMessage =
                              chatProvider.chatList[index].message;

                          showTranslateMessage(context, index);
                        },
                        icon: Icon(
                          Icons.translate,
                          color: ColorConstant.instance.additionalWhite,
                          size: 18.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Consumer<TextToSpeechViewModel>(
                      builder: (context, state, child) {
                        return state.isCompleted
                            ? Expanded(
                                child: IconButton(
                                  iconSize: 18.0,
                                  onPressed: () async {
                                    HapticFeedback.heavyImpact();

                                    state.speak(
                                        chatProvider.chatList[index].message);
                                    state.changeSelectedIndex(index);
                                  },
                                  icon: Icon(
                                    Icons.mic,
                                    color:
                                        ColorConstant.instance.additionalWhite,
                                    size: 18.0,
                                  ),
                                ),
                              )
                            : index == state.selectedIndex
                                ? Expanded(
                                    child: AvatarGlow(
                                      showTwoGlows: true,
                                      endRadius: 35.0,
                                      animate: !state.isCompleted,
                                      duration:
                                          const Duration(milliseconds: 1500),
                                      glowColor: Colors.blue,
                                      repeat: true,
                                      repeatPauseDuration:
                                          const Duration(milliseconds: 100),
                                      child: CircleAvatar(
                                        backgroundColor:
                                            ColorConstant.instance.greyScale400,
                                        radius: 15.0,
                                        child: IconButton(
                                          onPressed: () async {
                                            state.speak(chatProvider
                                                .chatList[index].message);
                                            state.changeSelectedIndex(index);
                                          },
                                          icon: Center(
                                            child: Icon(
                                              Icons.mic,
                                              color: ColorConstant
                                                  .instance.greyScale600,
                                              size: 15.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: CircleAvatar(
                                      backgroundColor:
                                          ColorConstant.instance.greyScale400,
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
                                  );
                      },
                    )
                  ],
                ),
              ),
      ],
    );
  }

  void scrollListToEND() {
    _listScrollController.animateTo(
      _listScrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  Future<void> sendMessage(BuildContext context,
      {required ConversationRoomViewModel chatProvider}) async {
    HapticFeedback.heavyImpact();

    ConversationRoomViewModel provider =
        Provider.of<ConversationRoomViewModel>(context, listen: false);

    // provider.isListening = false;

    // if (!provider.isListening) {
    //   provider.speechToText.stop();
    // }

    if (viewModel.isTyping) {
      showTopSnackBar(
        Overlay.of(context)!,
        const CustomSnackBar.error(
          message: "You cannot send multiple sounds at the same time",
        ),
      );
      return;
    }

    if (viewModel.sendTextController.text.isEmpty) {
      // chatProvider.chatList.removeLast();
      // chatProvider.addUserMessage(message: "Please send audio");
      showTopSnackBar(
        Overlay.of(context)!,
        const CustomSnackBar.error(
          message: "Please send audio",
        ),
      );
      return;
    }

    try {
      String msg = viewModel.sendTextController.text;
      _isFirst = false;

      viewModel.isTyping = true;

      chatProvider.addUserMessage(message: msg);
      provider.sendTextController.clear();

      focusNode.unfocus();

      await chatProvider.sendMessageAndGetAnswers(
        message: msg,
        conversationId: widget.conversationId,
      );
      textViewModel.isSpeaking = false;
      // chatProvider.tempList = chatProvider.chatList;
    } catch (error) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: TextWidget(
      //       label: error.toString(),
      //     ),
      //     backgroundColor: Colors.red,
      //   ),
      // );
    } finally {
      scrollListToEND();
      viewModel.isTyping = false;
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
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Consumer<ConversationRoomViewModel>(
            builder: (context, state, child) {
              return FractionallySizedBox(
                heightFactor: 0.9,
                child: Container(
                  width: width(1.0),
                  decoration: BoxDecoration(
                    color: ColorConstant.instance.paletteBackground,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Image.asset(
                          ImageConstant.instance.imageBottomEllipse,
                          width: width(1.0),
                          fit: BoxFit.cover,
                        ),
                      ),
                      translate(state, index),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Padding translate(ConversationRoomViewModel state, int index) {
    return Padding(
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
          } else if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 24.0,
                        height: 24.0,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(50.0),
                          border: Border.all(
                              color: ColorConstant.instance.paletteGrey),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.close,
                            size: 15.0,
                            color: ColorConstant.instance.paletteGrey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    LocaleKeys.message.tr(),
                    style: currentTextTheme.headline1?.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.instance.additionalWhite,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    state.translateMessage,
                    style: currentTextTheme.headline1?.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: ColorConstant.instance.additionalWhite,
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
                          fontWeight: FontWeight.w600,
                          color: ColorConstant.instance.additionalWhite,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                                width: 1.0,
                                color: ColorConstant.instance.additionalWhite),
                          ),
                        ),
                        onPressed: () {
                          changeLanguage(context);
                        },
                        child: Text(
                          viewModel.nativeLanguage == ''
                              ? state.conversationModel.nativeLanguage!.title!
                              : viewModel.nativeLanguage,
                          style: currentTextTheme.headline3?.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: ColorConstant.instance.additionalWhite,
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
                      color: ColorConstant.instance.additionalWhite,
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
    );
  }

  Future<dynamic> changeLanguage(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.88,
          child: Container(
            width: width(1.0),
            decoration: BoxDecoration(
                color: ColorConstant.instance.additionalWhite,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                )),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15.0),
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
                              color: ColorConstant.instance.greyScale900,
                              size: 15.0,
                            )),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Text(
                      LocaleKeys.all_lang.tr(),
                      style: currentTextTheme.headline3?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: ColorConstant.instance.greyScale600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15.0),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: viewModel.languages.length,
                      itemBuilder: (context, index) {
                        return Consumer<ConversationRoomViewModel>(
                          builder: (context, state, child) {
                            return Column(
                              children: [
                                LanguageButton(
                                  image: viewModel.languages[index].flag!,
                                  languageId: index + 1,
                                  selectedIndex: state.selectedIndex,
                                  onTap: () {
                                    viewModel.selectedLanguageId =
                                        viewModel.languages[index].id!;
                                    viewModel.selectedLanguageCode =
                                        viewModel.languages[index].code!;
                                    state.changeCheckboxStatus(index: index);
                                    viewModel.selectedIndex = index;
                                    viewModel.nativeLanguage =
                                        viewModel.languages[index].title!;
                                  },
                                  widthValue: width(1.0),
                                  heightValue: height(0.07),
                                  backgroundColor:
                                      ColorConstant.instance.additionalWhite,
                                  borderRadius: 66.0,
                                  text: viewModel.languages[index].title!,
                                  textStyle: currentTextTheme.headline3
                                          ?.copyWith(
                                              fontWeight: FontWeight.w400,
                                              color: ColorConstant
                                                  .instance.greyScale900) ??
                                      const TextStyle(),
                                  onChangedCheckBox: (value) {
                                    viewModel.selectedLanguageId =
                                        viewModel.languages[index].id!;
                                    viewModel.selectedLanguageCode =
                                        viewModel.languages[index].code!;
                                    state.changeCheckboxStatus(index: index);
                                    viewModel.selectedIndex = index;
                                    viewModel.nativeLanguage =
                                        viewModel.languages[index].title!;
                                  },
                                ),
                                const SizedBox(height: 15.0),
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
  }
}
