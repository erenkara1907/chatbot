import 'dart:math';
import 'dart:ui';

import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/view/base/base_state.dart';
import 'package:chatbot/product/home/model/category_model.dart';
import 'package:chatbot/product/home/viewmodel/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletons/skeletons.dart';

import '../../../core/constants/icon_constant.dart';
import '../../level/view/level_view.dart';
import 'category_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
// ignore: library_private_types_in_public_api
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends BaseState<HomeView> {
  HomeViewModel viewModel = HomeViewModel();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: ColorConstant.instance.paletteBackground,
        body: FutureBuilder(
          future: viewModel.getCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Skeleton(
                  isLoading: true,
                  skeleton: Padding(
                    padding: const EdgeInsets.only(
                        left: 24.0, right: 24.0, top: 55.0),
                    child: Column(
                      children: [
                        SkeletonItem(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SkeletonAvatar(
                                style: SkeletonAvatarStyle(
                                  width: 44.0,
                                  height: 44.0,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SkeletonItem(
                                child: Container(
                                  width: 107.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 75.0),
                        const SkeletonAvatar(
                          style: SkeletonAvatarStyle(
                            width: 147.0,
                            height: 147.0,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(height: 75.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SkeletonParagraph(
                              style: const SkeletonParagraphStyle(
                                lines: 1,
                                lineStyle: SkeletonLineStyle(
                                  width: 35.0,
                                ),
                              ),
                            ),
                            const SkeletonAvatar(
                              style: SkeletonAvatarStyle(
                                width: 16.0,
                                height: 16.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          height: 180.0,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SkeletonItem(
                                  child: Container(
                                    width: 162.0,
                                    height: 166.0,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                SkeletonItem(
                                  child: Container(
                                    width: 162.0,
                                    height: 166.0,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                SkeletonItem(
                                  child: Container(
                                    width: 162.0,
                                    height: 166.0,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        SizedBox(
                          height: 170.0,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SkeletonItem(
                                  child: Container(
                                    width: 162.0,
                                    height: 166.0,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                SkeletonItem(
                                  child: Container(
                                    width: 162.0,
                                    height: 166.0,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                SkeletonItem(
                                  child: Container(
                                    width: 162.0,
                                    height: 166.0,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  child: const Center(),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return hasData();
            } else {
              return const Text("error");
            }
          },
        ),
      ),
    );
  }

  SingleChildScrollView hasData() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          topWidgets(),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 90.0, left: 24.0, right: 24.0),
            child: ListView.builder(
              itemCount: viewModel.categories.length,
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: false,
              shrinkWrap: true,
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
                              child: scenarioCard(indexCategory, index),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  SizedBox scenarioCard(int indexCategory, int index) {
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LevelView(
                profilePhoto: viewModel.profileModel.data!.user!.profilePhoto!,
                scenarioId:
                    viewModel.categories[indexCategory].scenarios[index].id,
                levels:
                    viewModel.categories[indexCategory].scenarios[index].levels,
                scenarioName:
                    viewModel.categories[indexCategory].scenarios[index].title,
                scenario: viewModel
                    .categories[indexCategory].scenarios[index].scenario,
                scenarioIcon:
                    viewModel.categories[indexCategory].scenarios[index].icon,
              ),
            ),
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
                style: currentTextTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: ColorConstant.instance.additionalWhite,
                  fontSize: 14.0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                viewModel.categories[indexCategory].scenarios[index].scenario,
                style: currentTextTheme.titleSmall?.copyWith(
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

  Row category(
      {required String category,
      required List<ScenariosOfCategory> scenarios}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          category,
          style: currentTextTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: ColorConstant.instance.additionalWhite,
            fontSize: 20.0,
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryView(
                  profilePhoto:
                      viewModel.profileModel.data!.user!.profilePhoto!,
                  categoryName: category,
                  scenariosOfCategory: scenarios,
                ),
              ),
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

  Padding topWidgets() {
    return Padding(
      padding: const EdgeInsets.only(top: 77.0, left: 24.0, right: 24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 24.0,
                backgroundImage: NetworkImage(
                    viewModel.profileModel.data!.user!.profilePhoto!),
              ),
              chip(
                label: "Category",
                onTap: () {
                  chipDialogCategory();
                },
              ),
            ],
          ),
          const SizedBox(height: 33.0),
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                "assets/images/image_circle_loop_home.gif",
              ),
              Positioned(
                top: 60.0,
                left: 0.0,
                right: 0.0,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Hi ${viewModel.profileModel.data!.user!.name}",
                    style: currentTextTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(155, 150, 161, 1),
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 60.0,
                left: 0.0,
                right: 0.0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: TextButton(
                    onPressed: () {
                      var index = 0;
                      var rng = Random();
                      for (var i = 0; i < viewModel.scenarios.length; i++) {
                        index = rng.nextInt(viewModel.scenarios.length);
                      }

                      viewModel.createConversation(
                        context,
                        scenarioId: index.toString(),
                        cefr: 'A1',
                        scenarioTitle: viewModel.scenarios[index].title!,
                        profilePhoto:
                            viewModel.profileModel.data!.user!.profilePhoto!,
                      );
                    },
                    child: Text(
                      "Tap to chat",
                      style: currentTextTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: ColorConstant.instance.additionalWhite,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget chip({required String label, required void Function() onTap}) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: onTap,
      child: Chip(
        label: Text(label),
        labelStyle: currentTextTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: ColorConstant.instance.greyScale50,
          fontSize: 12.0,
        ),
        padding: const EdgeInsets.all(10.0),
        backgroundColor: const Color.fromRGBO(69, 70, 72, 1),
        deleteIcon: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: InkWell(
            onTap: () {
              chipDialogCategory();
            },
            child: SvgPicture.asset(
              IconConstant.instance.iconArrowDown,
              width: 16.0,
              height: 16.0,
              color: ColorConstant.instance.greyScale50,
            ),
          ),
        ),
        deleteButtonTooltipMessage: "",
        onDeleted: () {
          chipDialogCategory();
        },
      ),
    );
  }

  Future<dynamic> chipDialogCategory() {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            color: const Color.fromRGBO(38, 38, 38, 0.6),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 62.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30.0),
                    ListView.builder(
                      itemCount: viewModel.categories.length,
                      addAutomaticKeepAlives: false,
                      addRepaintBoundaries: false,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryView(
                                  profilePhoto: viewModel
                                      .profileModel.data!.user!.profilePhoto!,
                                  categoryName:
                                      viewModel.categories[index].title,
                                  scenariosOfCategory:
                                      viewModel.categories[index].scenarios,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              viewModel.categories[index].title,
                              style: currentTextTheme.displayLarge?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: ColorConstant.instance.additionalWhite,
                                fontSize: 24.0,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(50.0),
                      child: CircleAvatar(
                        radius: 30.0,
                        backgroundColor: ColorConstant.instance.additionalWhite,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.close,
                            size: 24.0,
                            color: ColorConstant.instance.greyScale900,
                          ),
                        ),
                      ),
                    )
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
