import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static const String _defaultLocale = 'es_DO';

  static String yMd(
    DateTime? date, {
    String locale = _defaultLocale,
  }) {
    if (date == null) return '';
    return DateFormat.yMd(locale).format(date);
  }

  static String dMMMMy(
    DateTime? date, {
    String locale = _defaultLocale,
  }) {
    if (date == null) return '';
    return DateFormat('d MMMM yyyy', locale).format(date);
  }

  static String fullDate(
    DateTime? date, {
    String locale = _defaultLocale,
  }) {
    if (date == null) return '';
    return DateFormat('EEEE, d MMMM yyyy', locale).format(date);
  }

  static String monthYear(
    DateTime? date, {
    String locale = _defaultLocale,
  }) {
    if (date == null) return '';
    return DateFormat('MMMM yyyy', locale).format(date);
  }

  static String dayMonth(
    DateTime? date, {
    String locale = _defaultLocale,
  }) {
    if (date == null) return '';
    return DateFormat('d MMMM', locale).format(date);
  }

  static String weekday(
    DateTime? date, {
    String locale = _defaultLocale,
  }) {
    if (date == null) return '';
    return DateFormat('EEEE', locale).format(date);
  }

  static String time(
    DateTime? date, {
    String locale = _defaultLocale,
  }) {
    if (date == null) return '';
    return DateFormat('hh:mm a', locale).format(date);
  }

  static String dateTime(
    DateTime? date, {
    String locale = _defaultLocale,
  }) {
    if (date == null) return '';
    return DateFormat('d MMM yyyy, hh:mm a', locale).format(date);
  }

  static String dateOnlyId(DateTime? date) {
    if (date == null) return '';

    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  static DateTime? tryParse(dynamic value) {
    if (value == null) return null;

    if (value is DateTime) return value;

    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }

  static bool isSameDate(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;

    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static String relativeDayLabel(
    DateTime? date, {
    DateTime? reference,
    String locale = _defaultLocale,
  }) {
    if (date == null) return '';

    final ref = dateOnly(reference ?? DateTime.now());
    final target = dateOnly(date);
    final difference = target.difference(ref).inDays;

    if (difference == 0) return 'Hoy';
    if (difference == 1) return 'Mañana';
    if (difference == -1) return 'Ayer';

    return fullDate(date, locale: locale);
  }
}
