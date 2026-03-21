// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'calendar_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class CalendarLocalizationsEs extends CalendarLocalizations {
  CalendarLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get previousMonthTooltip => 'Mes anterior';

  @override
  String get nextMonthTooltip => 'Mes siguiente';

  @override
  String get todayButton => 'Hoy';

  @override
  String weekNumber(int week) {
    return 'S$week';
  }

  @override
  String weekNumberLabel(int week) {
    return 'Semana $week';
  }
}
