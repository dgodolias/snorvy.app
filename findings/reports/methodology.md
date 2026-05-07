# Methodology — Loop Mode (depth-first per direction)

_Initialized: 2026-05-07 14:55 EEST (loop mode added on top of main exhaustive run)_
_Mode: loop (continuous, cap-bounded, depth-first)_

```yaml
loop_state:
  cap_target: 35              # weekly all-models %
  cap_started_at: 21          # weekly % when run began
  iter_tier: medium           # ~1pp/tick
  iter_burn_pp: 1
  active_direction: 6         # PIVOTED D4 → D6 (Tycoon Zero Flame game, B2C path)
  active_phase_started_at: 2026-05-07T16:30:00+03:00
  active_phase_ticks: 0
  active_phase_dimensions_done: []
  active_phase_dimensions_in_flight: []
  active_phase_dimensions_remaining:
    - adcap_iap_audit
    - asa_idle_game_keywords
    - founder_responsiveness_top3_games
    - reddit_idleclicker_comment_tree
    - launch_readiness_d6
  exhausted_directions: [1, 2, 3, 4, 6]   # All 5 actionable directions exhausted
  loop_status: CAP_REACHED   # weekly 33% with Tick 34 in flight → stop sequence triggered (1pp under 35% hard cap)
  cap_reached_at: 2026-05-07T19:25:00+03:00
  cap_reached_pct: 33
  cap_reached_session_pct: 44
  tick_34_status: COMPLETED_RERUN   # Re-dispatched after user authorized cap breach; all 4 files written
  tick_34_findings: "D11 HOLD, D8 HOLD-PROMOTE-watch, D2 PROMOTED (Intuit May 1 2026 price hike largest in QBO history)"
  deeper_dig_completed: [13, 7, 10, 9, 4, 11, 8, 2]   # 8 of 13 dirs deep-validated
  exploration_started_at: 2026-05-07T17:00:00+03:00
  exploration_dimensions:
    - new_country_TR_invoice_market   # Greek dev native country, untouched in v9
    - new_niche_voice_recorder_or_dictation
    - new_niche_sleep_tracker_or_alarm
    - new_country_BR_invoice_or_freelance
    - cross_validation_d1_competitor_legal_filings_landing_page
    - new_niche_meditation_anti_subscription
    - new_niche_focus_pomodoro_apps
  pivot_history:
    - {from: null, to: 1, at_tick: 0, reason: "loop start, D1 was top scoreboard"}
    - {from: 1, to: 2, at_tick: 0, reason: "D1 already exhausted in main run pre-loop: 11/11 applicable dimensions done"}
    - {from: 2, to: 3, at_tick: 3, reason: "D2 Phase B 3 ticks completed: iOS+IAP+founder resp + Reddit comment-tree + launch readiness. Top finding: SoloLedger app name + Schedule C estimator app ASA #1 + iOS 81.6% recent low. Reddit revealed users prefer free Wave/Xero so wedge repositioned to free-tier-parity + $39 lifetime US-tax differentiation."}
    - {from: 3, to: 4, at_tick: 2, reason: "D3 Phase C 2 ticks completed: 1500-drill+iOS+IAP combo + ASA+launch+TikTok combo. Top findings: Mileway app name, ASA stride alternative composite 10.0, TikTok #doordash 13.3B viable, Solo last-90d 83.3% (ESCALATING from 68%), Stride iOS-Android delta 36.7pp (Android-locked), Solo IAP $179.99 ceiling. D3 confidence promoted MEDIUM-HIGH → HIGH."}
    - {from: 4, to: 6, at_tick: 2, reason: "D4 Phase D Tick 1 returned + Tick 2 ASA delivered (10/12 dimensions criteria for exhaustion met). Top findings: DE-first launch (sevDesk dual-platform 78% + Lexware no IAP gap + €440 active price-hike), NL-second (Invoice Fly 0% reply rate), PL-third (Fakturownia already KSeF-native = defensive moat). ASA: §19 UStG App (DE), Tofu zamiennik (PL), Invoice Fly alternatief (NL) — all composite 10.0 zero-comp displacement keywords. Launch readiness still wrapping but key signal already integrated. Pivoting to D6 Phase E with ~7pp headroom."}
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
