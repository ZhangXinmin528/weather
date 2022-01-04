import 'package:flutter/material.dart';
import 'package:weather/data/model/remote/weather/weather_daily.dart';
import 'package:weather/resources/config/colors.dart';

class WeatherDailyWidget extends StatelessWidget {
  final List<Daily> dailyList;

  WeatherDailyWidget({Key? key, required this.dailyList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        color: AppColor.shadow,
        height: 200,
        padding: EdgeInsets.all(4),
        width: constraints.maxWidth,
        child: CustomPaint(
          painter: DailyChart(dailyList),
        ),
      );
    });
  }
}

class DailyChart extends CustomPainter {
  final List<Daily> dailyList;

  double maxTemp = 0;
  double minTemp = 0;

  Paint? _linePaint;
  Paint? _iconPaint;

  DailyChart(this.dailyList) {
    _linePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    _iconPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;

    final today = dailyList[0];
    maxTemp = double.parse(today.tempMax);
    minTemp = double.parse(today.tempMin);

    caculateTempRange();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final step = size.width / dailyList.length;

    final diffTemp = maxTemp - minTemp;
    final ratioY = diffTemp / (size.height / 2.0);

    final Path maxPath = Path();
    final Path minPath = Path();

    for (int i = 0; i < dailyList.length; i++) {
      final item = dailyList[i];
      final max = double.parse(item.tempMax);
      final min = double.parse(item.tempMin);
      if (i == 0) {
        maxPath.moveTo(
            step / 2.0, (size.height / 2.0) + (maxTemp - max) / ratioY);
        minPath.moveTo(
            step / 2.0, (size.height / 2.0) + (maxTemp - min) / ratioY);
      } else {
        maxPath.lineTo(
            step * (i + 0.5), (size.height / 2.0) + (maxTemp - max) / ratioY);
        minPath.lineTo(
            step * (i + 0.5), (size.height / 2.0) + (maxTemp - min) / ratioY);
      }
    }

    canvas.drawPath(maxPath, _linePaint!..color = AppColor.textRed);
    canvas.drawPath(minPath, _linePaint!..color = AppColor.greenery);
  }

  void caculateTempRange() {
    dailyList.forEach((daily) {
      final tempMax = double.parse(daily.tempMax);
      final tempMin = double.parse(daily.tempMin);
      if (maxTemp < tempMax) {
        maxTemp = tempMax;
      }

      if (minTemp > tempMin) {
        minTemp = tempMin;
      }
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
