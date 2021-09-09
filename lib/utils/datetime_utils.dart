import 'package:intl/intl.dart';

///时间工具
class DateTimeUtils {
  static const int dayAsMs = 86400000;
  static const int hoursAsMs = 3600000;
  static const int minutesAsMs = 60000;
  static const int secondsAsMs = 1000;

  static const String defaultFormat = 'dd/MM/yyyy';
  static const String weatherTimeFormat = 'HH:mm';

  ///格式化日期，格式
  static String defaultFormatDateTime(DateTime dateTime) {
    return DateFormat(defaultFormat).format(dateTime);
  }

  static String formatDateTime(DateTime dateTime, String format) {
    return DateFormat(format).format(dateTime);
  }

  static int getNowTime() {
    return DateTime.now().microsecondsSinceEpoch;
  }

  ///获取当前时间戳
  ///格式：HH:mm:ss
  static String formatNowTime() {
    return formatDateTime(DateTime.now(), weatherTimeFormat);
  }

  ///格式化时间：12：00
  static String getFormattedTime(DateTime dateTime) {
    final String hour = _formatTimeUnit(dateTime.hour);
    final String minute = _formatTimeUnit(dateTime.minute);
    return "$hour:$minute";
  }

  static String _formatTimeUnit(int timeUnit) {
    return timeUnit < 10 ? "0$timeUnit" : "$timeUnit";
  }

  static String formatTime(int time) {
    final int hours = (time / hoursAsMs).floor();
    final int minutes = ((time - hours * hoursAsMs) / minutesAsMs).floor();
    final int seconds =
        ((time - hours * hoursAsMs - minutes * minutesAsMs) / secondsAsMs)
            .floor();
    String text = "";
    if (hours > 0) {
      text += "${_formatTimeUnit(hours)}h ";
    }
    if (minutes > 0) {
      text += "${_formatTimeUnit(minutes)}m ";
    }
    if (seconds >= 0) {
      text += "${_formatTimeUnit(seconds)}s";
    }
    return text;
  }
}
