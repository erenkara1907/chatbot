import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/view/base/base_state.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/image_constant.dart';
import '../../auth/language/view/native_language_view.dart';
import '../viewmodel/home_view_model.dart';

class NewHomeView extends StatefulWidget {
  const NewHomeView({Key? key}) : super(key: key);

  @override
  NewHomeViewState createState() => NewHomeViewState();
}

class NewHomeViewState extends BaseState<NewHomeView> {
  HomeViewModel viewModel = HomeViewModel();

  FirebaseAnalytics analyticInstance = FirebaseAnalytics.instance;
  Future? categoriesFuture;

  checkRegisterStatus() {
    Future.delayed(const Duration(seconds: 2), () {
      if (viewModel.profileModel.data?.user?.nativeLanguage == null) {
        analyticInstance.logEvent(name: 'back_to_language_view_from_home_view');
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NativeLanguageView()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    categoriesFuture =
        Provider.of<HomeViewModel>(context, listen: false).getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Positioned(
            right: 0.0,
            child: Image.asset(
              ImageConstant.instance.imageHomeRightEllipse,
              width: width(1.0),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Image.asset(
              ImageConstant.instance.imageHomeBottomEllipse,
              width: width(1.0),
              fit: BoxFit.cover,
            ),
          ),
          Consumer<HomeViewModel>(
            builder: (context, state, child) {
              return Padding(
                padding: const EdgeInsets.only(top: 68.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: profileInfo(),
                    ),
                    Expanded(
                      child: ListView.builder(
                          addAutomaticKeepAlives: false,
                          addRepaintBoundaries: false,
                          physics: const ClampingScrollPhysics(),
                          itemCount: 8,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Positioned(
                                  left: 24.0,
                                  right: 24.0,
                                  top: 200.0,
                                  child: Center(
                                    child: SvgPicture.asset(
                                      ImageConstant.instance.imageHomeLine,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 30.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Shop",
                                        style: currentTextTheme.bodyLarge
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: ColorConstant
                                              .instance.additionalWhite,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                      const SizedBox(height: 7.0),
                                      Text(
                                        "1/6",
                                        style: currentTextTheme.bodyLarge
                                            ?.copyWith(
                                          fontWeight: FontWeight.w300,
                                          color: ColorConstant
                                              .instance.additionalWhite,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                      const SizedBox(height: 4.0),
                                      SizedBox(
                                        height: 3.0,
                                        width: 136.0,
                                        child: LinearProgressIndicator(
                                          value: 0.4,
                                          backgroundColor: const Color.fromRGBO(
                                              69, 70, 72, 1),
                                          color: ColorConstant
                                              .instance.paletteBlue,
                                        ),
                                      ),
                                      const SizedBox(height: 26.0),
                                      SizedBox(
                                        width: width(1.0),
                                        height: height(1.1),
                                        child: Stack(
                                          alignment: Alignment.topLeft,
                                          children: List.generate(6, (index) {
                                            return Positioned(
                                              left: index == 0
                                                  ? width(0.1)
                                                  : index == 1
                                                      ? width(0.58)
                                                      : index == 2
                                                          ? width(0.10)
                                                          : index == 3
                                                              ? width(0.6)
                                                              : index == 4
                                                                  ? width(0.07)
                                                                  : index == 5
                                                                      ? width(
                                                                          0.25)
                                                                      : width(
                                                                          0.13),
                                              top: index == 0
                                                  ? height(0.0)
                                                  : index == 1
                                                      ? height(0.12)
                                                      : index == 2
                                                          ? height(0.3)
                                                          : index == 3
                                                              ? height(0.6)
                                                              : index == 4
                                                                  ? height(0.69)
                                                                  : height(0.9),
                                              child: CircleAvatar(
                                                radius: 70.0,
                                                backgroundColor: ColorConstant
                                                    .instance.paletteCard,
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Row profileInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CircleAvatar(
          radius: 25.0,
          backgroundColor: Colors.pink,
        ),
        Row(
          children: [
            Container(
              height: 40.0,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(69, 70, 72, 1),
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 9.0,
              ),
              child: Row(
                children: [
                  Text(
                    "12",
                    style: currentTextTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: ColorConstant.instance.greyScale50,
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Icon(
                    Icons.person,
                    color: ColorConstant.instance.additionalWhite,
                    size: 20.0,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10.0),
            Container(
              height: 40.0,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(69, 70, 72, 1),
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 9.0,
              ),
              child: Row(
                children: [
                  Text(
                    "Category",
                    style: currentTextTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: ColorConstant.instance.greyScale50,
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Icon(
                    Icons.arrow_downward,
                    color: ColorConstant.instance.additionalWhite,
                    size: 20.0,
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
