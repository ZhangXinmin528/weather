import 'package:flutter/material.dart';
import 'package:weather/resources/config/colors.dart';
import 'package:weather/utils/log_utils.dart';
import 'package:weather/utils/system_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WeatherMapPage extends StatefulWidget {
  final String _url;

  WeatherMapPage(this._url);

  @override
  State<StatefulWidget> createState() {
    return _WeatherMapPageState();
  }
}

class _WeatherMapPageState extends State<WeatherMapPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            WebView(
              initialUrl: widget._url,
              javascriptMode: JavascriptMode.unrestricted,
              javascriptChannels: <JavascriptChannel>[
                JavascriptChannel(
                    name: 'jsbridge',
                    onMessageReceived: (message) {
                      debugPrint(message.message);
                    })
              ].toSet(),
              onWebViewCreated: (controller) {
                controller.loadUrl(widget._url);

                controller
                    .canGoBack()
                    .then((value) => debugPrint(value.toString()));

                controller
                    .canGoForward()
                    .then((value) => debugPrint(value.toString()));

                controller
                    .currentUrl()
                    .then((value) => debugPrint(value.toString()));
              },
              onPageFinished: (url) {
                print("onPageFinished:$url");
              },
              onWebResourceError: (error) {
                LogUtil.e("onWebResourceError..error:$error");
              },
            ),
            Container(
              color: AppColor.ground,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "和风天气地图",
                    style: TextStyle(
                      color: AppColor.textBlack,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
