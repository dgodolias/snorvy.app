# Explore Tick 3 — Notes / Habit / Fitness-Home Niche Scan

**Run date**: 2026-05-07
**Method**: Play Store search (US + BR), top apps by keyword (rejecting OS-built-in / corporate / hardware-locked / open-source incumbents per brief), pulled metadata + 200 newest reviews each, computed `recent_low_pct` = %≤2★ in reviews from last 90 days.

Data: `findings/raw/play-store/explore_notes.json`, `explore_habit.json`, `explore_fitness_home.json`.

---

## 1. NOTES NICHE — Notion-alternative thesis: STRONGLY VALIDATED

Top vulnerable cells (all US):

| App | Installs | Score | Recent low_pct | IAP range | Notes |
|---|---|---|---|---|---|
| **Evernote** | 100M+ | 3.54 | **84.0%** (n=200) | $1–$254.89 | Bending Spoons acquisition, predatory pricing, data-loss bugs. NUCLEAR rage cohort. |
| **Notion** | 10M+ | 4.59 | **33.5%** (n=200) | $11.99–$214.99 | Mobile app crashes, AI agent push, freezes. Big users want simpler/offline. |
| **Obsidian** | 1M+ | 4.12 | **22.0%** (n=200) | free | Battery drain on mobile; "you get a lot of bricks" — too complex for normies. |
| UpNote | 100k+ | 4.74 | 14.5% (n=110) | $1.99–$39.99 | Migration target FROM Evernote, but small base & sync issues. |
| ColorNote | 100M+ | 4.88 | 3.0% | $1.99–$15.99 | Beloved incumbent — DO NOT compete head-on. |
| Notepad/Easy Notebook | 10M+ | 4.77 | 4.0% | $3.99–$30.99 | Simple-Design — saturated commodity. |

**Top verbatim (Evernote, 1★, 👍181)**: *"Went from being really good to being absolutely unusable. None of the notes I've made are even viewable, which led to a lot of lost data. All it does is spin the loading bar..."*

**Top migration quote (Evernote, 1★, 👍89)**: *"Final Update April 2026 Reached my limit with their scamming BS. Canceled. Migrated to UpNote. $79 to $119..."*

**Thesis verdict**: Evernote refugees are actively migrating. UpNote is winning the migration but premium @ $35.99 is itself getting backlash. White space = **"no-subscription, offline-first, easy Evernote import"** — but execution risk: notes apps are CROWDED, ColorNote/Easy Notebook own the simple-tier. Real wedge = **Evernote-importer + offline + one-time-purchase** to catch the rage exodus. Build complexity moderate (rich text + import parser).

---

## 2. HABIT NICHE — US shows displacement, BR cornerstone HabitNow is BELOVED

Top vulnerable cells:

| App | Country | Installs | Score | Recent low_pct | Notes |
|---|---|---|---|---|---|
| **Productive (Apalon)** | US | 1M+ | 3.73 | **19.2%** (n=26)¹ / 29.5% overall | Subscription rage, "I LOVE the app, but the alerts stopped working" + "forces you to pay". |
| **Routinery** | US | 1M+ | 4.57 | **18.1%** (n=105) | "$72 lifetime sub disappeared, support email isn't real" — billing scam vibes. |
| **HabitKit** | US | 500k+ | 4.81 | 17.3% (n=52) | "only allow users to track up to 4 habits!" — paywall too aggressive. |
| **Habitica** | US | 5M+ | 4.68 | 16.3% (n=147) | "server connection lost", offline mode missing. |
| **Disciplined** | US | 500k+ | 4.34 | 16.3% (n=49) | Streak logic broken for non-daily habits ("3x/week doesn't count"). |
| **HabitNow** | US | 5M+ | 4.69 | 4.0% | Beloved. DO NOT compete head-on. |
| **HabitNow** | BR | 5M+ | 4.86 | **2.5%** (n=163) | BR loves it. v6 BR Rabit 33% signal does NOT generalize to top apps. |

¹ Productive's recent_n=26 is small — overall 29.5% is more reliable.

**Top verbatim (Productive, 1★, 👍46)**: *"My yearly subscription is up and I will not be renewing. I LOVE the app, but the alerts/reminders stopped working very early on, and to me that's the whole point!"*

**Thesis verdict**: US has a real cohort fed up with broken-paywall habit apps (Productive, Routinery, HabitKit all 16-19% low). But the gap is **NOT a 35%+ rage zone** — it's **"competent, no-paywall-traps, no-billing-scam"**. BR market is locked by HabitNow (4.86★, 2.5% low) — no entry point. Build effort is moderate, but TAM is split across 5 mid-strength incumbents. Lower confidence than Notes.

