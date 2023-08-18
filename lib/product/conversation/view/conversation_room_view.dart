// ignore_for_file: prefer_final_fields, unused_field, must_be_immutable, use_build_context_synchronously, unused_element, deprecated_member_use, unrelated_type_equality_checks

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/utils/speech_provider.dart';
import 'package:chatbot/core/view/base/base_state.dart';
import 'package:chatbot/product/conversation/view/popup_widget.dart';
import 'package:chatbot/product/conversation/view/text_widget.dart';
import 'package:chatbot/product/conversation/viewmodel/conversation_room_view_model.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
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

class _ConversationRoomViewState extends BaseState<ConversationRoomView>
    with AutomaticKeepAliveClientMixin {
  FirebaseAnalytics analyticInstance = FirebaseAnalytics.instance;
  @override
  bool get wantKeepAlive => true;
  final String appKey = "1686539747000176";
  final String secretKey = "acf887731c9876ee6e41652394c4c873";
  final String userId = "uid";
  final String baseHOST = "api.speechsuper.com";

  final String coreType =
      "sent.eval"; // Change the coreType according to your needs.
  final refText =
      "supermarket"; // Change the reference text according to your needs.
  // final audioPath =
  //     _path; // Change the audio path corresponding to the reference text.
  final audioType =
      "wav"; // Change the audio type corresponding to the audio file.
  final audioSampleRate = "16000";

  bool? _isFirst;
  bool isScroll = true;
  String voiceRatio = "";

  ConversationRoomViewModel viewModel = ConversationRoomViewModel();
  // AwsPollyService awsViewModel = AwsPollyService();

  late ScrollController _listScrollController;

  late FocusNode focusNode;
  late FlutterSoundRecorder _recorder;
  final player = AudioPlayer();

  String _path = '';
  bool isData = false;

  @override
  void initState() {
    analyticInstance.logEvent(name: "opened_conversation_room_view");
    Provider.of<ConversationRoomViewModel>(context, listen: false)
        .getAllMessages(conversationId: widget.conversationId);
    requestPermission();
    _recorder = FlutterSoundRecorder();
    _listScrollController = ScrollController();
    Provider.of<ConversationRoomViewModel>(context, listen: false)
        .sendTextController = TextEditingController();
    focusNode = FocusNode();
    _isFirst = true;
    viewModel.sendTextController = TextEditingController();

    super.initState();
  }

  requestPermission() async {
    analyticInstance.logEvent(name: "worked_request_permission");
    await Permission.microphone.request();
  }

  _startRecording(ConversationRoomViewModel chatProvider) async {
    final status = await Permission.microphone.request();
    // final myRecorder = FlutterSoundRecorder();

    if (status.isGranted) {
      try {
        analyticInstance.logEvent(name: "worked_start_recording");
        HapticFeedback.mediumImpact();
        await player.play(AssetSource("sound/sound_click.wav"));
        // chatProvider.addUserMessage(
        //   message: "Yükleniyor",
        //   betterSentence: '',
        //   correctSentence: '',
        //   sound: '',
        //   soundRatio: '',
        // );
        await player.play(AssetSource("sound/sound_user_bubble.wav"));
        // Uygulamanın kendi dosya yolunu alıyoruz
        Directory appDocDirectory = await getApplicationDocumentsDirectory();

        // Dosyanın kaydedileceği yolu belirliyoruz
        _path = '${appDocDirectory.path}/soundfile.wav';

        // Kaydediciyi başlatıyoruz
        await _recorder.openRecorder();
        // _recorder.onProgress!.listen((event) {
        // });
        await _recorder.startRecorder(toFile: _path);

        // await Future.delayed(
        //     const Duration(seconds: 20)); // Örnek olarak 10 saniye bekliyoruz

        // // Kaydediciyi durduruyoruz
        // await _recorder.stopRecorder();
        // // Kaydediciyi kapatıyoruz
        // await _recorder.closeRecorder();
      } catch (e) {
        analyticInstance.logEvent(
            name: "not_work_start_recording_in_conversation_room_view");
        await _recorder.stopRecorder();
        // Kaydediciyi kapatıyoruz
        await _recorder.closeRecorder();
        // chatProvider.chatList.removeLast();
        chatProvider.addUserMessage(
          message: "Please try again",
          betterSentence: '',
          correctSentence: '',
          sound: '',
          soundRatio: '',
        );
      }
    } else if (status.isDenied) {
      analyticInstance.logEvent(
          name: "status_denied_recording_in_conversation_room_view");
      chatProvider.isRecording = false;
      viewModel.showAlertDialog(context);
    } else if (status.isPermanentlyDenied) {
      analyticInstance.logEvent(
          name:
              "status_permanently_denied_recording_in_conversation_room_view");
      chatProvider.isRecording = false;
      viewModel.showAlertDialog(context);
    }
  }

  void _stopRecording(ConversationRoomViewModel chatProvider) async {
    analyticInstance.logEvent(name: "stop_recording_worked");
    final player = AudioPlayer();

    await _recorder.stopRecorder();
    await _recorder.closeRecorder();
    HapticFeedback.mediumImpact();
    await player.play(AssetSource("sound/sound_click.wav"));

    _uploadAudio(_path, chatProvider);
  }

  Future<void> _pronunciationCheck(
      ConversationRoomViewModel chatProvider) async {
    analyticInstance.logEvent(name: "pronunciation_check_worked");
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String connectSig =
        sha1.convert(utf8.encode("$appKey$timestamp$secretKey")).toString();
    String startSig = sha1
        .convert(utf8.encode("$appKey$timestamp$userId$secretKey"))
        .toString();
    String tokenId = DateTime.now().millisecondsSinceEpoch.toString();
    var params = {
      "connect": {
        "cmd": "connect",
        "param": {
          "sdk": {"version": 16777472, "source": 9, "protocol": 2},
          "app": {
            "applicationId": appKey,
            "sig": connectSig,
            "timestamp": timestamp
          }
        }
      },
      "start": {
        "cmd": "start",
        "param": {
          "app": {
            "applicationId": appKey,
            "sig": startSig,
            "userId": userId,
            "timestamp": timestamp
          },
          "audio": {
            "audioType": audioType,
            "sampleRate": audioSampleRate,
            "channel": 1,
            "sampleBytes": 2
          },
          "request": {
            "refText": viewModel.sendTextController.text,
            "coreType": coreType,
            "tokenId": tokenId,
          }
        }
      }
    };

    rootBundle.load(_path).then((ByteData data) async {
      var url = Uri.https(baseHOST, coreType);
      var request = http.MultipartRequest("POST", url)
        ..fields["text"] = jsonEncode(params)
        ..files.add(
            http.MultipartFile.fromBytes("audio", data.buffer.asUint8List()))
        ..headers["Request-Index"] = "0";

      var response = await request.send();

      if (response.statusCode != 200) {
        analyticInstance.logEvent(name: "prok_status_code_not_200");
        // resultController.text = "HTTP status code ${response.statusCode}";
      } else {
        analyticInstance.logEvent(name: "pro_status_code_200");
        response.stream.transform(utf8.decoder).join().then((String str) {
          if (str.contains("error")) {
            // resultController.text = str;
          } else {
            var respJson = jsonDecode(str);
            voiceRatio = "${respJson["result"]["overall"]}";
            // chatProvider.chatList.removeLast();

            chatProvider.availableMessage(true);
            if (chatProvider.isPractice) {
              chatProvider.chatList.removeLast();
              sendMessage(
                  chatProvider: Provider.of<ConversationRoomViewModel>(context,
                      listen: false),
                  context);
            }
          }
        });
      }
    });
  }

  void _uploadAudio(
    String path,
    ConversationRoomViewModel chatProvider,
  ) async {
    Dio dio = Dio();
    String uploadUrl = "https://transcribe.whisperapi.com";
    try {
      analyticInstance.logEvent(name: "upload_audio_worked");
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
          headers: {'Authorization': 'Bearer ZFAVBQD21KCPG7FR8D2CXARCSND4JHGG'},
        ),
      );

      if (response.statusCode == 200) {
        analyticInstance.logEvent(name: "upload_audio_status_code_200");
        // provider.addMessage(response.data["text"]);
        chatProvider.setText(response.data["text"]);
        viewModel.sendTextController.clear();
        // chatProvider.chatList.removeLast();
        scrollListToEND();

        viewModel.sendTextController.text = response.data["text"];
        if (viewModel.sendTextController.text.isEmpty) {
          // chatProvider.chatList.removeLast();
          chatProvider.setText("Please send message");
          // Provider.of<ConversationRoomViewModel>(context, listen: false)
          //     .setIsTyping();
          Future.delayed(
            const Duration(seconds: 1),
            () {
              chatProvider.setSpeaking();
            },
          );
          return;
        }
        await _pronunciationCheck(chatProvider);

        if (chatProvider.isPractice) {
          analyticInstance.logEvent(name: "upload_audio_add_dump_message");

          chatProvider.addUserMessage(
            message: "loading",
            betterSentence: "",
            correctSentence: "",
            sound: "",
            soundRatio: "",
          );

          chatProvider.voiceMessage != "" ? Navigator.pop(context) : null;
        } else {
          // Future.delayed(
          //   const Duration(seconds: 1),
          //   () {
          //     analyticInstance.logEvent(name: "upload_audio_add_dump_message");
          //     chatProvider.addUserMessage(
          //       message: "loading",
          //       betterSentence: "betterSentence",
          //       correctSentence: "correctSentence",
          //       sound: "sound",
          //       soundRatio: "soundRatio",
          //     );
          //   },
          // );
        }
      }
    } catch (e) {
      analyticInstance.logEvent(
          name: "upload_audio_error_in_conversation_room_view");
      await _recorder.stopRecorder();
      // Kaydediciyi kapatıyoruz
      await _recorder.closeRecorder();
      // chatProvider.chatList.removeLast();
      chatProvider.addUserMessage(
        message: "Please try again",
        betterSentence: '',
        correctSentence: '',
        sound: '',
        soundRatio: '',
      );
    }
  }

  setComplete(ConversationRoomViewModel chatProvider) {
    analyticInstance.logEvent(
        name: "complete_message_func_worked_in_conversation_room_view");
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
    super.build(context);
    var chatProvider = Provider.of<ConversationRoomViewModel>(context);

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: GestureDetector(
        onTap: () {
          viewModel.startFocusNode();
        },
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
                    color: ColorConstant.instance.paletteCard,
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
                    color: ColorConstant.instance.paletteCard,
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
    analyticInstance.logEvent(name: "opened_complete_dialog");
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
                  style: currentTextTheme.displaySmall?.copyWith(
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
                          analyticInstance.logEvent(
                              name:
                                  "clicked_continue_chat_conversation_room_view");
                          setState(() {
                            chatProvider.endChat = 3;
                          });
                        },
                        child: Text(
                          "Continue",
                          style: currentTextTheme.headlineMedium?.copyWith(
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
                          analyticInstance.logEvent(
                              name: "clicked_complete_chat");
                          chatProvider.isGetMessage = false;
                          Provider.of<ConversationRoomViewModel>(context,
                                  listen: false)
                              .isReadMessage = false;
                          // Provider.of<AwsPollyService>(context, listen: false)
                          //     .stop();

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
                        textStyle: currentTextTheme.headlineMedium?.copyWith(
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
    analyticInstance.logEvent(name: "worked_chat_body_conversation_room_view");
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
                      Material(
                        borderRadius: BorderRadius.circular(50.0),
                        child: CircleAvatar(
                          radius: 14.0,
                          backgroundColor: ColorConstant.instance.backIconColor,
                          child: CircleAvatar(
                            radius: 12.0,
                            backgroundColor:
                                ColorConstant.instance.paletteBackground,
                            child: IconButton(
                              onPressed: () {
                                analyticInstance.logEvent(
                                    name:
                                        "close_chat_body_conversation_room_view");
                                Provider.of<ConversationRoomViewModel>(context,
                                        listen: false)
                                    .isReadMessage = false;
                                Provider.of<SpeechProvider>(context,
                                        listen: false)
                                    .stop();
                                chatProvider.isReadMessage = false;
                                chatProvider.isGetMessage = false;
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BottomBarView()));
                              },
                              icon: Icon(
                                Icons.arrow_back_ios,
                                size: 10.0,
                                color: ColorConstant.instance.backIconColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "Speaking to Talkios",
                        style: currentTextTheme.titleMedium?.copyWith(
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
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0.0,
                          left: 0.0,
                          right: 0.0,
                          bottom: 0.0,
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
                        Consumer<ConversationRoomViewModel>(
                          builder: (context, state, child) {
                            return (state.isSpeaking &&
                                    state.voiceMessage != state.dumpMessage)
                                ? Positioned.fill(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10.0, sigmaY: 10.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/images/image_circle_loop.gif",
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18.0),
                                            child: state.voiceMessage ==
                                                    "loading"
                                                ? SizedBox(
                                                    width: width(0.3),
                                                    child: SpinKitThreeBounce(
                                                      color: ColorConstant
                                                          .instance
                                                          .additionalWhite,
                                                      size: 18.0,
                                                    ),
                                                  )
                                                : Text(
                                                    state.voiceMessage,
                                                    style: currentTextTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: state.voiceMessage ==
                                                              "Please send message"
                                                          ? ColorConstant
                                                              .instance
                                                              .additionalRed
                                                          : ColorConstant
                                                              .instance
                                                              .additionalWhite,
                                                      fontSize: 20.0,
                                                    ),
                                                    maxLines: 4,
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : const Center();
                          },
                        ),
                      ],
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
                                    analyticInstance.logEvent(
                                        name:
                                            "clicked_rate_dialog_button_conversation_room_view");
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
                                        style: currentTextTheme.displaySmall
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
                  Selector<ConversationRoomViewModel, MyValues>(
                    builder: (context, state, child) {
                      return state.isSelectVoice
                          ? AbsorbPointer(
                              absorbing:
                                  state.isActive == 1 && !viewModel.isTyping
                                      ? false
                                      : true,
                              child: voiceButton(context),
                            )
                          : AbsorbPointer(
                              absorbing:
                                  state.isActive == 1 && !viewModel.isTyping
                                      ? false
                                      : true,
                              child: sendMessageInput(chatProvider),
                            );
                    },
                    selector: (context, model) =>
                        MyValues(model.isActive, model.isSelectVoice),
                  ),
                ],
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: 10,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: SkeletonItem(
                      child: SkeletonParagraph(
                        style: SkeletonParagraphStyle(
                          lines: 3,
                          spacing: 6,
                          lineStyle: SkeletonLineStyle(
                            randomLength: true,
                            height: 10,
                            borderRadius: BorderRadius.circular(8),
                            minLength: MediaQuery.of(context).size.width / 6,
                            maxLength: MediaQuery.of(context).size.width / 3,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  SizedBox sendMessageInput(ConversationRoomViewModel chatProvider) {
    analyticInstance.logEvent(name: "clicked_send_message_input");
    return SizedBox(
      width: width(1.0),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: SizedBox(
              width: width(1.0),
              child: TextField(
                onTap: () {
                  Provider.of<SpeechProvider>(context, listen: false).stop();
                },
                maxLines: null,
                enabled: chatProvider.isActive == 0 ? false : true,
                controller: viewModel.sendTextController,
                focusNode: viewModel.sendMessageFocusNode,
                style: currentTextTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: ColorConstant.instance.additionalWhite,
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
                            analyticInstance.logEvent(
                                name: "clicked_open_speak");
                            Provider.of<ConversationRoomViewModel>(context,
                                    listen: false)
                                .isReadMessage = false;
                            Provider.of<SpeechProvider>(context, listen: false)
                                .stop();
                            Provider.of<ConversationRoomViewModel>(context,
                                    listen: false)
                                .selectVoice(true);

                            // speakModal(context);
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
                                analyticInstance.logEvent(
                                    name: "clicked_send_meessage_input_button");
                                Provider.of<SpeechProvider>(context,
                                        listen: false)
                                    .stop();

                                await sendMessage(context,
                                    chatProvider: chatProvider);
                                viewModel.sendTextController.clear();
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
                  hintStyle: currentTextTheme.displaySmall?.copyWith(
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
        Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: AbsorbPointer(
                absorbing: viewModel.isTyping,
                child: AvatarGlow(
                  endRadius: 75.0,
                  animate: Provider.of<ConversationRoomViewModel>(context)
                      .isRecording,
                  duration: const Duration(milliseconds: 500),
                  glowColor: const Color.fromRGBO(71, 115, 254, 1),
                  repeat: true,
                  repeatPauseDuration: const Duration(milliseconds: 100),
                  showTwoGlows: true,
                  curve: Curves.fastOutSlowIn,
                  child: Consumer<ConversationRoomViewModel>(
                    builder: (context, state, child) {
                      return GestureDetector(
                        onLongPress: () {
                          Provider.of<ConversationRoomViewModel>(context,
                                  listen: false)
                              .setPractice(false);
                          Provider.of<ConversationRoomViewModel>(context,
                                  listen: false)
                              .clickMiniVoiceButton(false);
                          analyticInstance.logEvent(
                              name: "press_record_button");
                          Provider.of<ConversationRoomViewModel>(context,
                                  listen: false)
                              .setText("loading");

                          Provider.of<SpeechProvider>(context, listen: false)
                              .stop();
                          Provider.of<ConversationRoomViewModel>(context,
                                  listen: false)
                              .setIsRecord();
                          Provider.of<ConversationRoomViewModel>(context,
                                  listen: false)
                              .setSpeaking();
                          _startRecording(
                              Provider.of<ConversationRoomViewModel>(context,
                                  listen: false));
                        },
                        onLongPressEnd: (_) {
                          analyticInstance.logEvent(
                              name: "press_end_record_button");

                          Provider.of<SpeechProvider>(context, listen: false)
                              .stop();
                          Provider.of<ConversationRoomViewModel>(context,
                                  listen: false)
                              .setIsRecord();
                          _stopRecording(Provider.of<ConversationRoomViewModel>(
                              context,
                              listen: false));
                          Provider.of<ConversationRoomViewModel>(context,
                                  listen: false)
                              .setIsTyping();
                        },
                        onTap: () {
                          if (state.isAvailableMessage && !state.isPractice) {
                            sendMessage(
                                chatProvider:
                                    Provider.of<ConversationRoomViewModel>(
                                        context,
                                        listen: false),
                                context);
                            state.setSpeaking();
                            state.availableMessage(false);
                          } else {
                            Provider.of<ConversationRoomViewModel>(context,
                                    listen: false)
                                .setPractice(false);
                            Provider.of<ConversationRoomViewModel>(context,
                                    listen: false)
                                .clickMiniVoiceButton(false);
                            Provider.of<SpeechProvider>(context, listen: false)
                                .stop();
                            Provider.of<ConversationRoomViewModel>(context,
                                    listen: false)
                                .showPopupWarning();
                          }
                        },
                        child: Container(
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
                                child: state.isAvailableMessage &&
                                        !state.isPractice
                                    ? SvgPicture.asset(
                                        IconConstant.instance.iconSendVoice,
                                        color: ColorConstant
                                            .instance.additionalWhite,
                                      )
                                    : SvgPicture.asset(
                                        IconConstant.instance.iconVoice,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            PopupWidget(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                analyticInstance.logEvent(
                    name: "clicked_keyboard_button_open_input");
                Provider.of<SpeechProvider>(context, listen: false).stop();
                Provider.of<ConversationRoomViewModel>(context, listen: false)
                    .clickMiniVoiceButton(false);
                viewModel.sendTextController.text = "";
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
            Consumer<ConversationRoomViewModel>(
              builder: (context, state, child) {
                return AnimatedOpacity(
                  opacity:
                      state.isAvailableMessage && !state.isPractice ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: CircleAvatar(
                    radius: 20.0,
                    backgroundColor: ColorConstant.instance.additionalWhite,
                    child: IconButton(
                      onPressed: () {
                        if (state.isAvailableMessage && !state.isPractice) {
                          viewModel.sendTextController.text = '';
                          Provider.of<ConversationRoomViewModel>(context,
                                  listen: false)
                              .setSpeaking();
                          Provider.of<ConversationRoomViewModel>(context,
                                  listen: false)
                              .availableMessage(false);
                        }
                      },
                      icon: Icon(
                        Icons.close,
                        color: ColorConstant.instance.paletteBackground,
                        size: 15.0,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Row speakHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Material(
          borderRadius: BorderRadius.circular(50.0),
          child: CircleAvatar(
            radius: 14.0,
            backgroundColor: ColorConstant.instance.backIconColor,
            child: CircleAvatar(
              radius: 12.0,
              backgroundColor: ColorConstant.instance.paletteBackground,
              child: IconButton(
                onPressed: () {
                  analyticInstance.logEvent(name: "closed_speak_modal");
                  // Provider.of<AwsPollyService>(context, listen: false).stop();
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 10.0,
                  color: ColorConstant.instance.backIconColor,
                ),
              ),
            ),
          ),
        ),
        Column(
          children: [
            Text(
              "Speaking to Talkios",
              style: currentTextTheme.titleMedium?.copyWith(
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
                    // Consumer<AwsPollyService>(
                    //   builder: (context, state, child) {
                    //     return state.isCompleted
                    //         ? const Center()
                    //         : index == state.selectedIndex
                    //             ? CircleAvatar(
                    //                 backgroundColor:
                    //                     ColorConstant.instance.greyScale400,
                    //                 radius: 15.0,
                    //                 child: IconButton(
                    //                   onPressed: () async {
                    //                     HapticFeedback.heavyImpact();
                    //                     state.stop();
                    //                   },
                    //                   icon: Icon(
                    //                     Icons.mic_off,
                    //                     color: ColorConstant
                    //                         .instance.additionalRed,
                    //                     size: 15.0,
                    //                   ),
                    //                 ),
                    //               )
                    //             : const Center();
                    //   },
                    // ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<dynamic> pronunciationAndGrammer({
    required String correctMessage,
    required String userMessage,
    required String betterMessage,
    required String voiceRatio,
    required String userSound,
    required String profilePhoto,
    required int conversationId,
    required int messageId,
  }) {
    analyticInstance.logEvent(name: "opened_pronunciation_and_grammar_modal");
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
                    proAndGrammer(
                      context,
                      correctMessage: correctMessage,
                      userMessage: userMessage,
                      betterMessage: betterMessage,
                      voiceRatio: voiceRatio,
                      userSound: userSound,
                      profilePhoto: profilePhoto,
                      conversationId: conversationId,
                      messageId: messageId,
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

  Widget proAndGrammer(
    BuildContext context, {
    required String correctMessage,
    required String userMessage,
    required String betterMessage,
    required String voiceRatio,
    required String userSound,
    required String profilePhoto,
    required int conversationId,
    required int messageId,
  }) {
    return correctMessage == "correctSentence"
        ? futureModal(conversationId, messageId, userMessage, profilePhoto)
        : Padding(
            padding: const EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              top: 24.0,
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      analyticInstance.logEvent(name: "closed_pronunciation");
                      Navigator.pop(context);
                      Provider.of<SpeechProvider>(context, listen: false)
                          .stop();
                    },
                    child: Container(
                      width: 25.0,
                      height: 25.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(
                          color: ColorConstant.instance.backIconColor,
                          width: 3.0,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.close,
                          size: 15.0,
                          color: ColorConstant.instance.backIconColor,
                        ),
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
                    grammarView(
                      correctMessage: correctMessage,
                      userMessage: userMessage,
                      betterMessage: betterMessage,
                      messageId: messageId,
                    ),
                    Column(
                      children: [
                        const Expanded(child: SizedBox()),
                        CircularPercentIndicator(
                          radius: 55.0,
                          lineWidth: 7.0,
                          percent: voiceRatio != ""
                              ? double.parse(voiceRatio) / 100
                              : 0.0, // Yüzde değeri, 0.0 - 1.0 aralığında olmalı
                          center: Text(
                            voiceRatio,
                            style: currentTextTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: ColorConstant.instance.additionalWhite,
                              fontSize: 32.0,
                            ),
                          ),
                          progressColor: ColorConstant.instance.palettePurple,
                          backgroundColor: ColorConstant.instance.paletteGrey,
                        ),
                        const Expanded(child: SizedBox()),
                        Text(
                          userMessage,
                          style: currentTextTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: ColorConstant.instance.paletteBlue,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Consumer<ConversationRoomViewModel>(
                          builder: (context, state, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                avatarButtonAI(
                                  state: state,
                                  avatarPhoto:
                                      ImageConstant.instance.imageAIProfile,
                                  message: userMessage,
                                ),
                                SizedBox(
                                  width: userSound == "" ? 0.0 : 20.0,
                                ),
                                userSound == ""
                                    ? const Center()
                                    : avatarButton(
                                        state: state,
                                        avatarPhoto: profilePhoto,
                                        onPressed: () async {
                                          // Provider.of<AwsPollyService>(context,
                                          //         listen: false)
                                          //     .stop();
                                          analyticInstance.logEvent(
                                              name: "clicked_play_user_sound");
                                          state.setAvatarAISelect(false);
                                          state.setAvatarSelect(true);

                                          final player = AudioPlayer();
                                          await player.play(
                                            UrlSource(
                                              userSound,
                                            ),
                                          );
                                        }),
                              ],
                            );
                          },
                        ),
                        const Expanded(child: SizedBox()),
                        Text(
                          "Practice",
                          style: currentTextTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: const Color.fromRGBO(155, 150, 161, 1),
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Stack(
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
                                  onLongPress: () {
                                    Provider.of<ConversationRoomViewModel>(
                                            context,
                                            listen: false)
                                        .setPractice(true);
                                    analyticInstance.logEvent(
                                        name:
                                            "press_play_record_sound_practice");
                                    Provider.of<SpeechProvider>(context,
                                            listen: false)
                                        .stop();
                                    Provider.of<ConversationRoomViewModel>(
                                            context,
                                            listen: false)
                                        .setIsRecord();
                                    _startRecording(
                                        Provider.of<ConversationRoomViewModel>(
                                            context,
                                            listen: false));
                                  },
                                  onLongPressEnd: (_) {
                                    analyticInstance.logEvent(
                                        name:
                                            "press_end_play_record_sound_practice");
                                    Provider.of<SpeechProvider>(context,
                                            listen: false)
                                        .stop();
                                    Provider.of<ConversationRoomViewModel>(
                                            context,
                                            listen: false)
                                        .setIsRecord();

                                    _stopRecording(
                                        Provider.of<ConversationRoomViewModel>(
                                            context,
                                            listen: false));
                                  },
                                  onTap: () {
                                    Provider.of<SpeechProvider>(context,
                                            listen: false)
                                        .stop();
                                    Provider.of<ConversationRoomViewModel>(
                                            context,
                                            listen: false)
                                        .setPractice(true);
                                    Provider.of<ConversationRoomViewModel>(
                                            context,
                                            listen: false)
                                        .showPopupWarning();
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
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      172, 173, 177, 1),
                                              foregroundColor: Colors.red,
                                              radius: 30.0,
                                              child: SvgPicture.asset(
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
                            PopupWidget(),
                          ],
                        ),
                      ],
                    )
                  ]),
                )
              ],
            ),
          );
  }

  FutureBuilder<dynamic> futureModal(int conversationId, int messageId,
      String userMessage, String profilePhoto) {
    return FutureBuilder(
      future: viewModel.getMessage(
        conversationId: conversationId,
        messageId: messageId,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.done) {
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
                    grammarView(
                      messageId: messageId,
                      correctMessage: viewModel.oneMessage[0].correctSentence,
                      userMessage: userMessage,
                      betterMessage: viewModel.oneMessage[0].betterSentence,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Column(
                        children: [
                          CircularPercentIndicator(
                            radius: 55.0,
                            lineWidth: 7.0,
                            percent: double.parse(
                                    viewModel.oneMessage[0].soundRatio) /
                                100, // Yüzde değeri, 0.0 - 1.0 aralığında olmalı
                            center: Text(
                              viewModel.oneMessage[0].soundRatio,
                              style: currentTextTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: ColorConstant.instance.additionalWhite,
                                fontSize: 32.0,
                              ),
                            ),
                            progressColor: ColorConstant.instance.palettePurple,
                            backgroundColor: ColorConstant.instance.paletteGrey,
                          ),
                          const Expanded(child: SizedBox()),
                          Text(
                            userMessage,
                            style: currentTextTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: ColorConstant.instance.paletteBlue,
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Consumer<ConversationRoomViewModel>(
                            builder: (context, state, child) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  avatarButtonAI(
                                    avatarPhoto:
                                        ImageConstant.instance.imageAIProfile,
                                    message: userMessage,
                                    state: state,
                                  ),
                                  SizedBox(
                                    width: viewModel.oneMessage[0].sound == ""
                                        ? 0.0
                                        : 20.0,
                                  ),
                                  viewModel.oneMessage[0].sound == ""
                                      ? const Center()
                                      : avatarButton(
                                          state: state,
                                          avatarPhoto: profilePhoto,
                                          onPressed: () async {
                                            analyticInstance.logEvent(
                                                name:
                                                    "clicked_play_user_sound<_in_pronunciation_and_grammar_modal_conversation_room_view");
                                            state.setAvatarAISelect(false);
                                            state.setAvatarSelect(true);
                                            // Provider.of<AwsPollyService>(
                                            //         context,
                                            //         listen: false)
                                            //     .stop();
                                            final player = AudioPlayer();
                                            await player.play(
                                              UrlSource(viewModel
                                                  .oneMessage[0].sound),
                                            );
                                          }),
                                ],
                              );
                            },
                          ),
                          const Expanded(child: SizedBox()),
                          Text(
                            "Practice",
                            style: currentTextTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(155, 150, 161, 1),
                              fontSize: 14.0,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: AvatarGlow(
                                  endRadius: 75.0,
                                  animate:
                                      Provider.of<ConversationRoomViewModel>(
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
                                    onLongPress: () {
                                      Provider.of<ConversationRoomViewModel>(
                                              context,
                                              listen: false)
                                          .setPractice(true);
                                      analyticInstance.logEvent(
                                          name:
                                              "press_play_record_sound_practice");
                                      Provider.of<SpeechProvider>(context,
                                              listen: false)
                                          .stop();
                                      Provider.of<ConversationRoomViewModel>(
                                              context,
                                              listen: false)
                                          .setIsRecord();

                                      _startRecording(Provider.of<
                                              ConversationRoomViewModel>(
                                          context,
                                          listen: false));
                                    },
                                    onLongPressEnd: (_) {
                                      analyticInstance.logEvent(
                                          name:
                                              "press_end_play_record_sound_practice");
                                      Provider.of<SpeechProvider>(context,
                                              listen: false)
                                          .stop();
                                      Provider.of<ConversationRoomViewModel>(
                                              context,
                                              listen: false)
                                          .setIsRecord();

                                      _stopRecording(Provider.of<
                                              ConversationRoomViewModel>(
                                          context,
                                          listen: false));
                                    },
                                    onTap: () {
                                      Provider.of<SpeechProvider>(context,
                                              listen: false)
                                          .stop();
                                      Provider.of<ConversationRoomViewModel>(
                                              context,
                                              listen: false)
                                          .setPractice(true);
                                      Provider.of<ConversationRoomViewModel>(
                                              context,
                                              listen: false)
                                          .showPopupWarning();
                                    },
                                    child: Consumer<ConversationRoomViewModel>(
                                      builder: (context, state, child) {
                                        return Container(
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: CircleAvatar(
                                            radius: 55.0,
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    120, 122, 124, 0.2),
                                            child: CircleAvatar(
                                              radius: 40.0,
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      120, 122, 124, 0.4),
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    const Color.fromRGBO(
                                                        172, 173, 177, 1),
                                                foregroundColor: Colors.red,
                                                radius: 30.0,
                                                child: SvgPicture.asset(
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
                              PopupWidget(),
                            ],
                          ),
                        ],
                      ),
                    )
                  ]),
                )
              ],
            ),
          );
        } else {
          return const Text("error");
        }
      },
    );
  }

  Widget avatarButton({
    required String avatarPhoto,
    required void Function()? onPressed,
    required ConversationRoomViewModel state,
  }) {
    return SizedBox(
      width: 91.0,
      height: 51.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(60, 70, 72, 0.7),
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: BorderSide(
              color: state.isAvatarSelected
                  ? ColorConstant.instance.additionalGreen
                  : const Color.fromRGBO(60, 70, 72, 0.7),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            CircleAvatar(
              radius: 13.0,
              backgroundImage: NetworkImage(avatarPhoto),
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

  Widget avatarButtonAI(
      {required String avatarPhoto,
      required String message,
      required ConversationRoomViewModel state}) {
    return SizedBox(
      width: 91.0,
      height: 51.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(60, 70, 72, 0.7),
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: BorderSide(
              color: state.isAvatarAISelected
                  ? ColorConstant.instance.additionalGreen
                  : const Color.fromRGBO(60, 70, 72, 0.7),
            ),
          ),
        ),
        onPressed: () async {
          // Provider.of<AwsPollyService>(context, listen: false).stop();
          analyticInstance.logEvent(name: "clicked_play_ai_sound");
          state.setAvatarSelect(false);
          state.setAvatarAISelect(true);

          Provider.of<SpeechProvider>(context, listen: false)
              .speak(message, -1);
        },
        child: Row(
          children: [
            CircleAvatar(
              radius: 13.0,
              backgroundImage: AssetImage(avatarPhoto),
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

  Padding grammarView({
    required String correctMessage,
    required String userMessage,
    required String betterMessage,
    required int messageId,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: width(1.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    userMessage,
                    style: currentTextTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: ColorConstant.instance.additionalWhite
                          .withOpacity(0.6),
                      fontSize: 16.0,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SvgPicture.asset(
                  IconConstant.instance.iconWrong,
                  width: 16.0,
                  height: 16.0,
                )
              ],
            ),
          ),
          const SizedBox(height: 18.0),
          SizedBox(
            width: width(1.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    correctMessage,
                    style: currentTextTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: ColorConstant.instance.additionalWhite,
                      fontSize: 16.0,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SvgPicture.asset(
                  IconConstant.instance.iconCorrect,
                  width: 16.0,
                  height: 16.0,
                )
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
          Text(
            "It's better to say",
            style: currentTextTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: ColorConstant.instance.additionalWhite,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            width: width(1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    betterMessage,
                    style: currentTextTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: ColorConstant.instance.additionalWhite,
                      fontSize: 14.0,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16.0,
                      backgroundColor: const Color.fromRGBO(60, 70, 72, 1),
                      child: IconButton(
                        onPressed: () async {
                          analyticInstance.logEvent(
                              name: "clicked_play_translate_button");
                          await viewModel.translate(
                            conversationId: widget.conversationId,
                            messageId: messageId,
                            translateTitle: viewModel.nativeLanguage,
                          );

                          Provider.of<ConversationRoomViewModel>(context,
                                  listen: false)
                              .setTranslateMessage(
                                  viewModel.translateModel.betterSentence!);
                        },
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
                        onPressed: () async {
                          analyticInstance.logEvent(
                              name: "clicked_play_ai_speak_to_text_button");

                          Provider.of<SpeechProvider>(context, listen: false)
                              .speak(betterMessage, -1);
                        },
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
          ),
          const SizedBox(height: 10.0),
          Consumer<ConversationRoomViewModel>(
            builder: (context, state, child) {
              return Text(
                state.translateMessage == "" ? "" : state.translateMessage,
                style: currentTextTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: ColorConstant.instance.paletteBlue,
                  fontSize: 14.0,
                ),
              );
            },
          ),
          const Expanded(flex: 2, child: SizedBox()),
        ],
      ),
    );
  }

  SegmentedTabControl segmentTabBar() {
    return SegmentedTabControl(
      textStyle: currentTextTheme.bodySmall?.copyWith(
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Text(
                              chatProvider.chatList[index].message,
                              style: currentTextTheme.displaySmall?.copyWith(
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
                            onPressed: () async {
                              analyticInstance.logEvent(
                                  name: "clicked_open_translate");
                              await viewModel.getAllMessages(
                                  conversationId: widget.conversationId);
                              // Provider.of<AwsPollyService>(context,
                              //         listen: false)
                              // .stop();
                              Provider.of<ConversationRoomViewModel>(context,
                                      listen: false)
                                  .clickMiniVoiceButton(false);
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
                            onPressed: () async {
                              analyticInstance.logEvent(
                                  name: "clicked_open_pro_and_grammar_modal");
                              Provider.of<SpeechProvider>(context,
                                      listen: false)
                                  .stop();
                              Provider.of<ConversationRoomViewModel>(context,
                                      listen: false)
                                  .clickMiniVoiceButton(false);
                              Provider.of<ConversationRoomViewModel>(context,
                                      listen: false)
                                  .setTranslateMessage("");
                              Provider.of<ConversationRoomViewModel>(context,
                                      listen: false)
                                  .setAvatarAISelect(false);
                              Provider.of<ConversationRoomViewModel>(context,
                                      listen: false)
                                  .setAvatarSelect(false);
                              await viewModel.getAllMessages(
                                conversationId: widget.conversationId,
                              );

                              pronunciationAndGrammer(
                                correctMessage:
                                    viewModel.chatList[index].correctSentence,
                                userMessage: viewModel.chatList[index].message,
                                betterMessage:
                                    viewModel.chatList[index].betterSentence,
                                voiceRatio:
                                    viewModel.chatList[index].soundRatio,
                                userSound: viewModel.chatList[index].sound,
                                profilePhoto: widget.profilePhoto,
                                conversationId: widget.conversationId,
                                messageId: viewModel.chatList[index].id,
                              );
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

  Future<dynamic> selectLanguageModal() {
    analyticInstance.logEvent(name: "opened_select_language");
    return showModalBottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: FractionallySizedBox(
            heightFactor: 0.7,
            child: Container(
              width: width(1.0),
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Column(
                    children: [
                      Container(
                        width: width(1.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: ColorConstant.instance.paletteGrey,
                          ),
                        ),
                        child: ListView.builder(
                          itemCount: viewModel.languages.length,
                          addAutomaticKeepAlives: false,
                          addRepaintBoundaries: false,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: width(1.0),
                              height: 61.0,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(32, 33, 35, 0.8),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(
                                            index == 0 ? 16.0 : 0.0),
                                        topRight: Radius.circular(
                                            index == 0 ? 16.0 : 0.0),
                                        bottomLeft: Radius.circular(index ==
                                                (viewModel.languages.length - 1)
                                            ? 16.0
                                            : 0.0),
                                        bottomRight: Radius.circular(index ==
                                                (viewModel.languages.length - 1)
                                            ? 16.0
                                            : 0.0),
                                      ),
                                      side: BorderSide(
                                          color: ColorConstant
                                              .instance.paletteGrey)),
                                ),
                                onPressed: () {
                                  analyticInstance.logEvent(
                                      name:
                                          "selected_${viewModel.languages[index].title!}");
                                  viewModel.selectedLanguageId =
                                      viewModel.languages[index].id!;
                                  viewModel.selectedLanguageCode =
                                      viewModel.languages[index].code!;
                                  viewModel.selectedIndex = index;
                                  viewModel.nativeLanguage =
                                      viewModel.languages[index].title!;

                                  Provider.of<ConversationRoomViewModel>(
                                          context,
                                          listen: false)
                                      .selectLanguageText(
                                          viewModel.languages[index].title!);

                                  Navigator.pop(context);
                                },
                                child: Text(
                                  viewModel.languages[index].title!,
                                  style: currentTextTheme.caption?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20.0,
                                    color:
                                        ColorConstant.instance.additionalWhite,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      SizedBox(
                        width: width(1.0),
                        height: 61.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(32, 33, 35, 0.8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                side: BorderSide(
                                  color: ColorConstant.instance.paletteGrey,
                                ),
                              )),
                          onPressed: () {
                            analyticInstance.logEvent(
                                name:
                                    "clicked_cancel_button_in_select_language_modal_in_conversation_room_view");
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancel",
                            style: currentTextTheme.caption?.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 20.0,
                              color: ColorConstant.instance.additionalWhite,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Column assistantMessage(ConversationRoomViewModel chatProvider, int index) {
    if (index == chatProvider.getChatList.length - 1 &&
        !Provider.of<SpeechProvider>(context, listen: false).isSpeaking &&
        chatProvider.isReadMessage) {
      analyticInstance.logEvent(name: "voiced_message_worked");
      Provider.of<SpeechProvider>(context, listen: false)
          .speak(chatProvider.chatList[index].message, index);
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
                style: currentTextTheme.displaySmall?.copyWith(
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
                          analyticInstance.logEvent(name: "clicked_translate");
                          await viewModel.getAllMessages(
                              conversationId: widget.conversationId);

                          Provider.of<SpeechProvider>(context, listen: false)
                              .stop();
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
                    Expanded(
                      child: IconButton(
                        iconSize: 18.0,
                        onPressed: () async {
                          analyticInstance.logEvent(
                              name: "clicked_voice_message");
                          HapticFeedback.heavyImpact();

                          var provider = Provider.of<SpeechProvider>(context,
                              listen: false);

                          if (provider.isSpeaking) {
                            provider.stop();
                          } else {
                            provider.speak(
                                chatProvider.chatList[index].message, index);
                          }
                        },
                        icon: Consumer<SpeechProvider>(
                          builder: (context, state, child) {
                            // print("index :$index");
                            // print("state index : ${state.messageIndex}");
                            return Icon(
                              state.isSpeaking && state.messageIndex == index
                                  ? Icons.stop
                                  : Icons.mic,
                              color: ColorConstant.instance.additionalWhite,
                              size: 18.0,
                            );
                          },
                        ),
                      ),
                    ),
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
    analyticInstance.logEvent(name: "worked_send_message_func");

    if (viewModel.isTyping) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "You cannot send multiple sounds at the same time",
        ),
      );
      return;
    }

    if (viewModel.sendTextController.text.isEmpty) {
      analyticInstance.logEvent(
          name: "worked_empty_text_validate_in_conversation_room_view");
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "Please send message",
        ),
      );
      return;
    }

    try {
      String msg = viewModel.sendTextController.text;
      viewModel.sendTextController.clear();
      _isFirst = false;

      viewModel.isTyping = true;

      chatProvider.addUserMessage(
        message: msg,
        betterSentence: "betterSentence",
        correctSentence: "correctSentence",
        sound: "sound",
        soundRatio: "soundRatio",
      );

      viewModel.sendMessageFocusNode.unfocus();

      focusNode.unfocus();

      await chatProvider.sendMessageAndGetAnswers(
        context,
        soundRatio: voiceRatio,
        sound: _path,
        message: msg,
        conversationId: widget.conversationId,
      );

      // Provider.of<AwsPollyService>(context, listen: false).isSpeaking = false;

      // chatProvider.tempList = chatProvider.chatList;
    } catch (error) {
      analyticInstance.logEvent(
          name: "error_send_message_func_in_conversation_room_view");
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: TextWidget(
      //       label: error.toString(),
      //     ),
      //     backgroundColor: Colors.red,
      //   ),
      // );
    } finally {
      analyticInstance.logEvent(name: "finally_send_message_func");
      scrollListToEND();
      viewModel.isTyping = false;
    }
  }

  Future<dynamic> rateDialog(
      BuildContext context, ConversationRoomViewModel state) {
    analyticInstance.logEvent(name: "opened_rate_dialog_modal");
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
                            style: currentTextTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: ColorConstant.instance.greyScale900,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Provider.of<SpeechProvider>(context,
                                      listen: false)
                                  .stop();
                              analyticInstance.logEvent(
                                  name: "clicked_skip_ratel");
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BottomBarView()));
                            },
                            child: Text(
                              LocaleKeys.skip.tr(),
                              style: currentTextTheme.headlineMedium?.copyWith(
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
                                  Provider.of<SpeechProvider>(context,
                                          listen: false)
                                      .stop();
                                  analyticInstance.logEvent(
                                      name:
                                          "clicked_rate_${state.rates[index].id!}");
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
    analyticInstance.logEvent(name: "opened_translate_message");
    return showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Consumer<ConversationRoomViewModel>(
            builder: (context, state, child) {
              return DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.9,
                builder: (BuildContext context, ScrollController scroll) {
                  return Container(
                    width: width(1.0),
                    decoration: BoxDecoration(
                      color: ColorConstant.instance.paletteBackground,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      controller: scroll,
                      child: SizedBox(
                        width: width(1.0),
                        height: height(1.0),
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
                            translate(index, state),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Padding translate(int index, ConversationRoomViewModel state) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 24.0,
      ),
      child: FutureBuilder(
        future: viewModel.translate(
          conversationId: widget.conversationId,
          messageId: viewModel.chatList[index].id,
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
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      analyticInstance.logEvent(
                          name: "closed_translate_message");
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
                  style: currentTextTheme.displayLarge?.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: ColorConstant.instance.additionalWhite,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  state.translateMessage,
                  style: currentTextTheme.displayLarge?.copyWith(
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
                      style: currentTextTheme.displayLarge?.copyWith(
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
                        analyticInstance.logEvent(
                            name: "clicked_select_language");
                        // changeLanguage(context);
                        selectLanguageModal();
                      },
                      child: Consumer<ConversationRoomViewModel>(
                        builder: (context, stateCo, child) {
                          return Text(
                            stateCo.nativeLanguage == ''
                                ? viewModel
                                    .conversationModel.nativeLanguage!.title!
                                : stateCo.nativeLanguage,
                            style: currentTextTheme.displaySmall?.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: ColorConstant.instance.additionalWhite,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Text(
                  viewModel.translateModel.message!,
                  style: currentTextTheme.displayLarge?.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: ColorConstant.instance.additionalWhite,
                  ),
                ),
              ],
            );
          } else {
            return const Text('error');
          }
        },
      ),
    );
  }
}
