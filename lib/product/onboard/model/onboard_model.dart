import 'package:flutter/material.dart';

class OnboardModel {
  final String image;
  final String title;
  final String subTitle;
  final String counterText;
  final Color bgColor;
  final double height;

  OnboardModel({
    required this.image,
    required this.title,
    required this.subTitle,
    required this.counterText,
    required this.bgColor,
    required this.height,
  });
}
