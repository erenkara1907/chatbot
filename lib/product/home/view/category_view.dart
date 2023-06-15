import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/constants/image_constant.dart';
import 'package:chatbot/core/view/base/base_state.dart';
import 'package:chatbot/product/home/model/category_model.dart';
import 'package:flutter/material.dart';

class CategoryView extends StatefulWidget {
  final String categoryName;
  final List<ScenariosOfCategory> scenariosOfCategory;
  const CategoryView({
    Key? key,
    required this.categoryName,
    required this.scenariosOfCategory,
  }) : super(key: key);
  @override
// ignore: library_private_types_in_public_api
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends BaseState<CategoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.instance.paletteBackground,
      body: Stack(
        children: [
          Positioned(
            top: -170.0,
            left: 0.0,
            right: 0.0,
            child: Image.asset(
              ImageConstant.instance.imageAI,
            ),
          ),
          Positioned(
            top: -170.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              color: ColorConstant.instance.paletteBackground.withOpacity(0.5),
              width: width(1.0),
              height: height(4.0),
            ),
          ),
          scenario(),
        ],
      ),
    );
  }

  SizedBox scenarioCard(int index) {
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
        onPressed: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.scenariosOfCategory[index].icon!,
                width: 48.0,
                height: 48.0,
              ),
              const SizedBox(height: 10.0),
              Text(
                widget.scenariosOfCategory[index].title!,
                style: currentTextTheme.subtitle2?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: ColorConstant.instance.additionalWhite,
                  fontSize: 14.0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                widget.scenariosOfCategory[index].scenario!,
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

  Padding scenario() {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 103.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.categoryName,
            style: currentTextTheme.caption?.copyWith(
              fontWeight: FontWeight.w600,
              color: ColorConstant.instance.additionalWhite,
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 26.0),
          GridView.builder(
            padding: EdgeInsets.zero,
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.scenariosOfCategory.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              mainAxisSpacing: 14.0,
              crossAxisSpacing: 14.0,
            ),
            itemBuilder: (context, index) {
              return scenarioCard(index);
            },
          ),
        ],
      ),
    );
  }
}
