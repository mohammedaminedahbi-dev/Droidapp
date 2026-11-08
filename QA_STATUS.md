# QA status (honest environment report)

Date: 2026-11-06

## Performed
- Created a Flutter project structure and Android Gradle configuration targeting API 36.
- Added a local curated word bank with 812 unique five-letter words (answer pool is deduplicated before level selection).
- Added unit tests for exact matches, duplicate-letter scoring, word validation, and 120 distinct level answers.
- Added a local persistence service and privacy/data disclosure draft.
- Created app icon PNGs in Android mipmap densities and a 1024×500 feature graphic draft.
- Reviewed official Google Play target API guidance. New mobile apps and updates must target API 36 or higher as of August 31, 2026.

## Not performed
- `flutter analyze`, `flutter test`, Flutter builds, Gradle builds, emulator runs, and device testing were **not run** because this environment has no Flutter/Dart SDK, Android SDK, or emulator, and external package downloads are unavailable.
- No APK or AAB was compiled. No production upload key exists. No Google Play upload or review occurred.
- The word bank has not received human editorial review for all word meanings/locale suitability.

## Must verify before release
- Run every command in README on a Flutter-equipped machine and fix any compile/analyzer/test failures.
- Test all screens and all buttons; verify progress survives force-stop/relaunch; test duplicate letter examples manually.
- Add widget/integration coverage for the full flow and test API 36, narrow devices, accessibility font scaling, and keyboard navigation.
- Verify icon and feature graphic against current Play Console image specifications, and capture real in-app screenshots.
- Replace privacy contact placeholders, check final merged manifest and dependency SDK behavior, complete Data safety/content rating, and test a Play internal track install.
