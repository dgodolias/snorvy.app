# Graph Report - c:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings  (2026-05-07)

## Corpus Check
- Corpus is ~14,422 words - fits in a single context window. You may not need a graph.

## Summary
- 164 nodes · 263 edges · 10 communities (9 shown, 1 thin omitted)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 12 edges (avg confidence: 0.78)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Tooling Infrastructure & Skill System|Tooling Infrastructure & Skill System]]
- [[_COMMUNITY_Love8 Cluster + LATAM Couples Markets|Love8 Cluster + LATAM Couples Markets]]
- [[_COMMUNITY_Turkish Niche Cluster (couplesleeptarot)|Turkish Niche Cluster (couple/sleep/tarot)]]
- [[_COMMUNITY_SEA + Pacific Markets (IDPHVNTH)|SEA + Pacific Markets (ID/PH/VN/TH)]]
- [[_COMMUNITY_Competitor Research + Revenue Revisions|Competitor Research + Revenue Revisions]]
- [[_COMMUNITY_MENA Arab Markets (buzzArab + SAAEEG)|MENA Arab Markets (buzzArab + SA/AE/EG)]]
- [[_COMMUNITY_Cultural Validation Findings (Maktub research)|Cultural Validation Findings (Maktub research)]]
- [[_COMMUNITY_Brazilian Astrology Cluster (Astrolink)|Brazilian Astrology Cluster (Astrolink)]]
- [[_COMMUNITY_Global Benchmarks (AppsFlyerRevenueCatDuolingo)|Global Benchmarks (AppsFlyer/RevenueCat/Duolingo)]]
- [[_COMMUNITY_Phase 10 Niche Expansion|Phase 10 Niche Expansion]]

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

## Communities (10 total, 1 thin omitted)

### Community 0 - "Tooling Infrastructure & Skill System"
Cohesion: 0.12
Nodes (24): Arctic Shift Reddit Mirror, CapCut (ByteDance), App-Radar Directions Report v3, feedback_research_methodology.md, google-play-scraper Library, Google Trends API (rate-limited), Graphify Knowledge Graph Layer, HYP: Cross-country Love8 displacement (VALIDATED) (+16 more)

### Community 1 - "Love8 Cluster + LATAM Couples Markets"
Cohesion: 0.12
Nodes (23): ana wa anta - You and I for Married Couples, BR/astrology cell, BR/couple cell, MX/couple cell, TR/couple cell (score 17), Chongqing Daole Er Technology Co Ltd, Brazil (BR), Mexico (MX) (+15 more)

