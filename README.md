# monthly_calendar

A customizable monthly calendar widget for Flutter with swipe navigation,
day cell customization, ISO week numbers, and built-in localization.

## Features

- Monthly calendar view with animated swipe navigation
  (horizontal for months, vertical for years)
- Customizable day cells via a builder callback
- ISO 8601 week number display
- Date range constraints (`firstDate` / `lastDate`)
- Month / year picker dialog
- Fully configurable styles
- Localized strings

## Setup

Add the localization delegates to your `MaterialApp`.
`CalendarLocalizations.localizationsDelegates` already includes the Material,
Cupertino, and Widgets delegates, so you can use it directly:

```dart
import 'package:monthly_calendar/monthly_calendar.dart';

MaterialApp(
  localizationsDelegates: CalendarLocalizations.localizationsDelegates,
  supportedLocales: CalendarLocalizations.supportedLocales,
  home: MyScreen(),
)
```

If you have your own delegates,
add only `CalendarLocalizations.delegate` to your existing list.

## Basic Usage

```dart
CustomCalendarView(
  today: DateTime.now(),
  selectedDate: _selectedDate,
  onDayTapped: (date) => setState(() => _selectedDate = date),
)
```

## Custom Day Cells

Use `dayBuilder` to annotate or restyle individual days.
Return `null` to use the default rendering.

```dart
CustomCalendarView(
  today: DateTime.now(),
  dayBuilder: (context, info) {
    if (info.date.weekday == DateTime.saturday ||
        info.date.weekday == DateTime.sunday) {
      return DayCell(
        numberStyle: TextStyle(color: Colors.red),
      );
    }
    return null;
  },
)
```

`DayInfo` fields:

| Field | Type | Description |
|---|---|---|
| `date` | `DateTime` | The date of the cell |
| `isInCurrentMonth` | `bool` | Whether the day is in the displayed month |
| `isToday` | `bool` | Whether the day is today |
| `isSelected` | `bool` | Whether the day matches `selectedDate` |
| `weekdayIndex` | `int` | ISO 8601 weekday (1 = Monday, 7 = Sunday) |
| `isOutOfRange` | `bool` | Whether the day is outside `firstDate`/`lastDate` |

`DayCell` fields:

| Field | Type | Description |
|---|---|---|
| `numberStyle` | `TextStyle?` | Override the day number text style |
| `decoration` | `BoxDecoration?` | Override the cell background decoration |
| `annotation` | `Widget?` | Widget rendered as an overlay (positioned via `annotationAlignment` in `CalendarStyle`) |

## Styling

Pass a `CalendarStyle` to the `style` parameter.

```dart
CustomCalendarView(
  today: DateTime.now(),
  style: CalendarStyle(
    firstDayOfWeek: DateTime.sunday,
    rowHeight: 52,
    showWeekNumbers: true,
    rotateWeekNumbers: true,
    selectedDecoration: BoxDecoration(
      color: Colors.indigo,
      shape: BoxShape.circle,
    ),
    todayDecoration: BoxDecoration(
      border: Border.all(color: Colors.indigo),
      shape: BoxShape.circle,
    ),
  ),
)
```

### `CalendarSwipe` values

| Value | Effect |
|---|---|
| `none` | Swipe disabled |
| `horizontal` | Swipe left/right changes month |
| `vertical` | Swipe up/down changes year |
| `all` | Both horizontal and vertical swipe |

## Localization

Supported locales: `en`, `de`, `es`, `fr`, `nl`, `pt`.

The package uses Flutter's standard localization system.
No additional configuration is needed beyond adding the delegates
as shown in [Setup](#setup).

To add a new language, create a new ARB file in `lib/l10n/` and run:

```
make l10n
```
