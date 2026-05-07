# EXPLORATION TICK 1 — v9 hunt for new directions

Date: 2026-05-07. v9 weekly usage 27% / 35% cap. 8pp headroom remaining.

## A. TR Invoice / e-SMM market

### Legal landscape (WebSearch verified)
- **e-Fatura** mandatory only for companies above **3M TL annual revenue**.
- **Serbest meslek erbabı (freelancers)** are NOT required to use e-Fatura — they MUST use **e-SMM (e-Serbest Meslek Makbuzu)**, a separate GIB system.
- e-SMM mandatory for ALL freelancers earning regular professional income. GIB integration is FREE via dijital.gib.gov.tr.
- Legal risk LOW — building a compliant GIB client is not a regulated activity.

### Vulnerable cells (recent 90-day low_pct)

| App | low_pct | n_recent |
|---|---|---|
| **com.earsivfatura.app (Mikrogrup)** | **66.7%** | 12 |
| io.earsiv.sysmond (SYSMOND) | 41.3% | 46 |
| com.uyumsoft.ebelge | 50.0% | 2 (low n) |

Top complaint: **bait-and-switch token monetization**. Verbatim:
> "50 jeton hediye verip de 4 faturada 9 jetona da düşmez. Hatta 9 jeton vardı 1 tane fatura keseyim diye girdim 1 jeton kalmış. Ayıp ayıp" (Sysmond, 1★, 9 thumbs)

> "1 haftadır fatura kesemiyorum. Arayüz çalışmıyor. Onay mesajları gelmiyor." (Mikrogrup, 1★, 7 thumbs)

**Verdict: GO** — strong signal, untouched e-SMM sub-niche, $0 GIB integration cost.

## B. Voice recorder niche (US)

### Vulnerable cells (recent 90-day low_pct)

| App | low_pct | n_recent |
|---|---|---|
| Smart Voice Recorder (SmartMob) | 14.4% | 194 |
| Easy Voice Recorder (Digipom) | 7.0% | 200 |
| quality apps Voice Recorder | 4.0% | 200 |

Top complaints: ad spam (Quality Apps), data loss, SD card permission breakage on new Android versions.

Verbatim (Smart Voice Recorder, 17 thumbs, 2★):
> "I thought this was one of the best aps around. Unfortunately, my internal memory is always full and I used to have it setup to record on the SD card. But last week I got a new phone…"

**Verdict: WEAK** — top low_pct only 14.4%, far below D1 baseline (23%). Category is mature & well-served. Reject.

## C. Sleep tracker / alarm niche (US)

### Vulnerable cells (recent 90-day low_pct)

| App | low_pct | n_recent |
|---|---|---|
| **ShutEye Sleep Tracker (ENERJOY)** | **61.6%** | 125 |
| Yawn Sleep Tracker (Leap Fitness) | 25.5% | 200 |
| Alarmy (Delightroom) | 8.5% | 200 |

ShutEye is collapsing at 61.6% recent low_pct (D6 baseline 52% — exceeds it). Pattern = **trial→billing scam**.

Verbatim (ShutEye, 1★, 45 thumbs, Jan 2026):
> "This app was supposed to start with a 7 day free trial, but it immediately charged me for 12 months of service. Additionally, it did not work as advertised. After 2 hours of laying in bed, fully awake, it was telling me that I had 2 episodes of deep sleep…"

Verbatim (ShutEye, 1★, 44 thumbs, Jan 2026):
> "I was charged during the free trial. the app itself is fine, although any time you turn off the tracker, it goes through all the steps to start again. It's redundant…"

**Verdict: STRONG** — ShutEye 61.6% is exceptional. Wedge = honest flat-fee sleep recorder with NO trial scam pattern. $0-cost (microphone + local storage). Build 4-6 weeks.

## Best NEW DIRECTION CANDIDATE

**TIE between two finalists** (both beat v9 D5):

### #1: TR e-SMM "Serbest Makbuz" — for Greek-dev cultural proximity
- Mikrogrup 66.7% low_pct + Sysmond 41.3% — bait-and-switch wedge
- Legal: GIB free integration, e-SMM mandatory for ALL TR freelancers
- $0 backend, 5-7 weeks build, low legal risk
- Geographic edge: Greek dev, TR cultural proximity, near-zero competition awareness in Western dev community
- **WHY THIS WINS**: Dual-mandate market (every TR freelancer LEGALLY needs this) + worst-incumbent monetization (token scam) creates clean wedge. Distribution via Reddit r/freelance_TR + LinkedIn TR.

### #2: ShutEye-displacement honest sleep recorder (US)
- 61.6% recent low_pct — near D6 (Tycoon Zero) territory
- ShutEye install base: **10M+ installs, 107K ratings, $1.49-$79.99 IAP** — massive TAM
- Wedge: flat one-time $4.99, NO trial, microphone + local-only storage
- $0 backend (zero cloud), 4-6 weeks build
- **WHY**: Pure execution play — match ShutEye's core feature, strip the scam.

### Install metadata (verified)
- **ShutEye**: 10M+ installs, 107,011 ratings, IAP $1.49-$79.99
- **Yawn (Leap)**: 5M+ installs (lesser low_pct 25.5%, lower priority)
- TR Sysmond: 100K+ installs, 8,341 ratings (free, no IAP visible — likely token-paywalled in-app)
- TR Mikrogrup: 100K+ installs, 2,262 ratings (free, no IAP)
- TR Uyumsoft: 100K+ installs, 144 ratings (free, no IAP — but app appears abandoned)

**Recommended ranking**: e-SMM > ShutEye (e-SMM has stronger moat via geographic + regulatory specificity; ShutEye is more pure-execution but easier to copy).

Voice recorder niche REJECTED (max 14.4% low_pct insufficient).

## Recommendation
Add **e-SMM Direction (D7-candidate)** to v9 stack at next tick. Optionally add ShutEye-displacement as D8-candidate. Both beat v9 D5 (Smart Receipts merged) on low_pct severity AND constraint fit.
