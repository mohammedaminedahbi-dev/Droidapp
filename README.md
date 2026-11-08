# LetterForge

An original, offline-first Flutter five-letter word puzzle game for Android. It uses a dark teal visual system, mint/yellow/charcoal feedback, rounded tiles, an on-screen QWERTY keyboard, physical keyboard support, local progress, levels, hints, extra attempts, stats, settings, and a privacy notice.

## Project status

This workspace contains the Flutter source and Android project configuration. The current execution environment does **not** have Flutter, Dart, the Android SDK, or an emulator installed, so APK/AAB compilation and emulator/device QA could not be run here. Do not treat this archive as a compiled or release-verified app. The included test suite and exact build steps are intended for a Flutter-equipped machine.

## Requirements

- Flutter stable with Dart 3.4 or newer
- Android SDK Platform 36 and a compatible Android build-tools version
- Java 17
- Android Studio or command-line Android SDK tools

## Run

```bash
flutter doctor -v
flutter pub get
flutter analyze
flutter test
flutter run
```

For physical keyboard testing, connect a keyboard to an Android device or use a desktop/web debug run. The game handles Enter and Backspace through Flutter keyboard events.

## Build device-test APK

```bash
flutter build apk --debug
flutter build apk --release
```

Outputs:
- `build/app/outputs/flutter-apk/app-debug.apk`
- `build/app/outputs/flutter-apk/app-release.apk`

The configured Gradle release signing currently uses the debug signing configuration only to allow local smoke testing. **Never submit that APK to Google Play.** Configure a private upload key using `RELEASE.md` before building the AAB.

## Build Google Play App Bundle

After configuring the release signing in `RELEASE.md`:

```bash
flutter build appbundle --release
```

Expected output: `build/app/outputs/bundle/release/app-release.aab`.

## Architecture

- `lib/domain/game_logic.dart`: duplicate-aware scoring, word validation, hint text.
- `lib/data/word_bank.dart`: offline answer/guess lexicon.
- `lib/services/progress_store.dart`: local progress serialization through SharedPreferences.
- `lib/main.dart`: branded UI and app screens.
- `test/game_logic_test.dart`: core game logic tests.
- `android/`: Android manifest, Kotlin entry point, Gradle config, target API 36.

## Data and permissions

The core game works offline. The manifest intentionally has no INTERNET permission or runtime permission requests. Progress is stored locally using SharedPreferences. The privacy notice describes this current build. If you add ad, analytics, crash-reporting, cloud sync, or purchase SDKs, update the privacy policy, manifest, Play Data safety answers, and consent flow to match the final binaries.

## Content

The built-in word bank is curated and self-contained. It currently provides hundreds of valid five-letter guesses and more than 120 distinct candidate level answers. This is a compact embedded dictionary, not an exhaustive English dictionary; unsupported guesses are rejected with a message.
