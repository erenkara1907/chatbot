import 'dart:ui';

import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/view/base/base_state.dart';
import 'package:chatbot/product/home/model/category_model.dart';
import 'package:chatbot/product/home/viewmodel/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletons/skeletons.dart';

import '../../../core/constants/icon_constant.dart';
import '../../../core/constants/image_constant.dart';
import '../../../core/utils/page_transition.dart';
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
              return const CircularProgressIndicator();
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
                const EdgeInsets.only(bottom: 70.0, left: 24.0, right: 24.0),
            child: ListView.builder(
              itemCount: viewModel.categories.length,
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: false,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, indexCategory) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    category(
                      category: viewModel.categories[indexCategory].title,
                      scenarios: viewModel.categories[indexCategory].scenarios,
                    ),
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
            createRoute(
              page: LevelView(
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
                style: currentTextTheme.subtitle2?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: ColorConstant.instance.additionalWhite,
                  fontSize: 14.0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                viewModel.categories[indexCategory].scenarios[index].scenario,
                style: currentTextTheme.subtitle2?.copyWith(
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
          style: currentTextTheme.subtitle1?.copyWith(
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

  Stack topWidgets() {
    return Stack(
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
              Text(
                "Hi ${viewModel.profileModel.data!.user!.name}",
                style: currentTextTheme.caption?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(155, 150, 161, 1),
                  fontSize: 14.0,
                ),
              ),
              Image.asset(
                ImageConstant.instance.imageAI,
              ),
              Text(
                "Tap to chat",
                style: currentTextTheme.caption?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: ColorConstant.instance.additionalWhite,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget chip({required String label, required void Function() onTap}) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: onTap,
      child: Chip(
        label: Text(label),
        labelStyle: currentTextTheme.subtitle1?.copyWith(
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
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 62.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Center(),
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
                                categoryName: viewModel.categories[index].title,
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
                            style: currentTextTheme.headline1?.copyWith(
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
        );
      },
    );
  }
}
