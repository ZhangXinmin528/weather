import 'package:flutter/material.dart';
import 'package:weather/data/model/internal/markdown.dart';

class MarkdownPage extends StatefulWidget {
  final MarkdownFile markdownFile;

  MarkdownPage(this.markdownFile);

  @override
  State<StatefulWidget> createState() {
    return _MarkdownState(markdownFile);
  }
}

class _MarkdownState extends State<MarkdownPage> {
  final MarkdownFile _file;

  _MarkdownState(this._file);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              pinned: true,
              expandedHeight: 120.0,
              backgroundColor: Colors.white,
              forceElevated: innerBoxIsScrolled,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  _file.title,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ];
        },
        body: ListView(
          padding: const EdgeInsets.only(),
          physics: ClampingScrollPhysics(),
          children: [
            Text("测试一下啊啊啊啊"),
          ],
        ),
        // body: FutureBuilder(
        //   future: rootBundle.loadString(_file.path),
        //   builder: (context, snapshot) {
        //     LogUtil.d('markdown..path:${_file.path}..data:${snapshot.data}');
        //     if (snapshot.hasData) {
        //       final data = snapshot.data as String;
        //       return Markdown(data: data);
        //     } else {
        //       return SizedBox();
        //     }
        //   },
        // ),
      ),
    );
  }
}
