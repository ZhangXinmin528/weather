import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///城市管理
class CityManagementPage extends StatefulWidget {
  const CityManagementPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CityManangePageState();
  }
}

class _CityManangePageState extends State<CityManagementPage> {
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
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      margin: EdgeInsets.only(
                          top: 9.0, bottom: 9.0, left: 18.0, right: 18.0),
                      color: Color.fromARGB(255, 53, 61, 94),
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
                                  color: Colors.white, fontSize: 18.0),
                            ),
                            Column(
                              children: [
                                Text(
                                  "11°",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0),
                                ),
                                Text(
                                  "多云",
                                  style: TextStyle(color: Colors.grey.shade400),
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

// class _CityManangePageState extends State<CityManagementPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             leading: IconButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 icon: Icon(
//                   Icons.arrow_back,
//                   color: Colors.black,
//                 )),
//             pinned: true,
//             expandedHeight: 120.0,
//             backgroundColor: Colors.white,
//             flexibleSpace: FlexibleSpaceBar(
//               title: Text(
//                 '城市管理',
//                 style: TextStyle(color: Colors.black),
//               ),
//             ),
//           ),
//
//           Container(
//             color: Color.fromARGB(255, 115, 123, 146),
//             margin: EdgeInsets.only(
//                 left: 22.0, top: 30.0, right: 22.0, bottom: 30.0),
//             child: Text("sousuo"),
//           ),
//           SliverFixedExtentList(
//             itemExtent: 100.0,
//             delegate: SliverChildBuilderDelegate(
//               (BuildContext context, int index) {
//                 return Card(
//                   margin: EdgeInsets.only(
//                       top: 9.0, bottom: 9.0, left: 18.0, right: 18.0),
//                   color: Color.fromARGB(255, 53, 61, 94),
//                   elevation: 4.0,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(12.0))),
//                   child: Container(
//                     padding: EdgeInsets.only(
//                         left: 12.0, right: 12.0, top: 18.0, bottom: 18.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "北京市",
//                           style: TextStyle(color: Colors.white, fontSize: 18.0),
//                         ),
//                         Column(
//                           children: [
//                             Text(
//                               "11°",
//                               style: TextStyle(
//                                   color: Colors.white, fontSize: 16.0),
//                             ),
//                             Text(
//                               "多云",
//                               style: TextStyle(color: Colors.grey.shade400),
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 );
//               },
//               childCount: 10,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
