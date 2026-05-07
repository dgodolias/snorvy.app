# D4 Loop Tick 2 Summary — EU Solo-Freelancer Invoice (DE+PL+NL)

**Date**: 2026-05-07 | **Direction**: v9 D4 — multi-country EU invoice app, shared codebase
**Inputs**: ASA scoring 17 kws × 3 countries, 5 EU competitor descriptions, 12 TikTok hashtags
**Sources**: `d4_asa_keyword_estimates.md`, `d4_app_store_copy_drafts.md`, `play-store/d4_competitor_descriptions.json`, `tiktok/d4_eu_freelancer_hashtags.json`

---

## 1. ASA top 3 keywords per country (composite Vol×Intent ÷ Comp)

### Polish (PL) — KSeF panic active
1. **Tofu zamiennik / Tofu alternative** — 10.00 (displacement, zero comp)
2. **samozatrudniony faktura** — 7.50 (role-noun ownership)
3. **KSeF aplikacja** — 6.25 (highest absolute volume — pick for paid ASA, mandatory deadline Apr 1 2026)

### German (DE) — Kleinunternehmer §19
1. **§19 UStG App** — 10.00 (legal-tech intent, zero comp)
2. **Kleinunternehmer Rechnung App** — 6.67 (mid-high vol, niche-noun open)
3. **Rechnungs App kostenlos ohne Abo** — 5.00 (Abo-Falle backlash; lifetime positioning is empty)

### Dutch (NL) — ZZP KOR
1. **Invoice Fly alternatief** — 10.00 (displacement, zero comp)
2. **Nederlandse factuur app** — 7.50 (anti-foreign / "NL-made" wedge)
3. **ZZP factuur app** — 6.25 (highest NL absolute volume — pick for paid)

> **Pattern**: Each country has the same shape: a 10.00-composite displacement keyword (zero comp) + a 6-7 composite role-noun keyword + a high-vol generic keyword. Triple-stack the title/subtitle.

---

## 2. D4 recommended unified app name

**Primary**: `Faktly: Rechnung KSeF Factuur` — 30 chars (≤40 cap)

**Why**: Coined from `Faktura` (PL) / `Faktura/Rechnung` (DE legal slang) / `Factuur` (NL). Phonetic across all three. Trademark-clean (NOT Tofu / Lexware / sevDesk / Invoice Fly / Holvi / Moneybird / Bookipi / Faktura / Rechnung). Subtitle slot localizes per country.

**Backups**: `Billio: Solo-Freelancer EU Invoice` (33 chars), `Inkey: Mobile Invoice EU` (24 chars)

**Country-localized subtitles** (≤30 chars iOS):
- PL: `Faktura JDG • KSeF • bez abo` — 28
- DE: `Rechnung §19 • GoBD • ohne Abo` — 30
- NL: `ZZP factuur • EU • geen abo` — 27

---

## 3. EMPTY positioning slots (audit takeaway)

7 wedges no incumbent occupies:

1. **KSeF-native daily-driver** — official `pl.gov.mf.ksef` is a utility; Tofu doesn't mention KSeF. Open lane for "polished mobile-first KSeF app."
2. **§19 first-class onboarding** — Lexware/sevDesk treat §19 generic; nobody asks at signup "Are you Kleinunternehmer?" and strips USt automatically.
3. **EU-data residency** — Invoice Fly American (Labhouse), Tofu American (GetPaid Inc.); Moneybird is the only fully-Dutch player. "Made in EU / data stays in Frankfurt" wedge in all 3 markets.
4. **Lifetime price (no Abo)** — every paid competitor is monthly. **€39 lifetime** is unique.
5. **Multi-country single login** — no incumbent serves DE+PL+NL freelancer with one account; cross-border solo freelancers are unserved.
6. **Android-first invoice creation** — Lexware Office DE explicitly cannot create invoices on Android per web-search source; "Android freelancer" is structurally underserved.
7. **Offline-first** — every incumbent assumes always-online cloud sync.

---

## 4. TikTok hashtag table EU + viability verdict

