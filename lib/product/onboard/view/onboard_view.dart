import 'package:chatbot/core/language/locale_keys.g.dart';
import 'package:chatbot/core/utils/page_transition.dart';
import 'package:chatbot/core/view/base/base_stateless.dart';
import 'package:chatbot/product/auth/register/view/register_view.dart';
import 'package:concentric_transition/concentric_transition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

final pages = [
  PageData(
    lottieString: "assets/lottie/lottie_onboard_one.json",
    icon: Icons.bubble_chart,
    title: LocaleKeys.onboard_one.tr(),
    bgColor: const Color.fromRGBO(39, 50, 168, 1),
    textColor: Colors.white,
  ),
  PageData(
    lottieString: "assets/lottie/lottie_onboard_two.json",
    icon: Icons.format_size,
    title: LocaleKeys.onboard_two.tr(),
    textColor: Colors.white,
    bgColor: const Color.fromRGBO(94, 68, 157, 1),
  ),
  PageData(
    lottieString: "assets/lottie/lottie_onboard_three.json",
    icon: Icons.hdr_weak,
    title: LocaleKeys.onboard_three.tr(),
    bgColor: const Color.fromRGBO(226, 232, 240, 1),
  ),
];

class OnboardView extends StatelessWidget {
  const OnboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ConcentricPageView(
        colors: pages.map((p) => p.bgColor).toList(),
        radius: screenWidth * 0.1,
        // curve: Curves.ease,
        nextButtonBuilder: (context) => Padding(
          padding: const EdgeInsets.only(left: 3), // visual center
          child: Icon(
            Icons.navigate_next,
            size: screenWidth * 0.08,
          ),
        ),
        onFinish: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => RegisterView()));

          Navigator.of(context).pushReplacement(
              createRoute(page: RegisterView(), begin: const Offset(0.0, 1.0)));
        },
        itemCount: pages.length,
        duration: const Duration(milliseconds: 1500),
        opacityFactor: 2.0,
        scaleFactor: 0.9,
        verticalPosition: 0.85,
        direction: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (index) {
          final page = pages[index % pages.length];
          return SafeArea(
            child: _Page(page: page),
          );
        },
      ),
    );
  }
}

class PageData {
  final String? title;
  final IconData? icon;
  final Color bgColor;
  final Color textColor;
  final String lottieString;

  const PageData({
    this.title,
    this.icon,
    required this.lottieString,
    this.bgColor = Colors.white,
    this.textColor = Colors.black,
  });
}

class _Page extends BaseStateless {
  final PageData page;

  _Page({required this.page});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    space(double p) => SizedBox(height: screenHeight * p / 100);
    return Column(
      children: [
        space(10),
        // _Image(
        //   page: page,
        //   size: 190,
        //   iconSize: 170,
        // ),
        SizedBox(
          width: width(context: context, value: 1.0),
          height: 240.0,
          child:
              Lottie.asset(page.lottieString, height: 230.0, fit: BoxFit.cover),
        ),
        space(20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: _Text(
            page: page,
            style: TextStyle(
              fontSize: screenHeight * 0.046,
            ),
          ),
        ),
      ],
    );
  }
}

class _Text extends StatelessWidget {
  const _Text({
    Key? key,
    required this.page,
    this.style,
  }) : super(key: key);

  final PageData page;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      page.title ?? '',
      style: TextStyle(
        color: page.textColor,
        fontWeight: FontWeight.w600,
        fontFamily: 'Helvetica',
        letterSpacing: 0.0,
        fontSize: 18,
        height: 1.2,
      ).merge(style),
      textAlign: TextAlign.center,
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({
    Key? key,
    required this.page,
    required this.size,
    required this.iconSize,
  }) : super(key: key);

  final PageData page;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final bgColor = page.bgColor
        // .withBlue(page.bgColor.blue - 40)
        .withGreen(page.bgColor.green + 20)
        .withRed(page.bgColor.red - 100)
        .withAlpha(90);

    final icon1Color =
        page.bgColor.withBlue(page.bgColor.blue - 10).withGreen(220);
    final icon2Color = page.bgColor.withGreen(66).withRed(77);
    final icon3Color = page.bgColor.withRed(111).withGreen(220);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(60.0)),
        color: bgColor,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            right: -5,
            bottom: -5,
            child: RotatedBox(
              quarterTurns: 2,
              child: Icon(
                page.icon,
                size: iconSize + 20,
                color: icon1Color,
              ),
            ),
          ),
          Positioned.fill(
            child: RotatedBox(
              quarterTurns: 5,
              child: Icon(
                page.icon,
                size: iconSize + 20,
                color: icon2Color,
              ),
            ),
          ),
          Icon(
            page.icon,
            size: iconSize,
            color: icon3Color,
          ),
        ],
      ),
    );
  }
}
