# Google Play Data Safety Notes

Snorvy is designed as a local-only app. The app does not operate a backend and does not transmit sleep audio to Snorvy servers.

## Data Collection

Recommended Play Console answer for Snorvy MVP:

- Data collected: No, because Snorvy does not transmit user data off the device to the developer or a third party.
- Data shared: No, because Snorvy does not share user data with third parties.
- Data encrypted in transit: Not applicable for app data, because the MVP has no backend data transmission.
- User deletion request mechanism: Users can delete individual nights from History, delete all local sleep data from Settings, or clear app data/uninstall.

## Local Data Processed On Device

Snorvy creates and stores the following on the user's device:

- Audio files: voice or sound recordings captured after the user starts recording.
- App activity: sleep log dates, durations, snore score placeholders, and local recording metadata.
- Purchases: local lifetime-unlock entitlement state, backed by Google Play Billing restore/purchase events.

## User-Triggered Export

If a user exports or shares a recording, that action is user initiated and leaves Snorvy's local-only control. The privacy policy should state this clearly.

## Play Console Audio Classification Reference

Google's Data safety taxonomy includes "Audio files" as voice or sound recordings, and "Other audio files" as audio files created or provided by the user.
