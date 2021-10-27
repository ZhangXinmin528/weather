import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 200),
      alignment: Alignment.topCenter,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          Colors.white,
        ),
      ),
    );
  }
}
