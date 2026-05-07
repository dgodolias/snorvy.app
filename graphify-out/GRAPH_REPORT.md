# Graph Report - playstore_app  (2026-05-07)

## Corpus Check
- 14 files · ~47,323 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 194 nodes · 283 edges · 11 communities detected
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 12 edges (avg confidence: 0.78)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 22|Community 22]]

## God Nodes (most connected - your core abstractions)
1. `Love8 - App for Couples` - 17 edges
2. `App-Radar Directions Report v3` - 12 edges
3. `Run Ledger - Evolution Log` - 12 edges
4. `Country ARPU (per user / yr)` - 12 edges
5. `Maktub Cultural Validation` - 11 edges
6. `Sleep Cycle AB (Nasdaq SLEEP)` - 11 edges
7. `Labyrinthos Tarot Cards` - 11 edges
8. `Market Economics: Country x Niche Revenue` - 10 edges
9. `Morning Briefing v2` - 10 edges
10. `buzzArab MENA Dating` - 10 edges

## Surprising Connections (you probably didn't know these)
- `Duolingo` --references--> `Morning Briefing v2`  [INFERRED]
  findings/raw/market_economics.md → findings/reports/morning-briefing.md
- `Halal Matrimonial` --semantically_similar_to--> `Dating Apps`  [INFERRED] [semantically similar]
  findings/raw/maktub_cultural_validation.md → findings/raw/market_economics.md
- `Lifetime Unlock (₺149 / R$/peso) Pricing` --conceptually_related_to--> `$/MAU/month`  [INFERRED]
  findings/reports/directions.md → findings/raw/market_economics.md
- `TH/couple cell` --references--> `Love8 - App for Couples`  [EXTRACTED]
  findings/reports/directions.md → findings/raw/competitor_revenues.md
- `Love8 TR 20.9% 1-star, 7516 1-star reviews` --references--> `Love8 - App for Couples`  [EXTRACTED]
  findings/reports/FINAL_VERDICT.txt → findings/raw/competitor_revenues.md

## Hyperedges (group relationships)
- **v2 to v3 thesis falsification cluster** — hyp_sleep_cycle_no_tr, hyp_mena_30_60_mau, fact_sleep_cycle_has_tr, fact_buzzarab_ad_only, fact_sleep_cycle_2_25_mau, subagent_cultural_validation, subagent_localization_audit, directions_v3_doc [INFERRED 0.92]
- **Cross-country Love8 displacement opportunity** — love8_app, cell_tr_couple, cell_mx_couple, cell_br_couple, cell_th_couple, direction_1_cift, direction_2_pareja_casal, metric_cross_country_count [INFERRED 0.95]
- **MENA matrimonial vs couples-care gap** — buzzarab_app, mawada_app, muzz_app, salams_app, alkhattaba_app, ana_wa_anta_app, direction_4_maktub, fact_buzzarab_ad_only, niche_matrimonial, niche_couple [INFERRED 0.90]
- **Sleep Cycle as revenue anchor** — sleep_cycle_ab, fact_sleep_cycle_24_7m_arr, fact_sleep_cycle_2_25_mau, fact_couples_multiplier_revision, metric_dollar_per_mau, hyp_sleep_cycle_anchor, hyp_mena_30_60_mau [INFERRED 0.93]
- **Self-evolving methodology with run ledger** — run_ledger_doc, phase_0_read_ledger, phase_11_country_expand, phase_12_validate, memory_system, feedback_methodology_md, run_2026_05_06, run_2026_05_07_morning, run_2026_05_07_continuation, thesis_self_evolving_methodology [INFERRED 0.95]
- **TR tarot competitive landscape (Faladdin vs Labyrinthos)** — faladdin_app, labyrinthos_app, fact_labyrinthos_v260_machine_tr, fact_tr_tarot_volume_very_high, thesis_tarot_learning_vs_reading, direction_5_tarot_turkce, country_tr [INFERRED 0.90]
- **Solo-displacement realism matrix across 5 competitors** — love8_app, astrolink_app, sleep_cycle_ab, labyrinthos_app, tinder_app, displacement_medium_love8, displacement_low_astrolink, displacement_very_low_sleep, displacement_zero_tinder, metric_founder_responsiveness [INFERRED 0.88]
- **Revenue x Vulnerability composite scoring system** — metric_arpu, metric_niche_multiplier, metric_conversion_rate, metric_dollar_per_mau, metric_one_star_pct, metric_low_pct, metric_composite_score, metric_cultural_validation, thesis_revenue_x_vulnerability [INFERRED 0.92]

## Communities

### Community 0 - "Community 0"
Cohesion: 0.12
Nodes (23): ana wa anta - You and I for Married Couples, BR/astrology cell, BR/couple cell, MX/couple cell, TR/couple cell (score 17), Chongqing Daole Er Technology Co Ltd, Brazil (BR), Mexico (MX) (+15 more)

