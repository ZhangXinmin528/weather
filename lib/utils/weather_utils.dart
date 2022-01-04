import 'package:flutter/material.dart';
import 'package:weather/data/model/remote/weather/weather_air.dart';
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

  ///获取空气质量对应颜色
  static String getAQIDesc(Now? now) {
    final aqi = now?.aqi;
    final category = now?.category;

    //空气质量级别
    if (category != null && category.isNotEmpty) {
      if (category.length < 3) {
        return "$aqi 空气 $category";
      } else {
        return "$aqi $category";
      }
    }

    if (aqi != null && aqi.isNotEmpty) {
      final aqiValue = int.parse(aqi);
      if (aqiValue >= 0 && aqiValue <= 50) {
        return "$aqi 空气优";
      } else if (aqiValue >= 51 && aqiValue <= 100) {
        return "$aqi 空气良";
      } else if (aqiValue >= 101 && aqiValue <= 150) {
        return "$aqi 轻度污染";
      } else if (aqiValue >= 151 && aqiValue <= 200) {
        return "$aqi 重度污染";
      } else if (aqiValue >= 201 && aqiValue <= 300) {
        return "$aqi 重度污染";
      } else if (aqiValue > 300) {
        return "$aqi 严重污染";
      }
    }

    return "";
  }
}
