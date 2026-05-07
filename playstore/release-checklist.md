# Play Store Release Checklist

Checked against official Google guidance on 2026-05-07.

## Build Requirements

- Package name: `app.snorvy`
- Required upload format: Android App Bundle (`.aab`)
- Target SDK: Android 15 / API 35 or higher for new apps and updates
- Signing: use Play app signing; sign the uploaded bundle with a private upload key

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
- `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS`
- `WAKE_LOCK`

Before production release, verify that every permission has user-facing rationale in onboarding and Play Console. The microphone foreground service needs a clear demo video and persistent notification behavior.

## Remaining Before Production Track

- Add persistent foreground notification for overnight recording.
- Add in-app delete controls for recordings/history.
- Add real app icon and Play Store 512x512 icon.
- Generate and safely store upload keystore.
- Build signed `.aab`.
- Upload to internal testing first.

