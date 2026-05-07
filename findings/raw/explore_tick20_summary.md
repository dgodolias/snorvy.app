# Explore Tick 20 — D10 Launch Readiness Summary

**Date:** 2026-05-07
**Direction:** D10 — MY MyInvois Companion (Malaysia LHDN Phase 4)
**Time spent:** ~28 min (within 25-30 min cap)

## 1. MY freelancer forum — top 5 verbatim complaints

1. **Play Store reviewers (EN/BM mix):** "The app doesn't scale properly with phones, making certain buttons unclickable, and e-invoices cannot be exported to PDF format—only to JSON script." → Govt mobile app fails basic UX.
2. **Play Store, persistent 2026 bugs:** "Too many bugs, including the inability to update notification emails and TIN information... as of 2026 the app is still buggy." → 18 months of unfixed regressions.
3. **Lowyat "Natsukashii" (BM-EN):** "pretty much a lot of stuff is not ready.. people also don't have enough knowledge about it, then suddenly comes last minute deadline" → Education wedge huge.
4. **Lowyat foreign-clients thread:** "it's obviously twice the amount of paperwork on my end" / "Feels like a lot of work just to keep track of these tiny fees individually" → Forex + micro-fee pain.
5. **Lowyat "LonelyHart16" (BM):** "Seems like details unclear. Only thing that is clear is gamen die2 want implement einv." → Confusion = trust opening.

**Named alternatives found:** Bukku (only serious threat — free, MDEC-Peppol-accredited, desktop-first), InvoisPro, JomeInvoice, Financio, IRIS MyInvois, Zoho Books LHDN plug-in. **None are mobile-native + Bahasa-first** — D10 wedge stands.

## 2. D10 ASA — top 3 + recommended app name

| Rank | Keyword (BM) | Composite |
|---|---|---|
| 1 | **MyInvois alternatif** | 18.00 |
| 2 | **e-Invois aplikasi mudah** | 15.75 |
| 3 | **freelance Malaysia invois** | 13.33 |

**Recommended app name:** **`e-Invois Cepat: Freelance & MSME`** (29 chars, trademark-clean vs MyInvois / Bukku / SQL Account / Maybank2u / InvoisPro / JomeInvoice).
**Subtitle (26 chars exact):** **"Patuh LHDN. Cepat & Mudah."**
**Anti-positioning hook:** "Bosan dengan aplikasi e-invois yang lambat dan rumit? e-Invois Cepat menjadikan penghantaran invois LHDN-patuh semudah hantar WhatsApp." (legal-safe, no LHDN/MyInvois named).

## 3. Phase 4 mandate timeline + urgency

| Phase | Date | Turnover | TAM |
|---|---|---|---|
| 1 | 1 Aug 2024 (LIVE) | > RM100M | ~5K |
| 2-3 | 2025 (LIVE) | RM5M–RM100M | ~60K |
| **4** | **1 Jan 2026 (LIVE — grace until 31 Dec 2026)** | **RM1M–RM5M** | **~150K** |
| 5 | 1 Jul 2026 (8 wks out) | < RM1M MSME + freelancers | ~600K |

**Penalty:** RM200 – RM20,000 per non-compliant invoice (Sec 82C ITA 1967), up to RM20K fine or 6 months prison. **Full enforcement:** 1 Jan 2027.
**Bonus trigger:** Jan 2026 — all transactions > RM10K require individual e-invoice (no consolidation). Affects everyone.
**Solo-dev window:** Build May-Jun (6-8 wks) → Launch Jul-Aug → Peak growth Sep-Dec 2026 → Saturation risk Jan 2027+. 

**Launch urgency rating: HIGH (RED-HOT)** — 8 weeks to Phase 5, 6 months to peak panic, 12 months to saturation. Still green-field on mobile-native + Bahasa-first.

## 4. Final D10 confidence: **HIGH**

Reasoning:
- Govt-app failure independently corroborated by 4+ sources (100% recent low_pct holds)
- Mandate is concrete + Federal-level (highest regulatory conviction in entire v9 board)
- TAM 750K combined Phase 4+5; mobile sub-segment 800K-1M
- Only one credible competitor (Bukku) and they're desktop-first
- $0 cost achievable: Flutter + Firebase free tier + LHDN free Peppol API
- ICP (Bahasa-first MY freelancer/MSME) is well-defined and reachable via TikTok Bahasa + Lowyat threads
- Anti-positioning is legal-safe (attacks "slow and complicated" category, never names LHDN/MyInvois)

**Risk to confidence:**
- LHDN could ship a better app (low probability given 18-mo track record)
- Bukku could ship mobile tier (medium probability, ~6mo lag)
- Phase 5 could be deferred (politically possible; would soften but not kill — Phase 4 still mandatory and live now)

**Recommendation:** D10 promotes from "needs validation" to "build-ready". Suggest re-ranking against v9 #1 in next tick.

---

## File outputs from Tick 20

- `findings/raw/d10_my_forum_validation.md` (forum scrape, named alternatives table)
- `findings/raw/d10_app_store_copy_drafts.md` (ASA composites, name, subtitle, hook, ~2,950 char Bahasa description)
- `findings/raw/d10_mandate_timeline.md` (full phase calendar, penalty matrix, launch window)
- `findings/raw/explore_tick20_summary.md` (this file)
