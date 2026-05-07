# Explore Tick 26 Summary — D13 Bloki Build Playbook

**Date:** 2026-05-07 | **Mode:** EXPLORATION | **Weekly cap headroom:** ~4pp before tick

## 1. AADE API Readiness Verdict

**GREEN — buildable for solo dev, $0 cost, no certification gate.**

Key facts:
- ERP-user track (what Bloki needs) = self-service Taxisnet registration, ~1 hour
- Auth = simple API key in headers (`aade-user-id` + `Ocp-Apim-Subscription-Key`)
- Sandbox is free, separate registration at `mydata-dev-register.azurewebsites.net`
- Spec v2.0.1 published Jan 2026, official PDF + 3 open-source reference libraries
- 13 primary endpoints, REST/JSON, no OAuth complexity
- Rate limits not published but Azure-backed; non-issue for freelancer-scale traffic
- **Integration time: 5-7 working days** to wire SendInvoices + RequestDocs end-to-end

NOT recommended: "Provider" track (multi-month committee certification). Bloki ships as ERP-user app where each user enters their own subscription key during onboarding.

## 2. 7-Week Build Plan Summary

| Week | Dates | Theme | Critical milestone |
|---|---|---|---|
| 1 | May 11-17 | Foundations + sandbox | First sandbox call green |
| 2 | May 18-24 | Core API | Round-trip invoice <5s |
| 3 | May 25-31 | Greek-first UX | 3 freelancer cold tests |
| 4 | Jun 1-7 | Classification + E3 | Push notifs working |
| 5 | Jun 8-14 | Beta recruit + polish | 15 active beta users |
| 6 | Jun 15-21 | Trademark + compliance | Privacy/ToS + Play assets |
| 7 | Jun 22-28 | Soft launch + ASA prep | Open beta GR-only |

**Public launch: Jul 6, 2026** | **Paid tier: Sep 1** | **Mandate ride: Oct 1**

Beta recruit channels: r/greece, insomnia.gr, LinkedIn cold DMs (30). Target 15 active beta users by Jun 14.

Pre-launch hard gates: trademark filed, accountant-reviewed Greek ToS, real invoice posted to production AADE, 8 Greek screenshots, crash-free >99.5%.

## 3. Y1 ARR Projection

| Scenario | Paid subs end Y1 | ARR exit (Jun 2027) | Y1 cumulative revenue |
|---|---|---|---|
| Pessimistic | ~990 | ~€95k | ~€45k |
| **Base** | **~1,670** | **~€160k** | **~€75k** |
| Optimistic | ~4,500 | ~€430k | ~€180k |

**Mandate inflection (Oct 1, 2026):** modeled as 4-5x install spike, +350 paid subs in October alone (base case).

**Break-even:** ~165 paid subs → reached **mid-September 2026** (before mandate even hits). Total Y1 hard cost ~€814 (€350 ASA + €110 trademark/domain + €230 accountant + €124 dev fees).

## 4. Final D13 Build Greenlight

**YES — ship it.**

Why:
- API technically buildable in 1-2 weeks of API work, 7 weeks total to launch-ready
- $0 hard build cost (only €350 ASA + ~€460 misc)
- Mandate Oct 1 is a hard regulatory catalyst, not speculative demand
- Composite v9 score 9.0 (next direction 5.8) — clear winner for THIS Greek dev
- No mobile-native competitor in Greek myDATA space currently
- Break-even by Sep 2026 in base scenario
- Y1 ARR €95k-€160k base/pessimistic floor, €430k upside

Risks accepted:
- AADE schema bumps (mitigated: abstract schema layer)
- Mandate delay (AADE has delayed before; even with 3-month delay, model still profitable)
- Competitor mobile entry (none today; Bloki gets first-mover)

Risks rejected as deal-breakers:
- Provider certification (NOT needed for ERP-user app)
- OAuth complexity (NOT used; simple API key)
- Rate limits (non-issue at freelancer scale)

## Files Generated

- `findings/raw/d13_aade_api_research.md` — API technical doc
- `findings/raw/d13_build_playbook.md` — week-by-week plan
- `findings/raw/d13_revenue_model.md` — 30-day + Y1 model
- `findings/raw/explore_tick26_summary.md` — this file

## Open Items for Tick 27

- TikTok competitor scan: `@mydata`, `@λογιστικό` Greek hashtags — measure organic ceiling
- Pricing A/B research: €4.99 vs €7.99 vs €9.99 — Greek freelancer willingness-to-pay
- Cloudflare Worker proxy architecture — confirm $0 covers projected call volume at 1,670 MAU
