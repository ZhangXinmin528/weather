import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/navigation/navigation_provider.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WeatherAppState();
  }
}

class _WeatherAppState extends State<WeatherApp> {
  final _navigationProvider = NavigationProvider();
  final GlobalKey<NavigatorState> _navigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [],
        child: MaterialApp(
          debugShowCheckedModeBanner: true,
          navigatorKey: _navigationKey,
          theme: _initThemeData(),
          supportedLocales: const [
            Locale('en'),
          ],
          onGenerateRoute: _navigationProvider.router.generator,
        ));
  }

  @override
  void initState() {
    super.initState();
    //初始化路由表
    _navigationProvider.defineRotes();
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
