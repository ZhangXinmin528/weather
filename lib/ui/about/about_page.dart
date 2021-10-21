import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:weather/resources/config/colors.dart';

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
            text: S.of(context).programHome,
            onTap: () => push(context,
                page: CustomWebViewPage(
                    title: S.of(context).appName,
                    url: "https://github.com/hahafather007/flutter_weather",
                    favData: null)),
          ),

          // 意见反馈
          _buildOverviewItem(
            icon: Icons.feedback,
            text: S.of(context).feedback,
            onTap: () => openBrowser(
                "https://github.com/hahafather007/flutter_weather/issues/new"),
          ),

          // 检查更新
          _buildOverviewItem(
            icon: Icons.autorenew,
            text: S.of(context).checkUpdate,
            onTap: () async {
              if (await ChannelUtil.isDownloading()) {
                showSnack(text: S.of(context).apkDownloading);
              } else {
                _viewModel.checkUpdate();
              }
            },
          ),

          // 分享
          _buildOverviewItem(
            icon: Icons.share,
            text: S.of(context).shareApp,
            onTap: () {
              Share.text(S.of(context).share, S.of(context).shareAppUrl,
                  "text/plain");
            },
          ),

          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: _buildLine(),
          ),

          // 感谢
          _buildTitle(title: S.of(context).thanks),

          // 感谢内容
          _buildThanks(),

          _buildLine(),

          // 联系我
          _buildTitle(title: S.of(context).connectMe),
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
  Widget _buildTitle({@required String title}) {
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

  /// 概述的Item
  Widget _buildOverviewItem(
      {@required IconData icon,
        @required String text,
        @required VoidCallback onTap}) {
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
}
