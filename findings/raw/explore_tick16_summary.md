# Tick 16 Exploration Summary — MENA POS + EU Restaurant POS

Generated: 2026-05-07
Constraint: $0 cost, ~25–30 min exploration
Goal: fill v9 ~6pp headroom toward 35% cap with NEW vertical (or rule out).

## Methodology

- Searched Play Store (TR/SA/AE/DE/IT/PL) with localized keywords for restaurant/cafe/small-trader POS apps.
- REJECTED: Square, Loyverse, iZettle, Shopify POS, SumUp, Lightspeed (corporate / well-loved / PayPal-owned).
- Pulled metadata + 200 newest reviews each for top 5 candidates per region.
- "recent" = reviews with date ≥ 2025-02-01 (≈15 months). "low_pct" = (1★+2★)/recent.
- Note: Many Play Store devs do not localize review pulls perfectly; Zobaze/Kyte returned same global English review pool when queried with --country sa vs ae vs de vs it. Treat their low_pct as global, not country-scoped.

## A) MENA POS (Saudi Arabia, UAE, Egypt) — Top Vulnerable Cells

| App | Country | Installs | Score | Recent | Low | low_pct | Verdict |
|---|---|---|---|---|---|---|---|
| **Kyte** (com.kyte) | AE/SA | 1M+ (3.1M est) | 4.27 | 39 | 9 | **23.1%** | **Vulnerable** — global low_pct, complaints about feature removal post-trial, web desktop loss, paywall surprise |
| **Zobaze Restaurant POS** | SA/AE | 100k+ (107k est) | n/a | 51 | 10 | **19.6%** | Mid-vulnerable — "split payment still not available, daily issues in billing" + "high price" + "no reply of admin" |
| Fatora Cashier (io.fatora.cachieren) | SA | 10k+ (48k est) | unrated | 1 | 0 | n/a | Too small / sparse reviews; Arabic-first but inactive (last update Jan 2023) |

**Top MENA verbatim (Kyte AE/SA, 2026-03-08, 1★):** "Customer service is not helpful. They are not knowledgeable and always offline. Extracting report from the app is getting worst."

**Wedge thesis (if pursued):** Arabic-first + ZATCA e-invoicing compliance + offline-first cashier for SA/AE small cafes/restaurants. NO marketplace, NO KYC, NO payments processing → just a cash register + receipt printer + tax-ready report.

## B) EU Restaurant/Cafe small-trader POS — Top Vulnerable Cells

| App | Country | Installs | Score | Recent | Low | low_pct | Verdict |
|---|---|---|---|---|---|---|---|
| **Waiterio** (io.waiter.android) | IT | 100k+ (389k est) | 4.22 | 8 | 2 | **25.0%** | High low_pct but tiny n=8 — "Always decline card", thermal printer pairing fails. Small Italian sample. |
| **Zobaze Restaurant POS** | DE/IT | 100k+ | n/a | 51 | 10 | **19.6%** | Same global pool (split payment, price, support gap) |
| RePOS (com.repos) | DE | 100k+ (332k est) | 4.88 | 44 | 5 | 11.4% | Loved overall; Turkish dev. Recent regression complaints: "worked fine for 18 months… now incorrect reports… doubles up work". |
| aadhk RestPOS | DE | 500k+ (538k est) | 4.69 | 27 | 2 | 7.4% | Beloved, no monthly fee — well-defended. SKIP. |
| TabShop | DE | 500k+ (624k est) | 3.81 | 12 | 1 | 8.3% | Decent, but recent low n=12 too thin. Score 3.81 hides legacy 1★ (572 in histogram). |
| PoS Cash Register (mixxamm) | PL | 100k+ (208k est) | unrated | 0 | 0 | n/a | Too new (May 2025), 0 reviews — not yet validated. |

**Top EU verbatim (Waiterio IT, 2025-07-29, 2★):** "Application is good but I'm not able to connect my Thermal printer with the app even after trying every possible attempt."

## Best NEW Direction Candidate

**NONE beats existing v9 top 9.**

Reasoning:
1. **Vulnerability ceiling is too low.** Best cell = Kyte 23.1% recent low_pct (global pool, not country-scoped). v9 incumbents like Love8 32.8%, halal 30%+ are clearly stronger.
2. **Restaurant POS is a saturated, hardware-coupled vertical.** Top complaints are thermal printer pairing, ESC/POS Bluetooth, fiscal/ZATCA compliance, multi-tablet sync — these require physical-device QA and per-country tax-engine work. Solo-dev + $0 backend cannot match.
3. **ZATCA / EU fiscal compliance** is a regulatory moat in the WRONG direction — adds cost & risk, not a wedge for a one-person team.
4. **MENA Arabic POS** is the most defensible angle (Fatora is dormant, Kyte is non-Arabic-first), BUT install ceiling for Arabic-only POS is small AND ZATCA Phase-2 compliance audit cost would violate $0 budget.
5. **EU well-defended.** aadhk 4.69 / 500k installs / no-monthly-fee already owns the "simple cheap restaurant POS" niche in Germany. RePOS 4.88 owns Turkish-dev DE niche. No clean wedge.

## Recommendation

**REJECT both territories.** Hold v9 at current 9 directions. Continue scouting other territories per Tick 11 guidance (e.g., MENA hobbyist/lifestyle, EU consumer verticals NOT touching POS/fiscal/payments).

Files written:
- findings/raw/play-store/explore_mena_pos.json (4 cells, 727 reviews)
- findings/raw/play-store/explore_eu_pos.json (6 cells, ~1180 reviews)
- this summary
