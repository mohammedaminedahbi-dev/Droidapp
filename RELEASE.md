# Android release and Google Play checklist

## Current policy baseline

As checked on 2026-11-06, Google Play requires new mobile apps and updates to target Android 16 (API level 36) or higher. This project sets `compileSdk 36` and `targetSdk 36`. Re-check the official policy and SDK release notes immediately before submission because requirements can change.

Official references:
- https://support.google.com/googleplay/android-developer/answer/11926878
- https://developer.android.com/google/play/requirements/target-sdk
- https://support.google.com/googleplay/android-developer/answer/9859152 (App Bundle guidance)
- https://support.google.com/googleplay/android-developer/answer/10787469 (Data safety)

## Create an upload key securely

Run this on your own trusted development computer. Store the keystore and passwords outside source control and back them up securely.

```bash
keytool -genkeypair -v \
  -keystore "$HOME/letterforge-upload-key.jks" \
  -keyalg RSA -keysize 4096 -validity 10000 \
  -alias letterforge-upload
```

Create `android/key.properties` (this file must not be committed):

```properties
storePassword=REPLACE_WITH_YOUR_KEYSTORE_PASSWORD
keyPassword=REPLACE_WITH_YOUR_KEY_PASSWORD
keyAlias=letterforge-upload
storeFile=/absolute/path/to/letterforge-upload-key.jks
```

Add these entries to `.gitignore` before entering any secrets:

```gitignore
android/key.properties
*.jks
*.keystore
```

Then update `android/app/build.gradle` to load the file and use a release signing config. Example Kotlin-free Groovy configuration to add before `android {}`:

```groovy
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}
```

Inside `android {}`, add a `signingConfigs` section and change `buildTypes.release.signingConfig`:

```groovy
signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile file(keystoreProperties['storeFile'])
        storePassword keystoreProperties['storePassword']
    }
}
buildTypes {
    release {
        signingConfig signingConfigs.release
        minifyEnabled false
        shrinkResources false
    }
}
```

Do not check in `key.properties` or the keystore. If an upload key is lost or exposed, follow current Play Console key-reset guidance.

## Final build commands

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
flutter build apk --release
flutter build appbundle --release
```

Install the debug/release APK on real Android devices and exercise every screen before submitting. Keep the generated `.aab` and upload key private.

## Required pre-submission QA

- [ ] Run `flutter analyze` and resolve all errors and relevant warnings.
- [ ] Run unit tests; add widget and integration tests for navigation, keyboard input, hints, extra attempts, level unlock, persistence, and settings.
- [ ] Test API 23 minimum and current Android 16 / API 36 on real devices or emulators, plus narrow and large screens, font scaling, keyboard, background/restore, and process death.
- [ ] Verify level answers are unique for the intended 120-level campaign and check every answer/guess for spelling and suitability.
- [ ] Test duplicate letters, keyboard color precedence, hints/coin deductions, extra attempt caps, and replaying completed levels.
- [ ] Review contrast and touch targets with accessibility tools; confirm all animation, haptic and sound preferences work as described.
- [ ] Confirm no permissions or network libraries were added unintentionally.
- [ ] Replace this template's privacy contact details if applicable and review policy text against the actual built package.
- [ ] Complete Data safety accurately for the actual release binaries; do not claim zero data collection if SDKs are added.
- [ ] Complete content rating questionnaire, app access instructions (not needed for this offline app), target audience declaration, ads declaration, app category, contact details, store listing, and app signing in Play Console.
- [ ] Upload the AAB to an internal testing track, install from Play, review pre-launch report, and resolve issues before production rollout.

## Store listing draft

**App name:** LetterForge: Word Puzzle

**Short description (under 80 characters):** Forge your word skills with 120+ offline five-letter puzzles.

**Full description:**

Train your vocabulary one five-letter mystery at a time in LetterForge, a calm, colorful word puzzle built for quick daily breaks or longer brain-training sessions.

• Solve five-letter words with familiar green, yellow and grey feedback.
• Progress through 120 levels with a gradually tougher challenge.
• Use hints when you need a nudge, or spend coins to earn an extra guess.
• Track wins, streaks, average guesses and completed levels.
• Play offline—no account or connection required for core gameplay.
• Choose haptic feedback and sound preferences in settings.

Every guess helps you get closer. Think sharp, play kind, and forge your next streak.

**Ads / purchases:** The included source does not implement ads or purchases. Keep Play Console declarations consistent with the actual submitted build.

## Listing graphics

- `assets/letterforge_icon.svg` and Android mipmap PNGs: original icon artwork.
- `assets/feature_graphic.png` (1024×500): feature graphic draft.
- Actual in-app screenshots must be captured from the final running app on target devices. The current environment had no emulator, so no genuine gameplay screenshots or verified Play listing screenshots are included.

## Privacy and Data safety draft

For the current source configuration only: gameplay is offline, local progress/preferences are stored on-device, and no ads/analytics SDK or INTERNET permission is included. This suggests no user data is collected or shared by this build, but the publisher must inspect the final binary, SDK list, and current Play form before answering. The in-app privacy text is a template, not legal advice. Add a real publisher contact and host a public privacy policy URL before release if required by Play or applicable law.

## Permissions declaration

The current Android manifest declares no permissions. Recheck the merged manifest after every dependency change. If any future SDK adds permissions, document why they are needed and update the Play Console declarations.

## Release status

Not compiled, device-tested, signed with a production upload key, uploaded, published, or approved in this environment. These are explicit remaining steps, not implied accomplishments.
