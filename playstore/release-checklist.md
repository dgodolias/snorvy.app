# Play Store Release Checklist

Checked against official Google guidance on 2026-05-07.

## Build Requirements

- Package name: `app.snorvy`
- Required upload format: Android App Bundle (`.aab`)
- Current target SDK: API 36
- Signing: use Play app signing; sign the uploaded bundle with the private upload key

## Play Console Setup

- Create app: Snorvy
- Category: Health & Fitness
- App access: no login required
- Ads: no ads
- Content rating: complete questionnaire
- Data safety: local-only; no collection/shared data by developer
- Privacy policy URL: publish `legal/privacy-policy.md` to `https://snorvy.app/privacy`
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

Before production release, verify that every permission has user-facing rationale in onboarding and Play Console. The microphone foreground service needs a clear demo video and persistent notification behavior.

## Local Release Artifact

- Signed app bundle: `build/app/outputs/bundle/release/app-release.aab`
- Local upload key: `android/app/upload-keystore.jks`
- Signing config: `android/key.properties`

The upload key and signing config are ignored by Git. Back them up in a secure password manager or vault before relying on this Play app signing setup.

## Remaining Before Production Track

- Add persistent foreground notification for overnight recording.
- Add real app icon and Play Store 512x512 icon.
- Back up the upload keystore and credentials outside the repo.
- Upload to internal testing first.
