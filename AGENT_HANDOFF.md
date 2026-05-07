# Snorvy Agent Handoff

Date: 2026-05-08  
Repo: `C:\Users\demosgod\Desktop\PROJECTS\simplify.app`  
Branch: `develop`  
Remote: `https://github.com/dgodolias/snorvy.app.git`  
Current HEAD: `1e9eaec Fix Android recording codec startup`

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

Latest checks after `1e9eaec`:

```text
analyze --fatal-infos: No issues found
flutter test -r expanded: 14 tests passed
flutter build apk --debug: built successfully
flutter build appbundle --release: built app-release.aab (46.4MB)
```

Native Android smoke on emulator:

- Installed debug APK.
- Cleared app data.
- Granted:
  - `android.permission.RECORD_AUDIO`
  - `android.permission.POST_NOTIFICATIONS`
- Launched `app.snorvy/.MainActivity`.
- Started recording by tapping the Tonight primary button.
- Verified active recording UI screenshot:
  - `build\android-smoke-after-start-clean-service.png`
- Verified logcat:
  - `startRecorderCompleted: true`
  - foreground service allowed by Android
  - no `flutter_background_service_android` main-isolate warning
- Stopped recording.
- Verified saved recording UI screenshot:
  - `build\android-smoke-after-stop-clean-service.png`
- Verified saved file under app storage:
  - `app_flutter/recordings/night_1778194874103.m4a`
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

At the time this handoff was rewritten, only this file is expected to be modified before committing the handoff update. Code was clean after `1e9eaec`.

## Next Steps

1. Commit/push this updated `AGENT_HANDOFF.md`.
2. Do a final MVP audit against Play Store readiness:
   - Android package/signing/versioning
   - permissions and foreground-service declaration
   - privacy/data safety wording
   - Play listing metadata/screenshots
   - IAP product ID and fallback behavior
   - local deletion/export/playback flows
3. Run one final full verification pass:
   - analyze
   - full tests
   - browser smoke
   - native Android smoke
   - release appbundle
4. If any final Play Store blockers are found, fix them in small chunks and commit/push each chunk.
5. Do not mark the goal complete until the final audit and artifact are clean.
