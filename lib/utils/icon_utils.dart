import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather/resources/config/colors.dart';

class IconUtils {
  ///获取对应的svg天气图标
  static Widget getWeatherSVGIcon(String? code, {Color? color, double? size}) {
    if (code == null) {
      return SvgPicture.asset(
        "icons/999-fill.svg",
        color: color,
        semanticsLabel: 'weather svg widget',
        width: size,
        height: size,
      );
    }

    return SvgPicture.asset(
      "icons/$code-fill.svg",
      color: color,
      semanticsLabel: 'weather svg $code',
      width: size,
      height: size,
    );
  }

  ///获取对应的svg天气图标
  static Widget getWeatherWarningSVGIcon(String? code,
      {Color? color, double? size}) {
    if (code == null) {
      return SvgPicture.asset(
        "icons/9999.svg",
        color: color,
        semanticsLabel: 'weather svg widget',
        width: size,
        height: size,
      );
    }

    return SvgPicture.asset(
      "icons/$code.svg",
      color: color,
      semanticsLabel: 'weather svg $code',
      width: size,
      height: size,
    );
  }

  ///获取天气预警登记对应色值
  static Color getWeatherWarningLevelColor(String? level) {
    switch (level) {
      case "白色":
        return AppColor.warningWhite;
      case "蓝色":
        return AppColor.warningBlue;
      case "绿色":
        return AppColor.warningGreen;
      case "黄色":
        return AppColor.warningYellow;
      case "橙色":
        return AppColor.warningOrange;
      case "红色":
        return AppColor.warningRed;
      case "黑色":
        return AppColor.warningBlack;
      default:
        return AppColor.white;
    }
  }

