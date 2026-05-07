# Graph Report - c:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings  (2026-05-07)

## Corpus Check
- Corpus is ~5,779 words - fits in a single context window. You may not need a graph.

## Summary
- 87 nodes · 155 edges · 8 communities (7 shown, 1 thin omitted)
- Extraction: 88% EXTRACTED · 12% INFERRED · 0% AMBIGUOUS · INFERRED: 19 edges (avg confidence: 0.81)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Generic Competitor Pool (LATAMAsia)|Generic Competitor Pool (LATAM/Asia)]]
- [[_COMMUNITY_Love8 Cross-Country Vulnerability|Love8 Cross-Country Vulnerability]]
- [[_COMMUNITY_Top Directions Couples Multi-Locale|Top Directions: Couples Multi-Locale]]
- [[_COMMUNITY_Turkish Localization Gap|Turkish Localization Gap]]
- [[_COMMUNITY_Methodology & Process Log|Methodology & Process Log]]
- [[_COMMUNITY_Skills & Project Infrastructure|Skills & Project Infrastructure]]
- [[_COMMUNITY_Vietnam First-Mover Opportunity|Vietnam First-Mover Opportunity]]
- [[_COMMUNITY_Isolated Manifestation|Isolated: Manifestation]]

## God Nodes (most connected - your core abstractions)
1. `Direction 1: Cift TR couples` - 15 edges
2. `Directions Report 2026-05-07` - 11 edges
3. `Love8 Casais (BR)` - 10 edges
4. `Predatory billing / subscription` - 10 edges
5. `Love8 Çiftler (TR)` - 9 edges
6. `Astrolink BR` - 9 edges
7. `Direction 2: Pareja MX couples` - 9 edges
8. `Direction 4: Uyku Turkce TR sleep` - 9 edges
9. `Direction 5: Yeu VN couples` - 9 edges
10. `Love8 Parejas (MX)` - 8 edges

## Surprising Connections (you probably didn't know these)
- `Phase C: Synthesis + graphify` --rationale_for--> `Directions Report 2026-05-07`  [INFERRED]
  findings/reports/methodology.md → findings/reports/directions.md
- `Predatory billing / subscription` --semantically_similar_to--> `IAP-locked features`  [INFERRED] [semantically similar]
  findings/reports/directions.md → findings/reports/drill_analysis.txt
- `Sleep Cycle Turkish (TR)` --semantically_similar_to--> `Finch Self-Care Pet (BR)`  [INFERRED] [semantically similar]
  findings/reports/directions.md → findings/reports/drill_analysis.txt
- `Honorable: BR/astrology Astrolink billing` --references--> `Astrolink BR`  [EXTRACTED]
  findings/reports/directions.md → findings/reports/drill_analysis.txt
- `Findings README` --references--> `Final Verdict Matrix`  [EXTRACTED]
  findings/README.md → findings/reports/FINAL_VERDICT.txt

## Hyperedges (group relationships)
- **Love8 broken cross-country pattern** — app_love8_tr, app_love8_mx, app_love8_br, complaint_location_tracking, complaint_billing [INFERRED 0.95]
- **Multi-locale couples codebase play** — direction_1_cift_tr, direction_2_pareja_mx, direction_3_casal_br, direction_5_yeu_vn, thesis_cross_country_codebase [INFERRED 0.90]
- **Turkish localization gap across niches** — country_tr, complaint_language_gap, app_sleep_cycle_tr, app_yodha_tr, honorable_tr_tarot [INFERRED 0.85]
- **Predatory billing pattern across apps** — complaint_billing, app_love8_tr, app_tinder_vn, app_astrolink_br, app_remente_id [INFERRED 0.90]
- **Anti-surveillance value proposition** — thesis_no_tracking, thesis_one_time_pricing, complaint_location_tracking, complaint_kidnapping_safety, thesis_e2e_journal [INFERRED 0.88]

## Communities (8 total, 1 thin omitted)

### Community 0 - "Generic Competitor Pool (LATAM/Asia)"
Cohesion: 0.14
Nodes (16): Astrolink Carta Astral (MX), Astroscope (ID), Bumble (ID), Couple Joy (PH), Remente (ID), Indonesia (ID), Mexico (MX), Philippines (PH) (+8 more)

