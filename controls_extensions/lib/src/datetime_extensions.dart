import 'package:intl/intl.dart';
import 'time_ago.dart';

extension DateTimeExtension on DateTime {
  /// Format DateTime to custom mask
  format(String dateMask) {
    var formatter = new DateFormat(dateMask);
    return formatter.format(this);
  }

  toTimeString() => DateFormat.Hms().format(this);
  toDateString() => DateFormat.yMd().format(this);
  addDays(int value) => this.add(value.days);

  addHours(int value) => this.add(value.hours);
  addMinutes(int value) => this.add(value.minutes);

  bool isLeapYear() {
    int value = this.year;
    return value % 400 == 0 || (value % 4 == 0 && value % 100 != 0);
  }

  String timeAgo({String lang}) {
    int timeStamp = this.millisecondsSinceEpoch;
    lang = lang ?? Intl.defaultLocale;
    Language lg = Language.ENGLISH;
    if (lang.indexOf('pt') >= 0) lg = Language.PORTUGUESE;
    return TimeAgo.getTimeAgo(timeStamp, language: lg);
  }

  toDate() {
    return DateTime.parse(this.format('yyyy-MM-dd'));
  }

  toTime() {
    return this - this.toDate();
  }

  startOfMonth() {
    return DateTime(this.year, this.month, 1);
  }

  endOfMonth() {
    return DateTime(this.year, this.month + 1, 0);
  }

  lastDayOfMonth() {
    return endOfMonth().day;
  }

  startOfYear() {
    return DateTime(this.year, 1, 1);
  }

  endOfYear() {
    return DateTime(this.year, 12, 31);
  }

  toIso8601StringDate() {
    return this.format('yyyy-MM-dd');
  }
}

/// credits: https://github.com/jogboms/time.dart
extension NumTimeExtension<T extends num> on T {
  /// Returns a Duration represented in weeks
  Duration get weeks => days * DurationTimeExtension.daysPerWeek;

  /// Returns a Duration represented in days
  Duration get days => milliseconds * Duration.millisecondsPerDay;

  /// Returns a Duration represented in hours
  Duration get hours => milliseconds * Duration.millisecondsPerHour;

  /// Returns a Duration represented in minutes
  Duration get minutes => milliseconds * Duration.millisecondsPerMinute;

  /// Returns a Duration represented in seconds
  Duration get seconds => milliseconds * Duration.millisecondsPerSecond;

  /// Returns a Duration represented in milliseconds
  Duration get milliseconds => Duration(
      microseconds: (this * Duration.microsecondsPerMillisecond).toInt());

  /// Returns a Duration represented in microseconds
  Duration get microseconds =>
      milliseconds ~/ Duration.microsecondsPerMillisecond;

  /// Returns a Duration represented in nanoseconds
  Duration get nanoseconds =>
      microseconds ~/ DurationTimeExtension.nanosecondsPerMicrosecond;
}

extension DateTimeTimeExtension on DateTime {
  /// Adds this DateTime && Duration && returns the sum as a new DateTime object.
  DateTime operator +(Duration duration) => add(duration);

  /// Subtracts the Duration from this DateTime returns the difference as a new DateTime object.
  DateTime operator -(Duration duration) => subtract(duration);

  /// Returns a range of dates to [to], exclusive start, inclusive end
  /// ```dart
  /// final start = DateTime(2019);
  /// final end = DateTime(2020);
  /// start.to(end, by: const Duration(days: 365)).forEach(print); // 2020-01-01 00:00:00.000
  /// ```
  Iterable<DateTime> to(DateTime to,
      {Duration by = const Duration(days: 1)}) sync* {
    if (isAtSameMomentAs(to)) return;

    if (isBefore(to)) {
      var value = this + by;
      yield value;

      var count = 1;
      while (value.isBefore(to)) {
        value = this + (by * ++count);
        yield value;
      }
    } else {
      var value = this - by;
      yield value;

      var count = 1;
      while (value.isAfter(to)) {
        value = this - (by * ++count);
        yield value;
      }
    }
  }
}

extension DurationTimeExtension on Duration {
  static const int daysPerWeek = 7;
  static const int nanosecondsPerMicrosecond = 1000;

  /// Returns the representation in weeks
  int get inWeeks => (inDays / daysPerWeek).ceil();

  /// Adds the Duration to the current DateTime && returns a DateTime in the future
  DateTime get fromNow => DateTime.now() + this;

  @Deprecated('Use fromNow instead. Will be removed in 2.0.0')
  DateTime get later => fromNow;

  /// Subtracts the Duration from the current DateTime && returns a DateTime in the past
  DateTime get ago => DateTime.now() - this;
}
