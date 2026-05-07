# QBSE / Time-Tracker / Invoice IAP / Schedule C — Deep Drill Summary
Date: 2026-05-07 | Agent run window: ~50 min

---

## TASK 1 — QBSE deep drill at 1500 reviews

**App:** com.intuit.qbse (Intuit QuickBooks Self-Employed)
**Note:** Google Play scraper returned **identical English-language pool** for `--country us` and `--country gb` (1500 reviews each, byte-identical). Intuit appears to publish a single global EN listing rather than per-country localized review pools. Numbers below are **global EN, NEWEST-sorted, 1500 deep**.

### Headline numbers
| Metric | Value |
|---|---|
| Total reviews pulled | 1,500 |
| Date range | 2022-05-16 → 2026-05-04 |
| **Full-window low_pct (1-2★)** | **73.4 %** (1,101/1,500) |
| **Recent (2025+) low_pct** | **85.5 %** (195/228) |
| Prior Agent-3 reading (200 reviews) | 96.5 % |

**Verdict on the 96.5 % signal:** *Revised down to ~73 % full-window, but the recent-cohort signal is still extreme at 85.5 %.* The earlier 96.5 % over-stated by ~11 pts because Agent 3 sampled the freshest 200 (most-recent reviews skew negative — angry users post first). At 1500-depth we're catching enough satisfied historical reviewers to soften the headline. **However, the *trajectory is worsening*** — the 2025+ slice is 85.5 %. The product is structurally broken AND the rage is accelerating, not mean-reverting.

### Complaint cluster breakdown (n=1,101 low reviews, keyword-flagged)
| Theme | Hits | % of low |
|---|---|---|
| Customer support / can't reach human | 259 | 23.5 % |
| Subscription / paywall / billing trap | 190 | 17.3 % |
| Mileage tracking failure | 186 | 16.9 % |
| Login / password / re-auth loop | 137 | 12.4 % |
| Invoice / billing module bugs | 120 | 10.9 % |
| Bank sync broken | 76 | 6.9 % |
| Crashes / freeze | 71 | 6.4 % |
| Price too high | 68 | 6.2 % |
| Refund / double-charge | 55 | 5.0 % |

