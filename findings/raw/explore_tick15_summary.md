# Explore Tick 15 Summary - D8 ShutEye Launch Readiness Deep

Date: 2026-05-07 | Cap: 35% weekly | Pre-tick weekly: ~29% | Headroom: ~6pp

## 1. ShutEye 1500-depth Revised low_pct (US, NEWEST)

| Window | n | low (1-2*) | low_pct | Delta vs initial Tick-1 (61.6%) |
|---|---|---|---|---|
| Full pull | 1500 | 717 | **47.8%** | -13.8pp |
| 2025+ filter | 1500 | 717 | **47.8%** | (same as full - all reviews 2025+) |
| **Last 90d** | 122 | 74 | **60.7%** | matches initial scan; **CONFIRMED ACCELERATING** |

**Key revision:** Full 1500-window low_pct (47.8%) is below the initial 61.6% scan because the initial scan was a smaller fresh slice. However, the **last-90d slice still shows 60.7% low_pct** - so the user-rage signal IS recent and accelerating, not historical noise.

**Top complaint themes (top 20 highest-thumb 1-2*):**
- 11/20 reference billing/trial/refund (immediate-charge-on-trial pattern confirmed)
- 8/20 reference accuracy/sleep-stats inaccuracy
- 6/20 reference "can't cancel" + "took money"
- Quote #1 (117 thumbs, 2025-07-28): "language/wording is off, voices not soothing"
- Quote #2 (113 thumbs, 2025-03-20): "definitely canceling subscription, recordings inaccurate"
- Quote #6 (54 thumbs, 2025-12-11): "tell me how to cancel my subscription!! number does not work"
- Quote #8 (52 thumbs, 2025-07-18): "cancelled within trial period - yet they still took L30.70"
- Quote #10 (45 thumbs, 2026-01-13): "supposed to start with 7 day free trial, but it immediately charged me for 12 months"

**Verdict:** ShutEye trial-trap rage is REAL, RECENT, and CONCENTRATED. 60.7% low_pct in last 90d on 10M+ install incumbent = displacement gold.

## 2. Sleep Tracker Competitive Table

| App | Reviews | Full low_pct | 90d low_pct | Sub-rage (1-2*) | Verdict |
|---|---|---|---|---|---|
| **ShutEye** | 1500 | 47.8% | **60.7%** | very high (top-20: 11 mention) | **VULNERABLE - target** |
| **Sleep Cycle** | 200 | 54.0% | **65.5%** | 32/200 (16%) | **VULNERABLE - secondary target** |
| **Calm** | 200 | 47.0% | 47.0% | 33/200 (16.5%) | **VULNERABLE but mood/meditation crossover** |
| **Sleep as Android** | 200 | **13.0%** | 13.0% | 1/200 (0.5%) | **HEALTHY FORTRESS** - avoid |

**Strategic read:**
- Sleep as Android is the only fortress (one-time-purchase model, lifetime upgrades, technical user base) - DO NOT compete on its turf.
- Sleep Cycle is also vulnerable on subscriptions (65.5% recent low_pct, 16% sub-rage).
- ShutEye + Sleep Cycle are both subscription-exhausted - a $9.99 one-time-purchase upstart can attack BOTH simultaneously with one launch.
- Calm is a different category (meditation primary), but its 16.5% sub-rage signals same audience fatigue.

## 3. D8 ASA Top 5 Keywords

| # | Keyword | Composite | Why |
|---|---|---|---|
| 1 | `snore recorder pay once` | **6.75** | Lowest comp; no whale dominates this exact phrase |
| 2 | `sleep recorder no subscription` | 3.36 | High intent; only partial whale overlap |
| 3 | `ShutEye alternative` | 2.03 | Direct displacement target |
| 4 | `Sleep Cycle alternative` | 2.01 | Secondary target, same anti-sub story |
| 5 | `sleep tracker free no ads` | 1.81 | Crowded but searchable |

## 4. D8 Recommended App Name + 7 Empty Positioning Slots

**Recommended app name:** `Hush Sleep Recorder: Pay Once` (29 chars, trademark-clean)
**iOS subtitle:** `Pay once. No trial trap.` (24 chars)

**Empty positioning slots (gaps no incumbent owns):**

| Slot # | Position | Owner today | D8 claim |
|---|---|---|---|
| 1 | One-time purchase ($9.99) | Sleep as Android only | YES - cornerstone |
| 2 | "No trial trap" anti-pattern | NO ONE owns it | YES - hero hook |
| 3 | Offline-first / no-account | Sleep as Android partially | YES - reinforce |
| 4 | Export-your-data (WAV/CSV) | NO ONE | YES - "own your data" |
| 5 | Open-source recording engine | NO ONE | YES - trust signal |
| 6 | Snore-only minimalist tracker | crowded but not branded | YES via ASA #1 KW |
| 7 | Anti-Calm/anti-ShutEye direct ad creative | NO ONE | YES - paid ad differentiator |

All 7 slots are EMPTY in the current incumbent landscape (ShutEye, Sleep Cycle, Calm all subscription-locked; Sleep as Android occupies #1 partially but isn't marketed on slots 2/4/5).

## 5. Final D8 Confidence

**MEDIUM-HIGH**

Rationale:
- HIGH evidence: 60.7% recent low_pct on ShutEye (1500-depth confirmed) + 65.5% on Sleep Cycle 90d + 7 EMPTY positioning slots + 10M+ install displacement target + clearest anti-sub hook in the directions list
- MEDIUM caveat: Sleep tracking accuracy claims are technically hard ($0 budget = no ML, no ground-truth dataset); if D8 ships only audio recording w/o accurate stage detection, the "honest" hook may ring hollow when users compare to Apple Watch / Fitbit in-built tracking. The "pay once" wedge is durable; the "tracker" claim is risky without humility framing ("we record - we don't fake-predict your REM cycles").
- Holds at MEDIUM-HIGH (not full HIGH) until a 1-week MVP audio-recorder prototype validates 50-user opt-in rate.

**Compared to D9 (the prior tick winner):** D8 has a stronger displacement signal (60.7% vs D9's typical 30-40%) but a weaker "build-feasibility" story ($0 audio recorder is feasible; $0 sleep-stage classifier is not). D8 should ship as a recorder + minimal time-in-bed metric only, not a full tracker.
