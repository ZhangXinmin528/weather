import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:weather/bloc/app/app_bloc.dart';
import 'package:weather/bloc/main/main_screen_bloc.dart';
import 'package:weather/bloc/navigation/navigation_bloc.dart';
import 'package:weather/data/repository/local/application_local_repository.dart';
import 'package:weather/data/repository/local/storage_manager.dart';
import 'package:weather/data/repository/remote/heweather_api_provider.dart';
import 'package:weather/data/repository/remote/weather_remote_repo.dart';
import 'package:weather/navigation/navigation_provider.dart';
import 'package:weather/utils/shared_preferences_utils.dart';
import 'package:weather/weather_observer.dart';

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

  ///sp
  final StorageManager _storageManager =
      StorageManager(SharedPreferencesUtils());

  ///天气数据接口数据
  final WeatherRemoteRepository _weatherRemoteRepository =
      WeatherRemoteRepository(HeWeatherApiProvider());

  ///app整体缓存
  late ApplicationLocalRepository _applicationLocalRepository;

  @override
  void initState() {
    super.initState();
    _applicationLocalRepository = ApplicationLocalRepository(_storageManager);

    ///作用？？
    WidgetsFlutterBinding.ensureInitialized();

    //初始化路由表
    _navigationProvider.defineRotes();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>(
            create: (context) {
              return AppBloc(_applicationLocalRepository);
            },
          ),
          //导航
          BlocProvider<NavigationBloc>(
            create: (context) {
              return NavigationBloc(_navigationProvider, _navigatorKey);
            },
          ),
          //主页面
          BlocProvider<MainScreenBloc>(
            create: (context) {
              return MainScreenBloc(
                  _weatherRemoteRepository, _applicationLocalRepository);
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
        ));
  }

  ThemeData _initThemeData() {
    return ThemeData(
      textTheme: const TextTheme(
        headline5: TextStyle(fontSize: 60.0, color: Colors.white),
        headline6: TextStyle(fontSize: 35, color: Colors.white),
        subtitle2: TextStyle(fontSize: 20, color: Colors.white),
        bodyText2: TextStyle(fontSize: 15, color: Colors.white),
        bodyText1: TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }
}
