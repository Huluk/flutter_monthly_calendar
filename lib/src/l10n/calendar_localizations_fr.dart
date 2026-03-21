// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'calendar_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class CalendarLocalizationsFr extends CalendarLocalizations {
  CalendarLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get previousMonthTooltip => 'Mois précédent';

  @override
  String get nextMonthTooltip => 'Mois suivant';

  @override
  String get todayButton => 'Aujourd\'hui';

  @override
  String weekNumber(int week) {
    return 'S$week';
  }

  @override
  String weekNumberLabel(int week) {
    return 'Semaine $week';
  }
}
