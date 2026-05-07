# D8 Snorvey — Competitor Feature Matrix (2026-05-07)

**Subject app:** Snorvey — sleep recorder / snore tracker. Greek solo dev, $9.99 one-time-pay anti-subscription, Android + iOS.
**Method:** Live `google-play-scraper` v10.1.2 metadata pulls (2026-05-07) + official feature pages + 1,900 review dump (existing `findings/raw/play-store/d8_*.json`).
**Apps audited:**

| # | App | Play Store appId | Installs | Rating | Reviews (US Play) | Genre |
|---|---|---|---:|---:|---:|---|
| 1 | Sleep Cycle: Sleep Tracker | com.northcube.sleepcycle | 10M+ | 4.33 | 215,876 | Health & Fitness |
| 2 | ShutEye®: Sleep Tracker | health.sleep.sounds.tracker.alarm.calm | 10M+ | 4.42 | 107,013 | Health & Fitness |
| 3 | Sleep as Android: Smart alarm | com.urbandroid.sleep | 10M+ | 4.60 | 389,940 | Lifestyle |
| 4 | SnoreLab: Record Your Snoring | com.snorelab.app | 5M+ | 4.49 | 51,604 | Health & Fitness |
| 5 | Pillow: Sleep Tracker | (iOS only — id878691772, Neybox Digital Ltd) | iOS-exclusive | n/a | n/a | Health & Fitness |

> Pillow has NO Android version. The Play Store result `com.asanarebel.pillowpath` is an unrelated app from Asana Rebel. Pillow data below comes from pillow.app + App Store listing only.

---

## Core Recording Features

| Feature | Sleep Cycle | ShutEye | Sleep as Android | SnoreLab | Pillow | Snorvey MVP claim |
|---|---|---|---|---|---|---|
| Sleep audio recording (mic) | ✅ premium | ✅ premium | ✅ free + Unlock | ✅ free + premium | ✅ premium | ✅ free |
| Snore detection | ✅ premium | ✅ premium | ✅ AI sound recognition (premium) | ✅ core feature, free | ✅ premium | ✅ free |
| Snore audio playback per-event | ✅ premium | ✅ premium | ✅ premium | ✅ premium (full session free, highlights gated) | ✅ premium | ✅ free |
| Sleep stage detection (light/deep/REM) | ✅ accelerometer-based | ✅ 5-stage | ✅ via wearables / sonar | ❌ (snore-only focus) | ✅ accelerometer + Apple Watch | ❌ deliberate omission |
| Smart alarm (light-sleep wake window) | ✅ free | ✅ free | ✅ free | ❌ | ✅ premium | ❌ deliberate omission |
| Sonar / contactless tracking | ❌ | ❌ | ✅ unique to SaA | ❌ | ❌ | ❌ |
| Apple Watch / Wear OS integration | ✅ Apple Watch (premium) | ✅ Apple Watch | ✅ Pixel/Galaxy/Wear OS/Garmin/Fitbit | ❌ | ✅ Apple Watch (auto-track) | ❌ |
| Sleep talk / cough / sneeze detection | ✅ premium | ✅ talking, cough, sleepwalking | ✅ AI sound recognition | ❌ snore-only | ✅ audio events | ? (could add later) |
| Anti-snore intervention (vibration / tongue-click) | ❌ | ❌ | ✅ unique — vibrate / sound / smartlight | ❌ | ❌ | ❌ |
| Breathing rate / SpO2 / HRV | ✅ premium (Apple Watch 8+) | ❌ | ✅ Sleep Score includes SpO2/HRV/breath | ✅ "BreathFlow" (iOS-first, premium) | ✅ via Apple Watch | ❌ |
| Works with phone on nightstand (no wearable) | ✅ | ✅ | ✅ (sonar option) | ✅ | ❌ (Apple Watch needed for auto-track) | ✅ |
| Offline / no-account recording | ❌ login required | ❌ login required | ✅ works fully offline | ✅ no signup | ❌ | ✅ design goal |

## Insights / Reporting

