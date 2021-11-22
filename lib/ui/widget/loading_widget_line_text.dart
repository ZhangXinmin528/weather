import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:weather/resources/config/colors.dart';

class LoadingLineWidget extends StatelessWidget {
  final String content;

  LoadingLineWidget(this.content);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          LoadingIndicator(
            indicatorType: Indicator.lineScalePulseOutRapid,
            strokeWidth: 2,
            colors: [
              Colors.white,
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              content,
              style: TextStyle(color: AppColor.textWhite, fontSize: 12.0),
            ),
          ),
        ],
      ),
    );
  }
}
