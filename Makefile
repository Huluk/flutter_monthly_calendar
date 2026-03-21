MAKEFLAGS += --always-make

example:
	cd example && flutter run

l10n:
	flutter gen-l10n

install:
	flutter pub get

test:
	flutter test
