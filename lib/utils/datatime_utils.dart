import 'package:intl/intl.dart';

class DateTimeUtils {
  static const int dayAsMs = 86400000;
  static const int hoursAsMs = 3600000;
  static const int mintuesAsMs = 60000;
  static const int secondsAsMs = 1000;

  static const String defaultFormat = 'dd/MM/yyyy';

  ///格式化日期，格式
  static String formatDateTime(DateTime dateTime) {
    return DateFormat(defaultFormat).format(dateTime);
  }
}