  ///获取天气对应icon
  @deprecated
  static Widget getWeatherNowIcon(String? code, {double? size}) {
    switch (code) {
      case "100":
        return Image.asset(
          "icon/icon100.png",
          width: size,
          height: size,
        );
      case "101":
        return Image.asset(
          "icon/icon101.png",
          width: size,
          height: size,
        );
      case "102":
        return Image.asset(
          "icon/icon102.png",
          width: size,
          height: size,
        );
      case "103":
        return Image.asset(
          "icon/icon103.png",
          width: size,
          height: size,
        );
      case "104":
        return Image.asset(
          "icon/icon104.png",
          width: size,
          height: size,
        );
      case "150":
        return Image.asset(
          "icon/icon150.png",
          width: size,
          height: size,
        );
      case "153":
        return Image.asset(
          "icon/icon153.png",
          width: size,
          height: size,
        );
      case "154":
        return Image.asset(
          "icon/icon154.png",
          width: size,
          height: size,
        );
      case "300":
        return Image.asset(
          "icon/icon300.png",
          width: size,
          height: size,
        );
      case "301":
        return Image.asset(
          "icon/icon301.png",
          width: size,
          height: size,
        );
      case "302":
        return Image.asset(
          "icon/icon302.png",
          width: size,
          height: size,
        );
      case "303":
        return Image.asset(
          "icon/icon303.png",
          width: size,
          height: size,
        );
      case "304":
        return Image.asset(
          "icon/icon304.png",
          width: size,
          height: size,
        );
      case "305":
        return Image.asset(
          "icon/icon305.png",
          width: size,
          height: size,
        );
      case "306":
        return Image.asset(
          "icon/icon306.png",
          width: size,
          height: size,
        );

      case "307":
        return Image.asset(
          "icon/icon307.png",
          width: size,
          height: size,
        );
      case "308":
        return Image.asset(
          "icon/icon308.png",
          width: size,
          height: size,
        );
      case "309":
        return Image.asset(
          "icon/icon309.png",
          width: size,
          height: size,
        );
      case "310":
        return Image.asset(
          "icon/icon310.png",
          width: size,
          height: size,
        );
      case "311":
        return Image.asset(
          "icon/icon311.png",
          width: size,
          height: size,
        );
      case "312":
        return Image.asset(
          "icon/icon312.png",
          width: size,
          height: size,
        );
      case "313":
        return Image.asset(
          "icon/icon313.png",
          width: size,
          height: size,
        );
      case "314":
        return Image.asset(
          "icon/icon314.png",
          width: size,
          height: size,
        );
      case "315":
        return Image.asset(
          "icon/icon315.png",
          width: size,
          height: size,
        );

      case "316":
        return Image.asset(
          "icon/icon316.png",
          width: size,
          height: size,
        );
      case "317":
        return Image.asset(
          "icon/icon317.png",
          width: size,
          height: size,
        );
      case "318":
        return Image.asset(
          "icon/icon318.png",
          width: size,
          height: size,
        );
      case "350":
        return Image.asset(
          "icon/icon350.png",
          width: size,
          height: size,
        );
      case "351":
        return Image.asset(
          "icon/icon351.png",
          width: size,
          height: size,
        );

      case "399":
        return Image.asset(
          "icon/icon399.png",
          width: size,
          height: size,
        );
      case "400":
        return Image.asset(
          "icon/icon400.png",
          width: size,
          height: size,
        );
      case "401":
        return Image.asset(
          "icon/icon401.png",
          width: size,
          height: size,
        );
      case "402":
        return Image.asset(
          "icon/icon402.png",
          width: size,
          height: size,
        );
      case "403":
        return Image.asset(
          "icon/icon403.png",
          width: size,
          height: size,
        );
      case "404":
        return Image.asset(
          "icon/icon404.png",
          width: size,
          height: size,
        );
      case "405":
        return Image.asset(
          "icon/icon405.png",
          width: size,
          height: size,
        );
      case "406":
        return Image.asset(
          "icon/icon406.png",
          width: size,
          height: size,
        );
      case "407":
        return Image.asset(
          "icon/icon407.png",
          width: size,
          height: size,
        );
      case "408":
        return Image.asset(
          "icon/icon408.png",
          width: size,
          height: size,
        );
      case "409":
        return Image.asset(
          "icon/icon409.png",
          width: size,
          height: size,
        );

      case "410":
        return Image.asset(
          "icon/icon410.png",
          width: size,
          height: size,
        );
      case "499":
        return Image.asset(
          "icon/icon499.png",
          width: size,
          height: size,
        );
      case "456":
        return Image.asset(
          "icon/icon456.png",
          width: size,
          height: size,
        );
      case "457":
        return Image.asset(
          "icon/icon457.png",
          width: size,
          height: size,
        );
      case "500":
        return Image.asset(
          "icon/icon500.png",
          width: size,
          height: size,
        );
      case "501":
        return Image.asset(
          "icon/icon501.png",
          width: size,
          height: size,
        );
      case "502":
        return Image.asset(
          "icon/icon502.png",
          width: size,
          height: size,
        );
      case "503":
        return Image.asset(
          "icon/icon503.png",
          width: size,
          height: size,
        );
      case "504":
        return Image.asset(
          "icon/icon504.png",
          width: size,
          height: size,
        );
      case "507":
        return Image.asset(
          "icon/icon507.png",
          width: size,
          height: size,
        );
      case "508":
        return Image.asset(
          "icon/icon508.png",
          width: size,
          height: size,
        );
      case "509":
        return Image.asset(
          "icon/icon509.png",
          width: size,
          height: size,
        );
      case "510":
        return Image.asset(
          "icon/icon510.png",
          width: size,
          height: size,
        );
      case "511":
        return Image.asset(
          "icon/icon511.png",
          width: size,
          height: size,
        );
      case "512":
        return Image.asset(
          "icon/icon512.png",
          width: size,
          height: size,
        );
      case "513":
        return Image.asset(
          "icon/icon513.png",
          width: size,
          height: size,
        );

      case "514":
        return Image.asset(
          "icon/icon514.png",
          width: size,
          height: size,
        );
      case "515":
        return Image.asset(
          "icon/icon515.png",
          width: size,
          height: size,
        );
      case "900":
        return Image.asset(
          "icon/icon900.png",
          width: size,
          height: size,
        );
      case "901":
        return Image.asset(
          "icon/icon901.png",
          width: size,
          height: size,
        );
      case "999":
        return Image.asset(
          "icon/icon999.png",
          width: size,
          height: size,
        );
      default:
        return Image.asset(
          "icon/icon999.png",
          width: size,
          height: size,
        );
    }
  }
}
