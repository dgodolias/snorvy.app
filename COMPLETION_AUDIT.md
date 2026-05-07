# Snorvy MVP Completion Audit

Date: 2026-05-08  
Branch: `develop`  
Objective: build Snorvy into a working Flutter Android MVP ready to upload to Google Play Store.

## Success Criteria

- Functional Flutter Android app with Tonight, History, and Settings surfaces.
- Local-only overnight recording foundations: microphone recording, foreground service, local file storage, playback/export, and deletion.
- Sleep event/history UX: persisted nights, snore/talk/noise event analysis, history view, manual log flow.
- Purchase/paywall flow: free monthly quota, lifetime unlock UI, Google Play Billing product id, restore/purchase plumbing.
- Play Store readiness: signed Android App Bundle, app id/version/target SDK, minimal permissions, privacy/data-safety/foreground-service docs, screenshots and icon.
- Verification: analyzer, unit/widget tests, browser smoke, Android smoke, release build/signature/manifest checks.
- Developer workflow: logical chunks committed and pushed.

## Prompt-To-Artifact Checklist

| Requirement | Evidence | Status |
| --- | --- | --- |
| Flutter app shell and UX | `lib/src/app/snorvy_app.dart`, `lib/src/features/shell/snorvy_shell.dart`, `lib/src/features/tonight/tonight_screen.dart`, `lib/src/features/history/history_screen.dart`, `lib/src/features/settings/settings_screen.dart` | Pass |
| New visual design applied to Flutter app | `lib/src/theme/snorvy_theme.dart`; browser screenshot `build/web-smoke/mobile/04-settings.png`; Android screenshot `playstore/screenshots/phone/03-settings.png` | Pass |
| Local microphone recording | `lib/src/services/sleep_recorder.dart` uses Android-safe `.m4a`/`.aac`/`.wav` codec fallback | Pass |
| Overnight foreground recording service | `lib/src/services/recording_foreground_service.dart`; manifest service has `android:foregroundServiceType="microphone"` | Pass |
| Local persistence/storage | `lib/src/data/app_database.dart`; tests cover saved nights/events/deletion | Pass |
| Playback/export | `lib/src/services/audio_playback.dart`, `lib/src/services/recording_exporter.dart`; UI exposes Play/Export | Pass |
| Sleep event analyzer and neural classifier | `lib/src/services/sleep_event_analyzer.dart`; `test/sleep_event_analyzer_test.dart` covers snore, talk, quiet, and neural classifier separation | Pass |
| History and manual logs | `lib/src/features/history/history_screen.dart`; `test/widget_test.dart` covers manual log persistence and deletion | Pass |
| Data deletion | `lib/src/app/snorvy_controller.dart` has `deleteNight` and `deleteAllSleepData`; Settings exposes delete-all control | Pass |
| No login / local-only promise | Settings shows local-only/no-cloud rows and an in-app privacy policy dialog; privacy text says no backend account/cloud sync | Pass |
| In-app privacy policy | `lib/src/features/settings/settings_screen.dart` has `Privacy policy` row and full policy dialog; widget test opens it | Pass |
| Public Play privacy policy URL | Public gist: `https://gist.github.com/dgodolias/f02725dd83693fc2486fd44169238a04`; verified HTTP 200 and policy/contact text on 2026-05-08 | Pass |
| Purchase/paywall flow | `lib/src/services/unlock_repository.dart` uses product id `snorvy_lifetime_unlock`; `lib/src/features/unlock/unlock_sheet.dart`; controller tests cover quota/unlocked behavior | Pass |
| Anti-abuse for free quota without login | Implemented as local monthly quota; no MAC/IMEI/hardware IDs used | Pass |
| Android package id | Release packaged manifest has `package="app.snorvy"` | Pass |
| Google Play target SDK | Release packaged manifest has `android:targetSdkVersion="36"`; official Play requirement checked: API 35+ for new apps/updates from 2025-08-31 | Pass |
| Release signing | `android/app/build.gradle.kts` requires `android/key.properties` for release builds and signs with release config; `jarsigner -verify` returned `jar verified` | Pass |
| Release artifact | `build/app/outputs/bundle/release/app-release.aab`, 46.3 MB, rebuilt 2026-05-08 01:28 local time | Pass |
| Play Store icon/screenshots | `playstore/icon-512.png` is 512x512; `playstore/screenshots/phone/*.png` are 1080x2400 | Pass |
| Play metadata/docs | `playstore/release-checklist.md`, `playstore/data-safety.md`, `playstore/foreground-service-declaration.md`, `legal/privacy-policy.md` | Pass |
| Commit/push cadence | Recent pushed commits include `d617f43`, `e11a233`, `b396ce0`, `1e9eaec`, `6421c84`, `d99792c`, `63f0beb`, `e61ee6d` | Pass |

## Verification Commands

Latest current-state verification after the in-app privacy policy fix:

```text
flutter analyze --fatal-infos
Result: No issues found

flutter test -r expanded
Result: 15/15 tests passed

flutter build web --target tool/web_smoke_main.dart
Result: Built build/web

tool/run_web_smoke.ps1 -SkipBuild
Result: Browser smoke passed

flutter build apk --debug
Result: Built build/app/outputs/flutter-apk/app-debug.apk

flutter build appbundle --release
Result: Built build/app/outputs/bundle/release/app-release.aab (46.3MB)

jarsigner -verify -certs build/app/outputs/bundle/release/app-release.aab
Result: jar verified
```

Android emulator checks:

```text
Settings screen visible with Privacy policy row: true
Privacy dialog visible: true
Privacy dialog contains local-only text: true
Privacy dialog contains support@snorvy.app: true
Prior native recording smoke: start/stop recording saved local .m4a and showed Play/Export UI
```

## External Operator Steps

These are not implementation blockers; they are Play Console/account operations required to actually publish or test purchases:

- Back up `android/app/upload-keystore.jks` and `android/key.properties` outside the repo.
- Upload `build/app/outputs/bundle/release/app-release.aab` to Play Console internal testing.
- Create/activate Play product `snorvy_lifetime_unlock` in Play Console before testing real purchases.
- Use the public privacy policy URL in Play Console: `https://gist.github.com/dgodolias/f02725dd83693fc2486fd44169238a04`.

## Completion Decision

The app implementation, local release artifact, metadata package, privacy policy URL, and verification gates are complete for a Google Play internal-test upload. No repo-side or local-build blocker remains.
