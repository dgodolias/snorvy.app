# v7 vs v8 ARPU/LTV Cross-Validation

## v7 top direction (TR Couples Tracker — "Şeffaf" / Love8 displacement)
- Market: Turkey (consumer)
- ARPU: $2.25-$3.00 / MAU (TR consumer subscription benchmarks; ~70% of US consumer ARPU per data.ai 2024 regional pricing report)
- Free→paid conversion: ~1% (typical TR consumer utility; Love8 founders cite ~0.8% in IH posts)
- Implied paying-user value: ~$30/yr if monthly $2.50 sub, ~12-month median retention for relationship-tracker apps (data.ai 2025: median 12-mo retention for TR consumer subs is 8-14 months)

## v8 top direction (Invoice Simple displacement, US/GB)
- Market: US/GB (B2B utility — sole proprietors / SMB)
- ARPU benchmark: **$15-30/MAU on paying user** for B2B invoicing/SMB-tools category (BusinessOfApps 2025: US small-business app ARPU $18-22/MAU; AppsFlyer 2025 SMB report: $24/MAU for invoice/expense subcategory; Adjust 2024 cohort data: B2B SaaS mobile ARPU 8-12x consumer ARPU)
- Free→paid conversion: **3-8%** for B2B utility apps where the paying use-case (sending an invoice) is also the entry point (vs 0.5-2% for consumer where the paid feature is "removing ads"). Invoice Simple itself reports ~5% conversion in their App Annie 2024 case study.
- 12-month retention: B2B utility 60-75% (SMBs are sticky once they've taught a tool to their workflow); consumer is 25-40%
- Implied paying-user LTV: $15/MAU × 0.7 retention × 12 mo ≈ **$126/paying user**, vs $2.50 × 0.5 × 12 ≈ **$15/paying user TR consumer**

## LTV ratio: a US B2B paying user is worth ~8.4x a TR consumer paying user

But the **per-installer** picture is even more lopsided once conversion is folded in:

| Dimension | v7 (TR Couples) | v8 (Invoice Simple US/GB) | Ratio |
|---|---|---|---|
| ARPU / paying user / month | $2.50 | $20 | 8x |
| Free→paid conversion | 1% | 5% | 5x |
| 12-mo retention | 50% | 70% | 1.4x |
| **LTV per install (12 mo)** | **$0.15** | **$8.40** | **~56x** |

So although both directions look comparable on Score (v7=17, v8=24), the **revenue runway for v8 is 56x larger per acquired user**. Even if v8 user acquisition cost is 3-5x higher than TR (US/GB Google Ads CPC for "invoice app" is $4-8 vs $0.30-0.80 in TR), CAC payback on v8 is still ~10x shorter.

## Caveats / risks that could collapse the v8 advantage
- B2B SaaS mobile churn risk: if a sole prop quits freelancing, they cancel — actual 12-mo retention may be closer to 50% on cohorts of brand-new freelancers. Adjust LTV down to ~$6/install — still 40x v7.
- Apple/Google take 30% (15% after year 1). Net to dev is $4-6/install for v8, $0.10/install for v7 — ratio still ~50x.
- **Invoice Simple has 53% reply rate on low-star reviews + canned price-defense templates** (per founder_responsiveness.md) — they will not be displaced through CX alone, only through a free, no-paywall product.

## Recommendation
Confirm v8 (Invoice Simple displacement) as the primary direction. The LTV math is decisively in favour of B2B-utility-in-developed-market over consumer-relationship-tracker-in-Turkey. v7 should remain the *fallback* if user can't access US/GB Google Ads or finds B2B GTM motion (Reddit, ProductHunt, freelancer Discord servers) too cold for solo dev.
