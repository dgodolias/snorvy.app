# Explore Tick 12 — Kids learn / Budget / Period tracker

Date: 2026-05-07
Method: Top 4 candidates per niche (>=1M installs preferred), 200 newest reviews each, recent_low_pct = score<=3 within last 90d.
Raw: `findings/raw/play-store/explore_kids_budget_period.json`

## A) Kids learning niche

| App | Installs | Score | Ratings | Recent low% | n_recent | Pricing |
|---|---|---|---|---|---|---|
| ABCmouse | 1M+ | 4.55 | 22.7K | 27.0% | 200 | IAP $3.99–$104.99 |
| LogicLike ABC&Math | 10M+ | 4.45 | 74.5K | 31.0% | 171 | IAP $1.99–$199.99 |
| Kiddopia | 5M+ | 4.26 | 16K | **38.9%** | 54 | IAP $0.99–$199.99 |
| SplashLearn | 1M+ | 4.64 | 3.1K | 32.8% | 67 | IAP $7.99–$144 |

Top complaint cluster: surprise / unauthorized subscription charges + "$20/month" outrage. Kiddopia at 38.9% recent low + 4.26 score = real fatigue but corp-backed; SplashLearn 32.8% but only 3.1K ratings = small mass. RV AppStudios (Math Kids etc.) strong incumbent free option, no displacement opportunity.

Verdict: Saturated category. Khan Academy Kids is the dominant free option ("no ads, no subscriptions ever"). Pricing complaints exist but no clear cornerstone target. Kiddopia best vulnerability score but corp parent. **Pass**.

## B) Budget / personal finance niche (post-Mint shutdown)

| App | Installs | Score | Ratings | Recent low% | n_recent | Pricing |
|---|---|---|---|---|---|---|
| Wallet (BudgetBakers) | 10M+ | 4.61 | 376K | 22.0% | 200 | IAP $0.99–$144.99 |
| EveryDollar (Ramsey) | 1M+ | 4.34 | 15K | **44.7%** | 94 | IAP $7.99–$129.99 |
| Goodbudget | 1M+ | **3.31** | 19K | **60.0%** | 10 | IAP $0.99–$69.99 |
| Money Manager (Realbyte) | 10M+ | 4.63 | 453K | 11.0% | 200 | IAP $2.49–$20.99 |

**Key signals:**
- **EveryDollar 44.7%** (42/94) — "transactions stopped importing", "won't let me in until I answered personal questions about my finances", auto-sync broken across multiple recent reviews. Ramsey paywalled the auto-import behind Plus tier ($79.99/yr) AND broke it.
- **Goodbudget 60%** (small N=10 but 3.31 lifetime score, 19K ratings) — envelope-budget app, complaint about subscription-pushy + web/app sync broken.
- Money Manager (Realbyte) at 11% = healthy fortress. Wallet 22% = mostly India/SBI-bank specific complaints, not US.

**Mint shut down Jan 2024**. Refugees flowed mainly to Rocket Money (corp, $40/yr Premium gates 80% of value) and Empower (corp). EveryDollar tried to absorb them but broke their auto-sync. Goodbudget is envelope-niche, broken UX. **Real gap exists for: free, US-focused, manual-or-cheap-sync, no-subscription budget app**. Money Manager (Realbyte) already serves this well at 10M+ installs and 4.63 score — it's already the incumbent answer. Hard to displace.

Cornerstone candidate: build a US-localized fork of Money Manager's "manual + simple" model with envelope budgeting (Goodbudget's hook) without the broken sync. But Realbyte already sits on this throne with 453K ratings — overcrowded.

Verdict: Real Mint refugee pain but Money Manager already absorbs the "no-subscription manual tracker" demand. Niche has high CAC + finance app trust barrier. **Marginal — not viable as v9 Direction 10**.

## C) Period tracker niche (post-Roe privacy)

| App | Installs | Score | Ratings | Recent low% | n_recent | Pricing |
|---|---|---|---|---|---|---|
| Period Calendar (Simple Design) | 100M+ | 4.88 | 4.86M | 4.0% | 200 | IAP $0.99–$59.99 |
| Stardust | 1M+ | 4.44 | 20.8K | 31.0% | 200 | IAP $2.99–$39.99 |
| drip period & cycle tracker | 50K+ | 4.11 | 402 | 50.0% | 6 | Free, no IAP |
| Ovulation Tracker (Leap Fitness) | 10M+ | 4.84 | 449K | 5.0% | 200 | IAP $2.99–$59.99 |

**Key signals:**
- Period Calendar (Simple Design): **fortress** — 100M+ installs, 4.88 score, 4% recent low. Untouchable.
- Leap Fitness Ovulation: **fortress** — 10M+ installs, 4.84, 5% low (only complaint = ads). Untouchable.
- Stardust 31% — astrology/moon-synced quirk, technical bugs ("can't get past loading screen", "won't take logins"), Spanish complaint about Google-link mandatory privacy violation.
- drip is the offline-only/privacy-first niche app — but only 50K installs, 402 ratings = nobody is buying the privacy story at scale. 50% low_pct is on N=6 (statistical noise) but signals app is decaying ("crashes every time I add data").

Verdict: The post-Roe privacy paranoia narrative did NOT translate into displaceable demand. drip exists, was the canonical offline-only app, has only 50K installs in 4 years post-Roe. Mainstream users (Simple Design, Leap Fitness) don't care enough to switch. Privacy-as-feature isn't enough to overcome network/feature lead. **Not viable as Direction 10**.

## Best NEW direction: NONE

All three territories explored have no cornerstone-quality opening:
- Kids learning: corp-saturated, Khan Academy Kids dominates free segment.
- Budget/Mint refugees: Money Manager (Realbyte) already absorbs the no-subscription demand at 10M+/4.63.
- Period tracker: Two fortresses (Simple Design 100M, Leap Fitness 10M) have <5% recent low; canonical privacy challenger (drip) is dead at 50K installs proving privacy alone doesn't sell.

Best vulnerable cell across all: **Goodbudget** (3.31 score, 60% recent low) but small recent N and overshadowed by Realbyte's incumbent dominance.

Recommend: Do NOT add a Direction 10 from this tick. v9's 9 directions stand; 29% weekly with 6pp headroom can absorb deeper validation on existing TR couples / halal stack instead.
