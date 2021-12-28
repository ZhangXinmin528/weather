import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:weather/data/model/internal/markdown.dart';
import 'package:weather/data/model/remote/weather/weather_warning.dart';
import 'package:weather/resources/config/navigation_path.dart';
import 'package:weather/ui/about/about_page.dart';
import 'package:weather/ui/city/city_manage_page.dart';
import 'package:weather/ui/city/city_search_page.dart';
import 'package:weather/ui/main/main_page.dart';
import 'package:weather/ui/weather/warning_detial_page.dart';
import 'package:weather/ui/widget/markdown_page.dart';

///应用导航器:定义导航路由
class NavigationProvider {
  final router = FluroRouter();

  ///主页
  final _mainScreenHandler = Handler(handlerFunc: (context, params) {
    return const MainPage();
  });

  ///关于
  final _aboutPageHandler = Handler(handlerFunc: (context, params) {
    return AboutPage();
  });

  ///天气预警详情
  final _warningPageHandler = Handler(handlerFunc: (context, params) {
    final list = context?.settings?.arguments as List<Warning>;
    return WarningDetialPage(
      warningList: list,
    );
  });

  ///城市管理
  final _cityManageHandler = Handler(handlerFunc: (context, params) {
    return CityManagementPage();
  });

  ///城市搜索
  final _citySearchHandler = Handler(handlerFunc: (context, params) {
    return CitySearchPage();
  });

  ///markdown
  final _markdownHandler = Handler(handlerFunc: (context, params) {
    final file = context?.settings?.arguments as MarkdownFile;
    return MarkdownPage(file);
  });

  ///定义路由列表
  void defineRotes() {
    router.define(NavigationPath.mainPagePath, handler: _mainScreenHandler);
    router.define(NavigationPath.aboutPagePath, handler: _aboutPageHandler);
    router.define(NavigationPath.warningPagePath, handler: _warningPageHandler);
    router.define(NavigationPath.markdownPagePath, handler: _markdownHandler);
    router.define(NavigationPath.cityManagePagePath,
        handler: _cityManageHandler);
    router.define(NavigationPath.citySearchPagePath,
        handler: _citySearchHandler);
  }

  ///跳转
  void navigationToPath(String path, GlobalKey<NavigatorState> natigatorKey,
      {RouteSettings? routeSettings}) {
    router.navigateTo(
      natigatorKey.currentState!.context,
      path,
      routeSettings: routeSettings,
      transition: TransitionType.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
