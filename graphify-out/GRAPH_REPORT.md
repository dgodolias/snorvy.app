# Graph Report - c:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings  (2026-05-07)

## Corpus Check
- Corpus is ~2,964 words - fits in a single context window. You may not need a graph.

## Summary
- 59 nodes · 111 edges · 8 communities
- Extraction: 82% EXTRACTED · 18% INFERRED · 0% AMBIGUOUS · INFERRED: 20 edges (avg confidence: 0.82)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Generic Competitor Pool|Generic Competitor Pool]]
- [[_COMMUNITY_Love8 Cross-Country Vulnerability|Love8 Cross-Country Vulnerability]]
- [[_COMMUNITY_Research Methodology & Sources|Research Methodology & Sources]]
- [[_COMMUNITY_TRCouple Winner Verdict|TR/Couple Winner Verdict]]
- [[_COMMUNITY_Pricing & Billing Complaint Cluster|Pricing & Billing Complaint Cluster]]
- [[_COMMUNITY_Brazilian Portuguese Language Gap|Brazilian Portuguese Language Gap]]
- [[_COMMUNITY_Brazil Manifestation Niche|Brazil Manifestation Niche]]
- [[_COMMUNITY_AI Generative Content Backlash|AI Generative Content Backlash]]

## God Nodes (most connected - your core abstractions)
1. `Astrolink - Mapa Astral (BR)` - 13 edges
2. `Love8 - Ciftler icin uygulama (TR)` - 11 edges
3. `Love8 - App para casais (BR)` - 9 edges
4. `Love8 - App para parejas (MX)` - 9 edges
5. `Verdict: viral_engagement` - 8 edges
6. `Finch: Self-Care Pet (BR)` - 7 edges
7. `Top Recommendation: TR/couple` - 7 edges
8. `Findings Folder Layout` - 6 edges
9. `Location Tracking Inaccuracy` - 6 edges
10. `Brazil (BR)` - 5 edges

## Surprising Connections (you probably didn't know these)
- `Astrolink - Mapa Astral (BR)` --semantically_similar_to--> `Astrolink - Carta Astral (MX)`  [INFERRED] [semantically similar]
  findings/reports/drill_analysis.txt → findings/reports/FINAL_VERDICT.txt
- `Play Store Data Source` --shares_data_with--> `Love8 - Ciftler icin uygulama (TR)`  [INFERRED]
  findings/README.md → findings/reports/FINAL_VERDICT.txt
- `Play Store Data Source` --shares_data_with--> `Astrolink - Mapa Astral (BR)`  [INFERRED]
  findings/README.md → findings/reports/drill_analysis.txt
- `Premium Purchase Doesn't Unlock` --conceptually_related_to--> `Refund Denied`  [INFERRED]
  findings/reports/drill_analysis.txt → findings/reports/FINAL_VERDICT.txt
- `Verdict: high_recent_complaints` --conceptually_related_to--> `Rationale: low_pct 35.6% degrading`  [INFERRED]
  findings/reports/FINAL_VERDICT.txt → findings/reports/recommendation.md

## Hyperedges (group relationships)
- **Love8 broken across TR, BR, MX (location bug pattern)** — app_love8_tr, app_love8_br, app_love8_mx, complaint_location_inaccuracy [INFERRED 0.90]
- **Generative AI backlash across selfcare and astrology niches (Finch + Astrolink)** — app_finch_br, app_astrolink_br, complaint_ai_generative, complaint_crashes_bugs [INFERRED 0.80]
- **TR/couple top pick: Love8 vulnerability + viral TikTok niche + degrading metrics** — recommendation_top_cell_tr_couple, app_love8_tr, rationale_vulnerable_competitor, rationale_degrading_competitor, rationale_mega_tiktok_niche [EXTRACTED 1.00]

## Communities (8 total, 0 thin omitted)

### Community 0 - "Generic Competitor Pool"
Cohesion: 0.21
Nodes (14): Astrolink - Carta Astral (MX), Astroscope: Panduan Astrologi (ID), Bumble - Dating & Make Friends (ID), Catzy: Viaje de autocuidado (MX), Labyrinthos: Lecturas de Tarot (MX), Tarot Card Reading and Meaning / Labyrinthos (TR), Yodha Astrolojim ve Burcum (TR), Indonesia (ID) (+6 more)

