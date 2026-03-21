import 'dart:async';

import 'package:flutter/material.dart';

import 'time_util.dart';

/// Controller to programmatically control [CustomCalendarView].
///
/// Use a controller when you need to programmatically navigate
/// the calendar (e.g., from an external "Today" button).
///
/// The controller owns the [PageController] internally. The caller is
/// responsible for creating the controller and calling [dispose] when
/// no longer needed.
///
/// Example:
/// ```dart
/// final controller = CalendarController();
///
/// CustomCalendarView(
///   controller: controller,
///   ...
/// );
///
/// // Later, from a button:
/// controller.navigateTo(DateTime.now());
///
/// // When done:
/// controller.dispose();
/// ```
class CalendarController {
  // We use a "virtual" page approach so the user can swipe in both directions
  // without hitting an edge.
  static const int initialPage = 6000;

  final DateTime initialFocusDate;

  final PageController pageController;
  final Duration animationDuration;

  /// Creates a CalendarController.
  ///
  /// The [initialFocusDate] is used to calculate the initial page index.
  /// Defaults to today's date if not provided.
  CalendarController({
    DateTime? initialFocusDate,
    this.animationDuration = const Duration(milliseconds: 300),
  })  : initialFocusDate = initialFocusDate ?? DateTime.now(),
        pageController = PageController(initialPage: initialPage);

  DateTime get currentMonth => pageToMonth();

  DateTime pageToMonth({int? page, int delta = 0}) {
    final effectivePage =
        (page ?? pageController.page?.round() ?? initialPage) + delta;
    final diff = effectivePage - initialPage;
    return DateTime.utc(initialFocusDate.year, initialFocusDate.month + diff);
  }

  /// Navigate to the month containing the given date.
  void navigateTo(DateTime date) {
    final target = date.toUtcMonth();
    final diff = (target.year - initialFocusDate.year) * 12 +
        (target.month - initialFocusDate.month);
    unawaited(pageController.animateToPage(
      initialPage + diff,
      duration: animationDuration,
      curve: Curves.easeInOut,
    ));
  }

  void dispose() {
    pageController.dispose();
  }
}
