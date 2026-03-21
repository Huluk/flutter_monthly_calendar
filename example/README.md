# monthly_calendar — Example App

A Flutter application demonstrating the features of the `monthly_calendar` package.

## Running

From the `example/` directory:

```bash
flutter run
```

Or from the repository root:

```bash
make example
```

## What It Shows

The example renders a single-screen calendar demo with the following configuration:

- **Date range** constrained to 2025-03-15 through 2029-12-31
- **Week numbers** displayed in a rotated column on the left
- **Custom row height** and week starting on Sunday
- **Out-of-month rows** hidden to keep the layout compact
- **Event dots** on every third day of the month, rendered via the `dayBuilder` callback
- **Selected date** displayed below the calendar when a day is tapped
- **Month change** events logged to the console

These features are all implemented in `lib/main.dart` and can be used as a starting point for your own integration.
