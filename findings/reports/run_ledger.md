# Run Ledger — app-radar evolution log

This is the agent's **memory across runs**. Each entry documents what worked, what failed, and what to try next. The agent reads this file at Phase 0 of every run and applies learnings.

**Format**: append-only. Newest entries at the bottom. Never edit/delete past entries (they're the historical record). User can fill in `User decision` and `Outcome` sections post-hoc.

---

## Run 2026-05-06 23:00 (exhaustive — initial scan)

### Configuration
- Tier: exhaustive
- Mode: explore
- Hard cap: none
- Limits at start: session 11%, weekly 13%
- Limits at end: session 13%, weekly 13%

### Top result
- #1 cell: TR/couple, score 13
- Confidence: HIGH
- $/MAU: not computed (revenue dimension not yet in formula)

### What worked
- **Drill 500-3000 reviews on top apps** → surfaced 91-thumbs Turkish complaint on Labyrinthos, 52-thumbs cross-country Love8 patterns
- **TikTok comments by likes** in local language → MX/tarot 84K likes, TR/tarot 103K likes (engagement signal)
- **Reddit niche-subs (r/witchcraft, r/manifestation)** with `title=app` filter → 233-upvote "Duolingo for witchcraft" thread
- **Cross-country pattern detection** → Love8 broken in TR/BR/MX = key insight invisible from single-source
- **Multilingual complaint keyword bank** (trava/cobr/ücret/donuyor) → cluster complaint themes per cell

### What failed
- **Google Trends API**: HTML rate-limit on 100% of attempts after first 1-2 calls (3/3 batch attempts blocked). Burned ~30 min retrying with backoff before giving up.
- **r/Brasil + r/mexico + r/Turkey general country subs**: dominated by politics/news, low product signal. Niche subs (r/witchcraft etc.) much higher signal.
- **`q=` parameter on Arctic Shift**: doesn't exist; must use `title=` scoped to subreddit.
- **`sort=RATING` on google-play-scraper**: returns BEST first not worst (counter-intuitive). Must use `NEWEST` and filter score≤2.

### New metrics introduced
- TikTok hashtag `view_count` cumulative as niche size proxy
- Recent-low_pct (count of score≤2 in last 500 reviews / 500) as degrading-velocity signal
- Cross-country count (same appId in N countries) as leverage signal

### Hypotheses tested
- ✓ "Multilingual phrase banks for Reddit/TikTok find country-specific user voice" — VALIDATED
- ✓ "Cross-country pattern beats per-country analysis" — VALIDATED (Love8 finding)
- ✗ "Trends momentum is reliable" — FALSIFIED (rate-limited too aggressively)

### Hypotheses to test next run
- [ ] Replace Trends with TikTok hashtag WoW growth rate as momentum proxy
- [ ] Add competitor founder responsiveness as scoring signal
- [ ] Drill top 5 cells to 3000 reviews (Google's hard cap) for more thumbs-up signal density

### Scoring formula adjustments
- (Initial formula — baseline)

### User decision
- Direction picked: _not yet decided_

### Outcome
- _to be filled at 30/90 days_

---

## Run 2026-05-07 07:50 (exhaustive — expansion + revenue dimension)

### Configuration
- Tier: exhaustive (used 7h budget actively, not as ceiling)
- Mode: explore
- Hard cap: 35% weekly
- Limits at start: session 11%, weekly 13%
- Limits at end: session ~7%, weekly ~15% (only +2pp cost!)

### Top result
- #1 cell: TR/couple, score **17** (was 13 in previous run)
- Confidence: VERY HIGH
- $/MAU: **$6.0**
- Notable runner-up: SA/couple at $60/MAU/mo (whale market)

### What worked
- **Phase 1.5 ARPU + conversion research** (NEW) — flipped 3 cells in top 5, eliminated false positives like EG/astrology and ID/astrology that scored high on engagement but had low monetization
- **Founder background research subagent** (Phase 15) → discovered Love8 = anonymous Chongqing team that replies but doesn't fix → solo-displacement realism = MEDIUM
- **iOS cross-check via app-store-scraper** (Phase 14) → revealed Sleep Cycle TR iOS has **62% recent low_pct** (worse than Android 10.6%), no Turkish in iOS languages list
- **Drill top 5 to 3000 reviews** → BR/astrology Astrolink surfaced **157-thumbs review** on predatory billing (invisible at 500-review depth)
- **Niche expansion** (Phase 10): video_editing surfaced as huge vulnerability (CapCut BR 31.9% 1★)
- **Country expansion** (Phase 11): Arab markets (EG/SA/AE) and TH/couple all show buzzArab + Love8 spread → cross-country pattern broadens
- **Parallel agent dispatch** (session2 + ARPU research) — saved 1-2h wall time

### What failed
- **Google Trends**: still rate-limited 100% — DEFINITIVELY DOWNGRADE per ledger learnings
- **Initial 15-min wakeup pacing**: user explicitly corrected — "1 min, be active not waiting"
- **Synthesizer regenerates directions.md** every run, overwriting agent's creative fill — UX bug to fix
- **Some session2 niche subs** (Fitness, Vietnam, Philippines) returned 422 — sub names need verification

### New metrics introduced
- **monthly_rpu_usd** = country_ARPU × niche_multiplier — HIGH value (3 cells flipped in top 5)
- **conversion_rate** as separate boost — distinguishes EMEA/MENA from LATAM/SEA
- **cultural_risk** flag → −2 penalty (e.g. SA/astrology, EG/tarot) — correctly demoted false positives

### Hypotheses tested
- ✓ "Revenue dimension is critical" — VALIDATED (changed top 5 ranking dramatically)
- ✓ "Saudi/UAE are whale markets for couples" — VALIDATED ($60/$40 MAU)
- ✓ "Cultural risk filter needed for MENA × astrology/tarot" — VALIDATED
- ✓ "Drill 3000 reviews finds new high-thumbs quotes" — VALIDATED (157-thumbs on Astrolink)
- ✗ "ID/astrology TikTok 1.7M likes = strong" — FALSIFIED once revenue applied (low ARPU + low conv)
- ✗ "Hours = ceiling" — user corrected: "Hours = TARGET, fill the budget with deeper exploration"

### Hypotheses to test next run
- [ ] **TikTok hashtag WoW growth rate** as momentum proxy (replace failed Trends)
- [ ] **Reddit comment-tree fetch ratio** — does fetching trees on top threads boost insight density?
- [ ] **Per-state Trends breakdown** for big countries (BR-RJ vs BR-SP) — never attempted due to Trends rate limit
- [ ] **App store keyword search volume** as ASO signal — needs new tool/source
- [ ] **competitor founder responsiveness score** based on % of reviews replied to — see if it predicts displacement difficulty
- [ ] **MEA Arab markets cultural validation** — interview 5 Saudi/Emirati couples to validate "married couples app" framing for Direction 2 (Maktub)

### Scoring formula adjustments (proposed)
- ✅ ADD revenue dimension (DONE this run)
- ✅ ADD cultural_risk penalty (DONE this run)
- 🔬 **PROPOSED**: weight `cross_country_count` higher (currently +3) — Love8/buzzArab patterns suggest cross-country leverage is the strongest single predictor of viable directions. Test in next run.
- 🔬 **PROPOSED**: cap composite_score at 19 (current ceiling: 17 = TR/couple) so future runs have measurable room to exceed.
- 🔬 **PROPOSED**: penalize cells where ARPU researcher confidence = "L" (low) — currently treated equally with H confidence.

### User decision
- Direction picked: _not yet decided_

### Outcome
- _to be filled at 30/90 days_

---

## Methodology validation status (cross-run)

| Methodology element | Runs validated | Status |
|---|---|---|
| Composite scoring (vulnerability) | 2/2 | ✅ Stable |
| Cross-country pattern detection | 2/2 | ✅ Validated (Love8 4-country) |
| Multilingual complaint keywords | 2/2 | ✅ Validated |
| Drill top 5 to 3000 reviews | 1/1 | 🟡 Promising |
| Revenue × Vulnerability matrix | 1/1 | 🟡 Promising |
| iOS cross-check | 1/1 | 🟡 Promising |
| Founder background research | 1/1 | 🟡 Promising |
| Trends momentum signal | 0/2 (always rate-limited) | ❌ Unreliable — DOWNGRADE to optional |
| Cultural risk penalty (MENA × astrology/tarot) | 1/1 | 🟡 Promising |

A methodology element promotes from 🟡 to ✅ after 3 consecutive validation runs.
A methodology element demotes from ✅ to 🟡 if it fails to add signal in a run, and to ❌ after 2 consecutive failures.

---

## Open hypotheses register (carry forward)

These are unvalidated ideas the agent should attempt in future runs:

1. **Replace Trends with TikTok hashtag WoW growth rate** (momentum proxy)
2. **Reddit comment-tree fetching boosts insight density** (test by measuring quotable-quote count per thread)
3. **App Store keyword volume / ASO data** as new metric source
4. **Founder responsiveness score** = % of recent reviews developer replied to
5. **Per-state Trends breakdown** (when Trends finally works)
6. **In-market user interviews** — agent dispatches to find Reddit/Twitter/forum users in target market for direct DMs (ethical concern: opt-in only)
7. **Competitor revenue scraping** — Apptopia/Sensor Tower public summaries for direct revenue numbers