| Hashtag | Country | Views | Users | Verdict |
|---|---|---|---|---|
| #ondernemer | NL | 344.8M | 40.2K | **STRONG** — most-active EU SMB hashtag |
| #zzp | NL | 313.2M | 39.5K | **STRONG** — pure-target audience |
| #przedsiebiorca | PL | 282.1M | 16.6K | **STRONG** — PL entrepreneur creators active |
| #kleinunternehmer | DE | 248.6M | 3.4K | **MEDIUM** — high views but only 3.4K creators (Olli/`@ollinichtimdienst` dominant — 340K-play single video on §19) |
| #ksef | PL | 101.7M | 4.2K | **STRONG-NICHE** — pure intent ("KSEF certyfikaty" trending), perfect for organic launch |
| #faktura | PL | 58.7M | 3.0K | OK — narrower but on-topic |
| #selbststaendig | DE | 1.3M | 567 | **WEAK** — DE freelancer creators don't self-tag this way |
| #samozatrudniony | PL | 67K | 27 | **WEAK** — wrong tag (Polish prefer #JDG abbreviation but it's contaminated) |
| #freelancerpolska | PL | 568K | 58 | **WEAK** |
| #freelancerdeutsch | DE | — | — | **DOES NOT EXIST** |
| #jdg | — | 649M | 43K | **REJECTED — contaminated** by Chinese LoL team |

**Viability verdict per country**:
- **NL — YES, STRONG**: #zzp + #ondernemer = 658M combined views, 80K+ creators. Most-mature EU freelancer TikTok community.
- **PL — YES, CONDITIONAL on KSeF urgency**: #ksef 101M is perfect-intent. April 1 deadline = peak organic burst window. Polish creators (`@zmija.w.podatkach` 520K plays on KSEF certificates) actively explaining KSeF → joining their conversation = built-in distribution.
- **DE — CONDITIONAL**: 248M views on #kleinunternehmer concentrated in <5 creators. High virality if the right creator picks it up; low organic discoverability without partnership. DE freelancers post on LinkedIn more than TikTok.

---

## 5. Recommended D4 launch sequence (which country FIRST?)

**Sequence: PL first → NL second → DE third.**

### Why PL first (0-4 weeks post-launch)
1. **Hard deadline = active panic**. April 1, 2026 KSeF mandatory for JDG/MŚP. Searches like "KSeF aplikacja" are at peak right NOW (May 2026 = ~5 weeks post-deadline; tail of stragglers + people who failed first attempts at the gov app).
2. **Tofu precedent validates demand**: 1M+ installs in <2 yrs, ratings hidden but installs prove the cohort exists.
3. **TikTok #ksef 101M views** — perfect intent, low creator competition (4.2K users), can join @zmija.w.podatkach / @bogusz_o_finansach conversations.
4. **Government app is a polish utility, not a daily driver** — clean wedge.
5. **Price-sensitive market** — €39 lifetime is unusually attractive when expressed in PLN (~170 zł).

### Why NL second (weeks 5-10)
- **Strongest TikTok organic community** (658M combined views, 80K creators).
- **Anti-foreign-sentiment wedge** validated by scaffold quote — Invoice Fly is American, exposed.
- Smaller cohort than PL but higher ARPU and LTV.
- Use NL launch to test cross-border: same Faktly account billing PL+NL clients.

### Why DE last (weeks 11-16)
- **Permanent (not deadline-driven)** §19 cohort — no urgency window to miss.
- **Highest UX/legal expectations** (GoBD, XRechnung, ZUGFeRD) — needs the most polish, build LAST after PL/NL feedback.
- DE TikTok organic is weak; will need paid DE Google Ads from $350 budget.
- DE Mittelstand is loyalty-driven — easier to convert with NL/PL social-proof references already in place.

### Single-codebase implementation note
Since all 3 countries ship from one codebase (per scaffold), launch sequence affects copy/store-listing rollout, NOT engineering. Build all 3 jurisdictions' tax logic in v1; flip Play Store availability per country one week apart.

---

## Files written this tick

- `findings/raw/d4_asa_keyword_estimates.md` (composite scoring 17 kws × 3 countries)
- `findings/raw/d4_app_store_copy_drafts.md` (name, subtitles, anti-positioning, €39 lifetime price-stack, full DE description)
- `findings/raw/play-store/d4_competitor_descriptions.json` (5 EU competitor full descriptions)
- `findings/raw/tiktok/d4_eu_freelancer_hashtags.json` (12 hashtag stats + top videos for top 5)
- `findings/raw/tiktok/d4_hashtag_*.json` + `d4_posts_*.json` (raw cache)
- `findings/raw/play-store/d4_loop_tick2_summary.md` (this file)
