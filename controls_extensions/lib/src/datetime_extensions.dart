import 'package:intl/intl.dart';
import 'time_ago.dart';

extension DateTimeExtension on DateTime {
  /// Format DateTime to custom mask
  format(String dateMask, [lang = 'pt-BR']) {
    var formatter = new DateFormat(dateMask, lang);
    return formatter.format(this);
  }

  dateFormat(String mask, [lang = 'pt-BR']) => DateFormat(mask, lang);

  toTimeString() => DateFormat.Hms().format(this);
  toDateString() => DateFormat.yMd().format(this);

  addDays(int value) => this.add(Duration(days: value));
  addHours(int value) => this.add(Duration(hours: value));
  addMinutes(int value) => this.add(Duration(minutes: value));
  addMonths(int value) => DateTime(this.year, this.month + value, this.day);
  addYears(int value) => DateTime(this.year + value, this.month, this.day);

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

  DateTime toDate() {
    return DateTime(this.year, this.month, this.day);
  }

  DateTime toTime() {
    return DateTime(0, 0, 0, this.hour, this.minute, this.second);
  }

  String toTimeSql() {
    return this.toIso8601String().substring(11, 19);
  }

  String toDateTimeSql() {
    return this.toIso8601String().substring(0, 19).replaceAll('T', ' ');
  }

  String toDateSql() {
    return this.toIso8601String().substring(0, 10);
  }

  DateTime startOfDay() {
    return DateTime(this.year, this.month, this.day);
  }

  DateTime endOfDay() {
    return DateTime(this.year, this.month, this.day, 23, 59, 00);
  }

  DateTime startOfMonth() {
    return DateTime(this.year, this.month, 1);
  }

  double get hours => this.hour + ((this.minute / 60));

  DateTime endOfMonth() {
    return DateTime(this.year, this.month + 1, 0);
  }

  int lastDayOfMonth() {
    return endOfMonth().day;
  }

  DateTime startOfYear() {
    return DateTime(this.year, 1, 1);
  }

  DateTime endOfYear() {
    return DateTime(this.year, 12, 31);
  }

  DateTime toIso8601StringDate({format = 'yyyy-MM-dd'}) {
    return this.format(format);
  }

  DateTime dayBefore() {
    return this.add(Duration(days: -1));
  }

  DateTime dayAfter() {
    return this.add(Duration(days: 1));
  }

  static DateTime yesterday() {
    return today().addDays(-1);
  }

  static DateTime tomorrow() {
    return today().addDays(1);
  }

  static DateTime today() {
    DateTime d = DateTime.now();
    return DateTime(d.year, d.month, d.day);
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
  //DateTime operator -=( int days)=> this.add(Duration(days:-days));

  //DateTime operator +=( int days)=> this.add(Duration(days:days));
  //DateTime operator ++()=> this.add(Duration(days:1));
  //DateTime operator --()=>this.add(Duration(days:-1));

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
