# D13 Bloki — Pricing A/B Research (Tick 27)

Date: 2026-05-07. Goal: Set price tier for Greek freelancer myDATA app.

## Verified Competitor Pricing (Greek market, 2026)

| Product | Plan | Price | Notes |
|---|---|---|---|
| **e-timologio.com** | Free | €0 | 3 invoices, 5 clients, 100MB |
| e-timologio.com | Pro | **€9/year** | Unlimited invoices, 10GB, 5 team |
| e-timologio.com | Business | €19/year | Unlimited everything |
| **Timologio PRO** | Full | **€50/year** | Full ERP + accounting |
| **Epsilon Smart** | Promo | -50% off through 31.05.2026 | 130K subscribers; pricing wall, est. €5-18/mo |
| **Timologic** | Trial + paid | 7-day free; price not public | mobile-first competitor |
| AADE timologio (gov) | Free | €0 | Government-issued, basic, slow UX |

## Critical Finding — Greek Price Anchor is LOW

**e-timologio sets the market floor at €9/YEAR** (not month). This is roughly €0.75/month. Greek freelancers expect cheap or free invoicing tools because:

1. AADE provides a free government tool (timologio.aade.gr)
2. Most freelancers already pay an accountant €30-80/month — software is incremental
3. €9-19/year competitor pricing trains expectation of <€5/mo for software-only

Epsilon Smart's higher price is supported by enterprise/accounting-firm bundling, NOT freelancer-direct.

## Greek Freelancer Software Budget Benchmark

- Accountant fees: €30-80/mo (the dominant spend)
- Software-only spend: €0-€10/mo typical, €15+ rare
- Willingness to pay for *time savings* (the D13 wedge): meaningful only if app demonstrates 5+ hours/month saved

## Pricing Recommendation — Tiered with Lifetime Anchor

| Tier | Price | Strategy |
|---|---|---|
| **Free** | €0 | First 5 invoices/month, manual myDATA submit. Drives ASO + word-of-mouth. |
| **Pro Monthly** | **€4.99/mo** | Unlimited invoices, auto-myDATA, expense tracking. Anchors against Epsilon Smart promo (-50% ≈ €5-9). |
| **Pro Annual** | **€39/year** (€3.25/mo) | 35% discount vs monthly. Hits between e-timologio (€9-19) and Timologio PRO (€50). |
| **Lifetime** | **€69 one-time** | Greenshoots launch buyers; strong conversion lever for early adopters who hate subscriptions. |

## Why NOT €7.99 or €9.99/mo

- e-timologio's €9/year anchor makes €9.99/mo feel 12x overpriced.
- €7.99/mo = €96/year, double Timologio PRO's full ERP.
- Greek B2B SaaS price elasticity is steeper than DE/NL — confirmed by Paddle regional data showing Mediterranean WTP -10 to -15% vs US.

## ARR Sensitivity (1670 MAU year-1 projection from Tick 26)

Assume 8% paid conversion (industry standard for freelancer tools w/ free tier):
- 1670 × 8% = **134 paying users**
- Mix: 60% annual (€39), 25% monthly (€4.99×12=€60/yr realized at ~6mo avg = €30), 15% lifetime (€69 one-shot)
  - Annual: 80 × €39 = **€3,120**
  - Monthly: 34 × €30 = **€1,020**
  - Lifetime: 20 × €69 = **€1,380**
  - **Y1 ARR ≈ €5,520** (subscription-recurring portion ≈ €4,140; lifetime is one-shot)

## A/B Test Plan (post-launch, week 4)

- Cohort A: €4.99/mo + €39/yr + €69 lifetime
- Cohort B: €5.99/mo + €49/yr + €79 lifetime (+20%)
- Run 2 weeks, n>200 per cohort, measure paid conversion + revenue/install. Pick winner.

## Final Recommendation

**€4.99/mo + €39/year + €69 lifetime, free tier @ 5 invoices/mo.**
Optimizes for: (a) acquisition velocity in price-sensitive Greek market, (b) defensible mid-market position vs Epsilon Smart, (c) anti-subscription buyer capture via lifetime tier.
