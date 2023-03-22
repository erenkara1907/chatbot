// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, use_build_context_synchronously

import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/language/locale_keys.g.dart';
import 'package:chatbot/core/view/base/base_stateless.dart';
import 'package:chatbot/product/bottom_bar/view/bottom_bar_view.dart';
import 'package:chatbot/product/conversation/viewmodel/conversation_room_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/icon_constant.dart';
import '../../../core/constants/image_constant.dart';
import '../../../core/view/widget/button/language_button.dart';

class ConversationRoomView extends BaseStateless {
  ConversationRoomViewModel viewModel = ConversationRoomViewModel();

  final int conversationId;

  ConversationRoomView({
    this.conversationId = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => viewModel.startFocusNode(),
      child: Scaffold(
        backgroundColor: ColorConstant.instance.additionalWhite,
        body: Consumer<ConversationRoomViewModel>(
          builder: (context, state, child) {
            return FutureBuilder(
              future: state.getAllMessages(conversationId: conversationId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: chat(context, state),
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

  SizedBox chat(BuildContext context, ConversationRoomViewModel state) {
    return SizedBox(
      height: height(context: context, value: 1.0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 24.0, right: 24.0, bottom: 60.0, top: 30.0),
            child: messages(state),
          ),
          Positioned(
            bottom: 30.0,
            left: 0.0,
            right: 0.0,
            child: state.isActive == 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        ),
                        onPressed: () {
                          rateDialog(context, state);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock,
                              color: ColorConstant.instance.additionalRed,
                              size: 15.0,
                            ),
                            const SizedBox(width: 15.0),
                            Text(
                              LocaleKeys.endChat.tr(),
                              style: currentTextTheme(context)
                                  .headline3
                                  ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: ColorConstant.instance.additionalRed,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      sendInput(context, state),
                    ],
                  )
                : sendInput(context, state),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CircleAvatar(
                    backgroundColor: ColorConstant.instance.greyScale300,
                    radius: 25.0,
                    child: Image.asset(
                      ImageConstant.instance.smallRobot,
                      fit: BoxFit.fill,
                      width: 55.0,
                      height: 55.0,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    child: LinearProgressIndicator(
                      backgroundColor: ColorConstant.instance.greyScale50,
                      color: ColorConstant.instance.greyScale800,
                      minHeight: 6.0,
                      value: double.parse(
                          state.conversationModel.conversationCompletionCount!),
                    ),
                  ),
                ),
                Expanded(
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
            ),
          ),
        ],
      ),
    );
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
                width: width(context: context, value: 1.0),
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
                            style: currentTextTheme(context)
                                .headline3
                                ?.copyWith(
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
                              style: currentTextTheme(context)
                                  .headline4
                                  ?.copyWith(
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
                                    conversationId: conversationId,
                                    endConversationId: conversationId,
                                    rateId: state.rates[index].id!,
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

  Padding sendInput(BuildContext context, ConversationRoomViewModel state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SizedBox(
        width: width(context: context, value: 1.0),
        height: height(context: context, value: 0.075),
        child: TextFormField(
          enabled: state.isActive == 0 ? false : true,
          controller: state.sendMessageController,
          focusNode: state.sendMessageFocusNode,
          style: currentTextTheme(context).headline3?.copyWith(
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
                  child: state.isTap
                      ? CircularProgressIndicator(
                          color: ColorConstant.instance.greyScale600,
                        )
                      : IconButton(
                          onPressed: () {
                            if (state.sendMessageController.text.isNotEmpty) {
                              state.sendMessage(
                                conversationId: conversationId,
                              );
                            }
                          },
                          icon: SvgPicture.asset(
                            IconConstant.instance.iconSend,
                          ),
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
            hintText: LocaleKeys.ask.tr(),
            hintStyle: currentTextTheme(context).headline3?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: ColorConstant.instance.greyScale500,
                ),
          ),
        ),
      ),
    );
  }

  ListView messages(ConversationRoomViewModel state) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: state.messages.length,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        return Align(
          alignment: state.messages[index].role == 'user'
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: state.messages[index].role == 'user'
                    ? ColorConstant.instance.greyScale600
                    : ColorConstant.instance.greyScale200,
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0),
                    bottomLeft: Radius.circular(
                        state.messages[index].role == 'user' ? 20.0 : 0.0),
                    bottomRight: Radius.circular(
                        state.messages[index].role == 'user' ? 0.0 : 20.0)),
              ),
              child: state.messages[index].role == 'user'
                  ? Text(
                      state.messages[index].message!,
                      style: currentTextTheme(context).headline3?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: state.messages[index].role == 'user'
                                ? ColorConstant.instance.additionalWhite
                                : ColorConstant.instance.greyScale900,
                          ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.messages[index].message!,
                          style: currentTextTheme(context).headline3?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: state.messages[index].role == 'user'
                                    ? ColorConstant.instance.additionalWhite
                                    : ColorConstant.instance.greyScale900,
                              ),
                        ),
                        const SizedBox(height: 10.0),
                        CircleAvatar(
                          backgroundColor: ColorConstant.instance.greyScale400,
                          radius: 15.0,
                          child: IconButton(
                            onPressed: () async {
                              viewModel.translateMessage =
                                  state.messages[index].message!;

                              showTranslateMessage(context, index);
                            },
                            icon: Icon(
                              Icons.translate,
                              color: ColorConstant.instance.greyScale600,
                              size: 15.0,
                            ),
                          ),
                        )
                      ],
                    ),
            ),
          ),
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
                width: width(context: context, value: 1.0),
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
                      conversationId: conversationId,
                      messageId: state.messages[index].id!,
                      translateTitle: viewModel.nativeLanguage == ''
                          ? viewModel.nativePopularLanguage
                          : viewModel.nativeLanguage,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
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
                                style: currentTextTheme(context)
                                    .headline1
                                    ?.copyWith(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          ColorConstant.instance.greyScale900,
                                    ),
                              ),
                              const SizedBox(height: 24.0),
                              Text(
                                LocaleKeys.message.tr(),
                                style: currentTextTheme(context)
                                    .headline1
                                    ?.copyWith(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          ColorConstant.instance.greyScale900,
                                    ),
                              ),
                              const SizedBox(height: 16.0),
                              Text(
                                viewModel.translateMessage,
                                style: currentTextTheme(context)
                                    .headline1
                                    ?.copyWith(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          ColorConstant.instance.greyScale600,
                                    ),
                              ),
                              const SizedBox(height: 24.0),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    LocaleKeys.translate_to.tr(),
                                    style: currentTextTheme(context)
                                        .headline1
                                        ?.copyWith(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w500,
                                          color: ColorConstant
                                              .instance.greyScale900,
                                        ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  SizedBox(
                                    height:
                                        height(context: context, value: 0.04),
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
                                                width: width(
                                                    context: context,
                                                    value: 1.0),
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
                                                              currentTextTheme(
                                                                      context)
                                                                  .headline3
                                                                  ?.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
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
                                                                      widthValue: width(
                                                                          context:
                                                                              context,
                                                                          value:
                                                                              1.0),
                                                                      heightValue: height(
                                                                          context:
                                                                              context,
                                                                          value:
                                                                              0.07),
                                                                      backgroundColor: ColorConstant
                                                                          .instance
                                                                          .additionalWhite,
                                                                      borderRadius:
                                                                          66.0,
                                                                      text: viewModel
                                                                              .popularLanguageTitles[
                                                                          index],
                                                                      textStyle: currentTextTheme(context).headline3?.copyWith(
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
                                                              currentTextTheme(
                                                                      context)
                                                                  .headline3
                                                                  ?.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
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
                                                                      widthValue: width(
                                                                          context:
                                                                              context,
                                                                          value:
                                                                              1.0),
                                                                      heightValue: height(
                                                                          context:
                                                                              context,
                                                                          value:
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
                                                                      textStyle: currentTextTheme(context).headline3?.copyWith(
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
                                        style: currentTextTheme(context)
                                            .headline3
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
                                style: currentTextTheme(context)
                                    .headline1
                                    ?.copyWith(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          ColorConstant.instance.greyScale600,
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
