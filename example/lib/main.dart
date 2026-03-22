import 'package:flutter/material.dart';
import 'package:monthly_calendar/monthly_calendar.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar Demo',
      localizationsDelegates: CalendarLocalizations.localizationsDelegates,
      supportedLocales: CalendarLocalizations.supportedLocales,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const CalendarDemo(),
    );
  }
}

class CalendarDemo extends StatefulWidget {
  const CalendarDemo({super.key});

  @override
  State<CalendarDemo> createState() => _CalendarDemoState();
}

class _CalendarDemoState extends State<CalendarDemo> {
  DateTime? _selectedDate;

  bool _hasEvent(DateTime date) => date.day % 3 == 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Calendar View')),
      body: Column(
        children: [
          MonthlyCalendarView(
            today: DateTime.now(),
            selectedDate: _selectedDate,
            firstDate: DateTime(2025, 3, 15),
            lastDate: DateTime(2029, 12, 31),
            style: const CalendarStyle(
              calendarPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              rowHeight: 52,
              firstDayOfWeek: DateTime.sunday,
              rotateWeekNumbers: true,
              annotationAlignment: AlignmentGeometry.bottomCenter,
            ),
            showWeekNumbers: true,
            showOutOfMonthRows: false,
            onMonthChanged: (month) {
              debugPrint('Month changed: ${month.month}/${month.year}');
            },
            onDayTapped: (date) {
              setState(() => _selectedDate = date);
            },
            dayBuilder: (context, info) {
              // Show a small dot under days that have events.
              if (!_hasEvent(info.date)) return null; // default rendering

              final scheme = Theme.of(context).colorScheme;
              final color = info.isSelected
                  ? scheme.onPrimary
                  : scheme.primary.withValues(
                      alpha: info.isInCurrentMonth ? 1.0 : 0.3,
                    );

              return DayCell(
                annotation: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration:
                        BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                ),
              );
            },
          ),
          const Divider(),
          if (_selectedDate != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Selected: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
        ],
      ),
    );
  }
}
