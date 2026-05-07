# Snorvy

> Sleep recorder & snore tracker. Pay $9.99 once. No subscription. Ever.

**Status**: Pre-launch. Build starts May 11, 2026. Public launch target: Tue Jun 30, 2026.

**Domain**: snorvy.app

---

## What this branch contains

This is the **decision-ready reference** for Snorvy — the strategic docs the dev needs during build & launch. No research clutter, no rejected directions.

### 📋 Read first (in order)

| Doc | Purpose | When you read it |
|---|---|---|
| [`findings/reports/D8_SNORVY_FINAL_BRIEF.md`](findings/reports/D8_SNORVY_FINAL_BRIEF.md) | Decision support — the why, what, how | Now |
| [`findings/reports/D8_MONETIZATION_PLAN.md`](findings/reports/D8_MONETIZATION_PLAN.md) | Locked pricing & business model | Before any payment work |
| [`findings/reports/D8_LAUNCH_KIT.md`](findings/reports/D8_LAUNCH_KIT.md) | ASA campaigns, 25 TikTok scripts, ProductHunt + Reddit copy | Week 4 of build |

### 🔬 Evidence base (cite-able primary research)

| Doc | Contains |
|---|---|
| [`findings/raw/d8_feature_matrix.md`](findings/raw/d8_feature_matrix.md) | 5-incumbent feature audit (Sleep Cycle, ShutEye, Sleep As Android, SnoreLab, Pillow) |
| [`findings/raw/d8_user_sentiment_cross_source.md`](findings/raw/d8_user_sentiment_cross_source.md) | 32 verbatim quotes (Reddit + TikTok + Play Store) |
| [`findings/raw/d8_viral_marketing_evidence.md`](findings/raw/d8_viral_marketing_evidence.md) | Quest sleep, Cal AI, Finch, Things 3 — fact-checked case studies |
| [`findings/raw/d8_monetization_research.md`](findings/raw/d8_monetization_research.md) | Procreate / Things 3 / Forest precedents + 29 source URLs |
| [`findings/raw/d8_app_store_copy_drafts.md`](findings/raw/d8_app_store_copy_drafts.md) | ASA keywords, app name, iOS subtitle drafts |
| [`findings/raw/d8_competitive_refresh.md`](findings/raw/d8_competitive_refresh.md) | Live IAP data 2026-05-07 |
| [`findings/raw/d8_sleep_competitor_pricing_2026.md`](findings/raw/d8_sleep_competitor_pricing_2026.md) | Sleep As Android $9.49 → $84.99 9× hike, anti-sub wedge widening |
| [`findings/raw/d8_name_availability.md`](findings/raw/d8_name_availability.md) | Why "Snorvy" beat 11 other candidates (Hush, Murmur, etc.) |

---

## The 30-second pitch

**Problem**: Sleep tracking apps lock the actual recording behind paywalls and trial-trap users. ShutEye 60.7% recent low_pct, Sleep Cycle 65.5% — user rage is universal.

**Wedge**: $9.99 lifetime. Records snore + sleep talk. Plays back without paywall. No subscription. Local-only.

**Why now**: Sleep As Android lifetime price jumped 9× (Feb 2026, $9.49 → $84.99) + added subscription tier. The pay-once slot in Android sleep is empty.

**Why this dev**: Greek solo, $0 backend, Claude Max, 1-month build target.

**Y1 base outcome**: ~$13k revenue. Cumulative 5-year (with Snorvy 2 + sister apps): ~$233k base, 5-10× with viral TikTok hit.

---

## Tech stack (locked)

```
Cross-platform UI       Flutter 3.27+
Audio recording         flutter_sound 9.x
Audio classification    tflite_flutter + YAMNet (Snoring + Speech + Whispering filter)
Local DB                Drift (SQLite)
Charts                  fl_chart
IAP                     in_app_purchase 3.x
Background recording    flutter_background_service
VAD                     libfvad via Flutter FFI
Backend                 NONE (local-only audio)

Monthly cost @ 5k MAU   ~€0
```

---

## Critical constraints

- ❌ NO subscription tiers (breaks the entire wedge)
- ❌ NO free trial (trial-trap is the #1 viral TikTok complaint genre)
- ❌ NO cloud sync in v1 (forces sub pivot — that's how Day One / Pocket Casts / Carrot died)
- ❌ NO sleep stage detection (provably inaccurate, every competitor gets 1★ for this)
- ✅ Local-only audio
- ✅ One-time IAP $9.99
- ✅ 30-day generous refund policy (marketing weapon, not legal)

---

## Next 7 days

1. Submit Apple Developer Program application ($99/yr)
2. Submit Google Play Developer Program ($25 one-time)
3. Register `snorvy.app` domain
4. EUIPO trademark search "Snorvy" classes 9+42
5. Verify Taxisnet account (for Greek tax declaration)
6. Reach out to 3 Greek/EU sleep-niche micro-influencers (closed-beta partners)
7. Scaffold Flutter project + first commit

---

## Why this branch exists

The `main` branch contains the full app-radar research run (13 directions, 100+ raw research files, multi-month methodology evolution). This `develop` branch contains **only what's needed to build & launch Snorvy** — the focused source-of-truth for the next 12 months of work.

If you need historical context on rejected directions, alternate market analyses, or the full evidence corpus, switch to `main`.
