import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/bloc/city/city_manage_bloc.dart';
import 'package:weather/bloc/city/city_manage_event.dart';
import 'package:weather/bloc/city/city_manage_state.dart';
import 'package:weather/bloc/main/main_page_bloc.dart';
import 'package:weather/bloc/main/main_page_event.dart';
import 'package:weather/bloc/main/main_page_state.dart';
import 'package:weather/bloc/navigation/navigation_bloc.dart';
import 'package:weather/bloc/navigation/navigation_event.dart';
import 'package:weather/data/model/internal/tab_element.dart';
import 'package:weather/data/model/remote/weather/weather_now.dart';
import 'package:weather/data/repo/local/sqlite_manager.dart';
import 'package:weather/utils/log_utils.dart';

///城市管理
class CityManagementPage extends StatefulWidget {
  const CityManagementPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CityManangePageState();
  }
}

class _CityManangePageState extends State<CityManagementPage> {
  final SqliteManager _sqliteManager = SqliteManager.INSTANCE;

  late NavigationBloc _navigationBloc;
  late CityManageBloc _cityManageBloc;
  late MainPageBloc _mainPageBloc;

  IconData _menuIcon = Icons.reorder;
  bool _isEditedMode = false;
  late String _title = "城市管理";
  late bool _changed = false;
  List<TabElement> _tabList = [];

