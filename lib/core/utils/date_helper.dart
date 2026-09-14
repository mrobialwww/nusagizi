import 'package:intl/intl.dart';

class DateHelper {
  static final DateFormat _apiDateFormat = DateFormat('yyyy-MM-dd');

  /// Formats a [DateTime] into a standard API date string (`yyyy-MM-dd`).
  static String toApiDate(DateTime date) {
    return _apiDateFormat.format(date);
  }

  /// Parses a date string in `yyyy-MM-dd` format into a [DateTime] object.
  static DateTime fromApiDate(String dateString) {
    return DateTime.parse(dateString);
  }
}