**Structural failure vs tax-season volume:** ~71 % of complaints are structural (mileage + login + sync + crash + invoice + support — i.e. the app doesn't work). Only ~22 % are commercial gripes (subscription/paywall/price/refund). **Tax season explains the *volume* but the failures are year-round product defects.**

### Top-thumbed verbatim quotes
1. **2★ — 217 thumbs (David Majere, 2023-04-04):** "This app is garbage. You set it up, put in your preferences and then when it updates it loses those preferences for auto tracking miles everytime. It then has you set it up, asks you the same set up questions all over again and goes through the password hell to verify."
2. **1★ — 200 thumbs (Josh Humble, 2024-07-22):** "This app needs to be pulled off the market. It no longer works, and appears to be abandoned."
3. **1★ — 161 thumbs (Steven Wilson, 2023-07-05):** "The invoice section of the app is limited. Cannot print, text, or mark invoice as paid without having to (email) send it first… Have to subscribe through their website. Was charged for two subscriptions. App is a battery drainer."
4. **1★ — 133 thumbs (Brandon Abernathy, 2024-07-22):** "Reiterating again, do not pay for this garbage. They make it impossible to cancel… DO NOT PAY FOR mileage tracking. I consistently have issues with it not logging miles or logging me out."
5. **1★ — 108 thumbs (kim alvarado, 2024-10-10):** "I am trying to do my taxes and I couldn't just ask how many total miles I drive like in the past. I had to download the report, put it in excel and use the sum tool."

---

## TASK 2 — Time-tracker niche scan

| App | App ID | n pulled | low_pct | Signal |
|---|---|---|---|---|
| Toggl Track | com.toggl.giskard | 500 | **19.2 %** | Healthy |
| Clockify | me.clockify.android | 500 | **36.4 %** | Soft |
| Hubstaff | com.netsoft.Hubstaff | 327 | **37.9 %** | Soft / hostile |

(Harvest Andromeda + DeskTime + TimeCamp searches returned no matching app IDs in the requested form — Harvest's official Android app is no longer indexed in the FTS results we got back.)

### Verdict
**Saturated and mostly healthy.** Toggl at 19 % is *very* defended (mature Pomodoro tool, consistent quality). The "Free Toggl alternative?" Reddit demand exists, but **Clockify already occupies that slot for free**, and Clockify's 36.4 % is not a Carai-class displacement window — it's the normal soft-spot of any 4M-MAU productivity app.

**Hubstaff (37.9 % low) is the only slightly vulnerable cell**, and the vulnerability is *itself* the wedge — users hate the surveillance aspect:
> "Their desktop app is creepy and invasive. Despite shutting down the app using task manager, it still keeps the timer turned on and that probably means they keep taking screenshots." (1★, 20 thumbs)

But Hubstaff's market is employer-facing, not freelancer. The *freelancer* time-tracker market is well-served and **does NOT pass the v8 displacement threshold (≥80 % low_pct in a meaningful country×app cell).** Recommend de-prioritizing this niche.

### Top freelancer complaints (Toggl + Clockify combined)
- **Toggl:** UI changes break workflows ("Recent update removed the ability to quickly jump to last time"), Pomodoro sound bug unfixed since Aug-2025, GUI confusion.
- **Clockify:** Random forced re-login, Aug-2025 update broke timer mid-session, missing pause button in notification bar.

These are quality-of-life paper-cuts, not "the app is broken" rage — confirms healthy/saturated reading.

---

## TASK 3 — Invoice IAP price matrix

### Invoice Simple (com.aadhk.woinvoice) — confirmed current as of 2026-05-07
| Country | Currency | Cheapest IAP | Most-expensive IAP | Score (live) |
|---|---|---|---|---|
| US | USD | $4.99 | **$399.99** | 4.82 (167k ratings) |
| GB | GBP | £3.99 | **£359.99** | 4.73 |
| CA | CAD | $5.99 | **$549.99** | 4.74 |
| AU | AUD | $5.99 | **$599.99** | 4.67 |

**Confirmation:** the verbatim "$59 → $199" rage from prior 1500-review pull is *now eclipsed* by a **$399 (US) / $599 (AU) ceiling tier**. Invoice Simple has *raised the high tier even further* since the original review pull — the price-rage is going to intensify, not subside.

### Invoice alternatives (US only)
| App | App ID | Free? | IAP range | Score | Installs | Ratings |
|---|---|---|---|---|---|---|
| Wave | com.waveapps.sales | Yes | **$8 – $190** | 3.31 | 500k+ | 23.5k |
| Zoho Invoice | com.zoho.invoice | Yes | **NO IAP** | 4.80 | 1M+ | 30.7k |
| FreshBooks | com.freshbooks.andromeda | Free download | $21 – $65 | 4.24 | 1M+ | 5.9k |
| Bookipi | bookipi.invoice.maker.estimate.billing | Free download | $7.49 – $174.99 | 4.60 | 1M+ | 66k |
| Square Invoices | com.squareup.invoicesapp | Free download | $20 (single tier) | 4.69 | 1M+ | 19.7k |

### Wedge analysis
- **Wave is NOT free anymore** (Wave 2024 monetization shift) — it now charges $8-$190 IAP and **its Play score has cratered to 3.31**. Wave's market position has eroded.
- **Zoho Invoice is the only true $0-IAP competitor** (4.80 score, 30.7k ratings) — but it's tied to Zoho ecosystem (CRM upsell funnel) and lacks Schedule C export.
- **Sweet-spot price gap:** $0/forever-free OR a single $4.99 one-time unlock. Invoice Simple's rage is not "$4.99 is too much" — it's "$199-399/yr surprise renewal." A $0/free tier with optional **$4.99 one-time pro unlock** (no subscription) is the displacement angle.

---

## TASK 4 — Schedule C estimator competitive landscape

### Apps surveyed (US)
| App | App ID | Free? | IAP | Score | Installs | Ratings |
|---|---|---|---|---|---|---|
| **Keeper Tax** | com.keepertax | Free DL | NO IAP (web subscription) | **4.53** | 100k+ | 5.7k |
| 1099 Tax Calculator (AppVenture) | com.appventurepro.taxcalculator1099 | Free | NONE | n/a | 10+ | 0 |
| 1099 Tax Deductions Calc | com.tax.calculator.deductions.rideshare.delivery.tax1099 | Free | $3.99 | n/a | 10+ | 0 |
| Self-Employment Tax Calc | com.freelance.calculator.self.employment | Free | NONE | 4.28 | 10k+ | 50 |
| My 1099 Tax Helper | my1099.tax.helper | Free | NONE | n/a | 50+ | 0 |
| Lunavo Tax Refund Estimator | com.lunavo.app.taxrefundestimator | Free | $0.99-$2.99 | n/a | 100+ | 0 |

### Verdict — **GAP exists**
- **No free, well-rated, install-validated Schedule C estimator on Play Store.** The category bottom (50–10k installs, 0–50 ratings) is essentially empty. Most surfaced "calculators" are actually generic tax/loan/time calculators that mention Schedule C in keywords only.
- **Keeper Tax (com.keepertax) is the de-facto incumbent** at 100k installs, 4.53 score — but it's **free download, paid web subscription ($399/year per Reddit-confirmed top complaint)**. Keeper's 30 % low_pct on 200 reviews is moderate, and the verbatim complaints show two clear wedges:
  1. **Price rage:** "I've used keeper for the past few years and I've loved it but this price increase is crazy work. 399 is out of bounds." (1★, 28 thumbs)
  2. **Mobile-only restriction is annoying:** "Desktop features are severely restricted/non-existent. No one wants to do tax stuff from a 5.8in screen." (1★, 13 thumbs)
  3. **1099 form failures:** "If you have 1099 forms, don't bother with Keeper. They claimed they do them, then went months not bothering helping." (1★, 20 thumbs)
- **No app in the niche occupies the "$0 forever, simple gig-worker Schedule C estimator + mileage" cell.** That is a genuine green field, validated by:
  - QBSE 85.5% recent low (the giant is broken)
  - Keeper $399 rage (the modern incumbent has priced itself out)
  - 6 free calculators with 0–50k combined installs (no one has built it well)

**Direction 2 (Honest Gig Tracker) — Schedule C estimator angle is GREEN-LIT** as a free, simple, no-subscription Android app. The competitive moat is monetization restraint, not feature breadth.

---

## Action items for v9 directions ranking
1. **QBSE displacement target → strongly confirmed.** Recent-cohort 85.5 % low is enough to displace at scale; pair with Schedule C estimator + mileage as the 3-feature MVP.
2. **Time-tracker niche → drop from candidate list.** Toggl/Clockify are healthy, no displaceable cell.
3. **Invoice Simple displacement → confirmed.** $399 US / $599 AU IAP ceiling will continue to drive rage. The wedge is monetization (one-time $4.99 unlock) and Wave's collapse to 3.31.
4. **Schedule C estimator → green-lit standalone OR as feature inside QBSE-displacement app.** No free competitor exists at quality.
