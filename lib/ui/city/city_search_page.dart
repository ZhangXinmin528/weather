import 'package:flutter/material.dart';

class CitySearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CitySearchPageState();
  }
}

class CitySearchPageState extends State<CitySearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
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
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(0),
              hintText: "搜索城市",
              hintStyle: TextStyle(color: Colors.grey.shade400),
              suffixIcon: Icon(
                Icons.close,
                color: Colors.grey,
              ),
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
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
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
