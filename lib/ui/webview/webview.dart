import 'package:flutter/material.dart';
import 'package:weather/utils/log_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {
  final String _url;
  final String _title;

  WebviewPage(this._title, this._url);

  @override
  State<StatefulWidget> createState() {
    return _WebviewPageState();
  }
}

class _WebviewPageState extends State<WebviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget._title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 1.0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: WebView(
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
          ),
        ],
      ),
    );
  }
}
