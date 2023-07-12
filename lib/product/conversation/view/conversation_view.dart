// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, use_build_context_synchronously

import 'dart:ui';

import 'package:auto_animated/auto_animated.dart';
import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/language/locale_keys.g.dart';
import 'package:chatbot/core/view/base/base_stateless.dart';
import 'package:chatbot/product/conversation/viewmodel/conversation_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import '../../../core/constants/icon_constant.dart';
import '../../../core/constants/image_constant.dart';
import '../../../core/utils/connectivity_sevice.dart';
import '../../home/model/category_model.dart';
import '../../home/viewmodel/home_view_model.dart';
import 'conversation_room_view.dart';

class ConversationView extends BaseStateless {
  HomeViewModel viewModel = HomeViewModel();
  FirebaseAnalytics analyticInstance = FirebaseAnalytics.instance;
  @override
  Widget build(BuildContext context) {
    final connectivityService =
        Provider.of<ConnectivityService>(context, listen: true);
    analyticInstance.logEvent(name: "conversation_view_opened");
    Provider.of<ConversationViewModel>(context, listen: false).setActivePage();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: ColorConstant.instance.paletteBackground,
          body: connectionStatusWidget(
              connectivityService.connectionStatus, context),
        ),
      ),
    );
  }

  Widget connectionStatusWidget(
      ConnectionStatus connectionStatus, BuildContext context) {
    switch (connectionStatus) {
      case ConnectionStatus.Online:
        return conversationBody(context);
      case ConnectionStatus.Offline:
        return offlineNetwork(context);
    }
  }

  SizedBox offlineNetwork(BuildContext context) {
    return SizedBox(
      width: width(context: context, value: 1.0),
      height: height(context: context, value: 1.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 250.0,
            height: 250.0,
            child: Lottie.asset(
              "assets/lottie/lottie_network.json",
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 10.0),
          const Text(
            'Please check your internet connection',
            style: TextStyle(fontSize: 18, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Stack   conversationBody(BuildContext context) {
    return Stack(
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
    );
  }

  FutureBuilder<dynamic> messageList(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<ConversationViewModel>(context, listen: false)
          .getAllConversation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return skeletonLoading();
        } else if (snapshot.connectionState == ConnectionState.done) {
          analyticInstance.logEvent(name: "conversation_view_data_came");
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
                  style: currentTextTheme(context).displaySmall?.copyWith(
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
                            .headlineMedium
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
                            currentTextTheme(context).headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: ColorConstant.instance.additionalWhite,
                                ),
                        onTap: (index) {
                          analyticInstance.logEvent(name: "selected_$index");
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
          analyticInstance.logEvent(name: "conversation_view_data_not_came");
          return const Text('error');
        }
      },
    );
  }

  Padding skeletonLoading() {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 78.0),
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
  }

  Padding noMessage(BuildContext context) {
    analyticInstance.logEvent(name: "no_message_open");
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
            style: currentTextTheme(context).displaySmall?.copyWith(
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
    analyticInstance.logEvent(name: "no_complete_message");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 108.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            LocaleKeys.no_message.tr(),
            style: currentTextTheme(context).displaySmall?.copyWith(
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
    analyticInstance.logEvent(name: "create_message_open");
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
              analyticInstance.logEvent(name: "create_message_button");
              // showScenarios(context);
              showModalBottomSheet(
                isScrollControlled: true,
                enableDrag: true,
                context: context,
                builder: (BuildContext context) {
                  return DraggableScrollableSheet(
                    initialChildSize: 0.9,
                    expand: false,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorConstant.instance.paletteBackground,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                          ),
                          child: SingleChildScrollView(
                            controller: scrollController,
                            physics: const ClampingScrollPhysics(),
                            child: FutureBuilder(
                              future: viewModel.getCategories(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return SingleChildScrollView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 35.0,
                                        left: 24.0,
                                        right: 24.0,
                                      ),
                                      child: Column(
                                        children: [
                                          skeletonHorizontalLoading(),
                                          skeletonHorizontalLoading(),
                                          skeletonHorizontalLoading(),
                                          skeletonHorizontalLoading(),
                                        ],
                                      ),
                                    ),
                                  );
                                } else if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  analyticInstance.logEvent(
                                      name: "category_data_came");
                                  return hasData(context);
                                } else {
                                  analyticInstance.logEvent(
                                      name: "category_data_not_came");
                                  return const Text("error");
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

  Column skeletonHorizontalLoading() {
    return Column(
      children: [
        SkeletonParagraph(
          style: const SkeletonParagraphStyle(
            lines: 1,
            lineStyle: SkeletonLineStyle(
              width: 100.0,
            ),
          ),
        ),
        SizedBox(
          height: 168.0,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: SkeletonItem(
                    child: Container(
                      width: 162.0,
                      height: 168.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: ColorConstant.instance.paletteCard,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: SkeletonItem(
                    child: Container(
                      width: 162.0,
                      height: 168.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: ColorConstant.instance.paletteCard,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: SkeletonItem(
                    child: Container(
                      width: 162.0,
                      height: 168.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: ColorConstant.instance.paletteCard,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: SkeletonItem(
                    child: Container(
                      width: 162.0,
                      height: 168.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: ColorConstant.instance.paletteCard,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget hasData(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 70.0, left: 24.0, right: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30.0),
            InkWell(
              onTap: () {
                analyticInstance.logEvent(name: "closed_create_message");
                Navigator.pop(context);
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(50.0),
                    border:
                        Border.all(color: ColorConstant.instance.paletteGrey),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.close,
                      size: 16.0,
                      color: ColorConstant.instance.paletteGrey,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            ListView.builder(
              itemCount: viewModel.categories.length,
              shrinkWrap: true,
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: false,
              padding: EdgeInsets.zero,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, indexCategory) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      category(
                        context,
                        category: viewModel.categories[indexCategory].title,
                        scenarios:
                            viewModel.categories[indexCategory].scenarios,
                      ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        height: 168.0,
                        child: ListView.builder(
                          addAutomaticKeepAlives: false,
                          addRepaintBoundaries: false,
                          physics: const ClampingScrollPhysics(),
                          itemCount: viewModel
                              .categories[indexCategory].scenarios.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child:
                                  scenarioCard(context, indexCategory, index),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView scenarioOfCategory(BuildContext context,
      String categoryName, List<ScenariosOfCategory> scenarios) {
    analyticInstance.logEvent(name: "opened_category");
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    analyticInstance.logEvent(name: "closed_category");
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 24.0,
                    height: 24.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(50.0),
                      border:
                          Border.all(color: ColorConstant.instance.paletteGrey),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.close,
                        size: 16.0,
                        color: ColorConstant.instance.paletteGrey,
                      ),
                    ),
                  ),
                ),
                Text(
                  categoryName,
                  style: currentTextTheme(context).titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.instance.additionalWhite,
                        fontSize: 20.0,
                      ),
                ),
                const SizedBox(),
              ],
            ),
            const SizedBox(height: 15.0),
            GridView.builder(
              padding: EdgeInsets.zero,
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: false,
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: scenarios.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                mainAxisSpacing: 14.0,
                crossAxisSpacing: 14.0,
              ),
              itemBuilder: (context, index) {
                return scenarioCardCategory(
                  context,
                  index,
                  scenarios[index].icon,
                  scenarios[index].title,
                  scenarios[index].scenario,
                  scenarioId: scenarios[index].id,
                  levels: scenarios[index].levels,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  SizedBox scenarioCardCategory(BuildContext context, int index, String icon,
      String title, String scenario,
      {required List<Level> levels, required int scenarioId}) {
    return SizedBox(
      width: 162.0,
      height: 166.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstant.instance.paletteCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onPressed: () {
          analyticInstance.logEvent(name: "clicked_scenario_category");
          showModalBottomSheet(
            isDismissible: true,
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              analyticInstance.logEvent(name: "opened_level_view");
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: WillPopScope(
                  onWillPop: () async => false,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (details) {
                      if (details.metrics.pixels < 0 &&
                              ModalRoute.of(context)!.isCurrent ??
                          false) {
                        Navigator.pop(context);
                        return true;
                      }
                      return false;
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      decoration: BoxDecoration(
                        color: ColorConstant.instance.paletteBackground,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      child: level(
                        context,
                        title,
                        icon,
                        scenario,
                        levels,
                        scenarioId: scenarioId,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.network(
                icon,
                width: 48.0,
                height: 48.0,
                placeholderBuilder: (BuildContext context) => SkeletonItem(
                  child: Container(
                    width: 48.0,
                    height: 48.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                title,
                style: currentTextTheme(context).titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.instance.additionalWhite,
                      fontSize: 14.0,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Expanded(
                child: Text(
                  scenario,
                  style: currentTextTheme(context).titleSmall?.copyWith(
                        fontWeight: FontWeight.w300,
                        color: ColorConstant.instance.additionalWhite,
                        fontSize: 14.0,
                      ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox scenarioCard(BuildContext context, int indexCategory, int index) {
    return SizedBox(
      width: 162.0,
      height: 166.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstant.instance.paletteCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onPressed: () {
          analyticInstance.logEvent(name: "clicked_scenario");
          showModalBottomSheet(
            isDismissible: true,
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              analyticInstance.logEvent(name: "opened_level_view");
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: WillPopScope(
                  onWillPop: () async => false,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (details) {
                      if (details.metrics.pixels < 0 &&
                              ModalRoute.of(context)!.isCurrent ??
                          false) {
                        Navigator.pop(context);
                        return true;
                      }
                      return false;
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      decoration: BoxDecoration(
                        color: ColorConstant.instance.paletteBackground,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      child: level(
                          context,
                          viewModel
                              .categories[indexCategory].scenarios[index].title,
                          viewModel
                              .categories[indexCategory].scenarios[index].icon,
                          viewModel.categories[indexCategory].scenarios[index]
                              .scenario,
                          viewModel.categories[indexCategory].scenarios[index]
                              .levels,
                          scenarioId: viewModel
                              .categories[indexCategory].scenarios[index].id),
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.network(
                viewModel.categories[indexCategory].scenarios[index].icon,
                width: 48.0,
                height: 48.0,
                placeholderBuilder: (BuildContext context) => SkeletonItem(
                  child: Container(
                    width: 48.0,
                    height: 48.0,
                    decoration: BoxDecoration(
                      color: ColorConstant.instance.paletteGrey,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                viewModel.categories[indexCategory].scenarios[index].title,
                style: currentTextTheme(context).titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.instance.additionalWhite,
                      fontSize: 14.0,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                viewModel.categories[indexCategory].scenarios[index].scenario,
                style: currentTextTheme(context).titleSmall?.copyWith(
                      fontWeight: FontWeight.w300,
                      color: ColorConstant.instance.additionalWhite,
                      fontSize: 14.0,
                    ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row category(BuildContext context,
      {required String category,
      required List<ScenariosOfCategory> scenarios}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          category,
          style: currentTextTheme(context).titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: ColorConstant.instance.additionalWhite,
                fontSize: 20.0,
              ),
        ),
        IconButton(
          onPressed: () {
            analyticInstance.logEvent(name: "clicked_$category");
            showModalBottomSheet(
              isDismissible: true,
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: FractionallySizedBox(
                    heightFactor: 0.85,
                    child: Container(
                      width: width(context: context, value: 1.0),
                      decoration: BoxDecoration(
                        color: ColorConstant.instance.paletteBackground,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      child: scenarioOfCategory(
                        context,
                        category,
                        scenarios,
                      ),
                    ),
                  ),
                );
              },
            );
          },
          icon: Icon(
            Icons.arrow_forward_ios,
            color: ColorConstant.instance.additionalWhite,
            size: 16.0,
          ),
        ),
      ],
    );
  }

  Row header(BuildContext context, String scenarioName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            analyticInstance.logEvent(name: "closed_level");
            Navigator.pop(context);
          },
          child: Container(
            width: 24.0,
            height: 24.0,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(50.0),
              border: Border.all(
                color: ColorConstant.instance.paletteGrey,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.close,
                size: 16.0,
                color: ColorConstant.instance.paletteGrey,
              ),
            ),
          ),
        ),
        SizedBox(
          width: width(context: context, value: 0.7),
          child: Center(
            child: Text(
              scenarioName,
              style: currentTextTheme(context).bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: ColorConstant.instance.additionalWhite,
                    fontSize: 20.0,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(),
      ],
    );
  }

  SingleChildScrollView level(
    BuildContext context,
    String scenarioName,
    String scenarioIcon,
    String scenario,
    List<Level> levels, {
    required int scenarioId,
  }) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 35.0),
            header(context, scenarioName),
            const SizedBox(height: 35.0),
            Column(
              children: [
                SvgPicture.network(
                  scenarioIcon,
                  width: 62.0,
                  height: 62.0,
                ),
                const SizedBox(height: 26.0),
                Text(
                  scenario,
                  style: currentTextTheme(context).bodySmall?.copyWith(
                        fontWeight: FontWeight.w300,
                        color: ColorConstant.instance.additionalWhite,
                        fontSize: 16.0,
                      ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
            const SizedBox(height: 35.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: levels.length,
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: false,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: SizedBox(
                    width: width(context: context, value: 1.0),
                    height: height(context: context, value: 0.09),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstant.instance.paletteCard,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: () {
                        analyticInstance.logEvent(
                            name: "clicked_${levels[index].scale}");
                        analyticInstance.logEvent(
                            name: "go_to_conversation_room_view");
                        Provider.of<HomeViewModel>(context, listen: false)
                            .selectCefr(levels[index].cefr);
                        Provider.of<HomeViewModel>(context, listen: false)
                            .createConversation(
                          context,
                          scenarioId: scenarioId.toString(),
                          cefr:
                              Provider.of<HomeViewModel>(context, listen: false)
                                  .selectedCefr,
                          scenarioTitle: scenarioName,
                          profilePhoto: Provider.of<ConversationViewModel>(
                                  context,
                                  listen: false)
                              .profileModel
                              .data!
                              .user!
                              .profilePhoto!,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 16.0,
                        ),
                        child: SizedBox(
                          height: height(context: context, value: 0.09),
                          width: width(context: context, value: 1.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  width: 18.0,
                                  height: 20.0,
                                  child: Text(
                                    levels[index].cefr,
                                    style: currentTextTheme(context)
                                        .bodySmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: ColorConstant
                                              .instance.additionalWhite,
                                          fontSize: 18,
                                        ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 18.0),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Expanded(child: SizedBox()),
                                    Text(
                                      levels[index].scale,
                                      style: currentTextTheme(context)
                                          .bodySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: ColorConstant
                                                .instance.additionalWhite,
                                            fontSize: width(
                                                    context: context,
                                                    value: 1.0) %
                                                13,
                                          ),
                                    ),
                                    const Expanded(child: SizedBox()),
                                    SizedBox(
                                      width:
                                          width(context: context, value: 50.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: LinearProgressIndicator(
                                          backgroundColor: const Color.fromRGBO(
                                              69, 70, 72, 1),
                                          color: ColorConstant
                                              .instance.paletteBlue,
                                          value: double.parse(
                                            levels[index].conversationCompleted,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Expanded(child: SizedBox()),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20.0),
                              Expanded(
                                child: SvgPicture.asset(
                                  IconConstant.instance.iconBubble,
                                  width: 24.0,
                                  height: 24.0,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                                            .displaySmall
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
                                          .displaySmall
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
                                            .displaySmall
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
                                          .displaySmall
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
