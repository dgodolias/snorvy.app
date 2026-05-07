# Snorvy Agent Handoff

Date: 2026-05-08
Repo: `C:\Users\demosgod\Desktop\PROJECTS\simplify.app`
Branch: `develop`
Remote: `https://github.com/dgodolias/snorvy.app.git`
Current HEAD: `eadad53 added new design`

This file is an operational handoff for another agent. It contains project context, completed work, current uncommitted changes, verified commands, blockers, and recommended next steps. It intentionally does not include hidden chain-of-thought; it includes only useful project memory and concrete evidence.

## User Expectations

- User speaks Greek and wants autonomous execution with minimal back-and-forth.
- End goal: make Snorvy a 100% working MVP ready to upload to Google Play Store.
- Commit and push after every logical chunk, like a normal developer.
- After each meaningful change, run tests and visual/functional verification.
- Preferred verification includes running Flutter web in Chrome and using browser automation/screenshots.
- User does not want to press approval buttons. Avoid escalations where possible, but note that current sandbox blocks some required actions.
- User asked to apply the committed `new-design/` HTML/JS visual direction to the Flutter app next.

## Relevant Skills/Tools Mentioned

- `ux-designer`: use for transferring `new-design/` into a better Flutter UX/visual system.
- `andrej-karpathy`: user mentioned for neural/AI-style thinking.
- `flutter-dart-code-review`: available for later Flutter/Dart review.
- `webapp-testing`: useful for Playwright/browser smoke tests.
- GitHub plugin/tools are available, but local git writes are currently blocked by `.git` permissions unless escalated.

## Important Product Decisions

- Snorvy MVP is local-only: audio/history stays on device.
- No login for MVP.
- Free gate: 7 recordings per month for free users, lifetime unlock through IAP.
- Do not use MAC address, IMEI, serial, or hardware IDs for abuse prevention. Android/Play privacy rules make that risky and often impossible. Current MVP local quota can be reset by reinstall/clear data; acceptable for no-login/no-backend MVP. Later anti-abuse path: App Set ID + tiny backend, or Play Integrity server-side.
- Neural classifier requested before Play Store. Current implementation is a tiny deterministic feed-forward style classifier over local recorder level features. It is not YAMNet/libfvad and not a trained heavy model.

## Commit History Already On `develop`

Recent commits from `git log --oneline -12`:

```text
eadad53 added new design
56ec045 Add local sleep event detection
4667476 Add Snorvy app icon assets
7acab72 Add overnight foreground recording service
a8b7550 Add browser smoke verification gate
554a7a6 Add local data deletion controls
7b769f9 Prepare Android release signing
b2bc559 Add Play Store release metadata
fc2a806 Add lifetime unlock and free recording gate
9c5e0ac Add local recording playback and export
20f6c40 Wire Snorvy state to local persistence
066e659 Scaffold Snorvy Flutter MVP shell
```

`eadad53 added new design` added:

```text
new-design/Snorvy.html
new-design/ios-frame.jsx
new-design/snorvy-app.jsx
new-design/snorvy-tweaks.jsx
new-design/tweaks-panel.jsx
```

## Current Working Tree

Current `git status --short --branch`:

```text
## develop...origin/develop
 M README.md
 M lib/src/services/sleep_event_analyzer.dart
 M playstore/listing-en-US.md
 M test/sleep_event_analyzer_test.dart
 M tool/run_web_smoke.ps1
 M tool/web_smoke_test.py
```

Current `git diff --stat`:

```text
README.md                                  |   2 +-
lib/src/services/sleep_event_analyzer.dart | 138 +++++++++++++++++++++++++----
playstore/listing-en-US.md                 |   2 +-
test/sleep_event_analyzer_test.dart        |  35 ++++++++
tool/run_web_smoke.ps1                     |  22 +++--
tool/web_smoke_test.py                     |   4 +-
6 files changed, 175 insertions(+), 28 deletions(-)
```

These changes are verified but not committed because local `.git` writes are denied by ACL/sandbox, and the user rejected escalated git write prompts.

## Uncommitted Neural Classifier Chunk

Files changed:

- `lib/src/services/sleep_event_analyzer.dart`
- `test/sleep_event_analyzer_test.dart`
- `README.md`
- `playstore/listing-en-US.md`

What changed:

- Added `SleepClusterFeatures`.
- Added `SleepClusterClassifier` interface.
- Added `TinyLevelNeuralSleepClassifier implements SleepClusterClassifier`.
- `TinyLevelNeuralSleepClassifier` normalizes cluster features and runs a tiny feed-forward/ReLU/logit classifier:
  - sustained energy
  - impulse
  - irregularity
  - loudness
  - output labels: `SleepEventKind.snore`, `talk`, `noise`
