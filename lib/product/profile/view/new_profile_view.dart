import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/view/base/base_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/image_constant.dart';
import '../../../core/utils/connectivity_sevice.dart';

class NewProfileView extends StatefulWidget {
  const NewProfileView({Key? key}) : super(key: key);
  @override
// ignore: library_private_types_in_public_api
  _NewProfileViewState createState() => _NewProfileViewState();
}

class _NewProfileViewState extends BaseState<NewProfileView> {
  List<Color> gradientColors = [
    ColorConstant.instance.palettePurple,
    ColorConstant.instance.palettePurple,
  ];
  @override
  Widget build(BuildContext context) {
    final connectivityService =
        Provider.of<ConnectivityService>(context, listen: true);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: ColorConstant.instance.paletteBackground,
        body: connectionStatusWidget(
            connectivityService.connectionStatus, context),
      ),
    );
  }

  Widget connectionStatusWidget(
      ConnectionStatus connectionStatus, BuildContext context) {
    switch (connectionStatus) {
      case ConnectionStatus.Online:
        return profileBody(context);
      case ConnectionStatus.Offline:
        return SizedBox(
          width: width(1.0),
          height: height(1.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 250.0,
                height: 250.0,
                child: Lottie.asset(
                  "assets/lottie/lottie_network.json",
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Please check your internet connection',
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
    }
  }

  Stack profileBody(BuildContext context) {
    return Stack(
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
        profile(),
      ],
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'June';
        break;
      case 1:
        text = 'July';
        break;
      case 2:
        text = 'Agust';
        break;

      default:
        return Container();
    }

    return Text(text,
        style: currentTextTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w400,
          color: const Color.fromRGBO(69, 70, 72, 1),
          fontSize: 12.0,
        ),
        textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        horizontalInterval: 6,
        verticalInterval: 2,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.pink,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.grey,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: const AxisTitles( 
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 60,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 3,
      minY: 0,
      maxY: 2,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 2),
            FlSpot(1, 1.5),
            FlSpot(2, 0),
            FlSpot(3, 1.1),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors
                  .map((color) => color.withOpacity(0.05))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget profile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SizedBox(
        height: height(1.0),
        child: Column(
          children: [
            header(),
            profileInfo(),
            Container(
              width: width(1.0),
              height: height(0.2),
              decoration: BoxDecoration(
                color: ColorConstant.instance.paletteCard,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 19.0,
                  left: 15.0,
                  right: 15.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Rate of Spelling Mistakes",
                          style: currentTextTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.instance.additionalWhite,
                            fontSize: 16.0,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              iconSize: 12.0,
                              icon: const Icon(
                                Icons.arrow_upward_outlined,
                                size: 12.0,
                                color: Color.fromRGBO(69, 70, 72, 1),
                              ),
                            ),
                            Text(
                              "monthly",
                              style: currentTextTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(69, 70, 72, 1),
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: LineChart(
                          mainData(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            completeAndScore(),
            const SizedBox(height: 20.0),
            totalEarnings(),
          ],
        ),
      ),
    );
  }

  Container totalEarnings() {
    return Container(
      width: width(1.0),
      height: height(0.16),
      decoration: BoxDecoration(
        color: ColorConstant.instance.paletteCard,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 19.0,
          horizontal: 15.0,
        ),
        child: Column(
          children: [
            Expanded(
              child: Text(
                "Your Total Earnings",
                style: currentTextTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: ColorConstant.instance.additionalWhite,
                  fontSize: 14.0,
                ),
              ),
            ),
            const SizedBox(height: 18.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: totalEarningText(header: "New Words", earning: "20"),
                ),
                Container(
                  height:
                      70, // İsteğe bağlı, çizginin yüksekliğini belirleyebilirsiniz.
                  width: 1, // Çizginin genişliği.
                  color: ColorConstant.instance.additionalWhite
                      .withOpacity(0.2), // Çizginin rengi.
                ),
                Expanded(
                  child:
                      totalEarningText(header: "New Sentence", earning: "26"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Column totalEarningText({required String header, required String earning}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          header,
          style: currentTextTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w400,
            color: ColorConstant.instance.additionalWhite.withOpacity(0.6),
            fontSize: 14.0,
          ),
        ),
        const SizedBox(height: 6.0),
        Text(
          earning,
          style: currentTextTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w400,
            color: ColorConstant.instance.additionalWhite,
            fontSize: 24.0,
          ),
        )
      ],
    );
  }

  Row completeAndScore() {
    return Row(
      children: [
        Expanded(
          child: Container(
            width: width(0.5),
            height: height(0.2),
            decoration: BoxDecoration(
              color: ColorConstant.instance.paletteCard,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 19.0,
                horizontal: 15.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Completed Scenario",
                    style: currentTextTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.instance.additionalWhite,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    "12 👍🏻",
                    style: currentTextTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: ColorConstant.instance.additionalWhite,
                      fontSize: 40.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 20.0),
        Expanded(
          child: Container(
            width: width(0.5),
            height: height(0.2),
            decoration: BoxDecoration(
              color: ColorConstant.instance.paletteCard,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 19.0,
                horizontal: 15.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Pronunciation Score",
                    style: currentTextTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.instance.additionalWhite,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    "86 🎉",
                    style: currentTextTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: ColorConstant.instance.additionalWhite,
                      fontSize: 40.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Padding profileInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 41.0,
        vertical: 36.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.place,
                color: ColorConstant.instance.additionalWhite,
                size: 24.0,
              ),
              const SizedBox(width: 10.0),
              Text(
                "12",
                style: currentTextTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: ColorConstant.instance.additionalWhite,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          CircleAvatar(
            radius: 45.0,
            backgroundColor: ColorConstant.instance.paletteCard,
          ),
          Row(
            children: [
              Icon(
                Icons.place,
                color: ColorConstant.instance.additionalWhite,
                size: 24.0,
              ),
              const SizedBox(width: 10.0),
              Text(
                "3",
                style: currentTextTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: ColorConstant.instance.additionalWhite,
                  fontSize: 20.0,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Row header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          iconSize: 24.0,
          onPressed: () {},
          icon: Icon(
            Icons.arrow_back_ios,
            size: 24.0,
            color: ColorConstant.instance.additionalWhite,
          ),
        ),
        Text(
          "Profile",
          style: currentTextTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
            color: ColorConstant.instance.additionalWhite,
            fontSize: 16.0,
          ),
        ),
        IconButton(
          iconSize: 24.0,
          onPressed: () {},
          icon: Icon(
            Icons.settings,
            size: 24.0,
            color: ColorConstant.instance.additionalWhite,
          ),
        ),
      ],
    );
  }
}