### Community 1 - "Love8 Cross-Country Vulnerability"
Cohesion: 0.27
Nodes (14): Love8 - App para casais (BR), Love8 - App para parejas (MX), Love8 - Ciftler icin uygulama (TR), Location Tracking Inaccuracy, Premium Purchase Doesn't Unlock, Refund Denied, Composite Score 6 - BR/couple, Composite Score 6 - MX/couple (+6 more)

### Community 2 - "Research Methodology & Sources"
Cohesion: 0.25
Nodes (8): Rationale: 649.9B TikTok views mega niche, Findings Folder Layout, Play Store Data Source, Reddit Data Source, Exhaustive Scan 2026-05-06, TikTok Data Source, Google Trends Data Source, validate-app-idea Skill

### Community 3 - "TR/Couple Winner Verdict"
Cohesion: 0.33
Nodes (6): Composite Score 8 - TR/couple, Rationale: low_pct 35.6% degrading, Rationale: 1-star ratio 20.9%, Top Recommendation: TR/couple, Verdict: high_recent_complaints, Verdict: vulnerable_competitor

### Community 4 - "Pricing & Billing Complaint Cluster"
Cohesion: 0.5
Nodes (5): Astrolink - Mapa Astral (BR), Remente: Self Care, Wellbeing (ID), IAP Locked Features, Pricing/Billing Complaints, Composite Score 6 - BR/astrology

### Community 5 - "Brazilian Portuguese Language Gap"
Cohesion: 0.83
Nodes (4): Finch: Self-Care Pet (BR), Missing Native Language Support, Self-care Niche, Quote BR Finch: not in Portuguese

### Community 6 - "Brazil Manifestation Niche"
Cohesion: 0.5
Nodes (4): Lei da Atracao - Manifestar (BR), Me+ Agenda de Rotina Diaria (BR), Brazil (BR), Manifestation Niche

### Community 7 - "AI Generative Content Backlash"
Cohesion: 0.67
Nodes (4): AI Generative Content Complaints, Crashes and Bugs, Quote BR Astrolink: AI cannot read available info, learning bug, Quote BR Finch: uses generative AI for ads/code

## Knowledge Gaps
- **10 isolated node(s):** `validate-app-idea Skill`, `Reddit Data Source`, `Google Trends Data Source`, `Exhaustive Scan 2026-05-06`, `Manifestation Niche` (+5 more)
  These have ≤1 connection - possible missing edges or undocumented components.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Astrolink - Mapa Astral (BR)` connect `Pricing & Billing Complaint Cluster` to `Generic Competitor Pool`, `Love8 Cross-Country Vulnerability`, `Research Methodology & Sources`, `TR/Couple Winner Verdict`, `Brazil Manifestation Niche`, `AI Generative Content Backlash`?**
  _High betweenness centrality (0.291) - this node is a cross-community bridge._
- **Why does `Love8 - Ciftler icin uygulama (TR)` connect `Love8 Cross-Country Vulnerability` to `Generic Competitor Pool`, `Research Methodology & Sources`, `TR/Couple Winner Verdict`?**
  _High betweenness centrality (0.197) - this node is a cross-community bridge._
- **Why does `Play Store Data Source` connect `Research Methodology & Sources` to `Love8 Cross-Country Vulnerability`, `Pricing & Billing Complaint Cluster`?**
  _High betweenness centrality (0.160) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `Astrolink - Mapa Astral (BR)` (e.g. with `Astrolink - Carta Astral (MX)` and `Play Store Data Source`) actually correct?**
  _`Astrolink - Mapa Astral (BR)` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `Love8 - Ciftler icin uygulama (TR)` (e.g. with `Love8 - App para casais (BR)` and `Love8 - App para parejas (MX)`) actually correct?**
  _`Love8 - Ciftler icin uygulama (TR)` has 3 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `Love8 - App para casais (BR)` (e.g. with `Love8 - Ciftler icin uygulama (TR)` and `Love8 - App para parejas (MX)`) actually correct?**
  _`Love8 - App para casais (BR)` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `Love8 - App para parejas (MX)` (e.g. with `Love8 - App para casais (BR)` and `Love8 - Ciftler icin uygulama (TR)`) actually correct?**
  _`Love8 - App para parejas (MX)` has 2 INFERRED edges - model-reasoned connections that need verification._