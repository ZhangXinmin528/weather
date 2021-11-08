import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/bloc/city/city_manage_bloc.dart';
import 'package:weather/bloc/city/city_manage_event.dart';
import 'package:weather/bloc/city/city_manage_state.dart';
import 'package:weather/bloc/navigation/navigation_bloc.dart';
import 'package:weather/bloc/navigation/navigation_event.dart';

///城市管理
class CityManagementPage extends StatefulWidget {
  const CityManagementPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CityManangePageState();
  }
}

class _CityManangePageState extends State<CityManagementPage> {
  late NavigationBloc _navigationBloc;
  late CityManageBloc _cityManageBloc;
  IconData _menuIcon = Icons.reorder;

  @override
  void initState() {
    super.initState();
    _navigationBloc = BlocProvider.of(context);
    _cityManageBloc = BlocProvider.of(context);
    _cityManageBloc.add(InitCityListEvent());
    _cityManageBloc.emit(InitCityListState());
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
                      setState(() {
                        _menuIcon = Icons.save;
                      });
                    } else {
                      //保存配置
                      setState(() {
                        _menuIcon = Icons.reorder;
                      });
                    }
                  },
                  icon: Icon(_menuIcon),
                  color: Colors.black,
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  '城市管理',
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
        return _buildReorderableListWidget(state);
      } else {
        return SizedBox();
      }
    });
  }

  Widget _buildReorderableListWidget(CityListSuccessState state) {
    final tabList = state.tabList;
    return Container(
      child: ReorderableListView.builder(
          key: Key('city_manage_page_listview'),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final tab = tabList[index];
            return Card(
              key: Key('city_manage_page_listview_item:$index'),
              margin: EdgeInsets.only(
                  top: 9.0, bottom: 9.0, left: 18.0, right: 18.0),
              color: Color.fromARGB(255, 99, 153, 237),
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
              child: Container(
                padding: EdgeInsets.only(
                    left: 12.0, right: 12.0, top: 18.0, bottom: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tab.title,
                      style: TextStyle(color: Colors.white, fontSize: 22.0),
                    ),
                    Column(
                      children: [
                        Text(
                          "11°",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        Text(
                          "多云",
                          style: TextStyle(color: Colors.white, fontSize: 14.0),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
          itemCount: tabList.length,
          onReorder: (oldIndex, newIndex) {
            if (_menuIcon == Icons.save) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final temp = tabList.removeAt(oldIndex);
                tabList.insert(newIndex, temp);
              });
            }

            print("oldIndex:$oldIndex..newIndex:$newIndex");
          }),
    );
  }
}
