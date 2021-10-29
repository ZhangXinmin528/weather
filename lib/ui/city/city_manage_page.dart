import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    _navigationBloc = BlocProvider.of(context);
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
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(0),
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      margin: EdgeInsets.only(
                          top: 9.0, bottom: 9.0, left: 18.0, right: 18.0),
                      color: Color.fromARGB(255, 99, 153, 237),
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 12.0, right: 12.0, top: 18.0, bottom: 18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "北京市",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 22.0),
                            ),
                            Column(
                              children: [
                                Text(
                                  "11°",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                ),
                                Text(
                                  "多云",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.0),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
