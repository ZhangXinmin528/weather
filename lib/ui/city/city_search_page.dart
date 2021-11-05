import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/bloc/city/city_search_bloc.dart';
import 'package:weather/bloc/city/city_search_event.dart';
import 'package:weather/bloc/city/city_search_state.dart';
import 'package:weather/bloc/main/main_page_bloc.dart';
import 'package:weather/bloc/main/main_page_event.dart';
import 'package:weather/bloc/main/main_page_state.dart';
import 'package:weather/bloc/navigation/navigation_bloc.dart';
import 'package:weather/bloc/navigation/navigation_event.dart';

class CitySearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CitySearchPageState();
  }
}

class CitySearchPageState extends State<CitySearchPage> {
  late CitySearchBloc _citySearchBloc;
  late MainPageBloc _mainPageBloc;
  late NavigationBloc _navigationBloc;
  late TextEditingController _editingController;
  bool visible = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _citySearchBloc = BlocProvider.of(context);
    _citySearchBloc.add(TopCityEvent());
    _citySearchBloc.emit(TopCitiesInitDataState());

    _mainPageBloc = BlocProvider.of(context);

    _navigationBloc = BlocProvider.of(context);

    _editingController = TextEditingController();
    _editingController.addListener(() {
      final text = _editingController.text;
      setState(() {
        visible = text.isNotEmpty;
      });
      if (text.isEmpty) {
        _citySearchBloc.emit(TopCitiesInitDataState());
        _citySearchBloc.add(TopCityEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Container(
          height: 40,
          margin: EdgeInsets.only(
            left: 12.0,
          ),
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0)),
              color: Colors.grey.shade200),
          child: TextField(
            cursorColor: Colors.grey,
            controller: _editingController,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(0),
              hintText: "搜索城市",
              hintStyle: TextStyle(color: Colors.grey.shade400),
              suffixIcon: Visibility(
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _editingController.clear();
                  },
                ),
                visible: visible,
              ),
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            focusNode: _focusNode,
            onEditingComplete: () {
              final text = _editingController.text;
              if (text.isNotEmpty) {
                _citySearchBloc.add(CityLookupEvent(text));
                _focusNode.unfocus();
              } else {
                final snackBar = SnackBar(
                    content: Text(
                  "请输入要查询的城市",
                  style: TextStyle(color: Colors.red),
                ));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            autofocus: false,
            maxLines: 1,
          ),
        ),
        actions: [
          InkWell(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(left: 10.0, right: 16.0),
                child: Text(
                  "取消",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 16.0),
                ),
              ),
            ),
            onTap: () {
              _navigationBloc.add(CityManagePageNavigationEvent());
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: BlocBuilder<CitySearchBloc, CitySearchState>(
        builder: (context, state) {
          return Stack(
            children: [
              if (state is TopCitiesSuccessState) ...[
                _buildTopCitiesWidget(state),
              ] else if (state is CityLookupSuccessState) ...[
                _buildCityLookupWidget(state),
              ]
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopCitiesWidget(TopCitiesSuccessState state) {
    final cityList = state.cityList;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //热门城市
        Container(
          margin:
              EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 6.0),
          alignment: Alignment.centerLeft,
          child: Text(
            "热门城市",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 3,
          ),
          itemCount: cityList.length,
          padding: EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final city = cityList[index];

            return GestureDetector(
              child: Container(
                child: Center(
                  child: Text(
                    city.name,
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  // border: Border.all(color: Colors.grey, width: 0.5),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
              ),
              onTap: () {
                _mainPageBloc.add(AddWeatherTabToMainEvent());
                _mainPageBloc.emit(
                    AddSelectedCityToTabState(city.name, city.lat, city.lon));
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildCityLookupWidget(CityLookupSuccessState state) {
    final cityLocation = state.cityLocation;
    final locationList = cityLocation.location;

    return Container(
      child: ListView.builder(
        itemBuilder: (context, index) {
          final location = locationList[index];
          return InkWell(
            splashColor: Colors.grey.shade300,
            child: Container(
              padding: EdgeInsets.only(
                  left: 25.0, top: 16.0, right: 25.0, bottom: 16.0),
              child: Text(
                "${location.name}-${location.adm2},${location.country}",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            onTap: () {
              _mainPageBloc.add(AddWeatherTabToMainEvent());
              _mainPageBloc.emit(AddSelectedCityToTabState(
                  location.name, location.lat, location.lon));
              Navigator.of(context).pop();
            },
          );
        },
        itemCount: locationList.length,
      ),
    );
  }
}