  @override
  void initState() {
    super.initState();
    _navigationBloc = BlocProvider.of(context);
    _cityManageBloc = BlocProvider.of(context);
    _cityManageBloc.add(InitCityListEvent());
    _cityManageBloc.emit(InitCityListState());

    _mainPageBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              leading: IconButton(
                  onPressed: () {
                    if (_changed) {
                      _mainPageBloc.add(LoadCityListEvent());
                      _mainPageBloc.emit(LoadCityListState());
                    }
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  )),
              pinned: true,
              expandedHeight: 120.0,
              backgroundColor: Colors.white,
              forceElevated: innerBoxIsScrolled,
              actions: [
                IconButton(
                  onPressed: () {
                    if (_menuIcon == Icons.reorder) {
                      //进入编辑模式
                      _isEditedMode = true;
                      setState(() {
                        _menuIcon = Icons.save;
                        _title = "编辑模式";
                      });
                    } else {
                      //保存配置
                      _isEditedMode = false;
                      setState(() {
                        _menuIcon = Icons.reorder;
                        _title = "城市管理";
                      });
                      if (_changed) {
                        _cityManageBloc.add(SaveChangedEvent());
                        _cityManageBloc.emit(SaveCityChangedState(_tabList));
                      }
                    }
                  },
                  icon: Icon(_menuIcon),
                  color: Colors.black,
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  _title,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ];
        },
        body: SafeArea(
          top: false,
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 45,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(
                      left: 22.0, top: 20.0, right: 22.0, bottom: 10.0),
                  padding: EdgeInsets.only(
                      left: 12.0, top: 2.0, right: 12.0, bottom: 2.0),
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0)),
                      color: Colors.white),
                  child: TextButton.icon(
                      onPressed: () {
                        _navigationBloc.add(CitySearchPageNavigationEvent());
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.all(Colors.white)),
                      icon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      label: Text(
                        "搜索城市（中文/拼音）",
                        style: TextStyle(color: Colors.grey, fontSize: 16.0),
                      )),
                ),
                _buildListWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListWidget() {
    return BlocBuilder<CityManageBloc, CityManageState>(
        builder: (context, state) {
      if (state is CityListSuccessState) {
        if (_menuIcon == Icons.save) {
          return _buildReorderableListWidget(state);
        } else {
          return _buildCityListWidget(state);
        }
      } else {
        return SizedBox();
      }
    });
  }

  ///不可编辑列表
  Widget _buildCityListWidget(CityListSuccessState state) {
    final tabList = state.tabList;
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final tab = tabList[index];

          return _buildListItemWidget(
              key: Key("city_manage_page_listview_common"),
              tab: tab,
              orderEnable: false);
        },
        itemCount: tabList.length,
      ),
    );
  }

  ///可编辑列表
  Widget _buildReorderableListWidget(CityListSuccessState state) {
    final tabList = state.tabList;
    if (_tabList.isNotEmpty) {
      _tabList.clear();
    }
    _tabList.addAll(tabList);
    final bodyList = _tabList.sublist(1, tabList.length);
    final tabHeader = _tabList[0];
    return Container(
      child: ReorderableListView.builder(
          key: Key('city_manage_page_listview'),
          shrinkWrap: true,
          header: _buildListItemWidget(
              key: Key("city_manage_page_listview_header"),
              tab: tabHeader,
              orderEnable: false),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final tab = bodyList[index];
            return Dismissible(
                key: Key(
                    'city_manage_page_listview_item_dismiss:${tab.cityElement.longitude}&${tab.cityElement.latitude}'),
                secondaryBackground: Container(
                  color: Colors.red,
                  margin: EdgeInsets.all(16.0),
                  padding: EdgeInsets.only(right: 16.0),
                  alignment: Alignment.centerRight,
                  child: Text(
                    "删除",
                    style: TextStyle(color: Colors.black, fontSize: 18.0),
                  ),
                ),
                background: Container(
                  color: Colors.white,
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  LogUtil.d("CityManagePage..onDismissed");
                  setState(() {
                    _changed = true;
                    _tabList.removeAt(index + 1);
                    tabList.removeAt(index + 1);
                  });

                  ///TODO:需要删除对应城市的缓存数据
                },
                confirmDismiss: (direction) {
                  return Future<bool>.delayed(Duration(milliseconds: 100), () {
                    return _menuIcon == Icons.save;
                  });
                },
                child: _buildListItemWidget(
                    key: Key('city_manage_page_listview_item:$index'),
                    tab: tab,
                    orderEnable: true));
          },
          itemCount: bodyList.length,
          onReorder: (oldIndex, newIndex) {
            if (_menuIcon == Icons.save) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                _changed = true;
                _tabList.insert(newIndex + 1, _tabList.removeAt(oldIndex + 1));
                tabList.insert(newIndex + 1, tabList.removeAt(oldIndex + 1));
              });
            }
          }),
    );
  }

  ///列表的item
  Widget _buildListItemWidget(
      {required Key key, required TabElement tab, required bool orderEnable}) {
    return FutureBuilder(
        future: _sqliteManager.queryCityWeatherNow(tab.cityElement.key),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final Map<String, dynamic>? map =
                snapshot.data as Map<String, dynamic>?;
            if (map != null) {
              final WeatherRT weatherNow = WeatherRT.fromJson(
                  map[SqliteManager.weatherRTKey] as Map<String, dynamic>);

              final Now now = weatherNow.now;
              return _buildListCardItem(
                  key: key, tab: tab, orderEnable: orderEnable, now: now);
            } else {
              return _buildListCardItem(
                  key: key, tab: tab, orderEnable: orderEnable);
            }
          } else {
            return _buildListCardItem(
                key: key, tab: tab, orderEnable: orderEnable);
          }
        });
  }

  Widget _buildListCardItem(
      {required Key key,
      required TabElement tab,
      required bool orderEnable,
      Now? now}) {
    return Card(
      key: key,
      margin: EdgeInsets.only(top: 9.0, bottom: 9.0, left: 18.0, right: 18.0),
      color: Color.fromARGB(255, 99, 153, 237),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      child: Container(
        padding:
            EdgeInsets.only(left: 12.0, right: 12.0, top: 18.0, bottom: 18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Visibility(
                  child: Padding(
                    padding: EdgeInsets.only(right: 4.0),
                    child: Icon(
                      Icons.reorder,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  visible: _isEditedMode && orderEnable,
                ),
                Text(
                  tab.title,
                  style: TextStyle(color: Colors.white, fontSize: 22.0),
                ),
              ],
            ),
            Visibility(
              child: Column(
                children: [
                  Text(
                    "${now?.temp}°",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                  Text(
                    "${now?.text}",
                    style: TextStyle(color: Colors.white, fontSize: 14.0),
                  )
                ],
              ),
              visible: now != null,
            ),
          ],
        ),
      ),
    );
  }
}
