import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 160),
      padding: EdgeInsets.all(26.0),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      alignment: Alignment.topCenter,
      width: 80,
      height: 80,
      child: LoadingIndicator(
        indicatorType: Indicator.ballClipRotate,
        strokeWidth: 2,
        colors: [
          Colors.white,
        ],
      ),
    );
  }
}
