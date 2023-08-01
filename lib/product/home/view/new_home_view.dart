import 'dart:math' as math;

import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/view/base/base_state.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../auth/language/view/native_language_view.dart';
import '../viewmodel/home_view_model.dart';

class NewHomeView extends StatefulWidget {
  const NewHomeView({Key? key}) : super(key: key);

  @override
  NewHomeViewState createState() => NewHomeViewState();
}

class NewHomeViewState extends BaseState<NewHomeView> {
  HomeViewModel viewModel = HomeViewModel();

  FirebaseAnalytics analyticInstance = FirebaseAnalytics.instance;
  Future? categoriesFuture;

  checkRegisterStatus() {
    Future.delayed(const Duration(seconds: 2), () {
      if (viewModel.profileModel.data?.user?.nativeLanguage == null) {
        analyticInstance.logEvent(name: 'back_to_language_view_from_home_view');
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NativeLanguageView()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    categoriesFuture =
        Provider.of<HomeViewModel>(context, listen: false).getCategories();
  }

  MyPainter painter = MyPainter();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.instance.paletteBackground,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
        ),
        child: FutureBuilder(
          future: categoriesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Consumer<HomeViewModel>(
                builder: (context, state, child) {
                  return Column(
                    children: [
                      SizedBox(
                        height: height(0.15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 20.0,
                              backgroundColor:
                                  ColorConstant.instance.additionalWhite,
                              backgroundImage: NetworkImage(
                                  state.profileModel.data!.user!.profilePhoto!),
                            ),
                            Text(
                              state.dummyCategories[0].title,
                              style: currentTextTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: ColorConstant.instance.additionalWhite,
                                fontSize: 18.0,
                              ),
                            ),
                            Text(
                              "300 XP",
                              style: currentTextTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: ColorConstant.instance.additionalWhite,
                                fontSize: 16.0,
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: PageView.builder(
                          onPageChanged: (index) {
                            state.changeCategory(index);
                          },
                          scrollDirection: Axis.vertical,
                          itemCount: state.categories.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Center(
                                  child: CustomPaint(
                                    size: Size(200, height(0.85)),
                                    painter: painter,
                                  ),
                                ),
                                ListView.builder(
                                  addAutomaticKeepAlives: false,
                                  addRepaintBoundaries: false,
                                  scrollDirection: Axis.vertical,
                                  physics: const ClampingScrollPhysics(),
                                  itemCount:
                                      state.dummyCategories[0].scenarios.length,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    return SizedBox(
                                      width: width(1.0),
                                      height:
                                          100.0, // CircleAvatar'ın yüksekliğine ayarlanmış
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: index == 0
                                                ? width(0.47)
                                                : index == 1
                                                    ? width(0.49)
                                                    : index == 2
                                                        ? width(0.20)
                                                        : index == 3
                                                            ? width(0.23)
                                                            : index == 4
                                                                ? width(0.52)
                                                                : index == 5
                                                                    ? width(
                                                                        0.45)
                                                                    : width(
                                                                        0.13),
                                            top: index == 0
                                                ? height(0.0)
                                                : index == 1
                                                    ? height(0.02)
                                                    : index == 3
                                                        ? height(0.02)
                                                        : index == 5
                                                            ? height(0.02)
                                                            : height(0.0),
                                            child: CircleAvatar(
                                              radius: 35.0,
                                              backgroundColor: ColorConstant
                                                  .instance.paletteCard,
                                              child: SvgPicture.network(
                                                state.dummyCategories[0]
                                                    .scenarios[index].icon,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              return const Text("error");
            }
          },
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  List<Offset> stops = [];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    const int dashLength = 10;
    const int dashSpace = 5;

    // Frekansı arttırmak için bu sabiti arttırabiliriz.
    const double frequencyIncrease = 2;

    for (int i = 0; i < size.height.toInt(); i++) {
      if (i % 100 == 0) {
        Offset offset = Offset(
            size.width / 2 +
                (size.width * 0.5) *
                    math.sin(i / size.height * math.pi * 2 * frequencyIncrease),
            i.toDouble());

        // Offset'leri listeye ekleyin
        stops.add(offset);
      }

      if (i % (dashLength + dashSpace) < dashLength) {
        canvas.drawLine(
          Offset(
            size.width / 2 +
                (size.width * 0.5) *
                    math.sin(i / size.height * math.pi * 2 * frequencyIncrease),
            i.toDouble(),
          ),
          Offset(
            size.width / 2 +
                (size.width * 0.5) *
                    math.sin((i + 1) /
                        size.height *
                        math.pi *
                        2 *
                        frequencyIncrease),
            (i + 1).toDouble(),
          ),
          paint,
        );
      }
    }

    // durak noktaları oluşturulduktan sonra callback'i çağırın
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
