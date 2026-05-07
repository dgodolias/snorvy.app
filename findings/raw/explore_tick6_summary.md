# Explore Tick 6 — Summary (final wave)

Date: 2026-05-07. Token-efficient — full detail in d9_evernote_competitive.md and raw JSONs.

## 1. Evernote 1500-depth + alt landscape

| App | n | full low_pct | last-90d low_pct |
|---|---|---|---|
| **Evernote** | 1500 | **84.7%** | **88.2%** |
| UpNote | 200 | 11.0% | 14.5% |
| Obsidian | 200 | 22.0% | 22.0% |
| Joplin | 200 | 23.5% | 24.3% |

Evernote 1500-depth CONFIRMS 200-depth signal — and 90-day cohort actually rises to 88.2%. This is the single most extreme rage reading in the entire research program. None of the 3 alternatives is itself vulnerable enough to displace; UpNote in particular is the de-facto refugee destination already (one Evernote 1★ review with 89 thumbs explicitly names "Migrated to UpNote").

Rage is **ads (33%) + price-hike (29%)**, not data loss (8%). The Evernote refugee is non-technical and primarily wants to escape the ad/paywall squeeze.

## 2. D9 product spec refinement

The Evernote refugee profile (verified across 1271 1-2★ reviews):
- Non-technical (Obsidian intimidates them — "you get a lot of Bricks")
- 5-15yr accumulated notes (lock-in pain via .enex)
- Hits the 50-note + 1-notebook + 2-device paywall
- Already revolted by ads + price-doubling year-over-year

**Wedge features** (must-have to capture refugees):
1. One-tap **.enex import from Evernote**
2. Unlimited notes/notebooks/devices on free tier
3. **Zero ads, ever**
4. **User-owned cloud sync** (Google Drive / iCloud) — $0 backend
5. PDF/image/voice attachments that actually open
6. Per-notebook biometric lock
7. Android share-sheet web clipper
8. Local-first + encrypted at rest

**Anti-features**: no AI, no subscription on free tier, no count/device limits.

**Pricing**: $0 forever; $9.99 one-time pro unlock (themes, batch PDF export).
**Build**: 6-8 weeks. Backend: $0.

## 3. Tick-6 misc niches vulnerability

| App | category | n | last-90d low_pct | verdict |
|---|---|---|---|---|
| Calc991 plus | scientific calc | 200 | 2.0% | NOT vulnerable. 4.85 score. |
| RealCalc | scientific calc | 200 | 21.4% | Mildly elevated late-2025 ("took away fractions from free version") but install base cooling, only 14 reviews in 90d — too thin. |
| Planet Free VPN | VPN | 200 | 13.0% | Not vulnerable. 4.55 score, free tier holds. |
| iTranslate | translator | 200 | 44.1% | **VULNERABLE** — 3.40 score, 80/200 1-2★. Rage: paid pro lies about offline ("NEEDS INTERNET FOR IMAGE TRANSLATION"), free trial useless, broken AI voice. |

### iTranslate is the only meaningful new signal
- 80 1-2★ in 200; 44.1% last-90d.
- Pain: false offline marketing, image translation requires data, AI voice quality, hard-to-cancel trial.
- BUT: niche fundamentally requires AI/ML translation models. **Violates user's HARD constraint "NO AI inference"** unless built as a Google-Translate-API thin wrapper (still adds Google Cloud cost and is duplicative of Google Translate which is free + better).
- **Verdict: REJECT.** No zero-cost path.

Calculators/VPN/Translator scan = 3 niches checked, 0 viable new directions.

## 4. Best new direction candidate

**NONE beats existing v9 top 9.**

D9 (Evernote refugee Notes Vault) at 88.2% last-90d low_pct is now the ANCHOR direction — the highest-rage signal in the entire research program. Tick 6 confirms:
- Depth holds at 1500 reviews (84.7% full window)
- Rage is **accelerating** (88.2% in last 90 days vs 84.7% full)
- Refugees actively self-identify ("Migrated to UpNote", 89 thumbs)
- The competitive landscape has ONE strong incumbent (UpNote) but a clear positioning gap: **truly-free + .enex-import + user-owned-cloud + zero-ads** is unoccupied
- All HARD constraints satisfied: $0 backend, 6-8 wk build, low legal risk, no AI inference

Recommendation: **Promote D9 to v10 #1**, demote prior #1 (TR Couples Tracker Şeffaf) to #2. Build spec is now concrete enough to enter "validate by Reddit + r/Evernote scrape" phase rather than another exploration tick.

## Files written
- `findings/raw/play-store/d9_evernote_us_1500.json` (1500 reviews)
- `findings/raw/play-store/d9_upnote_us_200.json`, `d9_obsidian_us_200.json`, `d9_joplin_us_200.json`
- `findings/raw/play-store/d9_search_{upnote,obsidian,joplin}.json`
- `findings/raw/play-store/explore_tick6_{calc991,realcalc,planetvpn,itranslate}.json`
- `findings/raw/play-store/explore_tick6_{calc_sci,calc_tip,vpn,translator}.json` (search results)
- `findings/raw/play-store/d9_evernote_competitive.md` (deep landscape file)
- `findings/raw/play-store/_tick6_analyze.mjs` (analysis script)
