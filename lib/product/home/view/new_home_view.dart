import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/view/base/base_state.dart';
import 'package:flutter/material.dart';

class NewHomeView extends StatefulWidget {
  const NewHomeView({Key? key}) : super(key: key);
  @override
// ignore: library_private_types_in_public_api
  NewHomeViewState createState() => NewHomeViewState();
}

class NewHomeViewState extends BaseState<NewHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.instance.additionalWhite,
      body: SizedBox(
        height: height(1.0),
        child: Center(
          child: CustomPaint(
            painter: ZigzagRoadmapPainter(),
          ),
        ),
      ),
    );
  }
}

class ZigzagRoadmapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();

    const startY = 0.0;
    final endY = size.height;
    final stepY = size.height / 10.0; // Zigzag çizgileri arasındaki mesafe
    final stepX = size.width / 20.0; // Tırtıklar arasındaki mesafe

    double x = 0.0;
    path.moveTo(x, startY);

    for (double y = startY + stepY; y <= endY; y += stepY) {
      x = (x == 0.0) ? stepX / 2 : 0.0;
      path.lineTo(x, y - stepY / 2);
      path.lineTo(x + stepX / 2, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ZigzagRoadmapPainter oldDelegate) => false;
}
