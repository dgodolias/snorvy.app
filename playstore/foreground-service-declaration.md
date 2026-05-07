# Foreground Service Declaration Draft

Snorvy declares microphone foreground service capability because overnight recording is the core user-facing feature of the app.

## Foreground Service Type

- Type: `microphone`
- Manifest permission: `android.permission.FOREGROUND_SERVICE_MICROPHONE`
- Base permission: `android.permission.FOREGROUND_SERVICE`

## Play Console Description

Snorvy uses a microphone foreground service only after the user explicitly starts an overnight sleep recording. The service records audio locally on the device so the user can listen back to snoring or sleep talk events. The user can stop the recording from inside the app. The feature cannot be deferred without breaking the app's core purpose because the user expects the phone to keep recording while they sleep.

## User Benefit

- Lets users capture snoring and sleep talk overnight.
- Keeps audio local on the user's phone.
- Avoids cloud upload and account sign-in.

## User Visibility

For production submission, the recording service must show a persistent Android notification while recording and provide a stop action or clear in-app stop path.

## Demo Video Script

1. Open Snorvy.
2. Tap "Start local recording".
3. Show Android notification or visible recording state.
4. Tap "Stop recording".
5. Open History.
6. Play the saved recording.

## Policy Notes

Google Play requires Android 14+ apps using foreground services to declare valid FGS types in the manifest and Play Console, explain user impact, and provide a demo video when requested.

