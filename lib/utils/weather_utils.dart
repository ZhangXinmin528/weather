import 'package:flutter/material.dart';
import 'package:weather/resources/config/colors.dart';

class WeatherUtils {
  ///获取空气质量对应颜色
  static Color getAQIColor(String? level) {
    switch (level) {
      case "1":
        return AppColor.airExcellent;
      case "2":
        return AppColor.airGood;
      case "3":
        return AppColor.airLow;
      case "4":
        return AppColor.airMid;
      case "5":
        return AppColor.airBad;
      case "6":
        return AppColor.airSerious;
      default:
        return AppColor.airExcellent;
    }
  }
}
