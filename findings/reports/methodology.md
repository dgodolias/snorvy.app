# Methodology — Loop Mode (depth-first per direction)

_Initialized: 2026-05-07 14:55 EEST (loop mode added on top of main exhaustive run)_
_Mode: loop (continuous, cap-bounded, depth-first)_

```yaml
loop_state:
  cap_target: 35              # weekly all-models %
  cap_started_at: 21          # weekly % when run began
  iter_tier: medium           # ~1pp/tick
  iter_burn_pp: 1
  active_direction: 4         # PIVOTED D3 → D4 (EU multi-country, Polish KSeF priority)
  active_phase_started_at: 2026-05-07T16:00:00+03:00
  active_phase_ticks: 0
  active_phase_dimensions_done: []
  active_phase_dimensions_in_flight: []
  active_phase_dimensions_remaining:
    - ios_cross_check_de_pl_nl_competitors
    - iap_audit_de_pl_nl
    - founder_responsiveness_eu_competitors
    - asa_polish_ksef_keywords
    - tofu_invoice_fly_drill_500
    - launch_readiness_d4
  exhausted_directions: [1, 2, 3]   # D1 pre-loop, D2 Phase B, D3 Phase C
  pivot_history:
    - {from: null, to: 1, at_tick: 0, reason: "loop start, D1 was top scoreboard"}
    - {from: 1, to: 2, at_tick: 0, reason: "D1 already exhausted in main run pre-loop: 11/11 applicable dimensions done"}
    - {from: 2, to: 3, at_tick: 3, reason: "D2 Phase B 3 ticks completed: iOS+IAP+founder resp + Reddit comment-tree + launch readiness. Top finding: SoloLedger app name + Schedule C estimator app ASA #1 + iOS 81.6% recent low. Reddit revealed users prefer free Wave/Xero so wedge repositioned to free-tier-parity + $39 lifetime US-tax differentiation."}
    - {from: 3, to: 4, at_tick: 2, reason: "D3 Phase C 2 ticks completed: 1500-drill+iOS+IAP combo + ASA+launch+TikTok combo. Top findings: Mileway app name, ASA stride alternative composite 10.0, TikTok #doordash 13.3B viable, Solo last-90d 83.3% (ESCALATING from 68%), Stride iOS-Android delta 36.7pp (Android-locked), Solo IAP $179.99 ceiling. D3 confidence promoted MEDIUM-HIGH → HIGH."}
  start_limits: {session: 16, weekly: 25}
  expected_max_ticks: 10
```

## Direction 1 (Invoice Simple displacement) — EXHAUSTED before loop start

11 of 11 applicable dimensions completed in main run (cultural validation N/A for EN-only direction):

| # | Dimension | Done | Source |
|---|---|---|---|
| 1 | 3000-review drill US/GB | ✓ | invoice_simple_us_3000.json + invoice_simple_gb_3000.json |
| 2 | iOS cross-check 7 countries | ✓ | invoice_simple_ios_us/gb/ca/au/de/fr/jp.json |
| 3 | Founder responsiveness 8 incumbents | ✓ | founder_responsiveness.md |
| 4 | IAP audit US/GB/CA/AU | ✓ | iap_invoice_simple_*.json |
| 5 | Reddit comment-tree 10 threads | ✓ | reddit/tree-*.json |
| 6 | Cross-country (US/GB/CA/AU) | ✓ | invoice_simple_3000_analysis.json |
| 7 | ASA keyword volume + composite score | ✓ | aso_keyword_estimates.md |
| 8 | Cultural validation | N/A | EN-only direction |
| 9 | Legal/regulatory feasibility | ✓ | legal_cultural_validation.md (US/GB/CA/AU all GO) |
| 10 | Launch-readiness intel (FairBill) | ✓ | d1_launch_readiness.md + d1_app_store_copy_drafts.md |
| 11 | TikTok hashtag viability | ✓ | v9_hashtag_summary.md (CONDITIONAL viable, umbrella tags) |
| 12 | Revenue estimate | ✓ | revenue_estimates.md ($35M/year confirmed) |

→ EXHAUSTED. Locked in v9 directions report. No further D1 dispatches needed.

## Direction 2 (QBSE + Solopreneur + Schedule C combo) — ACTIVE

Pre-loop status: 6 of 12 dimensions done from main run.

