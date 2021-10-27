import 'package:weather/utils/log_utils.dart';

class TypesHelper {
  static double toDouble(num? val) {
    try {
      if (val == null) {
        return 0;
      }
      if (val is double) {
        return val;
      } else {
        return val.toDouble();
      }
    } catch (exception, stackTrace) {
      LogUtil.e("toDouble failed:$exception $stackTrace");
      return 0;
    }
  }

  static String numToString(int num) {
    return num.toString();
  }
}