| Feature | Sleep Cycle | ShutEye | Sleep as Android | SnoreLab | Pillow | Snorvey MVP claim |
|---|---|---|---|---|---|---|
| Per-night sleep score | ✅ free | ✅ free (limited) | ✅ free | ✅ "Snore Score" free | ✅ free | ✅ basic stats free |
| Trends > 7 days (history graph) | ✅ premium | ✅ premium | ✅ free | ✅ premium ("unlimited history") | ✅ premium | ✅ free (full local history) |
| Long-term snoring intensity trend | ✅ premium | ✅ premium | ✅ premium | ✅ premium "Trends Area" | ✅ premium | ✅ free |
| Personalized tips / sleep coach | ✅ premium | ✅ premium ("VIP") | ✅ free "Advice" + AI assistant | ✅ "Solutions/remedy" library | ✅ premium ("Snooze Lab") | ❌ deliberate (no coaching) |
| Sleep apnea risk assessment | ❌ | ✅ premium | ❌ (breathing alarm only) | ❌ (only "useful in consultation") | ❌ | ❌ (avoid medical liability) |
| Insomnia risk evaluation | ❌ | ✅ premium | ❌ | ❌ | ❌ | ❌ |
| Apple Health / Google Fit sync | ✅ | ✅ | ✅ Google Fit, Samsung Health | ✅ Apple Health (iOS) | ✅ Apple Health | ? (defer) |
| Audio export / share | ✅ (clip share) | ✅ premium | ✅ premium | ✅ premium ("data export") | ✅ premium | ✅ free MP3 export (wedge) |
| Dream journal / dream interpretation | ❌ | ✅ free + premium articles | ✅ "Lucid dreaming" feature | ❌ | ❌ | ❌ deliberate (bloat) |
| Remedy / lifestyle factor logging | ✅ tags (free) | ✅ tags | ✅ Tags | ✅ "Remedy testing" core | ✅ tags (premium) | ✅ simple tags (free) |

## Sleep Aid / Sounds (the "bloat creep")

| Feature | Sleep Cycle | ShutEye | Sleep as Android | SnoreLab | Pillow | Snorvey MVP claim |
|---|---|---|---|---|---|---|
| White noise / nature sounds | ✅ premium ("Sleep Aid") | ✅ free + premium | ✅ Unlock unlocks more lullabies | ❌ | ❌ | ❌ deliberate |
| Guided meditations / stories | ✅ premium | ✅ premium ("guided meditation") | ❌ | ❌ | ❌ | ❌ deliberate |
| Spotify integration as alarm | ❌ | ❌ | ✅ Spotify songs/playlists | ❌ | ❌ | ❌ |
| Smart-home (Hue / HomeKit) | ✅ premium | ❌ | ✅ Smartlight on snore | ❌ | ❌ | ❌ |
| CAPTCHA wake-up (math, QR, NFC) | ❌ | ❌ | ✅ unique | ❌ | ❌ | ❌ |
| Sunrise alarm | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ |

## Premium / Paywall Features (what is locked)

| Locked behind paywall | Sleep Cycle | ShutEye | Sleep as Android | SnoreLab | Pillow |
|---|---|---|---|---|---|
| Snore audio playback / saving | ✅ paywall | ✅ paywall | ✅ paywall (after 14-day trial) | ✅ paywall (highlights) | ✅ paywall |
| Trends > 7 days | ✅ paywall | ✅ paywall | ❌ free | ✅ paywall ("unlimited history") | ✅ paywall |
| Sleep Aid sounds / meditations | ✅ paywall | ✅ paywall | ✅ extra lullabies paywall | n/a | n/a |
| Apple-Watch heart-rate / SpO2 | ✅ paywall | n/a | ✅ paywall | n/a | ✅ paywall |
| BreathFlow / breathing analysis | n/a | ❌ | ✅ paywall (low-breath alarm) | ✅ paywall | n/a |
| Sleep apnea / insomnia risk | n/a | ✅ paywall | n/a | n/a | n/a |
| Cloud backup / data export | ✅ paywall | ✅ paywall | ✅ paywall | ✅ paywall | ✅ paywall |
| Tracking limited to alternate days | ❌ | ❌ | ✅ free tier locks tracking to Tue/Thu post-trial | ❌ | ❌ |
| Ads in free tier | ❌ no ads | ❌ no ads | ✅ ads after 14-day trial | ✅ ads | ❌ no ads |

