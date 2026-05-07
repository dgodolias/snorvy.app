# Play Store Release Checklist

Checked against official Google guidance on 2026-05-08.

## Build Requirements

- Package name: `app.snorvy`
- Required upload format: Android App Bundle (`.aab`)
- Current target SDK: API 36
- Signing: use Play app signing; sign the uploaded bundle with the private upload key
- Google Play target API requirement: new apps and updates must target Android 15 / API 35 or higher from 2025-08-31. Snorvy currently targets API 36.
- Source checked: https://support.google.com/googleplay/android-developer/answer/11926878

## Play Console Setup

- Create app: Snorvy
- Category: Health & Fitness
- App access: no login required
- Ads: no ads
- Content rating: complete questionnaire
- Data safety: local-only; no collection/shared data by developer
- Privacy policy URL: `https://gist.github.com/dgodolias/f02725dd83693fc2486fd44169238a04`
  - Verified 2026-05-08: HTTP 200 and contains Snorvy policy/contact text.
  - In-app policy text is available from Settings > Privacy policy.
- In-app product:
  - Product ID: `snorvy_lifetime_unlock`
  - Type: one-time product / non-consumable
  - Price: USD 9.99
  - Title: Lifetime Unlock
  - Description: Unlimited recording nights forever. No subscription.

## Permissions

Current Android permissions:

- `RECORD_AUDIO`
- `FOREGROUND_SERVICE`
- `FOREGROUND_SERVICE_MICROPHONE`
- `POST_NOTIFICATIONS`
- `WAKE_LOCK`
- `com.android.vending.BILLING`
- `ACCESS_NETWORK_STATE`
- `INTERNET`

Plugin-added legacy permissions for storage, phone state, Bluetooth, boot completed, and audio output are removed during Android manifest merge.

Before production release, verify that every permission has user-facing rationale in onboarding and Play Console. The microphone foreground service needs a clear demo video showing the persistent recording notification.

## Local Release Artifact

- Signed app bundle: `build/app/outputs/bundle/release/app-release.aab`
- Local upload key: `android/app/upload-keystore.jks`
- Signing config: `android/key.properties`
- Release build guard: `flutter build appbundle --release` fails if `android/key.properties` is missing, so a debug-signed release bundle is not produced accidentally.
- Play Store app icon: `playstore/icon-512.png`
- Phone screenshots: `playstore/screenshots/phone/*.png`
- Source brand icon: `assets/brand/snorvy-icon-1024.png`

The upload key and signing config are ignored by Git. Back them up in a secure password manager or vault before relying on this Play app signing setup.

## Remaining Before Production Track

- Back up the upload keystore and credentials outside the repo.
- Upload to internal testing first.
