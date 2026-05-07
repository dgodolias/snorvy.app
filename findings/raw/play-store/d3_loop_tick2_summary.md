# D3 Loop Tick 2 Summary — Honest Gig Tracker (US)

**Date**: 2026-05-07 | **Phase**: C, Tick 2 | **Direction**: v9 D3 (Solo + Stride displacement)
**Inputs added this tick**: ASA keyword scoring, 6-app full-description audit, TikTok 7-hashtag volume scan + 1 comment sample.

---

## 1. ASA — Top 5 keywords by composite score

(Composite = Volume × Intent ÷ Competition; all 1-5 scale)

| Rank | Keyword | V | I | C | Composite |
|---|---|---|---|---|---|
| 1 | **stride alternative** | 2 | 5 | 1 | **10.00** |
| 2 | **gig worker mileage** | 3 | 5 | 2 | **7.50** |
| 3 | **rideshare tax tracker** | 3 | 5 | 2 | **7.50** |
| 4 | **doordash mileage tracker** | 4 | 5 | 3 | **6.67** |
| 5 | **uber driver tax app** | 4 | 5 | 3 | **6.67** |

**#1 keyword**: `stride alternative` — pure displacement intent, near-zero competition, justified by Stride's 69.4% Android low_pct.

Skip list: `delivery driver app` (wrong intent), `instacart shopper app` (job-finder intent), `lyft driver tools` (Gridwise dominates).

Source: `findings/raw/d3_asa_keyword_estimates.md`.

---

## 2. D3 recommended app name + copy

- **Name (33 chars)**: `Mileway: Honest Gig Tax Tracker`
- **iOS subtitle (26 chars)**: `Mileage. Taxes. No tricks.`
- **Anti-positioning hook**: *"Tired of mileage apps that hide pricing until after sign-up, or auto-trackers that miss half your trips? Mileway shows you everything before you tap Sign Up, and our auto-tracker fires on every drive — or your next month is free."*
- **Price-stack wedge**: $39 LIFETIME tier (no incumbent offers; sustainable on $0-backend Firebase free tier)

Source: `findings/raw/d3_app_store_copy_drafts.md`.

---

## 3. EMPTY positioning slots — what no incumbent says

After scraping full Play Store descriptions for Solo, Stride, Hurdlr, MileIQ, Driversnote, Gridwise:

1. **No deceptive sign-up** — none advertise "no email required to start" (Solo's documented bank-link gate makes this a wedge)
2. **Auto-tracking guarantee** — none promise "every drive logged or your subscription is free" (Stride's broken auto-tracking → 69.4% Android low_pct is the gap)
3. **One-time / lifetime pricing** — every incumbent is subscription. $39 lifetime is empty.
4. **Live Schedule C estimator on storefront** — Hurdlr has it but buries it; nobody leads with "see your quarterly tax bill in real time"
5. **Founder-on-the-app responsiveness** — none mention a founder-replies-personally promise (Stride 99% personalized vs Solo 84% bare-minimum, but neither markets it)
6. **Local-first privacy** — only Driversnote says "we never sell data"; nobody says "trips never leave your phone"
7. **Anti-upsell** — Stride's storefront is dominated by insurance affiliate; empty slot for "we don't sell you insurance"

Source: `findings/raw/play-store/d3_competitor_descriptions.json`.

---

## 4. TikTok hashtag table — top 3 + viability verdict

| Rank | Hashtag | Views | Users | ≥100M? |
|---|---|---|---|---|
| 1 | #doordash | 13.29B | 552K | YES |
| 2 | #uberdriver | 7.85B | 364K | YES |
| 3 | #doordashdriver | 1.52B | 95K | YES |
| 4 | #rideshare | 725M | 57K | YES |
| 5 | #gigworker | 371M | 33K | YES |
| 6 | #gigwork | 183M | 23K | YES |
| 7 | #1099life | 2.4M | 1K | NO |

**Viability verdict**: **YES, conditional on creator-strategy.**
- 6 of 7 tested hashtags clear the 100M view threshold; cumulative ≥22B views = audience exists.
- BUT: top videos discuss earnings/gas/deactivation/day-in-the-life — NOT mileage-tracker apps. Sampled top uberdriver video (1.39M plays, 50 comments analyzed) showed strong gas/wear-and-tear/scam pain but ZERO mileage-app discussion.
- Implication: TikTok organic IS a viable launch channel, but Mileway must CREATE the tax/mileage angle (e.g. "$270 today — here's what the IRS actually sees", "your gas + miles deduction in 30 seconds"), not surf existing creator output. Distribution risk = LOW because the lane is open.

Source: `findings/raw/tiktok/d3_gig_drivers.json`.

---

## 5. Recommended D3 launch sequence

**Week 0 (now → Wk1)**: Lock IP — confirm "Mileway" trademark-clean (USPTO TESS quick search), reserve mileway.app domain, file Play Store + App Store reservations.

**Wk 1-4: Build MVP** (~$0 cost; Firebase free tier)
- Auto-mileage GPS detection + manual fallback
- Live Schedule C estimator (mileage × IRS rate + 1099 income → quarterly estimate)
- IRS-ready PDF export (single template)
- Lifetime $39 IAP + free tier (no email required)

**Wk 5: Soft launch — US Play Store only** (Android 68.2%/69.4% low_pct of competitors = first beachhead). iOS comes after Play Store traction.

**Wk 6+ launch channels** (in priority):
1. **TikTok organic**: 3 videos/wk in #doordash / #uberdriver lanes — earnings posts with overlay tax math. Hook: "$X today, here's what the IRS sees." Zero ad spend.
2. **Reddit comments**: continue the r/doordash / r/uber comment-tree pattern (already validated tick 1) — answer mileage/tax threads with one Mileway link in profile bio.
3. **ASA paid keyword test**: $50/wk burst on `stride alternative` (top composite, near-zero comp). Stop if CPI > $2.50.
4. **App Store SEO title-stack**: lead title `Mileway: Honest Gig Tax Tracker`; first 100 chars of description hit `doordash mileage`, `uber driver tax`, `1099 mileage`, `gig worker mileage`, `rideshare tax`.

**Kill criteria** (auto-pull plug):
- 30-day post-launch CPI > $4.00 across all channels
- 30-day Day-7 retention < 25%
- Schedule C estimator usage < 30% of MAU (means tax angle isn't the wedge — pivot to mileage-only)

**Win criteria** (double down):
- 30-day Day-7 retention ≥ 35%
- ≥ 50% of installs come from organic TikTok or Reddit
- Lifetime $39 attach rate ≥ 8% of installs by Day 30

---

## Files written this tick
- `findings/raw/d3_asa_keyword_estimates.md`
- `findings/raw/d3_app_store_copy_drafts.md`
- `findings/raw/play-store/d3_competitor_descriptions.json`
- `findings/raw/tiktok/d3_gig_drivers.json`
- `findings/raw/tiktok/d3_hashtag_*.json` (×7)
- `findings/raw/tiktok/d3_posts_{doordash,uberdriver,doordashdriver}.json`
- `findings/raw/tiktok/d3_comments_7601287059285789982.json`
