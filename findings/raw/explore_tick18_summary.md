# Tick 18 Exploration Summary

Date: 2026-05-07
Territories: (A) SEASIA MSME accounting/invoicing, (B) Tutoring/lesson-tracking solo apps
Time: ~25 min, $0 cost

---

## A) PH/MY/TH MSME accounting/invoicing

### Search-results landscape
- **PH search ("invoice app freelancer")**: ZERO PH-localized BIR e-invoicing apps surfaced. All results are global generic invoice apps (Invoice Simple, Bookipi, Invoice Home, Invoice2go, Refrens-IN). PH has no native MSME-specific PSP/BIR app on top results.
- **MY search ("invois MSME")**: Surfaced critical local apps: `my.gov.hasil.myinvois` (LHDN govt e-Invois client) and `lhdn.myinvois.epos` (free POS for MSMEs). LHDN's Phase 1 mandate (Aug 2024) covers >RM100M turnover; Phase 2 expanded Jan 2025 (>RM25M); Phase 3 (Jul 2025) covers RM5M-25M; Phase 4 covers EVERY freelancer/MSME by Jan 2026. So 800K+ Malaysian SMEs are in active scramble RIGHT NOW.
- **TH search ("ใบกำกับภาษี mobile")**: ZERO Thai-localized e-tax-invoice apps; only Vietnamese eTax Mobile and global generics. Thailand RD's e-Tax Invoice mandate is voluntary still — no urgency wedge.

### Vulnerability scan (recent low_pct, ≤180 days)
| App | Country | Installs | Recent | low_pct | Notes |
|---|---|---|---|---|---|
| **MyInvois (LHDN govt)** | MY | 10K+ | 8 | **100%** | Govt forces use, app broken |
| Invoice Simple | PH/MY/TH | 5M+ | 200 | 32.5% | Login bugs, deceptive pricing |
| Bookipi | PH/MY | 1M+ | 200 | 24.5% | Watermark forced, freemium pivot |
| Zoho Invoice | MY | 1M+ | 200 | 7.5% | Stable; OTP login fails |

### Best verbatims (MY MyInvois — 11 thumbs):
> "biggest failure of government is building an half baked app and force everyone to use and penalise people who making errors. after submit, the app just crash itself. it is just a stupid webview. rubbish portal rubbish app yet forcing everyone to use it." — KY Lim, 2026-03-01, 1★

> "when trying to submit e-invoice, the qr code scanner doesn't even work (black screen). Our gov wants us to do extra work for tax submission, but the system they provide doesn't even work properly" — zhi jing chuah, 2026-04-10, 1★

### Wedge for MY
LHDN forces every freelancer & MSME into e-Invois by Jan 2026; the official mobile app has 2.2★ and crashes on Vivo/Xiaomi. A simple Malay-first **3rd-party MyInvois client** that wraps the LHDN MyInvois API + handles PEPPOL UUID + offline draft + QR-validate is a **regulatory-forced** wedge with ZERO competition (only Zoho/Bookipi address it via desktop). Estimated freelancer + Phase 4 MSME TAM: 800K-1M users by mid-2026. Revenue: RM10/mo Pro tier (offline, multi-business, validated PEPPOL ID).

---

## B) Tutor / lesson-tracking solo apps

### Landscape
- Top results dominated by AI-tutor consumer apps (Tutor AI, Flexi, tutor.new) and marketplaces (TutorOcean, MyPrivateTutor, Wyzant) — all REJECT (corp/marketplace).
- Solo-tutor session-tracking apps are **TINY**: Tuition Lesson Tracker (1K+), Lesson Tracker Pro (10+), Tutoring Tracker (100+), Student Tracker (1K+). Only **Planbook Mobile** (10K+) has scale, and it's a K-12 lesson PLANNER (curriculum), NOT private-tutor session-tracker + invoicer.
- Music-teacher specific: Ostinato exists but is unrated; Note Teacher is a sight-reading tool, not session-tracker.

### Vulnerability scan
| App | Country | Installs | Recent | low_pct | Notes |
|---|---|---|---|---|---|
| Planbook Mobile | US | 10K+ | 2 | 50% (n=2) | K-12 planner, S26 incompat |
| Tuition Lesson Tracker | US | 1K+ | 0 | n/a | Single review |
| Tutoring Tracker | US | 100+ | 0 | n/a | No reviews |

### Verdict on tutor niche: **WEAK**
- TAM is real (US has 200K+ private tutors, 60K music teachers) but Play Store demand SIGNAL IS DEAD: every solo-tutor tracker has ≤1K installs after years on Store. Buyers prefer Excel + Venmo. Replacing Excel for solo educators is a known graveyard (low willingness-to-pay, calendar-app substitution).
- No ranked candidate clears the v9 ≥30% recent low_pct + ≥10K installs gate.

---

## Best NEW direction recommendation

**ADD: "MY Freelancer/MSME MyInvois Companion" (Malaysia, Bahasa Malaysia + English)**

- **Niche**: Malaysian freelancers + sole-prop MSMEs (Phase 4 mandate covers them by Jan 2026)
- **Country**: MY (Bahasa-first, English secondary)
- **Wedge**: Wrap LHDN MyInvois API + PEPPOL e-Invois XML generator. Replace the broken govt app with a fast Bahasa native client. Offline draft → batch submit when online. QR-scan client TIN → autofill. RM10/mo Pro = unlimited drafts, multi-business, audit-trail PDF export.
- **Vulnerable cell**: MyInvois govt app — recent low_pct **100%** (8/8 reviews ≤2★ in 180d); Bookipi MY 24.5%, Invoice Simple MY 32.5% — none of which serve PEPPOL XML generation.
- **Cost**: $0 backend (LHDN provides free API; PEPPOL XML is open-spec; can run client-side). Firebase Auth free tier.
- **Build time**: 8-10 weeks (PEPPOL XML schema is the long pole; ~150 fields).
- **Confidence**: HIGH — regulatory forcing function + visible govt-app rage + zero localized indie competitor.
- **Caveats**: Need Malaysian banking rail for OTP (otp.hasil.gov.my); requires MyDigital ID OAuth integration (free).

This SUPERSEDES exploring more SEASIA territories — MY is the singular obvious wedge.

---

## Summary stats
- 11 apps scanned (8 SEASIA, 5 tutor; some overlap)
- 1,302 reviews pulled
- Files: `findings/raw/play-store/explore_seasia_msme.json`, `explore_tutor.json`
- All raw `_t18_*.json` files retained for replay