### Community 1 - "Community 1"
Cohesion: 0.11
Nodes (23): ID/couple cell, TH/couple cell, VN/couple cell, Indonesia (ID), Philippines (PH), Thailand (TH), Vietnam (VN), Direction 3: Yêu - Vietnam First Couples (+15 more)

### Community 2 - "Community 2"
Cohesion: 0.13
Nodes (21): Arctic Shift Reddit Mirror, CapCut (ByteDance), feedback_research_methodology.md, google-play-scraper Library, Google Trends API (rate-limited), HYP: Cross-country Love8 displacement (VALIDATED), HYP: Trends momentum signal (FAILED 2/2), Project Memory System (~/.claude/projects/.../memory) (+13 more)

### Community 3 - "Community 3"
Cohesion: 0.13
Nodes (20): ASO Keyword Volume Research, Astrolink Brazilian Astrology, Solo-Displacement LOW-MED (Astrolink), Drill Analysis Results, Fabio Principe (Astrolink operator), BR mapa astral Very High volume (#4 globally), Faladdin 25M users TR-anchored, TR tarot ASO volume Very High (matrix peak) (+12 more)

### Community 4 - "Community 4"
Cohesion: 0.12
Nodes (18): AlKhattaba (الخطابة) Egyptian Matrimonial, Campaign Middle East Saudi Gen Z Playbook, Couples app form factor is Korean-American import, No Saudi/UAE dev shipped post-marriage couples app, No organic Arabic discourse for couples-care app, HYP: Cultural risk MENA × astrology penalty (VALIDATED), HYP: Subjective deliverable-complete stop (PROHIBITED), Maktub Cultural Validation (+10 more)

### Community 5 - "Community 5"
Cohesion: 0.17
Nodes (17): TR/sleep cell, TR/tarot cell, Turkey (TR), Direction 5: Tarot Türkçe - Native TR Tarot, App-Radar Directions Report v3, Labyrinthos v2.60 (Jun 2025) admits machine-translated TR/TH, Sleep Cycle DOES support Turkish iOS+Android, Love8 TR 20.9% 1-star, 7516 1-star reviews (+9 more)

### Community 6 - "Community 6"
Cohesion: 0.16
Nodes (16): Competitor Backgrounds Founder Research, Competitor Revenue Scrape, Solo-Displacement VERY LOW (Sleep Cycle / Labyrinthos), Solo-Displacement ZERO (Tinder), Couples multiplier revised 4x -> 3x, Sleep Cycle FY2024 $24.7M ARR / 918K subs, Sleep Cycle $2.25/MAU/mo anchor, HYP: Sleep Cycle $2.25/MAU revenue anchor (VALIDATED) (+8 more)

### Community 7 - "Community 7"
Cohesion: 0.18
Nodes (16): buzzArab MENA Dating, AE/couple cell, EG/couple cell, SA/couple cell, United Arab Emirates (AE), Egypt (EG), Saudi Arabia (SA), Direction 4: Maktub - Arab Married Couples (DOWNGRADED) (+8 more)

### Community 8 - "Community 8"
Cohesion: 0.18
Nodes (11): AppsFlyer Global ARPU averages, Co-Star Astrology, DramaBox / ReelShort short drama, Duolingo, RevenueCat global avg DL->paid 30d = 1.7%, Market Economics: Country x Niche Revenue, Photoroom AI Editor, RevenueCat State of Subscription Apps 2025 (+3 more)

### Community 10 - "Community 10"
Cohesion: 0.83
Nodes (3): fetch_comments(), fetch_json(), search_videos()

### Community 22 - "Community 22"
Cohesion: 1.0
Nodes (1): Phase 10: Niche Expansion

## Knowledge Gaps
- **49 isolated node(s):** `Findings README`, `Love8 Team / Love Elves`, `Sherif Omar (buzzArab founder)`, `ORBE VENTURES LTDA (CNPJ 53.277.567/0001-76)`, `Fabio Principe (Astrolink operator)` (+44 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **Thin community `Community 22`** (1 nodes): `Phase 10: Niche Expansion`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `App-Radar Directions Report v3` connect `Community 5` to `Community 0`, `Community 1`, `Community 2`, `Community 6`, `Community 7`?**
  _High betweenness centrality (0.161) - this node is a cross-community bridge._
- **Why does `Love8 - App for Couples` connect `Community 0` to `Community 1`, `Community 2`, `Community 3`, `Community 5`, `Community 6`?**
  _High betweenness centrality (0.137) - this node is a cross-community bridge._
- **Why does `Run Ledger - Evolution Log` connect `Community 2` to `Community 1`, `Community 4`, `Community 5`?**
  _High betweenness centrality (0.121) - this node is a cross-community bridge._
- **What connects `Findings README`, `Love8 Team / Love Elves`, `Sherif Omar (buzzArab founder)` to the rest of the system?**
  _49 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.12 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.11 - nodes in this community are weakly interconnected._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.13 - nodes in this community are weakly interconnected._