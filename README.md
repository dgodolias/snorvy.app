# Playstore App — Research & Build

Solo-developer app validation project. Currently in research phase.

## Layout

```
.
├── findings/         ← all research output (raw + analyzed + reports)
├── scripts/          ← reusable analysis/synthesis scripts
├── archive/          ← old iterations, logs, broken scripts
└── README.md
```

## Skills involved

Stored at `~/.claude/skills/` (global, reusable across projects):

| Skill | Role |
|---|---|
| `reddit-search` | Read Reddit posts/comments via Arctic Shift archive |
| `tiktok-search` | Read TikTok videos/comments/hashtags via Tikwm |
| `google-play-reviews` | Read Play Store reviews/metadata/search/charts via google-play-scraper |
| `google-trends` | Read search-interest signals via google-trends-api (heavily rate-limited — best-effort) |
| `app-radar` | **Discovery orchestrator** — synthesizes all sources into ranked top-5 app directions. Tier dropdown: `0h` (re-synth only) / `quick` / `medium` / `deep` / `exhaustive` |

## Current verdict (2026-05-06)

See [findings/reports/FINAL_VERDICT.txt](findings/reports/FINAL_VERDICT.txt).

**TL;DR**: Couples app, no-tracking thesis, launch in TR first then BR/MX. Love8 (5M+ installs in each) has 20.9% one-star ratio in Turkey with cross-country complaint pattern (location lies, refund denials, dark-pattern billing).

## How to re-run research

```bash
# In Claude Code:
/app-radar
# → asks for /limits check, then tier dropdown, then runs
```

For 0-hour re-synthesis (no new scans, just re-rank existing findings): pick `0h` tier.
For one-off lookups, hit any primitive skill directly.

## Output

`findings/reports/directions.md` — the deliverable. Top 5 app directions, each with:
- Niche × country + target competitor to displace
- Quoted user-voice proof (Play Store + TikTok + Reddit)
- Differentiation thesis + idea spec + monetization + 30-day plan
- Confidence rating

## Notes for future agents

- **Read this file first.** It tells you where things are.
- **Findings are append-only**. Don't overwrite existing `findings/raw/` files; new scans go alongside.
- **Use the depth tier** that matches the user's time budget — see `app-radar` SKILL.md for tier→params mapping.
- **The "manifestation" niche cooled in BR but exploded globally**. Cross-validate niches per country before committing.