### Community 1 - "Love8 Cross-Country Vulnerability"
Cohesion: 0.27
Nodes (16): Astrolink BR, Love8 Casais (BR), Love8 Parejas (MX), Love8 Çiftler (TR), AI-generated content complaint, Predatory billing / subscription, Crashes and bugs, IAP-locked features (+8 more)

### Community 2 - "Top Directions: Couples Multi-Locale"
Cohesion: 0.18
Nodes (14): Kidnapping safety fear (MX), Direction 1: Cift TR couples, Direction 2: Pareja MX couples, Cift TR 149TRY lifetime, Pareja MX 5USD lifetime, Uyku TR 99TRY lifetime, Quote: tengo miedo de que me secuestren MX, Quote: 580km/h phantom trips TR (+6 more)

### Community 3 - "Turkish Localization Gap"
Cohesion: 0.27
Nodes (12): Finch Self-Care Pet (BR), Labyrinthos Tarot (TR), Sleep Cycle Turkish (TR), Yodha Astrolojim (TR), Language localization gap, Samsung Health Connect missing, Turkey (TR), Direction 4: Uyku Turkce TR sleep (+4 more)

### Community 4 - "Methodology & Process Log"
Cohesion: 0.17
Nodes (12): Drill Analysis (500 reviews), 35% weekly cap checkpoint, Phase A: New niche exploration, Phase B: Drill refinement, Phase C: Synthesis + graphify, Methodology Report 2026-05-07, Skipped: IN, EG (low ARPU), Skipped: habit/period/mood trackers (+4 more)

### Community 5 - "Skills & Project Infrastructure"
Cohesion: 0.22
Nodes (9): Analyzed Folder, Raw Findings Folder, Reports Folder, Findings README, app-radar Skill, google-trends Skill, google-play-reviews Skill, reddit-search Skill (+1 more)

### Community 6 - "Vietnam First-Mover Opportunity"
Cohesion: 0.33
Nodes (7): Tinder VN, Vietnam (VN), Direction 5: Yeu VN couples, Casal BR R$24.90 lifetime, Yeu VN 99,000 VND lifetime, Quote: app bip lam VN Tinder scam, First-mover empty category thesis (VN)

## Knowledge Gaps
- **29 isolated node(s):** `Raw Findings Folder`, `Analyzed Folder`, `Reports Folder`, `Drill Analysis (500 reviews)`, `google-play-reviews Skill` (+24 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Directions Report 2026-05-07` connect `Generic Competitor Pool (LATAM/Asia)` to `Love8 Cross-Country Vulnerability`, `Top Directions: Couples Multi-Locale`, `Turkish Localization Gap`, `Methodology & Process Log`, `Vietnam First-Mover Opportunity`?**
  _High betweenness centrality (0.232) - this node is a cross-community bridge._
- **Why does `Final Verdict Matrix` connect `Love8 Cross-Country Vulnerability` to `Generic Competitor Pool (LATAM/Asia)`, `Skills & Project Infrastructure`?**
  _High betweenness centrality (0.222) - this node is a cross-community bridge._
- **Why does `Direction 1: Cift TR couples` connect `Top Directions: Couples Multi-Locale` to `Generic Competitor Pool (LATAM/Asia)`, `Love8 Cross-Country Vulnerability`, `Turkish Localization Gap`, `Vietnam First-Mover Opportunity`?**
  _High betweenness centrality (0.176) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `Love8 Casais (BR)` (e.g. with `Love8 Parejas (MX)` and `Love8 Çiftler (TR)`) actually correct?**
  _`Love8 Casais (BR)` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `Predatory billing / subscription` (e.g. with `IAP-locked features` and `Refund denied / support issues`) actually correct?**
  _`Predatory billing / subscription` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `Love8 Çiftler (TR)` (e.g. with `Love8 Parejas (MX)` and `Love8 Casais (BR)`) actually correct?**
  _`Love8 Çiftler (TR)` has 3 INFERRED edges - model-reasoned connections that need verification._
- **What connects `Raw Findings Folder`, `Analyzed Folder`, `Reports Folder` to the rest of the system?**
  _29 weakly-connected nodes found - possible documentation gaps or missing edges._