## Pricing Model (verified 2026-05-07)

| App | Free tier | Paid tier | Trial | IAP range (Play Store) | Ads |
|---|---|---|---|---|---|
| Sleep Cycle | basic tracking + smart alarm; trends ≤ 7 days | $39.99/yr Premium (held since 2024) | 60-day free trial; 30% promo codes circulating | $0.99 – $59.99 | No |
| ShutEye | tracking + basic sounds | $59.99 – $79.99/yr (regional) ≈ $7.99/mo or $3.33/mo annual | 7-day free trial | $1.49 – $79.99 | No |
| Sleep as Android | full app for 14 days, then alternate-day tracking + ads | $84.99 lifetime Unlock OR $4.99/mo / $49.99/yr | 14-day full trial | $0.99 – $75.00 | Yes (free tier) |
| SnoreLab | basic Snore Score + full session recording | $39.99/yr (≈ $3.33/mo) or $7.99/mo | 7-day free trial (annual) | $2.99 – $49.99 | Yes |
| Pillow (iOS) | basic auto-track | ~$4.99/mo or ~$40-50/yr | varies | iOS only | No |
| **Snorvey (target)** | **everything** | **$9.99 one-time** | **n/a** | **single SKU** | **No** |

## What is MISSING from all of them — the GAP (informed by 1,900 reviews + low-pct samples)

1. **One-time-pay option** in 2026 — Sleep as Android killed its $9.49 lifetime, jumped to $84.99. Sleep Cycle, ShutEye, SnoreLab, Pillow are subscription-only. Verbatim: *"all fun features require $33 annually. absurd."* (Sleep Cycle, 1★).
2. **Honest free tier with snore audio playback** — every dedicated competitor gates the actual recording playback behind paywall. Verbatim: *"this app is horrible… both times a failure with it saying i need to upgrade to premium just to check."* (ShutEye, 1★).
3. **No login / no account required** — Sleep Cycle, ShutEye, Pillow all force account creation. Verbatim Sleep Cycle 1★: *"google.. login"*.
4. **Robust to fan / AC ambient noise** — global complaint pattern. Verbatim Sleep Cycle 1★: *"it doesn't work when the fan or ac is on, in middle east and asia we have long summer hence ac and fans at night are common so it should work accordingly."*
5. **Easy refund / no dark-pattern subscription cancellation** — Verbatim ShutEye 1★: *"takes money from you monthly and does not have an easy simple way to cancel… they are thieves."* / *"I canceled my trial, and was still charged for a yearly premium subscription"* (Sleep Cycle).
6. **Full local-only history (no cloud lock-in)** — competitors gate historical data behind cloud subscriptions; users want offline ownership.
7. **MP3 / WAV export of nightly recording without paywall** — every competitor gates audio export. A doctor-shareable MP3 is a real unmet need.
8. **No "VIP / Pro / Premium" upsell prompts mid-session** — free-tier users complain about modal harassment; *"Makes you jump through hoops and then hits you with a subscription notice. START WITH THAT!!!!"* (ShutEye).
9. **Greek / Turkish / Arabic UI** — the big four ship English-first, machine-translated rest. Snorvey has a localization wedge for EU + MENA.
10. **A snore-only focused, simple UX** — SnoreLab is the closest, but adds BreathFlow / breathing disturbance bloat. Users want "press start, see graph in morning, listen to audio."

## What is TABLE STAKES — Snorvey MUST have or get instant 1★

1. **Reliable mic recording with VAD (voice activity detection)** — recording must not drop mid-night; Sleep Cycle 1★: *"it stopped recording. There is no audio available for the last two nights."*
2. **Doze / battery-optimization handling on Android** — survives screen-off + Doze; SnoreLab and SaA both fight this constantly in reviews.
3. **Snore Score or equivalent single-number summary** — users expect one number per night.
4. **Per-event timeline with playback** — tap a peak, hear that 8s clip.
5. **Smart alarm or at least a normal alarm clock** — even a single non-cyclic alarm. Without ANY alarm Snorvey looks broken vs all 4 incumbents.
6. **History view that lasts ≥ 30 nights** — cloud not required, but local SQLite must persist.
7. **Onboarding under 60 seconds** — the SnoreLab "press start, place phone next to bed" UX is the bar. No 6-step questionnaire.

