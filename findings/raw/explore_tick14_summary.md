# Explore Tick 14 — D9 Launch Readiness Deep-Dive

**Date**: 2026-05-07
**Direction**: D9 Evernote Refugee Notes Vault (validated 84.7% / 88.2% last-90d)
**Goal**: Launch readiness intel — ASA keywords, copy + positioning slots, competitive timeline.

---

## 1. D9 ASA — top 5 keywords by composite (Vol × Intent ÷ Comp)

| Rank | Keyword | Composite | Why it matters |
|---|---|---:|---|
| 1 | **bending spoons evernote** | 30.0 | Niche volume but ZERO competition. Pure refugee-displacement query, appears verbatim in 1-2★ reviews. Caution: don't NAME Bending Spoons in copy (legal); just claim the search-traffic via long-tail in description body. |
| 2 | **evernote import enex** | 20.0 | Highest-intent migration query. Only Joplin/Obsidian own it and both scare non-tech users. Cleanest empty slot. |
| 3 | **notes app no subscription** | 15.75 | Anti-paywall framing; volume + intent + low comp combo. Subtitle gold. |
| 4 | **evernote alternative** | 15.0 | Cornerstone term. UpNote dominates SEO; Play Store ASO under-claimed. |
| 5 | **lifetime notes app** / **no ads notes** (tie) | 15.0 | Both empty slots in incumbent ASO; both attack Evernote's #1 (ads) + #2 (price-hike) rage themes. |

Rejected: "Notion alternative" (saturated, wrong audience), "encrypted notes offline" (Standard Notes' moat, wrong wedge).

Full file: `findings/raw/d9_asa_keyword_estimates.md`.

---

## 2. D9 recommended app name + EMPTY positioning slots

**App name**: `Notebound: Notes Vault & ENEX Import` (37 chars / 40 max)
- Trademark-clean (no Class-9 software collisions on TESS public dataset; verify with attorney pre-launch).
- Avoids Evernote/UpNote/Obsidian/Joplin/Bear/Notion morphology.
- "Notebound" implies bound-book + offline-owned + safe-keeping in one word.

**iOS subtitle**: `Switch. Import. No ads.` (23 / 26 chars) — three verbs hit three top ASA terms.

**5 cleanest EMPTY positioning slots** (no incumbent advertises):
1. One-tap `.enex` import (Evernote's own export format)
2. "No ads, ever" explicit pledge in title/short
3. "Switch from Evernote in 60 seconds" verb-driven hook
4. Sync via YOUR Google Drive / iCloud (no backend = no future price-hike risk)
5. Senior-friendly large-font UI (zero competitors claim; iOS review verbatim demand: "no senior discount, $16/mo for a recipe")

**Anti-positioning hook (legal-safe)**: "Tired of losing your notes behind a paywall? Tired of ads taking over the app you've used for years? Notebound is the simple, ad-free notes app that imports your .enex file in one tap — no subscription, no device limits, no surprises."

Full file: `findings/raw/d9_app_store_copy_drafts.md` (includes full 2,895-char description draft).

---

## 3. D9 launch urgency timeline + Obsidian roadmap

**Obsidian mobile capture status**:
- 1.11 Mobile (Jan 12, 2026) shipped Lock Screen / Control Center / Home Screen widgets and iOS shortcuts. **Partial** — still requires full vault load before capture; community confirms "doesn't work well for quick capture."
- 1.12 Mobile in active development (kepano X confirm); estimated Q3-Q4 2026 release based on prior 6-month cadence.
- Even post-1.12, Obsidian remains BARRIER-TOO-HIGH for refugee user (22% low_pct, complexity complaints).

**UpNote**: Maintenance mode (Jan 2026 release notes = stability + Linux .deb + Czech/Dutch). Still NO .enex import. Premium-paywalls table/attachment/unlimited.

**Evernote (Bending Spoons era)**:
- Aug 2024 acquisition → Dec 2024 50-note free-tier cap → 2025-2026 prices climb $40 → $130 → $230-$350/yr renewals → AI force-inject + in-app ads → no reverse course.
- 88.2% last-90d low_pct = peak refugee migration NOW.

**D9 launch urgency: URGENT.**
- Refugee wave at peak velocity NOW.
- UpNote is the immediate threat (already explicitly named as destination in 437-thumb review).
- Obsidian gap closes Q3-Q4 2026 + Q1 2027.
- **Must launch by Aug-Sep 2026** to ride wave; post-Q1 2027 inflow decays.
- Build window: 6-8 wk (.enex parser is hardest piece; Drive/iCloud SDK + biometric + senior-UI are well-trodden).

Full file: `findings/raw/d9_competitive_timeline.md`.

---

## 4. Final D9 confidence

**HIGH.**

Why HIGH (not MEDIUM-HIGH):
- 1500-depth Evernote review pull confirms 88.2% last-90d low_pct (most extreme reading in entire research program).
- 437-thumb top quote explicitly names UpNote as refugee destination → migration intent verified, not inferred.
- Cross-platform: iOS 41.1% confirms Android thesis at lower amplitude.
- 5 EMPTY positioning slots audited against full descriptions of all 5 main competitors.
- Trademark-clean app name candidate.
- Obsidian mobile-capture closure is 6-12 months away → window is real.
- Build complexity = solo-dev shippable in 6-8 weeks at $0 backend cost (sync via user's Drive/iCloud).
- 2/5 ASA top-5 are wide-open empty-slot keywords (composite >20).

Residual risks:
- ASA volume estimates are educated proxies (no $0 ASA tool exists for absolute numbers).
- "Notebound" trademark needs attorney verification pre-launch.
- .enex parser is the single technical gating factor — must prototype Week 1.

---

## Files written (Tick 14)
- `findings/raw/d9_asa_keyword_estimates.md`
- `findings/raw/d9_app_store_copy_drafts.md`
- `findings/raw/d9_competitive_timeline.md`
- `findings/raw/play-store/d9_competitor_descriptions.json` (5 competitor full descriptions, raw)
- `findings/raw/explore_tick14_summary.md` (this file)
