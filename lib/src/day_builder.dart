import 'package:flutter/material.dart';

/// Metadata passed to a custom day‐cell builder.
class DayInfo {
  /// The date this cell represents.
  final DateTime date;

  /// Whether this date falls in the currently displayed month.
  final bool isInCurrentMonth;

  /// Whether this date is today.
  final bool isToday;

  /// ISO 8601 weekday: 1 = Monday … 7 = Sunday.
  final int weekdayIndex;

  /// Whether this date falls outside the calendar's [firstDay]/[lastDay] range.
  /// Out-of-range cells are rendered but not tappable.
  final bool isOutOfRange;

  /// Whether this date is the currently selected date.
  final bool isSelected;

  const DayInfo({
    required this.date,
    required this.isInCurrentMonth,
    required this.isToday,
    required this.weekdayIndex,
    this.isOutOfRange = false,
    this.isSelected = false,
  });
}

/// Structured customization for a single day cell.
///
/// All fields are optional.
///
/// ```dart
/// dayBuilder: (context, info) {
///   if (!hasEvent(info.date)) return null; // fully default
///   return DayCell(
///     annotation: Container(
///       width: 5, height: 5,
///       decoration: const BoxDecoration(
///         color: Colors.indigo, shape: BoxShape.circle,
///       ),
///     ),
///   );
/// }
/// ```
class DayCell {
  /// Override for the day-number [TextStyle]. Null keeps the default.
  final TextStyle? numberStyle;

  /// Override for the cell background [BoxDecoration]. Null keeps the default.
  final BoxDecoration? decoration;

  /// Widget rendered over the day number without shifting it.
  ///
  /// The view positions this via a [Stack] + [Align], so the number stays at
  /// the same vertical centre regardless of the annotation's size.
  /// The alignment is controlled by [CalendarStyle.annotationAlignment].
  final Widget? annotation;

  const DayCell({this.numberStyle, this.decoration, this.annotation});
}

/// Signature for a function that customizes a single day cell.
///
/// Return a [DayCell] to override specific aspects of the default rendering,
/// or `null` to use the default rendering entirely.
typedef DayBuilder = DayCell? Function(BuildContext context, DayInfo info);
