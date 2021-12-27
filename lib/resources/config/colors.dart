import 'package:flutter/material.dart';

abstract class AppColor {
  ///标准颜色
  static const white = Colors.white;

  /// app界面背景色
  static const ground = Colors.white;
  static const blackGround = Colors.black12;

  /// 阴影
  static const shadow = Color(0xFFEDEEF0);

  /// 字体颜色
  static const textBlack = Colors.black;
  static const textWhite = Colors.white;
  static const textWhite60 = Colors.white60;
  static const textGreyDark = Color(0xFF666666);
  static const textGreyLight = Color(0xFF888888);
  static const textRed = Colors.redAccent;
  static const textLightBlue = Colors.lightBlue;

  /// 分割线
  static const line = Color(0xFFBBBBBB);
  static const line2 = Color(0xFFDDDDDD);
  static const line3 = Color(0xFFEEEEEE);

  /// placeholder颜色
  static const holder = Color(0xFFCCCCCC);

  /// 所有主题色
  static const lapisBlue = Color(0xFF014284);
  static const paleDogWood = Color(0xFFECCAC0);
  static const greenery = Color(0xFF7DA743);
  static const primroseYellow = Color(0xFFF1C84C);
  static const flame = Color(0xFFF44727);
  static const islandParadise = Color(0xFF8AD9E0);
  static const kale = Color(0xFF4E673F);
  static const pinkYarrow = Color(0xFFC72B6C);
  static const niagara = Color(0xFF4C829E);

  ///天气预警等级色值
  static const warningWhite = Colors.white;
  static const warningBlue = Colors.blue;
  static const warningGreen = Colors.green;
  static const warningYellow = Colors.yellow;
  static const warningOrange = Colors.orange;
  static const warningRed = Colors.red;
  static const warningBlack = Colors.black;

  ///空气质量
  ///一级
  static const airExcellent = Color(0xFF95B359);

  ///二级
  static const airGood = Color(0xFFD9D459);

  ///三级
  static const airLow = Color(0xFFE0991D);

  ///四级
  static const airMid = Color(0xFFD96161);

  ///五级
  static const airBad = Color(0xFFCB90F0);

  ///六级
  static const airSerious = Color(0xFFD9416F);
}
