import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:weather/data/model/internal/markdown.dart';
import 'package:weather/resources/config/colors.dart';
import 'package:weather/utils/log_utils.dart';

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
        body: Container(
          color: AppColor.ground,
          child: FutureBuilder(
            future: rootBundle.loadString(_file.path),
            builder: (context, snapshot) {
              LogUtil.d('markdown..path:${_file.path}..data:${snapshot.data}');
              if (snapshot.hasData) {
                final data = snapshot.data as String;
                return Markdown(
                  data: data,
                  styleSheet: MarkdownStyleSheet.fromTheme(_initMDThemeData()),
                  styleSheetTheme: MarkdownStyleSheetBaseTheme.platform,
                );
              } else {
                return SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }

  ThemeData _initMDThemeData() {
    return ThemeData(
      textTheme: const TextTheme(
        headline5: TextStyle(fontSize: 60.0, color: AppColor.textBlack),
        headline6: TextStyle(fontSize: 35, color: AppColor.textBlack),
        subtitle2: TextStyle(fontSize: 20, color: AppColor.textBlack),
        bodyText2: TextStyle(fontSize: 15, color: AppColor.textBlack),
        bodyText1: TextStyle(fontSize: 12, color: AppColor.textBlack),
      ),
    );
  }
}
