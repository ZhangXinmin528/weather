import 'package:intl/intl.dart';

///时间工具
class DateTimeUtils {
  static const int dayAsMs = 86400000;
  static const int hoursAsMs = 3600000;
  static const int minutesAsMs = 60000;
  static const int secondsAsMs = 1000;

  static const String defaultFormat = 'yyyyMMdd HH:mm:ss';
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dailyFormat = 'MM/dd';
  static const String weatherTimeFormat = 'HH:mm';

  static const String weatherHourFormat = 'dd/MM HH:mm';

  ///=============================格式化时间戳===============================///
  ///格式化日期，格式:dd/MM/yyyy
  static String defaultFormatDateTime(DateTime dateTime) {
    return DateFormat(defaultFormat).format(dateTime);
  }

  ///指定格式格式化日期
  static String formatDateTime(DateTime dateTime, String format) {
    return DateFormat(format).format(dateTime);
  }

  ///format string datetime to another format string
  static String formatDateTimeString(String formattedString, String format) {
    return DateFormat(format).format(DateTime.parse(formattedString));
  }

  ///format utc datetime string to another format string
  ///ex. 2021-10-14T13:37+08:00
  static String formatUTCDateTimeString(String formattedString, String format) {
    return DateFormat(format).format(DateTime.parse(formattedString).toLocal());
  }

  ///=============================获取当前时间戳===============================///
  ///获取当前时间戳
  ///格式：HH:mm:ss
  static String formatNowTime() {
    return formatDateTime(DateTime.now(), weatherTimeFormat);
  }

  ///获取当前时间
  static int getNowTime() {
    return DateTime.now().microsecondsSinceEpoch;
  }

  ///获取格式化的当前时间
  ///格式：yyyyMMdd HH:mm:ss
  static String getFormatedNowTimeString() {
    return defaultFormatDateTime(DateTime.now());
  }

  ///=============================获取时间间隔===============================///

  ///获取时间间隔
  static String getTimeSpanByNow(int millseconds) {
    return DateFormat(defaultFormat).formatDuration(DateTime.now());
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
