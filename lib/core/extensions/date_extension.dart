import 'package:intl/intl.dart';

extension DateHelpers on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return now.day == this.day &&
        now.month == this.month &&
        now.year == this.year;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return yesterday.day == this.day &&
        yesterday.month == this.month &&
        yesterday.year == this.year;
  }

  String getFormatted() {
    return isToday()
        ? DateFormat.Hm().format(this)
        : DateFormat.yMd().format(this);
  }

  String get getTime => DateFormat.Hm().format(this);
}
