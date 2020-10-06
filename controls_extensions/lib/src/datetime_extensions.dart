import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'time_ago.dart';
import 'dynamic_extensions.dart';

extension DateTimeExtension on DateTime {
  /// Format DateTime to custom mask
  format(String dateMask, [lang = 'pt-BR']) {
    var formatter = new DateFormat(dateMask, lang);
    return formatter.format(this);
  }

  e(f) {
    return this.format('E').substring(0, 1).toUpperCase() +
        this.format(f ?? '');
  }

  DateTime from(dynamic value) => ''.toDateTime(value);

  dateFormat(String mask, [lang = 'pt-BR']) => DateFormat(mask, lang);

  toTimeString() => DateFormat.Hms().format(this);
  toDateString() => DateFormat.yMd().format(this);

  DateTime addDays(int value) {
    return add(Duration(days: value));
  }

  DateTime addHours(int value) => add(Duration(hours: value));
  DateTime addMinutes(int value) => add(Duration(minutes: value));
  DateTime addMonths(int value) =>
      DateTime(year, month + value, day, this.hour, this.minute, this.second);
  DateTime addYears(int value) => DateTime(this.year + value, this.month,
      this.day, this.hour, this.minute, this.second);

  bool isLeapYear() {
    int value = this.year;
    return value % 400 == 0 || (value % 4 == 0 && value % 100 != 0);
  }

  bool between(DateTime a, DateTime b) {
    var t = this.toDateTimeSql();
    return (t.compareTo(a.toDateTimeSql()) == 1) &&
        (t.compareTo(b.toDateTimeSql()) == -1);
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

  DateTime endOfHour([int hour]) {
    return DateTime(this.year, this.month, this.day, hour ?? this.hour, 59, 0);
  }

  DateTime startOfHour([int hour]) {
    return DateTime(this.year, this.month, this.day, hour ?? this.hour, 0, 0);
  }

  DateTime startOfDay() {
    return DateTime(this.year, this.month, this.day);
  }

  DateTime endOfDay() {
    return DateTime(this.year, this.month, this.day, 23, 59, 00);
  }

  ///  Obtem o primeiro dia da semana {first indica o primeiro dia da semana}
  DateTime startOfWeek({first = 1}) {
    return this.add(Duration(days: -(this.weekday - first)));
  }

  /// Obtem o ultimo dia da semana
  DateTime endOfWeek({first = 1}) {
    return this.add(Duration(days: (6 + first) - this.weekday));
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
  initialize({lang = 'pt_BR'}) {
    initializeDateFormatting(lang, null);
  }

  /// Adds this DateTime && Duration && returns the sum as a new DateTime object.
  DateTime operator +(Duration duration) => add(duration);

  /// Subtracts the Duration from this DateTime returns the difference as a new DateTime object.
  DateTime operator -(Duration duration) => subtract(duration);

  /// range this until to
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

  Iterable<DateTime> range(DateTime from, DateTime to, {int skip = 1}) sync* {
    while (from.compareTo(to) <= 0) {
      yield from;
      from = from.add(Duration(days: skip));
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

  /// sample:  print(parseDuration('10h 50m')); // 10:50:00.00000
  Duration parseDuration(String line) {
    final _regExp = RegExp(r'((?<hours>\d+)h)?[ ]*((?<minutes>\d+)m)?');
    final match = _regExp.firstMatch(line);

    if (match == null) {
      throw Exception('Could not get duration from: $line');
    }

    return Duration(
        hours: int.parse(match.namedGroup('hours') ?? '0'),
        minutes: int.parse(match.namedGroup('minutes') ?? '0'));
  }
}
