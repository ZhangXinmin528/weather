import 'package:flutter/material.dart';
import 'package:weather/ui/weather/weather_page.dart';
import 'package:weather/utils/datetime_utils.dart';

import 'data/model/internal/tab_element.dart';

class TestPage extends StatefulWidget {
  const TestPage();

  @override
  State<StatefulWidget> createState() {
    return TestPageState();
  }
}

class TestPageState extends State<TestPage> with TickerProviderStateMixin {
  final List<TabElement> tabList = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // final TabElement beijng = TabElement("北京", CityElement("北京", 39.89, 116.4));
    // tabList.add(beijng);
    // final TabElement jinan = TabElement("济南", CityElement("济南", 36.64, 117.13));
    // tabList.add(jinan);
    _tabController = TabController(length: tabList.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("测试"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  // final name = "天津${DateTimeUtils.getFormatedNowTimeString()}";
                  // final TabElement tianjin =
                  //     TabElement(name, CityElement(name, 38.99, 117.22));
                  // tabList.add(tianjin);
                  _tabController =
                      TabController(length: tabList.length, vsync: this);
                });
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
              )),
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          TabBarView(
            children: tabList
                .map(
                  (tab) => WeatherPage(tab.cityElement),
                )
                .toList(),
            controller: _tabController,
          ),
          _buildTabPageIndicator(),
        ],
      ),
    );
  }

  Widget _buildTabPageIndicator() {
    return TabPageSelector(
      controller: _tabController,
      color: Colors.white,
      indicatorSize: 10,
      selectedColor: Colors.grey,
    );
  }
}
