import 'package:flutter_test/flutter_test.dart';
import 'package:monthly_calendar/src/time_util.dart';

void main() {
  group('isoWeekNumber – basic week behavior', () {
    test('Monday starting a normal ISO week', () {
      expect(DateTime(2024, 3, 4).isoWeekNumber, 10);
    });

    test('Middle of the same week', () {
      expect(DateTime(2024, 3, 6).isoWeekNumber, 10);
    });

    test('Sunday ending the same ISO week', () {
      expect(DateTime(2024, 3, 10).isoWeekNumber, 10);
    });
  });

  group('isoWeekNumber – start-of-year edge cases', () {
    test('Jan 1, 2021 belongs to week 53 of previous ISO year', () {
      expect(DateTime(2021, 1, 1).isoWeekNumber, 53);
    });

    test('First Monday that begins ISO week 1', () {
      expect(DateTime(2021, 1, 4).isoWeekNumber, 1);
    });
  });

  group('isoWeekNumber – end-of-year edge cases', () {
    test('Dec 31, 2018 falls in ISO week 1 of next year', () {
      expect(DateTime(2018, 12, 31).isoWeekNumber, 1);
    });

    test('Dec 29, 2014 falls in ISO week 1 of next year', () {
      expect(DateTime(2014, 12, 29).isoWeekNumber, 1);
    });
  });

  group('isoWeekNumber – week 53 handling', () {
    test('Dec 31, 2015 is in week 53', () {
      expect(DateTime(2015, 12, 31).isoWeekNumber, 53);
    });

    test('End of 2020 transitions from week 52 to 53', () {
      expect(DateTime(2020, 12, 27).isoWeekNumber, 52);
      expect(DateTime(2020, 12, 28).isoWeekNumber, 53);
    });
  });

  group('isoWeekNumber – leap year behavior', () {
    test('Leap day does not break week calculation', () {
      expect(DateTime(2020, 2, 29).isoWeekNumber, 9);
    });
  });

  group('isoWeekNumber – sanity property checks', () {
    test('All weeks in a year fall within valid ISO range', () {
      for (var d = DateTime(2024, 1, 1);
          d.isBefore(DateTime(2025, 1, 1));
          d = d.add(const Duration(days: 1))) {
        final w = d.isoWeekNumber;
        expect(w >= 1 && w <= 53, isTrue);
      }
    });
  });
}
