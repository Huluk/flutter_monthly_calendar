// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'calendar_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class CalendarLocalizationsEn extends CalendarLocalizations {
  CalendarLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get previousMonthTooltip => 'Previous month';

  @override
  String get nextMonthTooltip => 'Next month';

  @override
  String get todayButton => 'Today';

  @override
  String weekNumber(int week) {
    return 'W$week';
  }

  @override
  String weekNumberLabel(int week) {
    return 'Week $week';
  }
}
