import 'package:flutter/material.dart';

/// Visual configuration for the calendar widget.
class CalendarStyle {
  /// Text style for the "Month Year" title in the header.
  final TextStyle? titleStyle;

  /// Icon used for the "previous month" button.
  final IconData prevIcon;

  /// Icon used for the "next month" button.
  final IconData nextIcon;

  /// Size of the navigation arrow icons.
  final double arrowIconSize;

  /// Color applied to the navigation arrow icons.
  final Color? arrowColor;

  /// Text style for the weekday labels row (Mo, Tu, …).
  final TextStyle? weekdayLabelStyle;

  /// Text style for regular day numbers.
  final TextStyle? dayTextStyle;

  /// Text style for the current‐day number.
  final TextStyle? todayTextStyle;

  /// Decoration drawn behind the current‐day cell.
  final BoxDecoration? todayDecoration;

  /// Text style for the selected day number.
  final TextStyle? selectedTextStyle;

  /// Decoration drawn behind the selected day cell.
  final BoxDecoration? selectedDecoration;

  /// Text style for days that belong to the previous/next month.
  final TextStyle? outsideTextStyle;

  /// First day of the week. Use [DateTime] constants such as [DateTime.monday]
  /// (= 1, the default) through [DateTime.sunday] (= 7).
  final int firstDayOfWeek;

  /// Padding around the entire calendar widget.
  final EdgeInsets calendarPadding;

  /// Padding inside each day cell.
  final EdgeInsets cellPadding;

  /// Height of each day‐cell row.
  final double rowHeight;

  /// Text style for the ISO week-number column.
  final TextStyle? weekNumberStyle;

  /// Width of the ISO week-number column.
  final double weekNumberWidth;

  /// Whether to rotate the week number 90° (reads bottom-to-top).
  final bool rotateWeekNumbers;

  /// Where to align the annotation widget (from [DayCell.annotation]) within
  /// each day cell. Defaults to [Alignment.bottomRight].
  final AlignmentGeometry annotationAlignment;

  const CalendarStyle({
    this.titleStyle,
    this.prevIcon = Icons.chevron_left,
    this.nextIcon = Icons.chevron_right,
    this.arrowIconSize = 24.0,
    this.arrowColor,
    this.weekdayLabelStyle,
    this.dayTextStyle,
    this.todayTextStyle,
    this.todayDecoration,
    this.selectedTextStyle,
    this.selectedDecoration,
    this.outsideTextStyle,
    this.firstDayOfWeek = DateTime.monday,
    this.calendarPadding = const EdgeInsets.all(8.0),
    this.cellPadding = const EdgeInsets.all(4.0),
    this.rowHeight = 48.0,
    this.weekNumberStyle,
    this.weekNumberWidth = 32.0,
    this.rotateWeekNumbers = false,
    this.annotationAlignment = Alignment.bottomRight,
  }) : assert(firstDayOfWeek >= DateTime.monday &&
            firstDayOfWeek <= DateTime.sunday);

  /// Returns a copy with the given fields replaced.
  CalendarStyle copyWith({
    TextStyle? titleStyle,
    IconData? prevIcon,
    IconData? nextIcon,
    double? arrowIconSize,
    Color? arrowColor,
    TextStyle? weekdayLabelStyle,
    TextStyle? dayTextStyle,
    TextStyle? todayTextStyle,
    BoxDecoration? todayDecoration,
    TextStyle? selectedTextStyle,
    BoxDecoration? selectedDecoration,
    TextStyle? outsideTextStyle,
    int? firstDayOfWeek,
    EdgeInsets? calendarPadding,
    EdgeInsets? cellPadding,
    double? rowHeight,
    TextStyle? weekNumberStyle,
    double? weekNumberWidth,
    bool? rotateWeekNumbers,
    AlignmentGeometry? annotationAlignment,
  }) {
    return CalendarStyle(
      titleStyle: titleStyle ?? this.titleStyle,
      prevIcon: prevIcon ?? this.prevIcon,
      nextIcon: nextIcon ?? this.nextIcon,
      arrowIconSize: arrowIconSize ?? this.arrowIconSize,
      arrowColor: arrowColor ?? this.arrowColor,
      weekdayLabelStyle: weekdayLabelStyle ?? this.weekdayLabelStyle,
      dayTextStyle: dayTextStyle ?? this.dayTextStyle,
      todayTextStyle: todayTextStyle ?? this.todayTextStyle,
      todayDecoration: todayDecoration ?? this.todayDecoration,
      selectedTextStyle: selectedTextStyle ?? this.selectedTextStyle,
      selectedDecoration: selectedDecoration ?? this.selectedDecoration,
      outsideTextStyle: outsideTextStyle ?? this.outsideTextStyle,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      calendarPadding: calendarPadding ?? this.calendarPadding,
      cellPadding: cellPadding ?? this.cellPadding,
      rowHeight: rowHeight ?? this.rowHeight,
      weekNumberStyle: weekNumberStyle ?? this.weekNumberStyle,
      weekNumberWidth: weekNumberWidth ?? this.weekNumberWidth,
      rotateWeekNumbers: rotateWeekNumbers ?? this.rotateWeekNumbers,
      annotationAlignment: annotationAlignment ?? this.annotationAlignment,
    );
  }
}
