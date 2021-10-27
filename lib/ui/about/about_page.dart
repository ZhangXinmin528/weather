import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather/resources/config/colors.dart';
import 'package:weather/ui/webview/webview_page.dart';

class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AboutPageState();
  }
}

class AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('about_page'),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.about,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: ListView(
        padding: const EdgeInsets.only(),
        physics: ClampingScrollPhysics(),
        children: [
          _buildAppName(),

          // 项目主页
          _buildOverviewItem(
              icon: Icons.home,
              text: AppLocalizations.of(context)!.programHome,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return WebviewPage(
                      "项目主页", "https://github.com/ZhangXinmin528/weather");
                }));
              }),

          // 意见反馈
          _buildOverviewItem(
            icon: Icons.feedback,
            text: AppLocalizations.of(context)!.feedback,
            onTap: () => _launchInBrower(
                "https://github.com/ZhangXinmin528/weather/issues/new"),
          ),

          // 检查更新
          _buildOverviewItem(
              icon: Icons.update,
              text: AppLocalizations.of(context)!.checkUpdate,
              onTap: () {}),

          // 分享
          _buildOverviewItem(
            icon: Icons.share,
            text: AppLocalizations.of(context)!.shareApp,
            onTap: () {
              Share.text("应用分享", "https://github.com/ZhangXinmin528/weather",
                  "text/plain");
            },
          ),

          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: _buildLine(),
          ),

          // 感谢
          _buildTitle(title: AppLocalizations.of(context)!.thanks),

          // 感谢内容
          _buildThanks(),

          _buildLine(),

          // 联系我
          // _buildTitle(title: S.of(context).connectMe),
        ],
      ),
    );
  }

  /// app名称和版本
  Widget _buildAppName() {
    return Container(
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Text(
              AppLocalizations.of(context)!.app_name,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold),
            ),
          ),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final PackageInfo info = snapshot.requireData;
                return Text(
                  "v${info.version} build(${info.buildNumber})",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold),
                );
              } else {
                return Text(
                  "",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLine() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      height: 1,
      color: AppColor.line2,
    );
  }

  /// 标题
  Widget _buildTitle({required String title}) {
    return Container(
      height: 60,
      padding: const EdgeInsets.only(left: 16),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(fontSize: 16, color: AppColor.text2),
      ),
    );
  }

  /// 感谢内容
  Widget _buildThanks() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      child: Linkify(
        text: AppLocalizations.of(context)!.thankItems,
        onOpen: (link) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return WebviewPage(
                AppLocalizations.of(context)!.app_name, link.url);
          }));
        },
        style: TextStyle(fontSize: 14, color: AppColor.text2, height: 1.2),
        linkStyle: TextStyle(fontSize: 14, color: Colors.black87),
      ),
    );
  }

  /// 概述的Item
  Widget _buildOverviewItem(
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.centerLeft,
          height: 48,
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 24,
                color: AppColor.text3,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  text,
                  style: TextStyle(fontSize: 14, color: AppColor.text2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchInBrower(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch the url:$url';
    }
  }
}