### Community 2 - "Turkish Niche Cluster (couple/sleep/tarot)"
Cohesion: 0.13
Nodes (22): ASO Keyword Volume Research, TR/sleep cell, TR/tarot cell, Turkey (TR), Direction 5: Tarot Türkçe - Native TR Tarot, BR mapa astral Very High volume (#4 globally), Faladdin 25M users TR-anchored, Labyrinthos v2.60 (Jun 2025) admits machine-translated TR/TH (+14 more)

### Community 3 - "SEA + Pacific Markets (ID/PH/VN/TH)"
Cohesion: 0.13
Nodes (21): ID/couple cell, TH/couple cell, VN/couple cell, Indonesia (ID), Philippines (PH), Thailand (TH), Vietnam (VN), Direction 3: Yêu - Vietnam First Couples (+13 more)

### Community 4 - "Competitor Research + Revenue Revisions"
Cohesion: 0.14
Nodes (18): Competitor Backgrounds Founder Research, Competitor Revenue Scrape, Solo-Displacement VERY LOW (Sleep Cycle / Labyrinthos), Solo-Displacement ZERO (Tinder), Couples multiplier revised 4x -> 3x, Sleep Cycle FY2024 $24.7M ARR / 918K subs, Sleep Cycle $2.25/MAU/mo anchor, HYP: Sleep Cycle $2.25/MAU revenue anchor (VALIDATED) (+10 more)

### Community 5 - "MENA Arab Markets (buzzArab + SA/AE/EG)"
Cohesion: 0.18
Nodes (16): buzzArab MENA Dating, AE/couple cell, EG/couple cell, SA/couple cell, United Arab Emirates (AE), Egypt (EG), Saudi Arabia (SA), Direction 4: Maktub - Arab Married Couples (DOWNGRADED) (+8 more)

### Community 6 - "Cultural Validation Findings (Maktub research)"
Cohesion: 0.15
Nodes (15): AlKhattaba (الخطابة) Egyptian Matrimonial, Campaign Middle East Saudi Gen Z Playbook, Couples app form factor is Korean-American import, No Saudi/UAE dev shipped post-marriage couples app, No organic Arabic discourse for couples-care app, HYP: Cultural risk MENA × astrology penalty (VALIDATED), Maktub Cultural Validation, Mawada Halal Matrimonial (+7 more)

### Community 7 - "Brazilian Astrology Cluster (Astrolink)"
Cohesion: 0.18
Nodes (13): Astrolink Brazilian Astrology, Solo-Displacement LOW-MED (Astrolink), Drill Analysis Results, Fabio Principe (Astrolink operator), Final Verdict Matrix, Finch Self-Care Pet, Findings README, Astrology (+5 more)

### Community 8 - "Global Benchmarks (AppsFlyer/RevenueCat/Duolingo)"
Cohesion: 0.18
Nodes (11): AppsFlyer Global ARPU averages, Co-Star Astrology, DramaBox / ReelShort short drama, Duolingo, RevenueCat global avg DL->paid 30d = 1.7%, Market Economics: Country x Niche Revenue, Photoroom AI Editor, RevenueCat State of Subscription Apps 2025 (+3 more)

## Knowledge Gaps
- **49 isolated node(s):** `Findings README`, `Love8 Team / Love Elves`, `Sherif Omar (buzzArab founder)`, `ORBE VENTURES LTDA (CNPJ 53.277.567/0001-76)`, `Fabio Principe (Astrolink operator)` (+44 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `App-Radar Directions Report v3` connect `Tooling Infrastructure & Skill System` to `Love8 Cluster + LATAM Couples Markets`, `Turkish Niche Cluster (couple/sleep/tarot)`, `SEA + Pacific Markets (ID/PH/VN/TH)`, `Competitor Research + Revenue Revisions`, `MENA Arab Markets (buzzArab + SA/AE/EG)`?**
  _High betweenness centrality (0.211) - this node is a cross-community bridge._
- **Why does `Love8 - App for Couples` connect `Love8 Cluster + LATAM Couples Markets` to `Tooling Infrastructure & Skill System`, `Turkish Niche Cluster (couple/sleep/tarot)`, `SEA + Pacific Markets (ID/PH/VN/TH)`, `Competitor Research + Revenue Revisions`, `Brazilian Astrology Cluster (Astrolink)`?**
  _High betweenness centrality (0.188) - this node is a cross-community bridge._
- **Why does `Country ARPU (per user / yr)` connect `SEA + Pacific Markets (ID/PH/VN/TH)` to `Love8 Cluster + LATAM Couples Markets`, `Turkish Niche Cluster (couple/sleep/tarot)`, `MENA Arab Markets (buzzArab + SA/AE/EG)`?**
  _High betweenness centrality (0.152) - this node is a cross-community bridge._
- **What connects `Findings README`, `Love8 Team / Love Elves`, `Sherif Omar (buzzArab founder)` to the rest of the system?**
  _49 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Tooling Infrastructure & Skill System` be split into smaller, more focused modules?**
  _Cohesion score 0.12 - nodes in this community are weakly interconnected._
- **Should `Love8 Cluster + LATAM Couples Markets` be split into smaller, more focused modules?**
  _Cohesion score 0.12 - nodes in this community are weakly interconnected._
- **Should `Turkish Niche Cluster (couple/sleep/tarot)` be split into smaller, more focused modules?**
  _Cohesion score 0.13 - nodes in this community are weakly interconnected._