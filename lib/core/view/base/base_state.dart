import 'package:flutter/material.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  ThemeData get currentTheme => Theme.of(context);
  TextTheme get currentTextTheme => Theme.of(context).textTheme;

  double width(double value) => MediaQuery.of(context).size.width * value;
  double height(double value) => MediaQuery.of(context).size.height * value;
}
