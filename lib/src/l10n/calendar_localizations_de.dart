// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'calendar_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class CalendarLocalizationsDe extends CalendarLocalizations {
  CalendarLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get previousMonthTooltip => 'Vorheriger Monat';

  @override
  String get nextMonthTooltip => 'Nächster Monat';

  @override
  String get todayButton => 'Heute';

  @override
  String weekNumber(int week) {
    return 'KW$week';
  }

  @override
  String weekNumberLabel(int week) {
    return 'Woche $week';
  }
}