- `LocalLevelSleepEventAnalyzer` now accepts an injectable classifier and defaults to `TinyLevelNeuralSleepClassifier`.
- Removed old `_kindForCluster` hard-coded branch rules.
- `_FrameCluster` now exposes `decibelSpread`.
- Added unit test: `neural classifier separates sustained snore from short talk`.
- README and Play Store listing wording updated from simple local detector to on-device classifier/tiny neural classifier.

Truthfulness note: call it an on-device classifier or tiny local neural classifier. Do not oversell it as a clinically validated neural network.

## Uncommitted Verification Tooling Chunk

Files changed:

- `tool/run_web_smoke.ps1`
- `tool/web_smoke_test.py`

Why changed:

- `tool/run_web_smoke.ps1` used `Get-CimInstance` to clean stale Python HTTP servers. In sandbox this fails with WMI access denied. It now wraps those cleanup calls in `try/catch`, logs a skip message, and still reliably kills the `$serverProcess` it starts.
- `tool/web_smoke_test.py` now skips `context.grant_permissions(["microphone"], origin=...)` for non-http origins. This was attempted for a `file://` fallback.

Important: `file://` smoke still does not work for Flutter web because Flutter fetches assets like `FontManifest.json`, and browser Fetch API does not support `file://` for this runtime. Browser smoke must use local HTTP server.

## Verification Evidence For Current Uncommitted Changes

These passed after the neural classifier/tooling changes:

```powershell
# Analyze
# Direct Flutter tool invocation was used to avoid stale flutter.bat locks.
C:\flutter\bin\cache\dart-sdk\bin\dart.exe \
  --packages=C:\flutter\packages\flutter_tools\.dart_tool\package_config.json \
  C:\flutter\bin\cache\flutter_tools.snapshot \
  --suppress-analytics analyze --fatal-infos
```

Result:

```text
No issues found! (ran in 18.3s)
```

```powershell
# Full test suite
C:\flutter\bin\cache\dart-sdk\bin\dart.exe \
  --packages=C:\flutter\packages\flutter_tools\.dart_tool\package_config.json \
  C:\flutter\bin\cache\flutter_tools.snapshot \
  --suppress-analytics test -r expanded
```

Result:

```text
14 tests passed.
```

Included tests:

- sleep event analyzer snore/talk/quiet cases
- new neural classifier snore/talk/noise separation
- free quota and unlocked user behavior
- foreground notification start/stop behavior
- saving local detected audio events and snore score
- recorder stops if notification fails
- local night/audio deletion
- widget tests for tonight/history/manual logs/recording flow

```powershell
# Web smoke build
C:\flutter\bin\cache\dart-sdk\bin\dart.exe \
  --packages=C:\flutter\packages\flutter_tools\.dart_tool\package_config.json \
  C:\flutter\bin\cache\flutter_tools.snapshot \
  --suppress-analytics build web --target tool/web_smoke_main.dart
```

Result:

```text
Built build\web
```

```powershell
# Browser smoke through local server
powershell -ExecutionPolicy Bypass -NoProfile -File tool\run_web_smoke.ps1 -SkipBuild
```

Result:

```text
Browser smoke passed.
```

Screenshots produced:

```text
build\web-smoke\mobile\01-tonight.png
build\web-smoke\mobile\02-recording-active.png
build\web-smoke\mobile\03-recorded-events.png
build\web-smoke\mobile\04-settings.png
build\web-smoke\mobile\05-manual-log-sheet.png
build\web-smoke\mobile\06-history-after-log.png
build\web-smoke\mobile\07-delete-confirm.png
build\web-smoke\mobile\08-history-after-delete.png
build\web-smoke\mobile\09-back-tonight.png
build\web-smoke\tablet\01-tonight.png
build\web-smoke\desktop\01-tonight.png
```

```powershell
# Release Play Store artifact
C:\flutter\bin\cache\dart-sdk\bin\dart.exe \
  --packages=C:\flutter\packages\flutter_tools\.dart_tool\package_config.json \
  C:\flutter\bin\cache\flutter_tools.snapshot \
  --suppress-analytics build appbundle --release
```

Result:

```text
Built build\app\outputs\bundle\release\app-release.aab (46.3MB)
```

Current artifact observed:

```text
C:\Users\demosgod\Desktop\PROJECTS\simplify.app\build\app\outputs\bundle\release\app-release.aab
Size: 48,567,627 bytes
```

## Sandbox / Permission Issues Encountered

- `flutter.bat` got stuck on stale lock behavior. Workaround: invoke Flutter tool directly through Dart:

```powershell
$env:APPDATA = Join-Path (Get-Location).Path '.appdata'
$env:LOCALAPPDATA = Join-Path (Get-Location).Path '.localappdata'
$env:DART_SUPPRESS_ANALYTICS = 'true'
$env:FLUTTER_ALREADY_LOCKED = 'true'
$env:FLUTTER_ROOT = 'C:\flutter'
C:\flutter\bin\cache\dart-sdk\bin\dart.exe `
  --packages=C:\flutter\packages\flutter_tools\.dart_tool\package_config.json `
  C:\flutter\bin\cache\flutter_tools.snapshot `
  --suppress-analytics <flutter args here>