| # | Dimension | Status | Notes |
|---|---|---|---|
| 1 | 1500-review drill QBSE+Solopreneur | ✓ | qbse_us_1500.json + qb_solopreneur_us_1500.json |
| 2 | iOS cross-check QBSE+Solopreneur | ⬜ MISSING | Need iOS reviews for QBSE and Solopreneur |
| 3 | Founder responsiveness Solopreneur-specific | ⬜ MISSING | Got QBSE 97%, Solopreneur replyText not pulled |
| 4 | IAP audit QBSE+Solopreneur | ⬜ MISSING | Need live IAP for both apps |
| 5 | Reddit comment-tree (Schedule C threads) | ⬜ MISSING | r/personalfinance, r/SmallBusiness, r/IRS Schedule C threads |
| 6 | Cross-country | N/A | US-only direction |
| 7 | ASA keyword volume + composite | ✓ | aso_keyword_estimates.md (Schedule C estimator section) |
| 8 | Cultural validation | N/A | EN-only |
| 9 | Legal/regulatory feasibility | ✓ | legal_cultural_validation.md (PTIN required only for paid prep) |
| 10 | Launch-readiness intel for D2 | ⬜ MISSING | Need app name + ASA + ProductHunt plan |
| 11 | TikTok hashtag viability | ⬜ partial | #1099tax 128K dead but #smallbusiness 237B umbrella works |
| 12 | Revenue estimate | ✓ | revenue_estimates.md ($300-500M segment estimate) |

→ 5 dimensions remaining. Estimated 5 ticks at medium tier = ~5pp budget = within limit.

---

## Phase C plan (D3 Honest Gig Tracker — pending D2 exhaustion)

When D2 declared exhausted, pivot to D3. D3 dimensions status (pre-loop):

| # | Dimension | Status |
|---|---|---|
| 1 | 1500-review drill Solo + Stride | ⬜ partial (only 200 reviews) |
| 2 | iOS cross-check Solo + Stride | ⬜ MISSING |
| 3 | Founder responsiveness Solo+Stride | ✓ done in main run (Solo 84%, Stride 99%) |
| 4 | IAP audit Solo + Stride | ⬜ MISSING |
| 5 | Reddit comment-tree gig threads | ✓ done in main run (r/doordash, r/lyftdrivers, r/uberdrivers) |
| 6 | Cross-country | N/A US-only |
| 7 | ASA volume + composite | ⬜ partial (covered in Agent 8, but D3-specific keywords need scoring) |
| 8 | Cultural validation | N/A EN-only |
| 9 | Legal/regulatory | ✓ Schedule C estimator legal (PTIN exempt) |
| 10 | Launch readiness for D3 | ⬜ MISSING |
| 11 | TikTok hashtag viability for gig workers | ⬜ MISSING (unique to D3 — gig drivers VERY active on TikTok) |
| 12 | Revenue estimate | ✓ done (Solo+Stride monetize off-app) |

→ 5 dimensions remaining for D3. Target 3 ticks at medium tier.

## Phase D plan (D4 EU multi-country — pending D3 exhaustion)

When D3 declared exhausted, pivot to D4. D4 dimensions status (pre-loop):

| # | Dimension | Status |
|---|---|---|
| 1 | 300-review drill on DE+PL+NL competitors | ✓ partial done (Agent 6 + Agent 9) |
| 2 | iOS cross-check DE/PL/NL | ⬜ MISSING |
| 3 | Founder responsiveness sevDesk+Lexware+Tofu+Invoice Fly | ⬜ MISSING |
| 4 | IAP audit sevDesk+Lexware+Tofu+Invoice Fly | ⬜ MISSING |
| 5 | Reddit comment-tree DE/PL/NL freelancer threads | ⬜ partial (DE done) |
| 6 | Cross-country | ✓ DE+PL+NL built-in |
| 7 | ASA volume Polish/Dutch/German keywords | ⬜ MISSING |
| 8 | Cultural validation | ✓ done DE; PL/NL needed |
| 9 | Legal/regulatory | ✓ done all 4 (DE GO, PL GO with KSeF, NL GO with KOR, FR/JP NO-GO) |
| 10 | Launch readiness for D4 | ⬜ MISSING |
| 11 | TikTok hashtag viability EU markets | ⬜ MISSING |
| 12 | Revenue estimate | ⬜ partial |

→ 9 dimensions partial/missing. May not fully exhaust before cap. Prioritize: iOS DE+PL, founder responsiveness, IAP audit, ASA Polish keywords (KSeF window).

## Run history reference

See `findings/reports/run_ledger.md` for full run history.
