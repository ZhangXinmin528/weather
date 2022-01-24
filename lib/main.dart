import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:weather/bloc/app/app_bloc.dart';
import 'package:weather/bloc/city/city_manage_bloc.dart';
import 'package:weather/bloc/city/city_search_bloc.dart';
import 'package:weather/bloc/main/main_page_bloc.dart';
import 'package:weather/bloc/navigation/navigation_bloc.dart';
import 'package:weather/bloc/weather/weather_page_bloc.dart';
import 'package:weather/navigation/navigation_provider.dart';
import 'package:weather/resources/config/colors.dart';
import 'package:weather/utils/shared_preferences_utils.dart';
import 'package:weather/weather_observer.dart';

import 'data/repo/local/app_local_repo.dart';
import 'data/repo/local/sp_manager.dart';
import 'http/connection_provider.dart';

void main() {
  Bloc.observer = WeatherObserver();

  runApp(WeatherApp());
}

class WeatherApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    //显示布局边界
    // debugPaintSizeEnabled = true;
    return _WeatherAppState();
  }
}

class _WeatherAppState extends State<WeatherApp> {
  ///路由表
  final NavigationProvider _navigationProvider = NavigationProvider();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();
  final RouteObserver<PageRoute> _routeObserver = RouteObserver();

  ///sp
  final SPManager _storageManager = SPManager(SharedPreferencesUtils());


  late ConnectionProvider _connectionProvider;
  ///app整体缓存
  late AppLocalRepo _appLocalRepo;

  @override
  void initState() {
    super.initState();
    _appLocalRepo = AppLocalRepo(_storageManager);

    ///作用？？
    WidgetsFlutterBinding.ensureInitialized();

    //初始化路由表
    _navigationProvider.defineRotes();

    _connectionProvider = ConnectionProvider();
    _connectionProvider.initConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>(
            create: (context) {
              return AppBloc(_appLocalRepo);
            },
          ),
          //导航
          BlocProvider<NavigationBloc>(
            create: (context) {
              return NavigationBloc(_navigationProvider, _navigatorKey);
            },
          ),
          //主页面
          BlocProvider<MainPageBloc>(
            create: (context) {
              return MainPageBloc(_appLocalRepo,_connectionProvider);
            },
          ),
          //天气页面
          BlocProvider<WeatherPageBloc>(
            create: (context) {
              return WeatherPageBloc();
            },
          ),
          //城市管理
          BlocProvider<CityManageBloc>(
            create: (context) {
              return CityManageBloc(_appLocalRepo);
            },
          ),
          //城市搜索
          BlocProvider<CitySearchBloc>(
            create: (context) {
              return CitySearchBloc(_appLocalRepo);
            },
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: true,
          navigatorKey: _navigatorKey,
          debugShowMaterialGrid: false,
          //显示网格线
          theme: _initThemeData(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('zh'),
          ],
          onGenerateRoute: _navigationProvider.router.generator,
          navigatorObservers: [_routeObserver],
        ));
  }

  ThemeData _initThemeData() {
    return ThemeData(
      textTheme: const TextTheme(
        headline5: TextStyle(fontSize: 60.0, color: AppColor.textWhite),
        headline6: TextStyle(fontSize: 35, color: AppColor.textWhite),
        subtitle2: TextStyle(fontSize: 20, color: AppColor.textWhite),
        bodyText2: TextStyle(fontSize: 15, color: AppColor.textWhite),
        bodyText1: TextStyle(fontSize: 12, color: AppColor.textWhite),
      ),
    );
  }
}
