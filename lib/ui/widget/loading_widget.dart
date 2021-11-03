import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 200),
      alignment: Alignment.topCenter,
      child: LoadingIndicator(
        indicatorType: Indicator.ballClipRotateMultiple,
        strokeWidth: 2,
        colors: [Colors.white, Colors.lightBlueAccent],
      ),
    );
  }
}
