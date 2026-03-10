import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

extension DateTimeX on DateTime {
  /// Relative time: "5 minutes ago", "2 hours ago", "3 days ago"
  String get relative => timeago.format(this);

  /// Short relative: "5m", "2h", "3d"
  String get relativeShort => timeago.format(this, locale: 'en_short');

  /// Full date: "March 7, 2026"
  String get fullDate => DateFormat.yMMMMd().format(this);

  /// Short date: "Mar 7, 2026"
  String get shortDate => DateFormat.yMMMd().format(this);

  /// Date only: "03/07/2026"
  String get numericDate => DateFormat('MM/dd/yyyy').format(this);

  /// Time only: "2:30 PM"
  String get time => DateFormat.jm().format(this);

  /// Date and time: "Mar 7, 2026 at 2:30 PM"
  String get dateTime => '$shortDate at $time';

  /// Day of week: "Monday"
  String get dayOfWeek => DateFormat.EEEE().format(this);

  /// Whether this date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Whether this date is in the past
  bool get isPast => isBefore(DateTime.now());

  /// Whether this date is in the future
  bool get isFuture => isAfter(DateTime.now());
}

extension StringToDateTime on String {
  /// Parse ISO 8601 string to DateTime
  DateTime get toDateTime => DateTime.parse(this);

  /// Try to parse, return null on failure
  DateTime? get toDateTimeOrNull => DateTime.tryParse(this);
}
