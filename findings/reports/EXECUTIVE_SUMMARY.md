# v9 Executive Summary — Greek Solo Dev Direction Recommendation

**TL;DR**: Build **D13 Bloki — Greek myDATA invoicing** for Android+iOS. Start **Monday 2026-05-11**. Public launch **Tuesday 2026-06-30** (94 days before the Oct 1, 2026 myDATA mandate). Y1 ARR realistic range: **€45k (pessimistic) → €75k (base) → €180k (optimistic)** with ARR exit run-rate €95k–€430k.

---

## The recommendation

Build Bloki, a mobile-native, Greek-language invoicing + myDATA submitter targeting the 700K μπλοκάκι (Greek freelancer) captive market that is legally forced to electronically transmit invoices to AADE by **Oct 1, 2026**. Pricing: free tier (5 invoices/mo) → €4.99/mo intro → €7.99/mo at mandate → **€69 lifetime** (anti-subscription wedge). The wedge is brutal: AADE's official myDATAapp sits at **57.9% recent low_pct** with 71 verbatim Greek 1★ reviews ("πατάτα" / "potato"), Epsilon Smart costs €5/mo and is desktop-tethered, and **no Greek-language mobile-native competitor exists**. Greek nationality is a structural moat: native AADE jargon + myDATA character semantics + cultural humor unattainable for foreign incumbents. Risks: AADE prod credentials lead time (5-10 business days — submit Week 0), Epsilon could ship a mobile app (low signal, monitored quarterly), TikTok algorithm push for Greek micro-niche is not guaranteed (mitigated by 3 hashtag tiers).

## Why this beats the other 12 directions

- **Composite 9.0 vs runner-up 5.8** (D7 TR e-SMM, D10 MY e-Invois) — 3.2pp gap, decisive
- **Native moat axis: 10/10** — only direction where being Greek is an asset, not neutral. Every other direction subtracts the dev's biggest comparative advantage
- **Forced-purchase deadline Oct 1, 2026** — Urgency 10/10 vs D1 FairBill's 4/10 (rage-only, no deadline)
- **CAC fit 10/10** — €350 = ~7-9k Greek installs at €0.04-0.05 CPI vs D1 US/GB €1-3 CPI buying ≈100-300 installs
- **Backend cost €0 verified** — Cloudflare Worker free tier covers 1670 MAU × ~30 calls/mo = 50K req/mo (50% of 100K/day daily allowance even at 10× growth)

## Week 0 actions (this week, May 7-10)

1. **Submit AADE production app registration TODAY** (lead time 5-10 biz days; soft-launch viable without prod creds, but mandate requires them)
2. **Create Cloudflare account** and verify Worker free tier (100K req/day) — boilerplate proxy setup
3. **Reserve Play Store + App Store listings** under name "Bloki — myDATA Τιμολόγηση"; draft per d13_app_store_copy_drafts.md
4. **Register domain** `bloki.gr` (or `blokiapp.gr` fallback) + EUIPO trademark search "Bloki" classes 9+42
5. **Reach out to 5 Greek accountant TikTokers** (10-50K followers): MVA Tax & Accounting, SitaropoulosTax, Eleni Mousena (closed-beta partnership offer)
6. **Confirm AADE Taxisnet account** is active (required to sign API EULA)
7. **Scaffold Flutter project** + add Drift (SQLite) + revenuecat_sdk; first commit to private GitHub repo

## 7-week build plan summary

| Week | Milestone | Critical risk |
|---|---|---|
| W0 (May 7-10) | AADE registration submitted, Cloudflare Worker boilerplate, Flutter scaffold | AADE registration delay > 10 days |
| W1 (May 11-17) | AADE auth flow + Worker proxy; first sandbox invoice POST | API EULA stuck in legal review |
| W2 (May 18-24) | Invoice list UI, client manager, expense tracker | Drift schema migration churn |
| W3 (May 25-31) | myDATA character classification + auto-submit | AADE character spec ambiguity |
| W4 (Jun 1-7) | Free tier limits, paywall, RevenueCat IAP | iOS StoreKit reviewer rejects "lifetime" SKU |
| W5 (Jun 8-14) | Greek localization polish, ASO assets, screenshots | Greek copy review needs accountant sanity check |
| W6 (Jun 15-21) | Closed beta with 10 freelancers + 3 accountant creators | Beta reveals myDATA edge case bug |
| W7 (Jun 22-28) | Bug fixes, App Store submission, soft launch | Apple review delay (3-7 days) |
| **Public launch** | **Tue 2026-06-30** | TikTok algorithm doesn't push Greek tax content |

## Y1 financial projection

| Scenario | Total installs (Y1) | Paid conversion | Y1 cum. revenue | ARR exit (Jun 2027) | Break-even |
|---|---|---|---|---|---|
| **Pessimistic** | ~10,000 | 5% (500 paid) | **~€45k** | ~€95k | Late Oct 2026 |
| **Base** | ~22,000 | 8% (1,670 paid) | **~€75k** | ~€160k | **Mid-Sep 2026** (pre-mandate) |
| **Optimistic** | ~45,000 | 10% (4,500 paid) | **~€180k** | ~€430k | Aug 2026 |

Total Y1 hard cost ~**€814** (ASA €350 + domain/TM €110 + accountant reviews €230 + dev fees €124). Break-even at ~165 paid subs.

## Trigger conditions for next direction (when D13 should be deprioritized)

- **30-day post-launch (Jul 30, 2026)**: <500 installs OR <2% activation → ASO + paywall A/B retest, do NOT pivot yet
- **90-day post-launch (Sep 30, 2026)**: <1,000 MAU OR <4% paid conversion → tighten Greek-only positioning, accountant referral push; if still flat by mandate week (Oct 7), prepare D7 (TR e-SMM) pivot research
- **180-day post-launch (Dec 30, 2026)**: <300 MAU OR mandate window failed to spike conversion → **PIVOT** to D7 (TR FaturAki) or D10 (MY e-Invois Cepat), both at composite 5.8 with deadline urgency
- **Any time**: Cloudflare cost >€20/mo sustained → backend cost broke $0 constraint; consider Supabase pivot
- **Upside trigger**: ≥1,000 MAU + ≥6% paid by Sep 30 → DOUBLE DOWN, build D14 sister app (Greek tax estimator) for cross-sell

## What NOT to spend time on (rejected directions)

- **D1 FairBill / D2 SoloLedger / D3 Mileway (US/GB B2B)** — €350 buys 100-300 installs in US/GB CPI; native moat = 1/10; Greek dev has no Schedule C / Self Assessment regulatory intuition. Park as Y2 expansion only after D13 lands.
- **D4 EU multi-country (DE/PL/NL/IT)** — 4 codebases, 4 localizations, Greek dev has zero German/Polish/Dutch/Italian. €40-70k combined ARR is real but execution complexity dominates timing edge. PL KSeF Apr 2026 already past peak.
- **D6 Tycoon Zero (Flutter Flame idle game)** — 8-12wk build + B2C variability + game ARPDAU 5-10× weaker than B2B utilities. Native moat = 1/10. Pure portfolio/passion project, not a Y1 revenue play.

---

_Confidence: HIGH. Source: 28 exploration ticks + Tick 25 final ranking + Tick 26 backend architecture validation + Tick 27 Greek TikTok validation + Tick 28 Cyprus extension scan. Decision frozen 2026-05-07._
