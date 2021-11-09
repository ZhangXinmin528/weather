import 'dart:async';
import 'dart:convert' as convert;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:weather/bloc/main/main_page_event.dart';
import 'package:weather/bloc/main/main_page_state.dart';
import 'package:weather/data/model/internal/tab_element.dart';
import 'package:weather/data/model/internal/weather_error.dart';
import 'package:weather/data/repo/local/app_local_repository.dart';
import 'package:weather/data/repo/remote/weather_remote_repo.dart';
import 'package:weather/location/location_manager.dart';
import 'package:weather/utils/datetime_utils.dart';
import 'package:weather/utils/log_utils.dart';

class MainPageBloc extends Bloc<MainPageEvent, MainPageState> {
  final LocationManager _locationManager = LocationManager();
  final WeatherRemoteRepository _weatherRemoteRepository;

  final AppLocalRepository _appLocalRepo;

  late BaiduLocation? _baiduLocation;

  final List<TabElement> tabList = [];

  MainPageBloc(this._weatherRemoteRepository, this._appLocalRepo)
      : super(LoadCityListState()) {
    _locationManager.listenLocationCallback((value) {
      //定位变化
      _baiduLocation = value;
      if (_baiduLocation != null && _baiduLocation!.city!.isNotEmpty) {
        Future.delayed(Duration(seconds: 1), () {
          add(LocationChangedEvent());
        });
        _locationManager.stopLocation();
        final String json = convert.jsonEncode(_baiduLocation!.getMap());
        _appLocalRepo.saveLocation(json);
        _appLocalRepo.saveLocationTime();
      }
      LogUtil.d("定位回调了..定位街道：：${_baiduLocation?.district}");
    });
  }

  @override
  Stream<MainPageState> mapEventToState(MainPageEvent event) async* {
    LogUtil.d("mapEventToState..$event");

    if (event is LoadCityListEvent) {
      //加载城市列表
      yield* _mapLoadCityListToState(state);
    } else if (event is RequestLocationEvent) {
      //定位相关
      yield* _mapStartLocationToState(state);
    } else if (event is LocationChangedEvent) {
      //定位数据变化
      yield* _mapLocationChangedToState(state);
    } else if (event is AddWeatherTabToMainEvent) {
      //添加天气tab
      yield* _mapAddWeatherTabToState(state);
    }
  }

  Stream<MainPageState> _mapLoadCityListToState(MainPageState state) async* {
    if (state is LoadCityListState) {
      final List<TabElement>? tabs = await _appLocalRepo.getCityList();
      if (tabs != null && tabs.isNotEmpty) {
        if (tabList.isNotEmpty) {
          tabList.clear();
        }
        tabList.addAll(tabs);
        LogUtil.d("MainPageBloc..city list size:${tabs.length}");
        yield AddWeatherTabState(true, tabList);
      } else {
        yield InitLocationState();
        add(RequestLocationEvent());
      }
    }
  }

  ///开始定位
  Stream<MainPageState> _mapStartLocationToState(MainPageState state) async* {
    LogUtil.d("_mapStartLocationToState()~");
    if (state is InitLocationState) {
      final time = await _appLocalRepo.getLocationTime();
      if (time != null && time.isNotEmpty) {
        final int span = DateTimeUtils.getTimeSpanByNow(time);
        LogUtil.d("location.. span:：$span..time:$time");
        if (span > 5) {
          _locationManager.startLocation();
        } else {
          _baiduLocation = await _appLocalRepo.getLocation();
          if (_baiduLocation != null && _baiduLocation!.city != null) {
            Future.delayed(Duration(seconds: 1), () {
              add(LocationChangedEvent());
            });
          } else {
            _locationManager.startLocation();
          }
        }
      } else {
        _locationManager.startLocation();
      }
    }
  }

  ///定位相关逻辑
  Stream<MainPageState> _mapLocationChangedToState(MainPageState state) async* {
    LogUtil.e("_mapLocationChangedToState..定位数据：${_baiduLocation?.address}");
    if (_baiduLocation != null && _baiduLocation!.city != null) {
      yield LocationSuccessState();
      add(AddWeatherTabToMainEvent());
    } else {
      LogUtil.e("定位回调了..定位失败~");
      //定位失败
      yield FailedLoadMainPageState(WeatherError.locationError);
    }
  }

  Stream<MainPageState> _mapAddWeatherTabToState(MainPageState state) async* {
    if (state is LocationSuccessState) {
      if (_baiduLocation != null && _baiduLocation!.city != null) {
        LogUtil.d("_mapAddWeatherTabToState()..定位成功~");
        final String name =
            "${_baiduLocation!.city} ${_baiduLocation?.district}";
        //定位成功

        final TabElement tabElement = generateTab(
            name, _baiduLocation!.latitude!, _baiduLocation!.longitude!);
        if (!containCity(tabElement.cityElement)) {
          tabList.add(tabElement);
          _appLocalRepo.saveCityList(tabList);
        }

        yield AddWeatherTabState(false, tabList);
      }
    } else if (state is AddSelectedCityToTabState) {
      LogUtil.d("_mapAddWeatherTabToState()..添加搜索城市~");

      final TabElement tabElement = generateTab(
          state.city, double.parse(state.lat), double.parse(state.lon));
      if (!containCity(tabElement.cityElement)) {
        tabList.add(tabElement);
        _appLocalRepo.saveCityList(tabList);
      }

      yield AddWeatherTabState(false, tabList);
    }
  }

  @override
  void onTransition(Transition<MainPageEvent, MainPageState> transition) {
    super.onTransition(transition);
    LogUtil.d("天气主页面..onTransition:$transition");
  }

  TabElement generateTab(String name, double latitude, double longitude) {
    final String key = "$latitude&$longitude";
    final CityElement cityElement = CityElement(
        key: key, name: name, latitude: latitude, longitude: longitude);
    final TabElement tab = TabElement(name, cityElement);
    return tab;
  }

  bool containCity(CityElement city) {
    bool state = false;
    if (tabList.isNotEmpty) {
      tabList.forEach((element) {
        state = state || (city.key == element.cityElement.key);
      });
    }
    return state;
  }
}
