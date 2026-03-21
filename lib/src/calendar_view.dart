import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'calendar_controller.dart';
import 'calendar_header.dart';
import 'calendar_style.dart';
import 'day_builder.dart';
import 'month_grid.dart';
import 'time_util.dart';

const int _maxRows = 6;
const double _swipeVelocityThreshold = 300;

/// Controls which swipe gestures navigate the calendar.
enum CalendarSwipe {
  /// No swipe navigation.
  none,

  /// Horizontal swipe changes the month.
  horizontal,

  /// Vertical swipe changes the year.
  vertical,

  /// Both horizontal (month) and vertical (year) swipes are active.
  all,
}

/// A monthly calendar view with swipe navigation and customizable day cells.
class CustomCalendarView extends StatefulWidget {
  /// The reference date (today).
  final DateTime today;

  /// The month to display initially. Defaults to `today`.
  /// Is ignored if using a custom [controller].
  final DateTime? initialFocusDate;

  /// Visual configuration. See [CalendarStyle] for available options.
  final CalendarStyle style;

  /// Optional builder that lets you provide a completely custom widget for
  /// any day cell. Return `null` to use the default rendering.
  final DayBuilder? dayBuilder;

  /// Called whenever the displayed month changes (via swipe or arrow tap).
  final ValueChanged<DateTime>? onMonthChanged;

  /// The currently selected date, highlighted with a solid fill.
  /// When both [selectedDate] and [today] fall on the same day, the selected
  /// style (solid fill) wins.
  final DateTime? selectedDate;

  /// Called when the user taps a day cell.
  final ValueChanged<DateTime>? onDayTapped;

  /// Swipe physics. Defaults to [BouncingScrollPhysics].
  final ScrollPhysics? swipePhysics;

  /// Whether to render day cells that belong to the previous/next month.
  /// Defaults to `true`. When `false`, those cells are left empty.
  final bool showOutOfMonthDays;

  /// Whether to show rows whose every cell is outside the current month.
  /// Defaults to `true`. When `false`, those rows are omitted entirely and
  /// the grid shrinks accordingly.
  final bool showOutOfMonthRows;

  /// Whether to show ISO week numbers in a leading column.
  final bool showWeekNumbers;

  /// Which swipe directions are active. Horizontal changes the month,
  /// vertical changes the year. Defaults to [CalendarSwipe.all].
  final CalendarSwipe swipeInput;

  /// Whether tapping a day cell shows an ink-ripple animation.
  /// Defaults to `true`.
  final bool enableTapAnimation;

  /// Earliest selectable date. Days before this are rendered but not tappable.
  /// Navigation to earlier months is also blocked unless
  /// [allowNavigationOutsideRange] is `true`.
  final DateTime? firstDate;

  /// Latest selectable date. Days after this are rendered but not tappable.
  /// Navigation to later months is also blocked unless
  /// [allowNavigationOutsideRange] is `true`.
  final DateTime? lastDate;

  /// When `true`, the prev/next arrows and swipe gestures can navigate to
  /// months outside the [firstDate]/[lastDate] range. Defaults to `false`.
  final bool allowNavigationOutsideRange;

  /// Optional controller for programmatic navigation.
  final CalendarController? controller;

  CustomCalendarView({
    super.key,
    required this.today,
    DateTime? initialFocusDate,
    this.selectedDate,
    this.style = const CalendarStyle(),
    this.dayBuilder,
    this.onMonthChanged,
    this.onDayTapped,
    this.swipePhysics,
    this.showOutOfMonthDays = true,
    this.showOutOfMonthRows = true,
    this.showWeekNumbers = false,
    this.swipeInput = CalendarSwipe.all,
    this.enableTapAnimation = true,
    this.firstDate,
    this.lastDate,
    this.allowNavigationOutsideRange = false,
    this.controller,
  })  : initialFocusDate =
            initialFocusDate ?? (controller == null ? today : null),
        assert(allowNavigationOutsideRange ||
            (initialFocusDate ?? today).isInRange(firstDate, lastDate));

  @override
  State<CustomCalendarView> createState() => _CustomCalendarViewState();
}

class _CustomCalendarViewState extends State<CustomCalendarView> {
  late DateTime _currentMonth;
  late CalendarController? _controller;

  CalendarController get _effectiveController =>
      widget.controller ?? _controller!;

  DateTime get _initialFocusDate => _effectiveController.initialFocusDate;

