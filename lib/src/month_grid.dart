import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'calendar_style.dart';
import 'day_builder.dart';
import 'day_cell.dart';
import 'l10n/calendar_localizations.dart';
import 'time_util.dart';

class MonthGrid extends StatelessWidget {
  final DateTime today;
  final DateTime? selectedDate;
  final DateTime month;
  final List<List<DateTime>> rows;
  final CalendarStyle style;
  final ThemeData theme;
  final DayBuilder? dayBuilder;
  final ValueChanged<DateTime>? onDayTapped;
  final bool showOutOfMonthDays;
  final bool showWeekNumbers;
  final bool enableTapAnimation;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const MonthGrid({
    super.key,
    required this.today,
    this.selectedDate,
    required this.month,
    required this.rows,
    required this.style,
    required this.theme,
    this.dayBuilder,
    this.onDayTapped,
    required this.showOutOfMonthDays,
    required this.showWeekNumbers,
    required this.enableTapAnimation,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  Widget build(BuildContext context) => ClipRect(
          child: OverflowBox(
        maxHeight: double.infinity,
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: rows
              .map((row) => SizedBox(
                  height: style.rowHeight,
                  child: Row(children: [
                    if (showWeekNumbers)
                      _styledWeekNumber(context, row.first.isoWeekNumber),
                    ...row.map((day) => _buildDayCell(context, day)),
                  ])))
              .toList(),
        ),
      ));

  Widget _styledWeekNumber(BuildContext context, int weekNumber) {
    final loc = CalendarLocalizations.of(context);
    return SizedBox(
        width: style.weekNumberWidth,
        child: Center(
            child: RotatedBox(
          quarterTurns: style.rotateWeekNumbers ? 3 : 0,
          child: Text(
            loc.weekNumber(weekNumber),
            semanticsLabel: loc.weekNumberLabel(weekNumber),
            style: style.weekNumberStyle ??
                theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
          ),
        )));
  }

  Widget _buildDayCell(BuildContext context, DateTime date) {
    final dayInfo = _dayInfo(date);
    final tappable = (dayInfo.isInCurrentMonth || showOutOfMonthDays) &&
        !dayInfo.isOutOfRange;
    final showContent = dayInfo.isInCurrentMonth || showOutOfMonthDays;
    return Expanded(
      child: DayCellWidget(
        dayInfo: dayInfo,
        showContent: showContent,
        tappable: tappable,
        style: style,
        theme: theme,
        customCell: showContent ? dayBuilder?.call(context, dayInfo) : null,
        onDayTapped: onDayTapped,
        enableTapAnimation: enableTapAnimation,
      ),
    );
  }

  DayInfo _dayInfo(DateTime date) {
    return DayInfo(
      date: date,
      isInCurrentMonth: date.month == month.month && date.year == month.year,
      isToday: date.year == today.year &&
          date.month == today.month &&
          date.day == today.day,
      isSelected: selectedDate != null &&
          date.year == selectedDate!.year &&
          date.month == selectedDate!.month &&
          date.day == selectedDate!.day,
      weekdayIndex: date.weekday,
      isOutOfRange: !date.isInRange(firstDate, lastDate),
    );
  }
}

class WeekdayRow extends StatelessWidget {
  final CalendarStyle style;
  final ThemeData theme;
  final int firstDayOfWeek;
  final bool showWeekNumbers;

  const WeekdayRow({
    super.key,
    required this.style,
    required this.theme,
    required this.firstDayOfWeek,
    required this.showWeekNumbers,
  });

  @override
  Widget build(BuildContext context) {
    final localeName = Localizations.localeOf(context).toString();
    final fmt = DateFormat.E(localeName);
    // DateTime.utc(2024, 1, 1) is a Monday.
    final labels = List.generate(
        7, (i) => fmt.format(DateTime.utc(2024, 1, firstDayOfWeek + i)));

    final labelStyle = style.weekdayLabelStyle ??
        theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          fontWeight: FontWeight.w600,
        );

    return Row(
      children: [
        if (showWeekNumbers) SizedBox(width: style.weekNumberWidth),
        ...labels.map((label) =>
            Expanded(child: Center(child: Text(label, style: labelStyle)))),
      ],
    );
  }
}
