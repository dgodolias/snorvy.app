# Methodology — exhaustive run 2026-05-07

## Config

| Param | Value |
|---|---|
| Tier | exhaustive (7h budget) |
| Mode | explore (discovery) |
| Hard cap | stop at 35% weekly all-models |
| Started | 2026-05-07 00:47 (session 11%, weekly 13%) |
| User | Greek (Demos), playstore_app project |

## Coverage gaps identified

Existing matrix: **20 cells** = 5 niches × 4 countries
- Niches: astrology, couple, manifestation, selfcare, tarot
- Countries: BR, ID, MX, TR

## Plan (autonomous, no user check-ins)

### NEW exploration (priority A)
- 4 new niches: **journaling, meditation, sleep, fitness** × 4 existing countries = 16 cells
- 2 new countries: **VN, PH** × 5 existing niches = 10 cells
- Total new cells: ~26

### REFINEMENT (priority B)
- Drill top 5 EXISTING cells (TR/couple, MX/couple, BR/astrology, BR/couple, TR/tarot) to 1500 reviews each (3x current depth)
- Pull comment-tree on top viral Reddit threads in those niches

### Synthesis (priority C)
- Re-run synthesize.mjs after each phase
- Cross-validate top winners across Play Store + TikTok + Reddit
- Final directions.md with refined top 5 (some may shift, some new directions may surface)
- Graphify with full LLM extraction + wiki

## Decisions log (autonomous)

- **Skipped niches**: habit_tracker, period_tracker, mood_tracker — TikTok footprint <1B views per earlier finding, won't yield TikTok-marketable directions. Documented as known gap.
- **Skipped Google Trends Phase 2**: heavy rate-limits, low value. Will use TikTok view_count + Play Store install ranges as momentum surrogates.
- **Skipped IN, EG**: low ARPU vs effort.
- **Country pick rationale (VN, PH)**: high Android share, growing Android markets, English+local language, low CPI for $350 ad budget.

## Limit checkpoints

Re-checking `/limits` before each heavy phase. Stopping cleanly if weekly all-models ≥ 35%. Will write `findings/reports/STOPPED.md` if cap triggers.

## Live progress

(To be appended as phases complete.)
