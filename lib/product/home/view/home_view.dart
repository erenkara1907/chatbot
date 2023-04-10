// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, no_leading_underscores_for_local_identifiers

import 'dart:math';

import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/constants/icon_constant.dart';
import 'package:chatbot/core/language/locale_keys.g.dart';
import 'package:chatbot/core/view/base/base_stateless.dart';
import 'package:chatbot/product/home/viewmodel/home_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletons/skeletons.dart';

import '../../../core/enum/preference_keys.dart';
import '../../conversation/view/conversation_room_view.dart';

class HomeView extends BaseStateless {
  HomeViewModel viewModel = HomeViewModel();

  Future setFirstLogin() async {
    final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    final SharedPreferences _prefs = await prefs;

    viewModel.isFirst =
        _prefs.getBool(PreferencesKeys.IS_FIRST_APP.toString())!;
  }

  @override
  Widget build(BuildContext context) {
    setFirstLogin();
    return Scaffold(
      backgroundColor: ColorConstant.instance.additionalWhite,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder(
              future: viewModel.getProfileInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const SkeletonAvatar(
                              style: SkeletonAvatarStyle(
                                width: 35.0,
                                height: 35.0,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            Expanded(
                              child: Column(
                                children: [
                                  SkeletonParagraph(
                                    style: const SkeletonParagraphStyle(
                                      lines: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                  SkeletonParagraph(
                                    style: SkeletonParagraphStyle(
                                      lines: 1,
                                      lineStyle: SkeletonLineStyle(
                                        width:
                                            width(context: context, value: 0.1),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            const SkeletonAvatar(
                              style: SkeletonAvatarStyle(
                                width: 35.0,
                                height: 35.0,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          height: height(context: context, value: 0.085),
                          width: width(context: context, value: 1.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: ColorConstant.instance.greyScale300,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        SkeletonParagraph(
                          style: SkeletonParagraphStyle(
                              lines: 1,
                              lineStyle: SkeletonLineStyle(
                                  width: width(context: context, value: 0.15))),
                        ),
                        const SizedBox(height: 20.0),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height:
                                          height(context: context, value: 0.2),
                                      decoration: BoxDecoration(
                                        color:
                                            ColorConstant.instance.greyScale300,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15.0),
                                  Expanded(
                                    child: Container(
                                      height:
                                          height(context: context, value: 0.2),
                                      decoration: BoxDecoration(
                                        color:
                                            ColorConstant.instance.greyScale300,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customAppBar(context),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Divider(
                              thickness: 1.0,
                              color: ColorConstant.instance.greyScale300,
                            ),
                            const SizedBox(height: 20.0),
                            lessonCard(context),
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
                            const SizedBox(height: 16.0),
                          ],
                        ),
                      )
                    ],
                  );
                } else {
                  return const Text('error');
                }
              },
            ),
            FutureBuilder(
              future: viewModel.getTopics(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: ColorConstant.instance.greyScale900,
                    ),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        bottom: 80.0, left: 24.0, right: 24.0),
                    child: GridView.builder(
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
                    ),
                  );
                } else {
                  return const Text('error');
                }
              },
            ),
          ],
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

  Container lessonCard(BuildContext context) {
    return Container(
      width: width(context: context, value: 1.0),
      decoration: BoxDecoration(
        color: ColorConstant.instance.greyScale100,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          lessonCardTop(context),
          viewModel.isFirst ? lessonCardContent(context) : const Center(),
        ],
      ),
    );
  }

  Padding lessonCardContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          Text(
            "So nice to meet you, ${viewModel.profileModel.data!.user!.name!}! I'm here for you.✌🏻 Let's start talking.",
            style: currentTextTheme(context).headline3?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: ColorConstant.instance.greyScale900,
                ),
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: width(context: context, value: 0.41),
            height: height(context: context, value: 0.04),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.instance.greyScale300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                elevation: 0,
              ),
              onPressed: () {
                var randomNumber = Random();
                int index = 0;
                for (var i = 1; i < viewModel.topics.length; i++) {
                  index = randomNumber.nextInt(viewModel.topics.length);
                }

                topicDialog(context, index);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.start_lesson.tr(),
                    style: currentTextTheme(context).headline3?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: ColorConstant.instance.greyScale900,
                        ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: ColorConstant.instance.greyScale900,
                    size: 20.0,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }

  Container lessonCardTop(BuildContext context) {
    return Container(
      height: height(context: context, value: 0.09),
      decoration: BoxDecoration(
          borderRadius: viewModel.isFirst
              ? const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                )
              : BorderRadius.circular(20.0),
          color: ColorConstant.instance.greyScale900),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.today_practice.tr(),
                    style: currentTextTheme(context).headline1?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0,
                          color: ColorConstant.instance.additionalWhite,
                        ),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      SvgPicture.asset(
                        IconConstant.instance.iconCharge,
                        color: ColorConstant.instance.additionalWhite,
                      ),
                      const SizedBox(width: 7.0),
                      Text(
                        '${viewModel.profileModel.data!.user!.dailyPractice!.completionPercentage} COMPLETED',
                        style: currentTextTheme(context).headline6?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: ColorConstant.instance.additionalWhite,
                            ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                height: 6.0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  child: LinearProgressIndicator(
                    backgroundColor: ColorConstant.instance.greyScale800,
                    color: ColorConstant.instance.greyScale50,
                    minHeight: 6.0,
                    value: double.parse(
                      viewModel.profileModel.data!.user!.dailyPractice!.count
                          .toString(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row customAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Container(
                width: 55.0,
                height: 55.0,
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: ColorConstant.instance.greyScale300,
                        blurRadius: 10.0,
                        spreadRadius: 1.0,
                        offset: const Offset(3, 3),
                      ),
                    ],
                    color: Color.fromRGBO(
                      viewModel.profileModel.data!.user!.color![0],
                      viewModel.profileModel.data!.user!.color![1],
                      viewModel.profileModel.data!.user!.color![2],
                      1,
                    ),
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(
                      width: 1.0,
                      color: ColorConstant.instance.additionalWhite,
                    )),
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    image: DecorationImage(
                      image: NetworkImage(
                          viewModel.profileModel.data!.user!.profilePhoto!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi ${viewModel.profileModel.data!.user!.name!}'
                      .toUpperCase(),
                  style: currentTextTheme(context).headline6?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: ColorConstant.instance.greyScale600,
                      ),
                ),
                Text(
                  LocaleKeys.welcome.tr(),
                  style: currentTextTheme(context).headline3?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.instance.greyScale900,
                      ),
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 24.0),
          child: Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: ColorConstant.instance.greyScale900,
            ),
            child: IconButton(
              onPressed: () {
                var randomNumber = Random();
                int index = 0;
                for (var i = 1; i < viewModel.topics.length; i++) {
                  index = randomNumber.nextInt(viewModel.topics.length);
                }

                topicDialog(context, index);
              },
              icon: Icon(
                Icons.add,
                color: ColorConstant.instance.additionalWhite,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