## What is BLOAT — Snorvey MUST DELIBERATELY skip

1. **Sleep stage detection (light/deep/REM)** — accelerometer-based stage classification is provably inaccurate (verbatim ShutEye 1★: *"will literally say I was in REM sleep when I was actively awake, driving, etc."*). Skip it = honesty wedge.
2. **Sleep apnea / insomnia "risk score"** — medical-liability landmine; ShutEye gets attacked for false positives.
3. **Dream interpretation / dream journal** — pure ShutEye filler; not a snorer's job.
4. **White-noise / lullaby / meditation library** — every competitor adds it, every competitor gets storage / battery complaints. Calm and Headspace own this category.
5. **Spotify alarm integration / sunrise alarm / Hue / HomeKit** — Sleep as Android territory; massive scope creep.
6. **Anti-snore vibration / tongue-click intervention** — ethically questionable, medically unproven, partner-disturbing.
7. **AI-powered "sleep coach" or chatbot advice** — needs cloud inference (violates $0-backend constraint).
8. **CAPTCHA wake-up / math problems / QR scan to dismiss alarm** — niche power-user feature.
9. **Cloud sync / multi-device** — pure cost center for a $9.99 one-time app. Local-only is a feature, not a limitation.
10. **VIP / Premium / Pro tier** — single SKU is the entire wedge.

## Snorvey positioning summary (one paragraph)

Snorvey is a **snore-recorder-first**, **stage-detection-free**, **single-screen** Android+iOS app for €9.99 one-time-pay that does the SnoreLab job (record + Snore Score + per-event playback + 30-day local trend) honestly and offline, without forcing the user through ShutEye's paywall maze, Sleep Cycle's account login, or Sleep as Android's $85 Unlock. The **deliberate omissions** (no sleep stages, no apnea risk, no meditation library, no cloud) are the marketing copy.

## Sources

- Live `google-play-scraper@10.1.2` runs 2026-05-07 against `com.northcube.sleepcycle`, `health.sleep.sounds.tracker.alarm.calm`, `com.urbandroid.sleep`, `com.snorelab.app` (cached at `C:/tmp/d8_*_meta.json` + the existing `findings/raw/play-store/d8_*_us_*.json` review dumps; 1,900 reviews total).
- Sleep Cycle Premium feature page — https://support.sleepcycle.com/hc/en-us/articles/206704909-Sleep-Cycle-Freemium-vs-Premium-Features
- ShutEye how-it-works — https://shuteye.ai/how-shuteye-sleep-tracker-works
- Sleep as Android anti-snoring docs — https://sleep.urbandroid.org/docs/sleep/anti_snoring.html
- Sleep as Android Unlock plan — https://sleep.urbandroid.org/docs/general/plan.html
- SnoreLab features — https://www.snorelab.com/ (HTTP-403 on direct fetch; data taken from Bouche review + Pixoneye 2026 listing + Adapty paywall library + Apple App Store listing)
- Pillow features — https://pillow.app/automatic-sleep-tracking-for-the-apple-watch + App Store id878691772 + LiveWorkSleep 2026 review
- Existing pricing diff `findings/raw/d8_sleep_competitor_pricing_2026.md` (this repo) — Sleep as Android lifetime $84.99 confirmed, Sleep Cycle $39.99/yr held since 2024.
- Existing complaint dumps used for verbatim quotes:
  - `findings/raw/play-store/d8_shuteye_us_1500.json` (1,500 reviews; 717 ≤ 2★)
  - `findings/raw/play-store/d8_sleepcycle_us_200.json` (200 reviews; 108 ≤ 2★)
  - `findings/raw/play-store/d8_sleepasandroid_us_200.json` (200 reviews; 26 ≤ 2★)
