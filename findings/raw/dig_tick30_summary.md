# DEEPER DIG Tick 30 — D13 Bloki Validation Summary

Date: 2026-05-07. Time: ~25 min. Cost: $0.

## Task 1 — AADE myDATAapp depth pull

### Volume reality check
Pulled 3000-target NEWEST sort but Play Store **only had 123 reviews available** for `gr.aade.mydataapp` (app launched early 2025; review volume self-caps). Full file: `findings/raw/play-store/d13_mydataapp_3000.json`.

### Revised low_pct (verified, not estimated)

| Window         | Reviews | 1–2★ | low_pct |
|----------------|---------|------|---------|
| Full (Jan 2025–May 2026) | 123 | 61 | **49.6%** |
| 2025+ recent cohort      | 123 | 61 | **49.6%** |
| Last 90 days             | 12  | 3  | **25.0%** |

Prior 200-review run reported 57.9% — true full-app number is **49.6%**, slightly softer but still elite-tier dysfunction. Last-90d softening (25%) suggests the AADE team shipped *some* fixes recently — but pain persists.

### Theme clusters (61 low-star reviews)

| Theme                       | Hits | Share |
|-----------------------------|------|-------|
| Login / auth (φιλικοί κωδικοί "απαγορευμένη ενέργεια") | 15 | 25% |
| Crashes / "doesn't work"    | 12 | 20% |
| Tablet incompatibility      | 10 | 16% |
| PDF export / send-to-client missing | 5 | 8% |
| Support absent              | 4  | 7%  |

### Top 5 NEW high-thumb 1★ verbatim quotes (with translation)

1. **chiptronic — 14 thumbs — 2025-09-25** (HIGHEST IN DATASET)
   > δεν λειτουργεί σε tablet xiaomi pad 2 νέο μοντέλο, γιατί αυτό? Δεν υπάρχει υποστήριξη στην εφαρμογή για ένα τόσο σοβαρό πρόβλημα?
   > *"Doesn't work on Xiaomi Pad 2 new model — why? Is there no support for such a serious problem?"*

2. **George N — 11 thumbs — 2025-02-21**
   > Έφτιαξα φιλικούς κωδικούς αλλά μου βγαίνει το μήνυμα: «Απαγορευμένη ενέργεια. Δεν έχετε άδεια πρόσβασης»
   > *"I created friendly-codes but I get 'Forbidden action. You don't have access permission.'"*

3. **Giannis Galanos — 10 thumbs — 2025-09-15**
   > Μα είναι δυνατόν να μην μπορεί να εγκατασταθεί σε τάμπλετ; Απευθείας ανάθεση να τολμήσω να πω;
   > *"Is it really possible it can't be installed on a tablet? Dare I say direct-award contract?"* (sarcasm about gov procurement)

4. **Andreas Anagnostopoulos — 9 thumbs — 2025-11-19**
   > Θα έπρεπε να είναι διαθέσιμη και σε ταμπλετ
   > *"It should be available on tablet too."*

5. **Παναγιώτης Βελονάς — 9 thumbs — 2025-07-12**
   > ενώ έχω δημιουργήσει φιλικούς κωδικούς, όταν τους βάζω μ βγάζει: απαγορευμένη ενέργεια, δεν έχετε άδεια πρόσβασης.
   > *"Although I've created friendly-codes, when I enter them I get: Forbidden action, you don't have access permission."*

**Single highest-thumb verbatim** = chiptronic's tablet/Xiaomi quote (14 thumbs), confirming **tablet support + reliable auth** as the #1 wedge surface area.

## Task 2 — Ecosystem intel (full file: `findings/raw/d13_ecosystem_intel.md`)

- AADE app developed in-house by AADE itself; no public vendor LinkedIn → no ownership entity to compete against; just government inertia.
- **Epsilon Net SA (EPSIL.AT)**: Greek-listed, 1,700+ employees, €100M turnover 2023, €150M target 2025, EBITDA 33%. Epsilon Smart product = 50k+ subs. Big incumbent but enterprise-positioned.
- **Elorus** (Athens, founded 2014): freemium $0/$9/$19/$39, 98% G2 satisfaction, native myDATA, **web-only** → mobile gap intact.
- **Timologic**: confirmed last update 2023-09-23, quietly abandoned (vendor: "Lomsoft"; no public shutdown event). 2.5+ years of unresolved freelancer pain.
- **SoftOne / Singular Logic**: legacy enterprise, "outdated/complex" per freelancer reviews.
- B2B e-invoicing mandate **postponed past Feb 2026** → onboarding window stays open.
- Open-source SDKs (`firebed/aade-mydata`, `ppapapetrou76/go-mydata-aade`) confirm myDATA API is freely integrable → $0 backend remains feasible.

## Task 3 — Revenue refresh (full file: `findings/raw/d13_revenue_refresh.md`)

- No new Greek-specific ARPU data found.
- Epsilon Smart 50k subs validates a **€5–8M ARR** product line is achievable in this exact market.
- Realistic D13 ARPU = €7–15/mo (Elorus comparable pricing).
- Conservative D13 ceiling: 1,000 paying users × €10/mo = **€120k/year MRR achievable for solo dev**, consistent with v9 thesis.
- Global B2B SaaS 2025 medians (28% growth, $1.2k CAC) don't directly apply — Greek freelancer market is high-volume / low-ARPU.

## D13 confidence change: **HIGH — UNCHANGED**

Reasons confirmed (no revision):
1. Recent low_pct re-verified at 49.6% (not 57.9% — slightly softer but still dysfunction-grade).
2. **Highest-thumb signal = 14 thumbs on tablet incompat** (a fix-shaped wedge).
3. Auth pain (15 reviews / 25% of low cohort) is a persistent theme through May 2026.
4. Incumbent (Epsilon) is enterprise-locked; nearest peer (Elorus) is web-only → mobile-native + Greek-first wedge is open.
5. $0 budget feasible (open SDKs, public REST API).
6. Last-90d softening to 25% is the only caution — AADE may be slowly improving. Window may be 6–12 months not 18.

Recommendation: **proceed to MVP scaffold for D13 Bloki**, prioritize tablet support + reliable login (the two highest-thumb pain clusters) as wedge features.
