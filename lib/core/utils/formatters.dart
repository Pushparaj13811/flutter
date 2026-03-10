import 'package:intl/intl.dart';

class Formatters {
  const Formatters._();

  /// Format duration in minutes to human-readable string.
  /// e.g. 90 → "1h 30m", 60 → "1h", 30 → "30m"
  static String duration(int minutes) {
    if (minutes < 60) return '${minutes}m';
    final hours = minutes ~/ 60;
    final remaining = minutes % 60;
    if (remaining == 0) return '${hours}h';
    return '${hours}h ${remaining}m';
  }

  /// Format a number with commas. e.g. 1234 → "1,234"
  static String number(num value) {
    return NumberFormat('#,##0').format(value);
  }

  /// Format a decimal to one place. e.g. 4.5 → "4.5"
  static String decimal(double value, {int places = 1}) {
    return value.toStringAsFixed(places);
  }

  /// Format a rating. e.g. 4.5 → "4.5", 0.0 → "—"
  static String rating(double value) {
    if (value <= 0) return '—';
    return decimal(value);
  }

  /// Format a percentage. e.g. 0.85 → "85%", 85.0 → "85%"
  static String percentage(double value) {
    final pct = value > 1 ? value : value * 100;
    return '${pct.round()}%';
  }

  /// Format a count with suffix. e.g. 1 → "1 session", 5 → "5 sessions"
  static String pluralize(int count, String singular, [String? plural]) {
    final label = count == 1 ? singular : (plural ?? '${singular}s');
    return '$count $label';
  }

  /// Format file size in bytes to human-readable string.
  /// e.g. 1048576 → "1.0 MB"
  static String fileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / 1048576).toStringAsFixed(1)} MB';
  }
}
