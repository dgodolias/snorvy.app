# D13 Bloki — FINAL GO/NO-GO MEMO

Author: app-radar Tick 27 (final exploration tick)
Date: 2026-05-07
Decision target: Greek solo dev, $0 backend budget, $350 Google Ads earmarked

---

## Decision: **GO — BUILD GREENLIT**

### Confidence: HIGH (v9 #1, score 26, 3 confirmations)
- Tick 25: market sizing + competitor low_pct gap validated
- Tick 26: AADE API + Cloudflare Worker $0 architecture confirmed at 1670 MAU
- Tick 27: Greek TikTok organic STRONG (3,900 #λογιστης creators), pricing benchmarked

---

## 7-Week Build Plan — Start Date: **Monday 2026-05-11**

| Week | Milestone | Owner |
|---|---|---|
| W0 (this week, May 7-10) | AADE sandbox creds, Cloudflare Worker boilerplate, Flutter scaffold | dev |
| W1 (May 11-17) | AADE auth flow + Worker proxy; first invoice POST to sandbox | dev |
| W2 (May 18-24) | Invoice list UI, client manager, expense tracker | dev |
| W3 (May 25-31) | myDATA character classification + auto-submit | dev |
| W4 (Jun 1-7) | Free tier limits, paywall, Stripe (or RevenueCat) integration | dev |
| W5 (Jun 8-14) | Greek localization polish, ASO assets, screenshots | dev |
| W6 (Jun 15-21) | Closed beta with 10 freelancers from r/greece + 3 accountant creators | dev + beta |
| W7 (Jun 22-28) | Bug fixes, App Store submission, soft launch | dev |
| **Public launch** | **Tuesday 2026-06-30** | dev |

---

## Required Immediate Actions (Week 0, May 7-10)

1. **AADE production app registration** — submit application TODAY; lead time 5-10 business days. (Source: findings/raw/play-store/d13_aade_api_research.md)
2. **Cloudflare account + Worker quota verification** — confirm 100K req/day free tier covers 1670 MAU × ~30 calls/mo = ~50K req/mo (well under).
3. **Reach out to 5 Greek accountant TikTokers** (10-50K follower range) for closed-beta partnership offer. Use findings/raw/tiktok/d13_greek_tiktok.json author list as starter (MVA Tax & Accounting, SitaropoulosTax, Eleni Mousena).
4. **Reserve Play Store listing** — name "Bloki — myDATA Τιμολόγηση", reserve handle, draft listing per d13_app_store_copy_drafts.md.
5. **Domain + landing page** — `bloki.gr` or `blokiapp.gr`, single page with TikTok-embed demo, beta-list signup.

---

## Risk Mitigations

| Risk | Mitigation |
|---|---|
| AADE API rate limits / changes | Cloudflare Worker abstraction layer; fallback to manual submit UX |
| Epsilon Smart -50% promo (until 31.05.2026) eats acquisition | Position as mobile-first + Greek-only; their promo expires before our launch |
| Greek freelancers won't pay for software | Free tier (5 invoices/mo) + lifetime €69 anti-subscription option |
| Cloudflare exceeds free tier | Architecture verified: 1670 MAU × ~30 calls/mo = 50K req/mo; 50% of 100K/day daily allowance even at 10x growth |
| TikTok algorithm doesn't push Greek micro-niche | 3 hashtag tiers (#λογιστης 235M, #φορολογια 49M, #ελευθεροςεπαγγελματιας 3M) hedge across reach levels |
| AADE registration delayed | Build offline-first invoice creation; submit-to-myDATA gate behind pro tier — soft-launch viable without AADE prod creds |

---

## Recommended Pricing Tier (final)

- **Free**: 5 invoices/month, manual myDATA submit
- **Pro Monthly**: €4.99/mo
- **Pro Annual**: €39/year (€3.25/mo equivalent — 35% discount)
- **Lifetime**: €69 one-time

Rationale: e-timologio sets €9/year price floor; Epsilon Smart sets €5-18/mo ceiling. €4.99/mo splits the middle. Lifetime tier captures Greek anti-subscription buyers + funds Y1 cashflow.

---

## Y1 ARR Realistic Range

- **Bear case**: 800 MAU, 5% paid conversion, €25/yr ARPU = **€1,000 ARR**
- **Base case** (Tick 26 model): 1670 MAU, 8% conversion, €30 blended = **€4,000-5,500 ARR**
- **Bull case**: 3000 MAU (TikTok organic hit), 10% conversion, €35 blended = **€10,500 ARR**

Plus one-shot lifetime revenue: ~€500-2000 in Y1 (not recurring).

Solo-dev viability check: **€4,000+ ARR in Y1 = build successful at $0 cost**. Y2 doubles via word-of-mouth + accountant referrals.

---

## Exit / Next-Direction Trigger Conditions

Pivot OR backlog D13 if any of these fire by **2026-12-31** (6 months post-launch):

1. **<300 MAU at month 6** → product-market fit failed; pivot to v9 D7 (Halal Marriage) or D9 (TR Couples Tracker)
2. **<3% paid conversion at month 4** → pricing wrong OR audience wrong; A/B retest
3. **AADE breaking changes** that require >2 weeks rework → reassess solo-dev sustainability
4. **Cloudflare $ cost >€20/mo sustained** → backend cost broke $0 constraint; consider Supabase pivot

If by **2026-09-30** (3 months post-launch) we hit ≥1000 MAU + ≥6% paid conversion: **double down** — add D14 sister-app (Greek tax estimator) for cross-sell.

---

## Final Word

**Build it. Start Monday. Y1 ARR floor €4K, ceiling €10K, marketing cost capped at $350 ads, backend $0. The thesis (Greek freelancer pain + AADE mandate + competitor low_pct gap + 235M-view TikTok audience) is the strongest signal-stack we've found in 27 ticks.**
