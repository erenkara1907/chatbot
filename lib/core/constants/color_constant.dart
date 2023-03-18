import 'package:flutter/material.dart';

class ColorConstant {
  static ColorConstant? _instance;
  static ColorConstant get instance {
    _instance ??= ColorConstant._init();
    return _instance!;
  }

  ColorConstant._init();

  // Greyscale
  Color greyScale50 = const Color.fromRGBO(250, 250, 250, 1);
  Color greyScale100 = const Color.fromRGBO(247, 250, 252, 1);
  Color greyScale200 = const Color.fromRGBO(237, 242, 247, 1);
  Color greyScale300 = const Color.fromRGBO(226, 232, 240, 1);
  Color greyScale400 = const Color.fromRGBO(203, 213, 224, 1);
  Color greyScale500 = const Color.fromRGBO(160, 174, 192, 1);
  Color greyScale600 = const Color.fromRGBO(113, 128, 150, 1);
  Color greyScale700 = const Color.fromRGBO(74, 85, 104, 1);
  Color greyScale800 = const Color.fromRGBO(39, 48, 63, 1);
  Color greyScale900 = const Color.fromRGBO(26, 32, 44, 1);

  // Additional
  Color additionalRed = const Color.fromRGBO(255, 98, 67, 1);
  Color additionalGreen = const Color.fromRGBO(0, 211, 148, 1);
  Color additionalWhite = const Color.fromRGBO(255, 255, 255, 1);
}
