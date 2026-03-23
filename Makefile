MAKEFLAGS += --always-make

example:
	cd example && flutter run

l10n:
	flutter gen-l10n

install:
	flutter pub get

publish:
	dart pub publish

test:
	flutter test
