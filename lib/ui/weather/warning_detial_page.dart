import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:weather/data/model/remote/weather/weather_warning.dart';
import 'package:weather/resources/config/colors.dart';
import 'package:weather/utils/icon_utils.dart';

class WarningDetialPage extends StatelessWidget {
  final List<Warning> warningList;

  const WarningDetialPage({Key? key, required this.warningList})
      : super(key: key);

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
                  AppLocalizations.of(context)!.warning_detial,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ];
        },
        body: ListView.builder(
          itemCount: warningList.length,
          padding: EdgeInsets.only(top: 0, bottom: 6.0),
          itemBuilder: (conteext, index) {
            final Warning? warning = warningList[index];
            return Container(
              color: AppColor.ground,
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconUtils.getWeatherWarningSVGIcon(warning?.type,
                          color: IconUtils.getWeatherWarningLevelColor(
                              warning?.level),
                          size: 30),
                      Padding(
                        padding: EdgeInsets.only(left: 12.0),
                        child: Text(
                          "${warning?.typeName}${warning?.level}预警",
                          style: TextStyle(
                              fontSize: 18.0,
                              color: AppColor.textBlack,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      "${warning?.text}",
                      style: TextStyle(
                          color: AppColor.textGreyDark,
                          fontSize: 14.0,
                          height: 1.6,
                          letterSpacing: 1.2),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
