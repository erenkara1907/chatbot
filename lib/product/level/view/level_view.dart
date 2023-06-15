import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/constants/icon_constant.dart';
import 'package:chatbot/core/view/base/base_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/image_constant.dart';
import '../../home/model/category_model.dart';

class LevelView extends StatefulWidget {
  final String scenarioName;
  final String scenario;
  final String scenarioIcon;
  final List<Level> levels;
  const LevelView({
    Key? key,
    required this.scenarioName,
    required this.scenario,
    required this.scenarioIcon,
    required this.levels,
  }) : super(key: key);
  @override
// ignore: library_private_types_in_public_api
  _LevelViewState createState() => _LevelViewState();
}

class _LevelViewState extends BaseState<LevelView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 68.0),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  header(),
                  const SizedBox(height: 70.0),
                  Column(
                    children: [
                      SvgPicture.network(
                        widget.scenarioIcon,
                        width: 62.0,
                        height: 62.0,
                      ),
                      const SizedBox(height: 26.0),
                      Text(
                        widget.scenario,
                        style: currentTextTheme.caption?.copyWith(
                          fontWeight: FontWeight.w300,
                          color: ColorConstant.instance.additionalWhite,
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.levels.length,
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: false,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: SizedBox(
                          width: width(1.0),
                          height: height(0.09),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  ColorConstant.instance.paletteCard,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            onPressed: () {},
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28.0,
                                vertical: 22.0,
                              ),
                              child: SizedBox(
                                height: height(0.09),
                                width: width(1.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.levels[index].cefr,
                                        style:
                                            currentTextTheme.caption?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: ColorConstant
                                              .instance.additionalWhite,
                                          fontSize: 24.0,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 18.0),
                                    Expanded(
                                      flex: 5,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.levels[index].scale,
                                            style: currentTextTheme.caption
                                                ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: ColorConstant
                                                  .instance.additionalWhite,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          const SizedBox(height: 6.0),
                                          SizedBox(
                                            width: width(50.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: LinearProgressIndicator(
                                                backgroundColor:
                                                    const Color.fromRGBO(
                                                        69, 70, 72, 1),
                                                color: ColorConstant
                                                    .instance.paletteBlue,
                                                value: double.parse(
                                                  widget.levels[index]
                                                      .conversationCompleted,
                                                ),
                                              ),
                                            ),
                                          ),
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
          ),
        ],
      ),
    );
  }

  Row header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
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
                color: ColorConstant.instance.paletteGrey,
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                IconConstant.instance.iconArrowBack,
                width: 13.0,
                height: 13.0,
                color: ColorConstant.instance.additionalWhite,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(
          width: width(0.7),
          child: Center(
            child: Text(
              widget.scenarioName,
              style: currentTextTheme.caption?.copyWith(
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
}
