import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather/data/model/remote/weather/weather_daily.dart';
import 'package:weather/resources/config/colors.dart';
import 'package:weather/utils/datetime_utils.dart';
import 'package:weather/utils/system_util.dart';

class WeatherDailyWidget extends StatefulWidget {
  final List<Daily> dailyList;

  WeatherDailyWidget({Key? key, required this.dailyList}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WeatherDailyState(dailyList);
  }
}

class _WeatherDailyState extends State<WeatherDailyWidget> {
  final List<Daily> dailyList;

  _WeatherDailyState(this.dailyList);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        color: AppColor.ground,
        height: 280,
        width: constraints.maxWidth,
        child: CustomPaint(
          painter: DailyChart(context, dailyList),
        ),
      );
    });
  }
}

class DailyChart extends CustomPainter {
  final BuildContext _context;
  final List<Daily> dailyList;

  int _paddingLeft = 0;
  int _paddingTop = 0;
  int _paddingText = 0;

  double _dateHeight = 0;

  double _maxTemp = 0;
  double _minTemp = 0;

  Paint? _textPaint;
  Paint? _linePaint;
  Paint? _iconPaint;

  DailyChart(this._context, this.dailyList) {
    _paddingLeft = dpToPx(_context, 4);
    _paddingTop = dpToPx(_context, 4);
    _paddingText = dpToPx(_context, 4);

    _textPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    _linePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    _iconPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;

    final today = dailyList[0];
    _maxTemp = double.parse(today.tempMax);
    _minTemp = double.parse(today.tempMin);

    caculateTempRange();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width - _paddingLeft * 2;
    final height = size.height - _paddingTop * 2;

    final step = width / dailyList.length;

    final diffTemp = _maxTemp - _minTemp;
    final ratioY = diffTemp / (height / 2.0);

    final List<Offset> maxPoints = [];
    final List<Offset> minPoints = [];

    final Path maxPath = Path();
    final Path minPath = Path();

    for (int i = 0; i < dailyList.length; i++) {
      final item = dailyList[i];
      final date = DateTimeUtils.formatDateTimeString(
          item.fxDate, DateTimeUtils.dailyFormat);

      final max = double.parse(item.tempMax);
      final min = double.parse(item.tempMin);
      double itemX = _paddingLeft.toDouble();
      if (i == 0) {
        itemX += step / 2.0;
        maxPath.moveTo(itemX, (height / 4.0) + (_maxTemp - max) / ratioY);
        minPath.moveTo(itemX, (height / 4.0) + (_maxTemp - min) / ratioY);
        drawText(canvas, "今天", itemX, _paddingTop.toDouble());
      } else {
        itemX = _paddingLeft + step * (i + 0.5);
        maxPath.lineTo(itemX, (height / 4.0) + (_maxTemp - max) / ratioY);
        minPath.lineTo(itemX, (height / 4.0) + (_maxTemp - min) / ratioY);
        drawText(canvas, date, itemX, _paddingTop.toDouble());
      }
      // canvas.drawLine(
      //     Offset(itemX + step / 2.0, _paddingTop.toDouble()),
      //     Offset(itemX + step / 2.0, height + _paddingTop),
      //     _linePaint!
      //       ..color = AppColor.line
      //       ..strokeWidth = 1.0);

      maxPoints.add(Offset(itemX, (height / 4.0) + (_maxTemp - max) / ratioY));
      minPoints.add(Offset(itemX, (height / 4.0) + (_maxTemp - min) / ratioY));

      canvas.drawPoints(
          ui.PointMode.points,
          maxPoints,
          _linePaint!
            ..color = AppColor.textRed
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4.0
            ..strokeCap = StrokeCap.round);

      canvas.drawPoints(
          ui.PointMode.points,
          minPoints,
          _linePaint!
            ..color = AppColor.greenery
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4.0
            ..strokeCap = StrokeCap.round);

      //weather text
      drawText(canvas, item.textDay, itemX, _paddingTop + _dateHeight);

      //weather icon
      // loadImageFromAsset("icons/${item.iconDay}.svg").then((value) =>
      //     canvas.drawImage(
      //         value, Offset(itemX - value.width / 2.0, offsetY), _iconPaint!));
    }

    canvas.drawPath(
        maxPath,
        _linePaint!
          ..color = AppColor.textRed
          ..strokeWidth = 1.0);

    canvas.drawPath(
        minPath,
        _linePaint!
          ..color = AppColor.greenery
          ..strokeWidth = 1.0);
  }

  void drawText(Canvas canvas, String content, double x, double y,
      {TextStyle? style}) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: content,
        style: style ?? TextStyle(fontSize: 14.0, color: AppColor.textBlack),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final Size size = textPainter.size;
    if (content == "今天") {
      _dateHeight = size.height;
    }

    final double dx = x - size.width / 2.0;
    final double dy = y - size.height / 2.0;
    textPainter.paint(canvas, Offset(dx, dy));
  }

  //读取 assets 中的图片
  Future<ui.Image> loadImageFromAsset(String path) async {
    final ByteData data = await rootBundle.load(path);
    final List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return decodeImageFromList(bytes as Uint8List);
  }

  void caculateTempRange() {
    dailyList.forEach((daily) {
      final tempMax = double.parse(daily.tempMax);
      final tempMin = double.parse(daily.tempMin);
      if (_maxTemp < tempMax) {
        _maxTemp = tempMax;
      }

      if (_minTemp > tempMin) {
        _minTemp = tempMin;
      }
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
