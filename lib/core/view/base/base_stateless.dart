import 'package:flutter/material.dart';

abstract class BaseStateless extends StatelessWidget {
  ThemeData currentTheme(BuildContext context) => Theme.of(context);
  TextTheme currentTextTheme(BuildContext context) =>
      Theme.of(context).textTheme;

  double width({required BuildContext context, required double value}) {
    return MediaQuery.of(context).size.width * value;
  }

  double height({required BuildContext context, required double value}) {
    return MediaQuery.of(context).size.height * value;
  }
}
