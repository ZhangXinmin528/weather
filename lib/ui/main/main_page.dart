import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:weather/bloc/app/app_bloc.dart';
import 'package:weather/bloc/app/app_event.dart';
import 'package:weather/bloc/main/main_page_bloc.dart';
import 'package:weather/bloc/main/main_page_event.dart';
import 'package:weather/bloc/main/main_page_state.dart';
import 'package:weather/bloc/navigation/navigation_bloc.dart';
import 'package:weather/bloc/navigation/navigation_event.dart';
import 'package:weather/data/model/internal/overflow_menu_element.dart';
import 'package:weather/data/model/internal/tab_element.dart';
import 'package:weather/data/model/internal/weather_error.dart';
import 'package:weather/ui/weather/weather_page.dart';
import 'package:weather/ui/widget/application_colors.dart';
import 'package:weather/ui/widget/loading_widget.dart';
import 'package:weather/ui/widget/widget_helper.dart';
import 'package:weather/utils/log_utils.dart';

///天气主页
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late AppBloc _appBloc;
  late MainPageBloc _mainPageBloc;
  late NavigationBloc _navigationBloc;

  late bool loadingVisiable = true;

  //tab
  final List<TabElement> tabList = [];
  late String currentCity = "";
  late PageController _pageController;
  late int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _appBloc = BlocProvider.of(context);
    _appBloc.add(LoadSettingsAppEvent());

    _mainPageBloc = BlocProvider.of(context);
    _mainPageBloc.add(LoadCityListEvent());

    _navigationBloc = BlocProvider.of(context);

    _pageController = PageController(
      initialPage: 0,
      keepPage: true,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<MainPageBloc, MainPageState>(
        listener: (context, state) {
          if (state is InitLocationState) {
          } else {
            setState(() {
              loadingVisiable = false;
            });
            if (state is AddWeatherTabState) {
              setState(() {
                loadingVisiable = false;
              });
              final tabs = state.tabList;
              LogUtil.d("BlocListener..size:${tabs.length}");
              if (tabs != null && tabs.isNotEmpty) {
                setState(() {
                  tabList.clear();
                  tabList.addAll(tabs);
                  int index = 0;
                  if (tabList.length > 1 && !state.isInit) {
                    index = tabList.length - 1;
                  } else {
                    index = 0;
                  }
                  currentCity = tabList[index].title;
                  _pageController.animateToPage(index,
                      duration: Duration(seconds: 1), curve: Curves.ease);
                });
              }
            }
          }
        },
        bloc: _mainPageBloc,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            _buildLightBackground(),
            // _buildLoadingWidget(),
            _buildWeatherTabWidget(),
            _buildToolbar()
          ],
        ),
        listenWhen: (previous, current) {
          return true;
        },
      ),
    );
  }

  /// 展示天气实时数据
  Widget _buildWeatherTabWidget() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView.builder(
          itemBuilder: (context, index) {
            return WeatherPage(tabList[index].cityElement);
          },
          onPageChanged: (index) {
            setState(() {
              currentCity = tabList[index].title;
              selectedIndex = index;
            });
          },
          reverse: false,
          itemCount: tabList.length,
          // physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          controller: _pageController,
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                tabList.length,
                (index) {
                  return Container(
                    width: 10.0,
                    height: 10.0,
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: index == selectedIndex
                          ? Color.fromARGB(255, 149, 182, 226)
                          : Colors.black38,
                      shape: BoxShape.circle,
                    ),
                  );
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildLoadingWidget() {
    return Visibility(
      child: LoadingWidget(),
      visible: loadingVisiable,
    );
  }

  ///失败页面
  Widget _buildFailedToLoadDataWidget(WeatherError error) {
    final appLocalizations = AppLocalizations.of(context)!;
    String detailedDescription = "";
    switch (error) {
      case WeatherError.connectionError:
        detailedDescription = appLocalizations.error_server_connection;
        break;
      case WeatherError.locationError:
        detailedDescription = appLocalizations.error_location_disabled;
        break;
      case WeatherError.data_not_available:
        detailedDescription = appLocalizations.error_date_not_available;
        break;
    }

    return _buildErrorWidget(
      "${appLocalizations.error_failed_to_load_weather_data} $detailedDescription",
      () {
        // _mainScreenBloc.add(RefreshMainEvent());
      },
      key: const Key("main_screen_failed_to_load_data_widget"),
    );
  }

  ///背景色
  Widget _buildGradientWidget() {
    return Container(
      key: const Key("main_screen_gradient_widget"),
      decoration: BoxDecoration(
        gradient: WidgetHelper.buildGradient(
          ApplicationColors.nightStartColor,
          ApplicationColors.nightEndColor,
        ),
      ),
    );
  }

  ///创建浅色背景
  Widget _buildLightBackground([double? maxHeight]) {
    return Container(
      key: const Key("main_screen_light_background"),
      child: Image.network(
        "https://cdn.qweather.com/img/plugin/190516/bg/h5/lightd.png",
        errorBuilder:
            (BuildContext context, Object exceptio, StackTrace? stackTrace) {
          LogUtil.e("An error occured when loading lightBackground image~");
          return Image.asset("images/lightd.png");
        },
      ),
      alignment: Alignment.topCenter,
      height: maxHeight,
    );
  }

  ///创建深色背景
  Widget _buildDarkBackground() {
    return Container(
      key: const Key("main_screen_dark_background"),
      child: Image.network(
          "https://cdn.qweather.com/img/plugin/190516/bg/h5/darkd.png"),
    );
  }

  ///异常情况
  Widget _buildErrorWidget(
    String errorMessage,
    Function() onRetryClicked, {
    Key? key,
  }) {
    final ButtonStyle buttonStyle =
        ElevatedButton.styleFrom(primary: Colors.redAccent);

    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                TextButton(
                  onPressed: onRetryClicked,
                  child: Text(
                    AppLocalizations.of(context)!.retry,
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: buttonStyle,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  ///构建标题栏
  Widget _buildToolbar() {
    return Container(
      key: const Key("main_screen_toolbar"),
      color: Color.fromARGB(255, 149, 182, 226),
      padding: EdgeInsets.only(top: 40.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            key: Key('main_screen_toolbar_title'),
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                //定位地址
                currentCity,
                key: const Key("main_screen_text_address"),
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal),
              ),
            ],
          ),
          Row(
            key: Key('main_screen_toolbar_menu'),
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Theme(
                data: Theme.of(context).copyWith(cardColor: Colors.white),
                child: PopupMenuButton<PopupMenuElement>(
                  onSelected: (PopupMenuElement element) {
                    _onMenuElementClicked(element, context);
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  elevation: 1,
                  offset: Offset(0, 50.0),
                  itemBuilder: (BuildContext context) {
                    return _getOverflowMenu(context)
                        .map((PopupMenuElement element) {
                      return PopupMenuItem<PopupMenuElement>(
                        value: element,
                        child: Text(
                          element.title!,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ],
          ),
          Row(
            key: Key('main_screen_toolbar_city'),
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Theme(
                data: Theme.of(context).copyWith(cardColor: Colors.white),
                child: IconButton(
                    onPressed: () {
                      _navigationBloc.add(CityManagePageNavigationEvent());
                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///菜单项
  List<PopupMenuElement> _getOverflowMenu(BuildContext context) {
    final applicationLocalization = AppLocalizations.of(context)!;
    final List<PopupMenuElement> menuList = [];
    menuList.add(PopupMenuElement(
        key: const Key("menu_overflow_settings"),
        title: applicationLocalization.settings));
    menuList.add(PopupMenuElement(
        key: const Key("menu_overflow_about"),
        title: applicationLocalization.about));
    return menuList;
  }

  ///菜单点击
  void _onMenuElementClicked(PopupMenuElement value, BuildContext context) {
    List<Color> startGradientColors = [];

    if (value.key == const Key("menu_overflow_settings")) {
      _navigationBloc.add(SettingsPageNavigationEvent(startGradientColors));
    }
    if (value.key == const Key("menu_overflow_about")) {
      _navigationBloc.add(AboutScreenNavigationEvent(startGradientColors));
    }
  }
}
