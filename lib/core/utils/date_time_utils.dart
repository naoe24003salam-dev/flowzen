import 'package:intl/intl.dart';

class DateTimeUtils {
  DateTimeUtils._();

  static String friendlyDate(DateTime date) {
    return DateFormat('EEEE, MMM d').format(date);
  }

  static String friendlyTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  static String monthDay(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  static String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}
