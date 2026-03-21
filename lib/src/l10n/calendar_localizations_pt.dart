// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'calendar_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class CalendarLocalizationsPt extends CalendarLocalizations {
  CalendarLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get previousMonthTooltip => 'Mês anterior';

  @override
  String get nextMonthTooltip => 'Próximo mês';

  @override
  String get todayButton => 'Hoje';

  @override
  String weekNumber(int week) {
    return 'S$week';
  }

  @override
  String weekNumberLabel(int week) {
    return 'Semana $week';
  }
}
