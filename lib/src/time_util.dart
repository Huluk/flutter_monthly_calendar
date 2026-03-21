typedef DateValidator = bool Function(DateTime);

extension DateTimeInRange on DateTime {
  bool isInRange(DateTime? before, DateTime? after) {
    if (before != null && before.isAfter(this)) return false;
    if (after != null && after.isBefore(this)) return false;
    return true;
  }

  bool isMonthValid(DateValidator validator) =>
      validator(DateTime.utc(year, month)) ||
      validator(DateTime.utc(year, month + 1, 0));

  DateTime toUtcDay() => DateTime.utc(year, month, day);

  DateTime toUtcMonth() => DateTime.utc(year, month);

  /// Returns the ISO 8601 week number for the week.
  int get isoWeekNumber {
    // Shift date to Thursday of the current ISO week
    final thursday = add(Duration(days: DateTime.thursday - weekday));
    final yearStart = DateTime(thursday.year, 1, 1);

    // Number of days between the Thursday and Jan 1
    final diff = thursday.difference(yearStart).inDays;
    return (diff ~/ 7) + 1;
  }
}
