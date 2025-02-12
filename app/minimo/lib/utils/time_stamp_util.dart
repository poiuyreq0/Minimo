import 'package:intl/intl.dart';

class TimeStampUtil {
  static String getElementTimeStamp(DateTime target) {
    final current = DateTime.now();
    late final String result;

    if (isSameDay(current, target)) {
      result = DateFormat('a h:mm', 'ko_KR').format(target);
    } else if (isSameDay(current.subtract(const Duration(days: 1)), target)) {
      result = '어제';
    } else if (isSameYear(current, target)) {
      result = DateFormat('M월 d일').format(target);
    } else {
      result = DateFormat('yyyy.MM.dd').format(target);
    }

    return result;
  }

  static String getBirthdayTimeStamp(DateTime target) {
    return DateFormat('yyyy-MM-dd').format(target);
  }

  static String getDetailTimeStamp(DateTime target) {
    return DateFormat('yyyy.MM.dd a h시 m분', 'ko_KR').format(target);
  }

  static String getSimpleTimeStamp(DateTime target) {
    final current = DateTime.now();
    late final String result;

    if (isSameYear(current, target)) {
      result = DateFormat('MM/dd HH:mm').format(target);
    } else {
      result = DateFormat('yy/MM/dd HH:mm').format(target);
    }

    return result;
  }

  static String getMessageTimeStamp(DateTime target) {
    return DateFormat('a h:mm', 'ko_KR').format(target);
  }

  static String getRoomTimeStamp(DateTime target) {
    return DateFormat('yyyy년 M월 d일 EEEE', 'ko_KR').format(target);
  }

  static bool isSameMinute(DateTime target1, DateTime target2) {
    if (target1.year == target2.year && target1.month == target2.month && target1.day == target2.day
        && target1.hour == target2.hour && target1.minute == target2.minute) {
      return true;
    } else {
      return false;
    }
  }

  static bool isSameDay(DateTime target1, DateTime target2) {
    if (target1.year == target2.year && target1.month == target2.month && target1.day == target2.day) {
      return true;
    } else {
      return false;
    }
  }

  static bool isSameYear(DateTime target1, DateTime target2) {
    if (target1.year == target2.year) {
      return true;
    } else {
      return false;
    }
  }
}