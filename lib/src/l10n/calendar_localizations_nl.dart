// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'calendar_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class CalendarLocalizationsNl extends CalendarLocalizations {
  CalendarLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get previousMonthTooltip => 'Vorige maand';

  @override
  String get nextMonthTooltip => 'Volgende maand';

  @override
  String get todayButton => 'Vandaag';

  @override
  String weekNumber(int week) {
    return 'W$week';
  }

  @override
  String weekNumberLabel(int week) {
    return 'Week $week';
  }
}
