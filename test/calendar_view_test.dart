import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monthly_calendar/monthly_calendar.dart';

// March 2026: March 1 = Sunday. With firstDayOfWeek=Monday, row 1 has
// Feb 23–Mar 1 (6 leading out-of-month days, including Feb 28).
final _march2026 = DateTime(2026, 3, 11);

Widget _wrap(Widget child) => MaterialApp(
      localizationsDelegates: CalendarLocalizations.localizationsDelegates,
      supportedLocales: const [Locale('en')],
      home: Scaffold(body: child),
    );

void main() {
  testWidgets('renders initial month title', (tester) async {
    await tester.pumpWidget(_wrap(CustomCalendarView(today: _march2026)));
    await tester.pumpAndSettle();

    expect(find.text('March 2026'), findsOneWidget);
  });

  testWidgets('next arrow advances to next month', (tester) async {
    await tester.pumpWidget(_wrap(CustomCalendarView(today: _march2026)));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();

    expect(find.text('April 2026'), findsOneWidget);
  });

  testWidgets('prev arrow goes to previous month', (tester) async {
    await tester.pumpWidget(_wrap(CustomCalendarView(today: _march2026)));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();

    expect(find.text('February 2026'), findsOneWidget);
  });

  testWidgets('today button returns to initial month after navigating away',
      (tester) async {
    await tester.pumpWidget(_wrap(CustomCalendarView(today: _march2026)));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();
    expect(find.text('April 2026'), findsOneWidget);

    await tester.tap(find.text('Today'));
    await tester.pumpAndSettle();
    expect(find.text('March 2026'), findsOneWidget);
  });

  testWidgets('onMonthChanged fires with correct month when navigating',
      (tester) async {
    DateTime? changed;
    await tester.pumpWidget(_wrap(CustomCalendarView(
      today: _march2026,
      onMonthChanged: (m) => changed = m,
    )));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();

    expect(changed?.month, 4);
    expect(changed?.year, 2026);
  });

  testWidgets('onDayTapped fires with the tapped date', (tester) async {
    DateTime? tapped;
    await tester.pumpWidget(_wrap(CustomCalendarView(
      today: _march2026,
      onDayTapped: (d) => tapped = d,
    )));
    await tester.pumpAndSettle();

    // "15" only appears once (Mar 15 is in-month, no other "15" in the grid).
    await tester.tap(find.text('15'));
    await tester.pumpAndSettle();

    expect(tapped?.day, 15);
    expect(tapped?.month, 3);
    expect(tapped?.year, 2026);
  });

  testWidgets('showWeekNumbers displays W10 label for second row of March 2026',
      (tester) async {
    // Row 2 of March 2026 = Mar 2–8, which is ISO week 10.
    await tester.pumpWidget(_wrap(CustomCalendarView(
      today: _march2026,
      showWeekNumbers: true,
    )));
    await tester.pumpAndSettle();

    expect(find.text('W10'), findsOneWidget);
  });

  testWidgets('showOutOfMonthDays=false hides out-of-month cells.',
      (tester) async {
    await tester.pumpWidget(_wrap(CustomCalendarView(
      today: _march2026,
      showOutOfMonthDays: false,
    )));
    await tester.pumpAndSettle();

    expect(find.text('28'), findsOneWidget);
  });

  testWidgets('showOutOfMonthDays=true renders out-of-month cells',
      (tester) async {
    await tester.pumpWidget(_wrap(CustomCalendarView(
      today: _march2026,
      showOutOfMonthDays: true,
    )));
    await tester.pumpAndSettle();

    // Feb 28 (out-of-month, row 1) + Mar 28 (in-month, row 4).
    expect(find.text('28'), findsNWidgets(2));
  });

  testWidgets('showOutOfMonthRows=false omits entirely-out-of-month row',
      (tester) async {
    // Feb 2026: row 6 = Mar 2–8 (all out-of-month). With the row hidden,
    // "2" only refers to Feb 2; Mar 2 is never rendered.
    await tester.pumpWidget(_wrap(CustomCalendarView(
      today: DateTime(2026, 2, 1),
      showOutOfMonthRows: false,
    )));
    await tester.pumpAndSettle();

    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('dayBuilder custom widget appears for the matching day',
      (tester) async {
    await tester.pumpWidget(_wrap(CustomCalendarView(
      today: _march2026,
      dayBuilder: (context, info) {
        if (info.date.day == 10 && info.date.month == 3) {
          return const DayCell(annotation: Text('SPECIAL'));
        }
        return null;
      },
    )));
    await tester.pumpAndSettle();

    // Annotation appears and the number is still rendered by the view.
    expect(find.text('SPECIAL'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
  });

  testWidgets('tapping the title opens the month/year picker dialog',
      (tester) async {
    await tester.pumpWidget(_wrap(CustomCalendarView(today: _march2026)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('March 2026'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('2026'), findsOneWidget);
  });

  testWidgets('selecting a month in the picker navigates the calendar',
      (tester) async {
    await tester.pumpWidget(_wrap(CustomCalendarView(today: _march2026)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('March 2026'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Jun'));
    await tester.pumpAndSettle();

    expect(find.text('June 2026'), findsOneWidget);
  });

  group('date range', () {
    // Range limited to Mar 10–20 2026.
    final firstDay = DateTime(2026, 3, 10);
    final lastDay = DateTime(2026, 3, 20);

    testWidgets('out-of-range day cannot be tapped', (tester) async {
      DateTime? tapped;
      await tester.pumpWidget(_wrap(CustomCalendarView(
        today: _march2026,
        firstDate: firstDay,
        onDayTapped: (d) => tapped = d,
      )));
      await tester.pumpAndSettle();

      // Day 9 is before firstDay.
      await tester.tap(find.text('9'));
      await tester.pumpAndSettle();
      expect(tapped, isNull);
    });

    testWidgets('in-range day can be tapped', (tester) async {
      DateTime? tapped;
      await tester.pumpWidget(_wrap(CustomCalendarView(
        today: _march2026,
        firstDate: firstDay,
        lastDate: lastDay,
        onDayTapped: (d) => tapped = d,
      )));
      await tester.pumpAndSettle();

      await tester.tap(find.text('15'));
      await tester.pumpAndSettle();
      expect(tapped?.day, 15);
    });

    testWidgets('prev arrow is blocked at firstDay month boundary',
        (tester) async {
      // firstDay is in March, so February is out of range.
      await tester.pumpWidget(_wrap(CustomCalendarView(
        today: _march2026,
        firstDate: firstDay,
      )));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();
      expect(find.text('March 2026'), findsOneWidget);
    });

    testWidgets('next arrow is blocked at lastDay month boundary',
        (tester) async {
      // lastDay is in March, so April is out of range.
      await tester.pumpWidget(_wrap(CustomCalendarView(
        today: _march2026,
        lastDate: lastDay,
      )));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();
      expect(find.text('March 2026'), findsOneWidget);
    });

    testWidgets('allowNavigationOutsideRange bypasses prev block',
        (tester) async {
      await tester.pumpWidget(_wrap(CustomCalendarView(
        today: _march2026,
        firstDate: firstDay,
        allowNavigationOutsideRange: true,
      )));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();
      expect(find.text('February 2026'), findsOneWidget);
    });

    testWidgets('dayBuilder receives isOutOfRange=true for out-of-range days',
        (tester) async {
      final outOfRangeDays = <int>[];
      await tester.pumpWidget(_wrap(CustomCalendarView(
        today: _march2026,
        firstDate: firstDay,
        lastDate: lastDay,
        dayBuilder: (context, info) {
          if (info.isOutOfRange) outOfRangeDays.add(info.date.day);
          return null;
        },
      )));
      await tester.pumpAndSettle();

      // Days 1–9 and 21–31 of March are out of range.
      expect(outOfRangeDays, containsAll([1, 5, 9, 21, 25, 31]));
      expect(outOfRangeDays, isNot(contains(10)));
      expect(outOfRangeDays, isNot(contains(20)));
    });

    testWidgets('picker disables out-of-range months', (tester) async {
      // Range covers only March 2026. Feb and Apr should be disabled.
      await tester.pumpWidget(_wrap(CustomCalendarView(
        today: _march2026,
        firstDate: firstDay,
        lastDate: lastDay,
      )));
      await tester.pumpAndSettle();

      await tester.tap(find.text('March 2026'));
      await tester.pumpAndSettle();

      // Tapping a disabled month does not close the dialog.
      await tester.tap(find.text('Feb'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);

      // Tapping the in-range month closes the dialog.
      await tester.tap(find.text('Mar'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
