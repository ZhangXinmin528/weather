import 'package:flutter/material.dart';
import 'package:weather/resources/config/colors.dart';

class WeatherUtils {
  ///获取空气质量对应颜色
  static Color getAQIColorByLevel(String? level) {
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
        return AppColor.ground;
    }
  }

  ///获取空气质量对应颜色
  static Color getAQIColorByAqi(String? aqi) {
    if (aqi == null || aqi.isEmpty) {
      return Colors.white;
    }

    final aqiValue = int.parse(aqi);
    if (aqiValue >= 0 && aqiValue <= 50) {
      return AppColor.airExcellent;
    } else if (aqiValue >= 51 && aqiValue <= 100) {
      return AppColor.airGood;
    } else if (aqiValue >= 101 && aqiValue <= 150) {
      return AppColor.airLow;
    } else if (aqiValue >= 151 && aqiValue <= 200) {
      return AppColor.airMid;
    } else if (aqiValue >= 201 && aqiValue <= 300) {
      return AppColor.airBad;
    } else if (aqiValue > 300) {
      return AppColor.airSerious;
    }
    return Colors.white;
  }
}
