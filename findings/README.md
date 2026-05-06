# Research Findings

App-idea validation research output. Standardized layout produced by the `validate-app-idea` skill and the four primitive research skills.

## Layout

```
findings/
├── raw/                  ← unprocessed JSON from each data source
│   ├── play-store/       ← google-play-reviews skill writes here
│   ├── tiktok/           ← tiktok-search skill writes here
│   ├── reddit/           ← reddit-search skill writes here
│   └── trends/           ← google-trends skill writes here
├── analyzed/             ← cross-source synthesis (matrices, theme clusters)
│   └── (run synthesize.mjs / analyze_*.py from /scripts to populate)
└── reports/              ← human-readable summaries
    └── FINAL_VERDICT.txt
```

## Naming convention for raw/

Use slugged identifiers so files don't collide:

| Source | Pattern | Example |
|---|---|---|
| play-store/search | `search-<term>-<country>.json` | `search-mapa-astral-br.json` |
| play-store/app | `app-<appId>-<country>.json` | `app-com.astrolink.webapp-br.json` |
| play-store/reviews | `reviews-<appId>-<country>.json` | `reviews-com.astrolink.webapp-br.json` |
| tiktok/hashtag | `hashtag-<name>.json` | `hashtag-manifestation.json` |
| tiktok/search | `search-<term>-<region>.json` | `search-astrologia-BR.json` |
| tiktok/comments | `comments-<videoId>.json` | `comments-7635764437227474207.json` |
| reddit/posts | `posts-<sub>-<query>.json` | `posts-witchcraft-app.json` |
| reddit/tree | `tree-<postId>.json` | `tree-1cz0djk.json` |
| trends/over-time | `overtime-<keywords-slug>-<geo>.json` | `overtime-mapa-astral-BR.json` |
| trends/by-region | `byregion-<keyword>.json` | `byregion-habit-tracker.json` |

## Current state

This folder contains the exhaustive scan from 2026-05-06. See [reports/FINAL_VERDICT.txt](reports/FINAL_VERDICT.txt) for the synthesis.
