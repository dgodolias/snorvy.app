# Snorvy Agent Handoff

Date: 2026-05-08  
Repo: `C:\Users\demosgod\Desktop\PROJECTS\simplify.app`  
Branch: `develop`  
Remote: `https://github.com/dgodolias/snorvy.app.git`  
Latest pushed implementation HEAD: `63f0beb Fail release builds without upload key`

This is operational memory for another agent. It contains concrete project state, completed work, verification evidence, product decisions, and next steps. It does not include hidden reasoning.

## User Expectations

- User speaks Greek and wants autonomous execution with minimal back-and-forth.
- End goal: make Snorvy a 100% working MVP ready to upload to Google Play Store.
- Commit and push after every logical chunk.
- Run tests and visual/functional verification after meaningful changes.
- User does not want approval prompts. Current environment supports full access/no approvals.
- User wants the `new-design/` direction applied to the real Flutter app, not left as HTML/React mockups.

## Product Decisions

- MVP is local-only: audio and sleep history stay on device.
- No login for MVP.
- Free gate is local: 7 recordings/month, with lifetime unlock through IAP.
- Do not use MAC address, IMEI, serial, or other hardware IDs for anti-abuse. For a no-login MVP, local quota reset on reinstall/clear-data is acceptable. Later path: App Set ID plus backend, or Play Integrity server-side.
- The neural layer is a tiny deterministic on-device classifier over recorder level features. It is useful for MVP signal labeling, but it is not a clinical model and should not be marketed as medically validated.

## Relevant Skills Mentioned

- `ux-designer`: requested for design/UX thinking.
- `andrej-karpathy`: requested around neural/AI thinking.
- `flutter-dart-code-review`: useful before final audit.
- `webapp-testing`: useful for Playwright/browser smoke tests.

## Recent Commits On `develop`

```text
63f0beb Fail release builds without upload key
d99792c Clarify local-only settings copy
6421c84 Add Play Store phone screenshots
ba7fc36 Update Snorvy agent handoff
1e9eaec Fix Android recording codec startup
b396ce0 Apply midnight Snorvy app design
635235b Add agent handoff notes
e11a233 Harden browser smoke verification
d617f43 Add tiny local neural sleep classifier
eadad53 added new design
56ec045 Add local sleep event detection
4667476 Add Snorvy app icon assets
```

Earlier MVP commits include foreground recording service, browser smoke verification, local data deletion, release signing, Play listing metadata, lifetime unlock/free gate, playback/export, persistence, and the initial Flutter shell.

## What Is Implemented

- Flutter app shell with Tonight, History, and Settings tabs.
- Local persistence with Drift/SQLite.
- Overnight recording flow with microphone permission.
- Android foreground service notification for active recording.
- Local audio recording, playback, export, and deletion.
- Free quota gate and lifetime unlock flow.
- Local sleep event analyzer with tiny on-device neural-style classifier.
- Manual sleep logs.
- Play Store metadata directory and Android release signing setup.
- Midnight Snorvy visual design applied to Flutter screens:
  - `lib/src/theme/snorvy_theme.dart`
  - `lib/src/features/shell/snorvy_shell.dart`
  - `lib/src/features/tonight/tonight_screen.dart`
  - `lib/src/features/history/history_screen.dart`
  - `lib/src/features/settings/settings_screen.dart`
  - `lib/src/features/unlock/unlock_sheet.dart`
- Browser smoke scripts and screenshots.
- Play Store phone screenshots under `playstore/screenshots/phone/`.
- Settings privacy rows now describe real MVP behavior instead of fake switches.
- Release builds now fail if the local upload key config is missing, preventing accidental debug-signed release bundles.
- Android native smoke verification on emulator.

## Latest Native Recorder Fix

Commit `1e9eaec` fixed Android native recorder startup:

- `lib/src/services/sleep_recorder.dart`
  - Replaced hardcoded `Codec.opusOGG`, which is not supported by the Android `flutter_sound` backend.
  - Added runtime format selection:
    - preferred `Codec.aacMP4` with `.m4a`
    - fallback `Codec.aacADTS` with `.aac`
    - fallback `Codec.pcm16WAV` with `.wav`