  // Range limits normalized to midnight.
  late final DateTime? _firstDate;
  late final DateTime? _lastDate;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller =
          CalendarController(initialFocusDate: widget.initialFocusDate);
    }
    _currentMonth = _initialFocusDate.toUtcMonth();
    _firstDate = widget.firstDate?.toUtcDay();
    _lastDate = widget.lastDate?.toUtcDay();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // === Month arithmetic ===

  void _flipPage(int delta) async {
    final currentMonth = _effectiveController.currentMonth;
    final target = DateTime.utc(currentMonth.year, currentMonth.month + delta);
    if (!_allowJump(target)) return;
    _effectiveController.navigateTo(target);
  }

  void _jumpToMonth(DateTime month) {
    if (!_allowJump(month)) return;
    _effectiveController.navigateTo(month);
  }

  /// Returns all dates to display in the grid for [month], including leading/
  /// trailing days from adjacent months to fill complete weeks.
  List<List<DateTime>> _rowsForMonth(DateTime month) {
    final firstOfMonth = month.toUtcMonth();
    // How many days from the previous month to show.
    final leadingDays =
        (firstOfMonth.weekday - widget.style.firstDayOfWeek) % 7;

    final startDate = firstOfMonth.subtract(Duration(days: leadingDays));

    return List.generate(_maxRows * 7, (i) => startDate.add(Duration(days: i)))
        .slices(7)
        .where((weekDays) =>
            widget.showOutOfMonthRows ||
            weekDays.first.month == month.month ||
            weekDays.last.month == month.month)
        .toList();
  }

  // === Build ===

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.style.calendarPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _header(Theme.of(context)),
          const SizedBox(height: 8),
          _weekdayRow(Theme.of(context)),
          const SizedBox(height: 4),
          _pagedGrid(Theme.of(context)),
        ],
      ),
    );
  }

  Widget _header(ThemeData theme) {
    final canGoPrev = DateTime.utc(_currentMonth.year, _currentMonth.month - 1)
        .isMonthValid(_allowJump);
    final canGoNext = DateTime.utc(_currentMonth.year, _currentMonth.month + 1)
        .isMonthValid(_allowJump);

    return CalendarHeader(
      currentMonth: _currentMonth,
      today: widget.today,
      style: widget.style,
      theme: theme,
      onPrev: canGoPrev ? () => _flipPage(-1) : null,
      onNext: canGoNext ? () => _flipPage(1) : null,
      onToday:
          _allowJump(widget.today) ? () => _jumpToMonth(widget.today) : null,
      onMonthSelected: _jumpToMonth,
      showWeekNumbers: widget.showWeekNumbers,
      allowJump: _allowJump,
    );
  }

  bool _allowJump(DateTime date) {
    if (widget.allowNavigationOutsideRange) return true;
    final monthStart = DateTime.utc(date.year, date.month);
    final monthEnd = DateTime.utc(date.year, date.month + 1, 0);
    if (_lastDate != null && monthStart.isAfter(_lastDate!)) return false;
    if (_firstDate != null && monthEnd.isBefore(_firstDate!)) return false;
    return true;
  }

  Widget _weekdayRow(ThemeData theme) {
    return WeekdayRow(
      style: widget.style,
      theme: theme,
      firstDayOfWeek: widget.style.firstDayOfWeek,
      showWeekNumbers: widget.showWeekNumbers,
    );
  }

  Widget _pagedGrid(ThemeData theme) {
    final rowsForMonth = _rowsForMonth(_currentMonth);
    return GestureDetector(
      onVerticalDragEnd: widget.swipeInput == CalendarSwipe.vertical ||
              widget.swipeInput == CalendarSwipe.all
          ? (details) {
              final v = details.primaryVelocity ?? 0;
              if (v < -_swipeVelocityThreshold) {
                _jumpToMonth(
                    DateTime.utc(_currentMonth.year + 1, _currentMonth.month));
              } else if (v > _swipeVelocityThreshold) {
                _jumpToMonth(
                    DateTime.utc(_currentMonth.year - 1, _currentMonth.month));
              }
            }
          : null,
      child: SizedBox(
        height: widget.style.rowHeight * rowsForMonth.length,
        child: PageView.builder(
          controller: _effectiveController.pageController,
          physics: widget.swipeInput == CalendarSwipe.none ||
                  widget.swipeInput == CalendarSwipe.vertical
              ? const NeverScrollableScrollPhysics()
              : widget.swipePhysics ?? const BouncingScrollPhysics(),
          onPageChanged: (page) {
            final month = _effectiveController.pageToMonth(page: page);
            setState(() => _currentMonth = month);
            widget.onMonthChanged?.call(month);
          },
          itemBuilder: (context, pageIndex) => MonthGrid(
            today: widget.today,
            selectedDate: widget.selectedDate,
            month: _effectiveController.currentMonth,
            rows: rowsForMonth,
            style: widget.style,
            theme: theme,
            dayBuilder: widget.dayBuilder,
            onDayTapped: widget.onDayTapped,
            showOutOfMonthDays: widget.showOutOfMonthDays,
            showWeekNumbers: widget.showWeekNumbers,
            enableTapAnimation: widget.enableTapAnimation,
            firstDate: _firstDate,
            lastDate: _lastDate,
          ),
        ),
      ),
    );
  }
}
