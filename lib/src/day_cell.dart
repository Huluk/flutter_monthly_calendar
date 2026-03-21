import 'package:flutter/material.dart';

import 'calendar_style.dart';
import 'day_builder.dart';

class DayCellWidget extends StatelessWidget {
  final DayInfo dayInfo;
  final bool showContent;
  final bool tappable;
  final CalendarStyle style;
  final ThemeData theme;
  final DayCell? customCell;
  final ValueChanged<DateTime>? onDayTapped;
  final bool enableTapAnimation;

  const DayCellWidget({
    super.key,
    required this.dayInfo,
    required this.showContent,
    required this.tappable,
    required this.style,
    required this.theme,
    required this.customCell,
    required this.onDayTapped,
    required this.enableTapAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final overlayBase = dayInfo.isSelected
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurface;

    return Padding(
      padding: style.cellPadding,
      child: InkResponse(
        onTap: tappable ? () => onDayTapped?.call(dayInfo.date) : null,
        containedInkWell: true,
        customBorder: const CircleBorder(),
        splashFactory: enableTapAnimation && tappable
            ? InkSplash.splashFactory
            : NoSplash.splashFactory,
        overlayColor: tappable
            ? WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) {
                  return overlayBase.withValues(alpha: 0.12);
                }
                if (states.contains(WidgetState.hovered)) {
                  return overlayBase.withValues(alpha: 0.08);
                }
                if (states.contains(WidgetState.focused)) {
                  return overlayBase.withValues(alpha: 0.12);
                }
                return null;
              })
            : null,
        child: showContent ? _buildStyledCell() : null,
      ),
    );
  }

  Widget _buildStyledCell() {
    TextStyle? textStyle;
    BoxDecoration? decoration;

    if (dayInfo.isOutOfRange) {
      textStyle = TextStyle(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
      );
    } else if (dayInfo.isSelected) {
      textStyle = style.selectedTextStyle ??
          TextStyle(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          );
      decoration = style.selectedDecoration ??
          BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          );
    } else if (dayInfo.isToday) {
      textStyle = style.todayTextStyle ??
          TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          );
      decoration = style.todayDecoration ??
          BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.colorScheme.primary,
              width: 1.5,
            ),
          );
    } else if (!dayInfo.isInCurrentMonth) {
      textStyle = style.outsideTextStyle ??
          TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.38),
          );
    } else {
      textStyle =
          style.dayTextStyle ?? TextStyle(color: theme.colorScheme.onSurface);
    }

    // DayCell overrides are ignored for out-of-range days.
    final effectiveCell = dayInfo.isOutOfRange ? null : customCell;

    return Center(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Ink(
          decoration: effectiveCell?.decoration ?? decoration,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text('${dayInfo.date.day}',
                    style: effectiveCell?.numberStyle ?? textStyle),
              ),
              if (effectiveCell?.annotation != null)
                Align(
                  alignment: style.annotationAlignment,
                  child: effectiveCell!.annotation,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
