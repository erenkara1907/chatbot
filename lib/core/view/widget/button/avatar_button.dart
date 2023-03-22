// ignore_for_file: use_key_in_widget_constructors

import 'package:chatbot/core/view/base/base_stateless.dart';
import 'package:flutter/material.dart';

class AvatarButton extends BaseStateless {
  final Color color;
  final String image;
  final EdgeInsetsGeometry padding;
  final int avatarId;
  final int selectedIndex;

  AvatarButton({
    required this.color,
    required this.image,
    required this.padding,
    required this.avatarId,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      height: 60.0,
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(
            width: 1.0,
            color: selectedIndex == avatarId - 1 ? Colors.red : Colors.transparent),
      ),
      child: Container(
        width: 50.0,
        height: 50.0,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Image.network(
          image,
          width: 50.0,
          height: 50.0,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
