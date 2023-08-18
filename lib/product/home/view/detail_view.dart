import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/view/base/base_state.dart';
import 'package:chatbot/core/view/widget/button/app_button.dart';
import 'package:flutter/material.dart';

class DetailView extends StatefulWidget {
  const DetailView({Key? key}) : super(key: key);
  @override
// ignore: library_private_types_in_public_api
  _DetailViewState createState() => _DetailViewState();
}

class _DetailViewState extends BaseState<DetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.instance.paletteBackground,
        elevation: 0,
        title: Text(
          "Short Scenario Name",
          style: currentTextTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: ColorConstant.instance.additionalWhite,
            fontSize: 18.0,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: ColorConstant.instance.additionalWhite,
        ),
      ),
      backgroundColor: ColorConstant.instance.paletteBackground,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 44.0, horizontal: 44.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 45.0,
                    backgroundColor: Colors.pink,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  "Matthew",
                  style: currentTextTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: ColorConstant.instance.additionalWhite,
                    fontSize: 24.0,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  "Software Developer",
                  style: currentTextTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: ColorConstant.instance.paletteGrey,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  "Scenario Name",
                  style: currentTextTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: ColorConstant.instance.additionalWhite,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  "Scenario Description",
                  style: currentTextTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: ColorConstant.instance.paletteGrey,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  "Mission One",
                  style: currentTextTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: ColorConstant.instance.additionalWhite,
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  "Mission Two",
                  style: currentTextTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: ColorConstant.instance.additionalWhite,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            AppButton(
              widthValue: width(1.0),
              heightValue: height(0.07),
              backgroundColor: ColorConstant.instance.paletteBlueDark,
              borderRadius: 25.0,
              text: 'Start',
              textStyle: currentTextTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.instance.additionalWhite,
                      fontSize: 18.0) ??
                  const TextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
