import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather/data/model/remote/weather/weather_daily.dart';
import 'package:weather/resources/config/colors.dart';
import 'package:weather/utils/datetime_utils.dart';
import 'package:weather/utils/log_utils.dart';
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
  List<Daily> dailyList;
  List<ui.Image> dayIconList = [];
  List<ui.Image> nightIconList = [];

  _WeatherDailyState(this.dailyList);

  @override
  void initState() {
    super.initState();
    obtainWeatherIcons();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        color: AppColor.ground,
        height: 300,
        width: constraints.maxWidth,
        child: CustomPaint(
          painter: DailyChart(context, dailyList, dayIconList, nightIconList),
        ),
      );
    });
  }

  void obtainWeatherIcons() async {
    for (int i = 0; i < dailyList.length; i++) {
      final Daily daily = dailyList[i];
      final dayIcon = await loadSVGFromAsset(code: daily.iconDay, size: 25);
      dayIconList.insert(i, dayIcon);
      final nightIcon = await loadSVGFromAsset(code: daily.iconNight, size: 25);
      nightIconList.insert(i, nightIcon);
    }
  }

  Future<ui.Image> loadSVGFromAsset(
      {required String code, required int size}) async {
    final rawSvg = await rootBundle.loadString("icons/$code-fill.svg");

    final DrawableRoot svgRoot = await svg.fromSvgString(rawSvg, rawSvg);
    final ui.Picture picture = svgRoot.toPicture(
        size: Size(size.toDouble(), size.toDouble()), clipToViewBox: false);
    return picture.toImage(size, size);
  }
}

class DailyChart extends CustomPainter {
  final BuildContext _context;
  final List<Daily> dailyList;
  final List<ui.Image> dayIconList;
  final List<ui.Image> nightIconList;

  int _paddingLeft = 0;
  int _paddingTop = 0;

  double _textHeight = 0;

  double _maxTemp = 0;
  double _minTemp = 0;

  Paint? _linePaint;
  Paint? _iconPaint;

  DailyChart(
      this._context, this.dailyList, this.dayIconList, this.nightIconList) {
    _paddingLeft = dpToPx(_context, 4);
    _paddingTop = dpToPx(_context, 4);

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: "测试",
        style: TextStyle(fontSize: 14.0, color: AppColor.textBlack),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final Size size = textPainter.size;
    _textHeight = size.height;

    _linePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    _iconPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.5;

    final today = dailyList[0];
    _maxTemp = double.parse(today.tempMax);
    _minTemp = double.parse(today.tempMin);

    caculateTempRange();
  }

  @override
  void paint(Canvas canvas, Size size) {
    // LogUtil.d("paint()..data:${dailyList.hashCode}");
    final width = size.width - _paddingLeft * 2;
    final height = size.height - _paddingTop * 2;

    final step = width / dailyList.length;

    final diffTemp = _maxTemp - _minTemp;
    final ratioY = diffTemp / (height / 3.0);

    final List<Offset> dayPoints = [];
    final List<Offset> nightPoints = [];

    final Path dayPath = Path();
    final Path nightPath = Path();

    for (int i = 0; i < dailyList.length; i++) {
      final item = dailyList[i];
      final date = DateTimeUtils.formatDateTimeString(
          item.fxDate, DateTimeUtils.dailyFormat);

      final max = double.parse(item.tempMax);
      final min = double.parse(item.tempMin);
      double itemX = _paddingLeft.toDouble();

      if (i == 0) {
        itemX += step / 2.0;
        dayPath.moveTo(
            itemX, _paddingTop + (height / 3.0) + (_maxTemp - max) / ratioY);
        nightPath.moveTo(
            itemX, _paddingTop + (height / 3.0) + (_maxTemp - min) / ratioY);
        //weather day date
        drawText(canvas,
            content: "今天", x: itemX, y: _paddingTop.toDouble() - 2, step: step);
        // LogUtil.d("paint()..date:${date}");
      } else {
        itemX = _paddingLeft + step * (i + 0.5);
        dayPath.lineTo(
            itemX, _paddingTop + (height / 3.0) + (_maxTemp - max) / ratioY);
        nightPath.lineTo(
            itemX, _paddingTop + (height / 3.0) + (_maxTemp - min) / ratioY);
        //weather day date
        drawText(canvas,
            content: date, x: itemX, y: _paddingTop.toDouble(), step: step);
      }

      ///weather day

      //weather day text
      drawText(canvas,
          content: item.textDay,
          x: itemX,
          y: _paddingTop + _textHeight,
          step: step);

      drawText(canvas,
          content: item.tempMax + "°",
          x: itemX,
          y: _paddingTop + _textHeight * 2,
          step: step);

      //weather day icon
      if (dayIconList != null &&
          dayIconList.isNotEmpty &&
          dayIconList.length > i) {
        final dayIcon = dayIconList[i];
        canvas.drawImage(
            dayIcon,
            Offset(itemX - dayIcon.width / 2.0, _paddingTop + _textHeight * 3),
            _iconPaint!..isAntiAlias = true);
      }

      canvas.drawPath(
          dayPath,
          _linePaint!
            ..color = AppColor.textRed
            ..strokeWidth = 1.0);

      dayPoints.add(Offset(
          itemX, _paddingTop + (height / 3.0) + (_maxTemp - max) / ratioY));

      canvas.drawPoints(
          ui.PointMode.points,
          dayPoints,
          _linePaint!
            ..color = AppColor.textRed
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4.0
            ..strokeCap = StrokeCap.round);

      ///weather night
      /////weather night text
      drawText(canvas,
          content: item.textNight,
          x: itemX,
          y: height - _textHeight / 2.0,
          step: step);

      drawText(canvas,
          content: item.tempMin + "°",
          x: itemX,
          y: height - _textHeight * 3 / 2.0,
          step: step);

      //weather day icon
      if (nightIconList != null &&
          nightIconList.isNotEmpty &&
          nightIconList.length > i) {
        final nightIcon = nightIconList[i];
        canvas.drawImage(
            nightIcon,
            Offset(itemX - nightIcon.width / 2.0, height - _textHeight * 3),
            _iconPaint!);
      }

      canvas.drawPath(
          nightPath,
          _linePaint!
            ..color = AppColor.greenery
            ..strokeWidth = 1.0);

      nightPoints.add(Offset(
          itemX, _paddingTop + (height / 3.0) + (_maxTemp - min) / ratioY));

      canvas.drawPoints(
          ui.PointMode.points,
          nightPoints,
          _linePaint!
            ..color = AppColor.greenery
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4.0
            ..strokeCap = StrokeCap.round);
    }
  }

  void drawText(
    Canvas canvas, {
    required String content,
    required double x,
    required double y,
    required double step,
    TextStyle? style,
  }) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: content,
        style: style ?? TextStyle(fontSize: 14.0, color: AppColor.textBlack),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );

    textPainter.layout(maxWidth: step);

    final Size size = textPainter.size;

    final double dx = x - size.width / 2.0;
    textPainter.paint(canvas, Offset(dx, y));
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
    return false;
  }
}
