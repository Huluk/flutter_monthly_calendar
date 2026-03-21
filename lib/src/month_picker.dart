import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'time_util.dart';

class MonthYearPickerDialog extends StatefulWidget {
  final DateTime initialMonth;
  final DateTime today;
  final DateValidator allowJump;

  const MonthYearPickerDialog({
    super.key,
    required this.initialMonth,
    required this.today,
    required this.allowJump,
  });

  @override
  State<MonthYearPickerDialog> createState() => MonthYearPickerDialogState();
}

class MonthYearPickerDialogState extends State<MonthYearPickerDialog> {
  late int _year;

  @override
  void initState() {
    super.initState();
    _year = widget.initialMonth.year;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localeName = Localizations.localeOf(context).toString();

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildYearSelector(theme),
          _buildMonthGrid(context, theme, localeName),
        ],
      ),
    );
  }

  bool _hasReachableMonthInYear(int year) => List.generate(
          12, (i) => DateTime.utc(year, i + 1).isMonthValid(widget.allowJump))
      .any((v) => v);

  Widget _buildYearSelector(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _hasReachableMonthInYear(_year - 1)
              ? () => setState(() => _year--)
              : null,
        ),
        Text('$_year', style: theme.textTheme.titleMedium),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _hasReachableMonthInYear(_year + 1)
              ? () => setState(() => _year++)
              : null,
        ),
      ],
    );
  }

  Widget _buildMonthGrid(
      BuildContext context, ThemeData theme, String localeName) {
    const monthsPerRow = 4, monthsPerColumn = 3;
    return Column(
        children: List.generate(
      monthsPerColumn,
      (row) => Row(
          children: List.generate(monthsPerRow, (column) {
        final month = DateTime.utc(_year, row * monthsPerRow + column + 1);
        final isSelected = _year == widget.initialMonth.year &&
            month.month == widget.initialMonth.month;
        final isCurrentMonth =
            _year == widget.today.year && month.month == widget.today.month;
        final inRange = month.isMonthValid(widget.allowJump);
        return Expanded(
            child: TextButton(
          onPressed: inRange ? () => Navigator.of(context).pop(month) : null,
          style: TextButton.styleFrom(
            foregroundColor:
                isSelected ? theme.colorScheme.onPrimaryContainer : null,
            backgroundColor:
                isSelected ? theme.colorScheme.primaryContainer : null,
            side: isCurrentMonth && !isSelected
                ? BorderSide(color: theme.colorScheme.primary, width: 1.5)
                : null,
          ),
          child: Text(DateFormat.MMM(localeName).format(month)),
        ));
      })),
    ));
  }
}