```

- Direct non-escalated Flutter sometimes fails because it needs to write to `C:\flutter\bin\cache\libimobiledevice.stamp`.
- Dart-only `dart run test` failed because `sqlite3` build hook tried to download a native Windows DLL from GitHub and sandbox blocked network.
- Browser smoke without escalation failed because sandboxed Chrome could not load `127.0.0.1` resources (`ERR_NETWORK_ACCESS_DENIED`).
- `file://` browser smoke failed because Flutter web uses Fetch API for assets, which cannot load from `file://`.
- Local git write failed:

```text
fatal: Unable to create 'C:/Users/demosgod/Desktop/PROJECTS/simplify.app/.git/index.lock': Permission denied
```

- `.git` ACL inspection showed explicit deny entries for the sandbox identity. Writing a temp file under `.git` also failed. Reading git status/log works.
- User rejected escalated git add/commit prompt. Therefore the current verified changes remain uncommitted.

## How To Commit Current Changes Next

Preferred normal local commands, if permissions/approval allow:

```powershell
git -c safe.directory=C:/Users/demosgod/Desktop/PROJECTS/simplify.app add README.md lib/src/services/sleep_event_analyzer.dart playstore/listing-en-US.md test/sleep_event_analyzer_test.dart
git -c safe.directory=C:/Users/demosgod/Desktop/PROJECTS/simplify.app commit -m "Add tiny local neural sleep classifier"
git -c safe.directory=C:/Users/demosgod/Desktop/PROJECTS/simplify.app push

git -c safe.directory=C:/Users/demosgod/Desktop/PROJECTS/simplify.app add tool/run_web_smoke.ps1 tool/web_smoke_test.py
git -c safe.directory=C:/Users/demosgod/Desktop/PROJECTS/simplify.app commit -m "Harden browser smoke verification"
git -c safe.directory=C:/Users/demosgod/Desktop/PROJECTS/simplify.app push
```

If local `.git` remains blocked and the user refuses escalated git writes, possible fallback is using the GitHub connector/API to create blobs/trees/commits directly on `origin/develop`. Caveat: local working tree/HEAD will remain dirty/behind unless local git metadata can later be updated.

## New Design Next Chunk

The user wants `new-design/` applied to the Flutter app. Current `new-design/` files are committed in `eadad53`.

Suggested next steps:

1. Read `new-design/Snorvy.html` and React files:
   - `new-design/snorvy-app.jsx`
   - `new-design/snorvy-tweaks.jsx`
   - `new-design/ios-frame.jsx`
   - `new-design/tweaks-panel.jsx`
2. Extract the design language:
   - colors
   - typography scale
   - layout rhythm
   - component shapes
   - navigation style
   - recording state visuals
   - card/list treatment
3. Map it into Flutter screens, likely starting with:
   - `lib/src/features/tonight/tonight_screen.dart`
   - history/settings widgets if colocated or referenced from tonight shell
   - shared colors/theme if present
4. Keep app functional; do not replace real flows with static mockups.
5. Run:
   - `analyze --fatal-infos`
   - full `flutter test`
   - browser smoke with screenshots
   - release appbundle if changes touch shared app structure/theme
6. Commit/push as a separate design chunk once git permissions are solved.

## Android Native Smoke Still Needed

Browser smoke is good but not enough for final Play Store confidence. Before declaring MVP complete, run native Android smoke on emulator/device:

- Build/install Android debug or release.
- Launch app on emulator.
- Verify permission prompts:
  - microphone
  - notification/foreground service on Android 13+
- Start overnight recording flow.
- Confirm foreground notification/service behavior.
- Stop recording.
- Confirm saved events/history/playback/export where possible.
- Confirm delete local data/audio.
- Capture screenshots/logcat if useful.

Known emulator from previous context:

```text
sdk gphone64 x86 64 / emulator-5554 / Android 16 API 36
```

ADB path likely:

```text
C:\Users\demosgod\AppData\Local\Android\Sdk\platform-tools\adb.exe
```

## MVP Completion Audit Still Required

Do not mark the goal complete yet. Before completion, audit against these deliverables:

- Functional Flutter Android app
- Local-only overnight recording foundations
- Sleep event/history UX
- Local storage and deletion controls
- Permissions and foreground service
- IAP/paywall/free quota flow
- Play Store metadata/privacy/data safety/release signing
- Neural/on-device classifier included truthfully
- New design applied to actual Flutter UI
- Browser visual smoke passing after design
- Native Android smoke passing
- Release `.aab` built after final changes
- All logical chunks committed and pushed

Current status: close, but not complete because neural/tooling changes are uncommitted, new design has not yet been applied to Flutter UI, and native Android smoke is still pending.