- `lib/src/services/audio_playback.dart`
  - Added playback mapping for `.aac`, `.m4a`, and `.mp4`.
- `lib/src/services/recording_foreground_service.dart`
  - Removed `DartPluginRegistrant.ensureInitialized()` from the background-service callback because this service does not use extra plugins in that isolate.
  - This removed the runtime warning from `flutter_background_service_android` about main-isolate-only registration.

## Verification Evidence

Latest final checks after `63f0beb` on 2026-05-08:

```text
analyze --fatal-infos: No issues found
flutter test -r expanded: 14 tests passed
flutter build web --target tool/web_smoke_main.dart: built successfully
tool/run_web_smoke.ps1 -SkipBuild: Browser smoke passed
flutter build apk --debug: built successfully
flutter build appbundle --release: built app-release.aab (46.3MB)
jarsigner -verify app-release.aab: jar verified; self-signed upload certificate warnings are expected for a Play upload key
```

Release manifest audit:

- Package: `app.snorvy`
- Target SDK: API 36
- Current Google Play target API requirement checked on 2026-05-08: API 35+ for new apps and updates from 2025-08-31.
- Runtime/user-facing permissions in the merged release manifest:
  - `RECORD_AUDIO`
  - `FOREGROUND_SERVICE`
  - `FOREGROUND_SERVICE_MICROPHONE`
  - `POST_NOTIFICATIONS`
  - `WAKE_LOCK`
  - `ACCESS_NETWORK_STATE`
  - `INTERNET`
  - `com.android.vending.BILLING`

Native Android smoke on emulator:

- Installed debug APK and cleared app data.
- Granted runtime permissions:
  - `android.permission.RECORD_AUDIO`
  - `android.permission.POST_NOTIFICATIONS`
- Launched `app.snorvy/.MainActivity`.
- Started recording by tapping the Tonight primary button.
- Verified active recording UI screenshot:
  - `build\android-final-active-recording.png`
- Verified logcat:
  - `startRecorderCompleted: true`
  - no `flutter_background_service_android` main-isolate warning
- Stopped recording.
- Verified saved recording UI screenshot:
  - `build\android-final-saved-recording.png`
- Verified saved file under app storage:
  - `app_flutter/recordings/night_1778195804291.m4a`
- Release artifact:
  - `build\app\outputs\bundle\release\app-release.aab`

Browser smoke after the design chunk passed previously with screenshots under:

```text
build\web-smoke\mobile\
build\web-smoke\tablet\
build\web-smoke\desktop\
```

## Known Tooling Notes

Direct Flutter tool invocation has been most reliable:

```powershell
$env:DART_SUPPRESS_ANALYTICS='true'
$env:FLUTTER_ALREADY_LOCKED='true'
$env:FLUTTER_ROOT='C:\flutter'
C:\flutter\bin\cache\dart-sdk\bin\dart.exe `
  --packages=C:\flutter\packages\flutter_tools\.dart_tool\package_config.json `
  C:\flutter\bin\cache\flutter_tools.snapshot `
  --suppress-analytics <flutter args>
```

ADB path:

```text
C:\Users\demosgod\AppData\Local\Android\Sdk\platform-tools\adb.exe
```

Current emulator used:

```text
emulator-5554
```

## Current Working Tree

At the time this handoff was rewritten, only documentation/checklist files are expected to be modified before committing the handoff update. Code was clean after `63f0beb`.

## Next Steps

1. Commit/push this updated `AGENT_HANDOFF.md` and `playstore/release-checklist.md`.
2. Back up `android/app/upload-keystore.jks` and `android/key.properties` outside the repo.
3. Publish the privacy policy at `https://snorvy.app/privacy`.
4. In Play Console, create product `snorvy_lifetime_unlock` before production testing purchases.
5. Upload `build\app\outputs\bundle\release\app-release.aab` to internal testing first.
