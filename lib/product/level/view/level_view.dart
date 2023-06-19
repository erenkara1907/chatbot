// ignore_for_file: deprecated_member_use

import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/constants/icon_constant.dart';
import 'package:chatbot/core/view/base/base_state.dart';
import 'package:chatbot/product/conversation/view/conversation_room_view.dart';
import 'package:chatbot/product/home/viewmodel/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/image_constant.dart';
import '../../home/model/category_model.dart';

class LevelView extends StatefulWidget {
  final String scenarioName;
  final String scenario;
  final String scenarioIcon;
  final int scenarioId;
  final List<Level> levels;
  final String profilePhoto;

  const LevelView({
    Key? key,
    required this.scenarioName,
    required this.scenario,
    required this.scenarioIcon,
    required this.levels,
    required this.scenarioId,
    required this.profilePhoto,
  }) : super(key: key);
  @override
// ignore: library_private_types_in_public_api
  _LevelViewState createState() => _LevelViewState();
}

class _LevelViewState extends BaseState<LevelView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.instance.paletteBackground,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Stack(
          children: [
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: Image.asset(
                ImageConstant.instance.imageTopEllipse,
              ),
            ),
            level(),
          ],
        ),
      ),
    );
  }

  Padding level() {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 68.0),
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
                style: currentTextTheme.bodySmall?.copyWith(
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
                      backgroundColor: ColorConstant.instance.paletteCard,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () {
                      Provider.of<HomeViewModel>(context, listen: false)
                          .selectCefr(widget.levels[index].cefr);

                      widget.levels[index].conversationId != "null" &&
                              widget.levels[index].conversationCompleted !=
                                  "1.00"
                          ? Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConversationRoomView(
                                  conversationId:
                                      widget.levels[index].conversationId,
                                  scenarioTitle: widget.scenarioName,
                                  profilePhoto: widget.profilePhoto,
                                ),
                              ),
                            )
                          : Provider.of<HomeViewModel>(context, listen: false)
                              .createConversation(
                              context,
                              scenarioId: widget.scenarioId.toString(),
                              cefr: Provider.of<HomeViewModel>(context,
                                      listen: false)
                                  .selectedCefr,
                              scenarioTitle: widget.scenarioName,
                              profilePhoto: widget.profilePhoto,
                            );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
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
                                style: currentTextTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: ColorConstant.instance.additionalWhite,
                                  fontSize: width(1.0) % 18,
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
                                  Expanded(
                                    child: Text(
                                      widget.levels[index].scale,
                                      style: currentTextTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: ColorConstant
                                            .instance.additionalWhite,
                                        fontSize: width(1.0) % 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6.0),
                                  Expanded(
                                    child: SizedBox(  
                                      width: width(50.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: LinearProgressIndicator(
                                          backgroundColor:
                                              const Color.fromRGBO(69, 70, 72, 1),
                                          color:
                                              ColorConstant.instance.paletteBlue,
                                          value: double.parse(
                                            widget.levels[index]
                                                .conversationCompleted,
                                          ),
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
                                widget.levels[index].conversationCompleted !=
                                        "1.00"
                                    ? IconConstant.instance.iconBubble
                                    : IconConstant.instance.iconRestart,
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
    );
  }

  Row header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
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
                  Navigator.of(context).pop();
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
        SizedBox(
          width: width(0.7),
          child: Center(
            child: Text(
              widget.scenarioName,
              style: currentTextTheme.bodySmall?.copyWith(
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