---

## 3. FITNESS HOME NICHE — STRONG subscription-scam rage in mid-tier

Top vulnerable cells (US):

| App | Installs | Score | Recent low_pct | IAP range | Notes |
|---|---|---|---|---|---|
| **Fitbod** | 1M+ | 4.50 | **45.9%** (n=196) | $9.99–$129.99 | "Wrong exercise mid-workout", "creating workouts in Spanish" — broken algorithm. |
| **FitOn** | 10M+ | 4.43 | **40.0%** (n=40)¹ / 35.5% overall | $14.99–$119.99 | "DO NOT PAY FOR THIS! THEY WILL NEVER STOP CHARGING YOU!" — billing fraud cohort. |
| **Freeletics** | 10M+ | 4.15 | **34.9%** (n=63) / 30% overall | $0.99–$210 | "Coach oscillates between too easy and dangerously hard" — quality regression. |
| **Fitify** | 10M+ | 4.76 | 18.5% (n=200) | $1.99–$359.99 | "Absolutely deceptive refund policy", "$359.99 for an app, AI-generated everything." |
| Home Workout (Leap) | 100M+ | 4.85 | 3.5% | $2.99–$69.99 | Beloved cornerstone. Don't fight. |
| Seven (Perigee) | 10M+ | 4.50 | 15.6% (n=45) | $0.99–$99.99 | Stable, only minor billing complaints. |

¹ FitOn recent_n=40 small — overall 35.5% is more reliable.

**Top verbatim (FitOn, 1★, 👍10)**: *"DO NOT PAY FOR THIS! THEY WILL NEVER STOP CHARGING YOU! I canceled four years ago and they are still charging me a yearly fee and I have to call and dispute it everytime with my bank because fiton only..."*

**Top verbatim (Freeletics, 1★, 👍188)**: *"Gets worse with every update and now deleted. The 'coach' oscillates between workouts that are far too easy or so hard they'll leave you unable to train for a week..."*

**Thesis verdict**: 3 incumbents (Fitbod, FitOn, Freeletics) all in the **30-46% low_pct danger zone**. The wedge is clear: **"no-subscription bodyweight workouts, no recurring charges, transparent flat IAP"**. BUT — content production cost (exercise videos/animations) is real, and Leap Fitness Group's free Home Workout (4.85★, 100M installs) covers the no-equipment beginner. The opening is for **gym/strength logging without the broken Fitbod algorithm** — but that needs exercise database + form-cue content.

---

## 4. BEST NEW DIRECTION CANDIDATE

### **Notes-Notion-Refugee Vault** (US + EN-speaking world)

**Why it beats the other two:**
1. **84% Evernote recent low** is one of the highest single-app rage signals seen all v9.
2. Migration is **already happening** to UpNote — but UpNote charges $35.99 premium, so a **one-time-purchase + free Evernote import** wedge is wide open.
3. **$0 backend possible** — local SQLite + optional self-hosted WebDAV/Dropbox sync (user BYO storage). No server cost, no AI inference.
4. Build effort 4-6 weeks: rich-text editor (TipTap or ProseMirror), Evernote ENEX import parser (well-documented format), tag system, search. NO marketplace, NO AI inference, NO legal risk.
5. Monetization: $14.99 one-time unlock + optional $0.99/mo "premium themes" (the proven Komorebi/ColorNote model already at 4.7-4.85★).

**Vs current v9 top:**
- Beats most of the lower v9 directions on raw rage signal (84% > anything except Evernote).
- Concern: notes is a **crowded vertical** (ColorNote 100M, Notion 10M, Easy Notebook 10M) — but the wedge is migration-pull, not new-user-acquisition.
- TR Couples Tracker (current v7 #1, 32.8%) still has cleaner build path — Notes Vault is a strong **#3-5 candidate** for v10, not a #1 displacement.

**Honorable mentions:**
- **Habit US (Productive/Routinery/HabitKit displacement)** — solid 16-19% low across 5 incumbents but no single rage spike, and BR is locked. Score: ~6/10.
- **Fitness Home (Fitbod/FitOn refugee)** — 35-46% low signals are strong, but content production cost (exercise media) violates spirit of "simple build". Score: ~6/10.

**Recommendation**: Add **Notes Vault** as v10 candidate at #3-5 slot for next ranking cycle, behind existing v9 top 2 (TR Couples + Halal-Marriage). Do not displace top 2.
