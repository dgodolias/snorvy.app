# D9 Evernote Refugee Notes Vault — Competitive Landscape (Tick 6)

Pulled 2026-05-07. Sample sizes: Evernote 1500 NEWEST, alternatives 200 NEWEST each (US, en).

## Headline numbers

| App | n | window | full low_pct | 2026+ low_pct | last-90d low_pct | score |
|---|---|---|---|---|---|---|
| **Evernote** (com.evernote) | 1500 | 2025-09-19 to 2026-05-05 | **84.7%** | **85.1%** | **88.2%** | 2.95 |
| UpNote (com.getupnote.android) | 200 | 2025-11-26 to 2026-05-04 | 11.0% | 12.6% | 14.5% | 4.61 |
| Obsidian (md.obsidian) | 200 | 2026-02-25 to 2026-05-06 | 22.0% | 22.0% | 22.0% | 4.56 |
| Joplin (net.cozic.joplin) | 200 | 2025-08-07 to 2026-05-04 | 23.5% | 24.7% | 24.3% | 4.14 |

Evernote 1500-depth low_pct CONFIRMS the 200-depth signal: 84.7% full, **88.2% in last 90 days** (rage is accelerating, not decaying). At 1500 reviews this is the most extreme low_pct reading observed in the entire research program.

## Evernote rage theme decomposition (1271 1-2★ reviews, 2025+)

| Theme | Count | % of 1-2★ |
|---|---|---|
| **Ads (in-app banners/interstitials)** | 423 | 33% |
| **Price hike (subscription cost rage)** | 372 | 29% |
| Login locked / 2-device limit | 103 | 8% |
| Note limit (50/1-notebook free tier) | 102 | 8% |
| Data loss (notes vanished) | 97 | 8% |
| Performance / crash | 58 | 5% |
| Sync break | 25 | 2% |
| Bending Spoons explicit mention | 23 | 2% |

Note: themes overlap. The dominant rage is **ads + paywall squeeze** (62% combined), not data loss. Bending Spoons sentiment is implicit ("private equity bought them out", "intentionally running it into the ground") more than explicit branding.

## Top verbatim rage (highest thumbs)

- 437 thumbs (2026-02-17, 1★): "Latest update has intrusive ads with no exit/blackout option."
- 427 thumbs (2025-10-19, 1★): "it's not a notepad anymore, it's an app full of ads… restricted to 1 notebook and 50 notes. Any time you transition to a page, you get an ad."
- 378 thumbs (2026-02-16, 1★): "Hundreds of documents have gone missing from my files, and now attachments won't open either."
- 89 thumbs (2026-04-26, 1★): "Final Update April 2026 Reached my limit with their scamming BS. Canceled. **Migrated to UpNote.**"
- 75 thumbs (2026-02-17, 1★): "USELESS NOW, mandatory ads if you don't cough up $30/mo!"
- 49 thumbs (2026-04-16, 1★): "Evernote probably got bought out by a private equity company guys. That's why it sucks now, they're intentionally trying to run it into the ground"
- 38 thumbs (2025-11-11, 1★): "I used this app for 10 years, through highschool & middleschool, now it's TRASH"
- 34 thumbs (2025-12-22, 1★): "started as $90 a year and each year they doubled the price… this year they charged me for $350"

## Alternative apps — vulnerability assessment

### UpNote — STRONG INCUMBENT, NOT A DISPLACEMENT TARGET
- 4.61 score, 11% full low_pct, 14.5% last-90d.
- Top complaint: "for security reasons future versions will [require login]" — small subset hates the new auth flow.
- Some sync-on-multi-device complaints (premium = $35.99 lifetime, viewed as fair).
- **Verdict**: UpNote is THE main beneficiary of Evernote refugees (verified by Evernote review #8 explicitly naming UpNote as destination). UpNote pricing is one-time $35-40, far below Evernote $79-119/yr. Hard to compete head-on.

### Obsidian — POWER-USER ONLY, COMPLEXITY MOAT BUT BARRIER TOO HIGH
- 4.56 score, 22% low_pct.
- Rage: battery drain (39 thumbs), "it's like you need a house but you get a lot of Bricks" (7 thumbs setup pain), copy/paste broken in update.
- **Verdict**: Obsidian wins markdown nerds but ALIENATES the average Evernote refugee (the 65yo "I just want my notes back" user). Gap exists for **simple Obsidian** but Obsidian's free tier is already so generous it's hard to undercut.

### Joplin — OPEN-SOURCE NICHE, SYNC IS BROKEN
- 4.14 score, 23.5% full low_pct, 24.3% last-90d (HIGHEST among the 3 alts).
- Rage: sync is bizarrely limited (only Joplin Cloud paid / Dropbox / OneDrive — 15 thumbs), WebDAV broken (5 thumbs), CIFS/NAS broken (6 thumbs).
- **Verdict**: Joplin has a clear hole — self-hosted sync that actually works — but this is a developer-niche play, NOT mass refugee capture.

## D9 Product spec refinement (zero-cost, Evernote refugee capture)

**Core thesis (post-tick6)**: The Evernote refugee is NOT a power user. They are a non-technical person with 5-15 years of accumulated notes who hit the 50-note paywall + ads + price-hike triple-tap. They need:

1. **One-tap import from Evernote .enex export** (must-have; no other refugee tool advertises this prominently except Joplin/Obsidian which scare non-tech users)
2. **Truly free, unlimited notes & notebooks** (no 50-note cap, no "1 notebook" trick)
3. **NO ads, ever** (this is the #1 rage theme — 33%)
4. **Multi-device sync via Google Drive / iCloud the user's own account** (zero backend cost; no Joplin-style "you must use our paid cloud")
5. **Attachment support: PDF + image + voice memo opens correctly** (Evernote review #12 — 67 thumbs — rages about read-only PDF attachments)
6. **Lock screen + biometric on individual notebooks** (privacy moat vs Google Keep)
7. **Web clipper-equivalent: Android share sheet → save to note** (matches Evernote's most-loved historical feature)
8. **Local-first, encrypted-at-rest** (anti-Bending-Spoons trust play)

**Anti-features (to differentiate from incumbents)**:
- NO AI features (refugees explicitly hate AI search per quote #6: "ai driven. I give it a try… zero value")
- NO subscription on free tier (ever)
- NO note-count limit
- NO device-count limit

**Pricing**: $0 free forever (basic). $9.99 one-time unlock for export-to-PDF batch + custom themes. (Match UpNote's lifetime model, undercut on entry.)

**Build complexity**: 6-8 weeks (ENEX parser is the hardest piece; rest is standard notes app + Drive/iCloud sync via SDK).

**Backend cost**: $0 (sync uses user's own cloud).
