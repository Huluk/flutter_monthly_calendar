import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'calendar_style.dart';
import 'l10n/calendar_localizations.dart';
import 'month_picker.dart';
import 'time_util.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime currentMonth;
  final DateTime today;
  final CalendarStyle style;
  final ThemeData theme;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final VoidCallback? onToday;
  final ValueChanged<DateTime> onMonthSelected;
  final bool showWeekNumbers;
  final DateValidator allowJump;

  const CalendarHeader({
    super.key,
    required this.currentMonth,
    required this.today,
    required this.style,
    required this.theme,
    required this.onPrev,
    required this.onNext,
    required this.onToday,
    required this.onMonthSelected,
    required this.showWeekNumbers,
    required this.allowJump,
  });

  @override
  Widget build(BuildContext context) {
    final loc = CalendarLocalizations.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final dayWidth = (constraints.maxWidth - style.weekNumberWidth) / 7;
        final weekNumberWidth = showWeekNumbers ? style.weekNumberWidth : 0;
        final titleOffset = weekNumberWidth + dayWidth * 2 / 5;
        return Row(children: [
          SizedBox(width: titleOffset),
          _titleButton(context),
          ..._navigationArrows(loc),
        ]);
      },
    );
  }

  Widget _titleButton(BuildContext context) {
    final localeName = Localizations.localeOf(context).toString();
    final title = DateFormat.yMMMM(localeName).format(currentMonth);
    return Expanded(
        child: TextButton(
      onPressed: () async {
        final picked = await showDialog<DateTime>(
          context: context,
          builder: (_) => MonthYearPickerDialog(
            initialMonth: currentMonth,
            today: today,
            allowJump: allowJump,
          ),
        );
        if (picked != null) onMonthSelected(picked);
      },
      style: TextButton.styleFrom(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.zero,
      ),
      child: Text(
        title,
        style: style.titleStyle ??
            theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    ));
  }

  List<Widget> _navigationArrows(CalendarLocalizations loc) => [
        IconButton(
          icon: Icon(style.prevIcon, size: style.arrowIconSize),
          color: style.arrowColor ?? theme.iconTheme.color,
          onPressed: onPrev,
          tooltip: loc.previousMonthTooltip,
        ),
        TextButton(
          onPressed: onToday,
          child: Text(loc.todayButton),
        ),
        IconButton(
          icon: Icon(style.nextIcon, size: style.arrowIconSize),
          color: style.arrowColor ?? theme.iconTheme.color,
          onPressed: onNext,
          tooltip: loc.nextMonthTooltip,
        ),
      ];
}
