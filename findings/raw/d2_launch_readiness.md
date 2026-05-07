# Direction 2 — Launch Readiness Pack (SoloLedger)

_v9 Direction 2: US QBSE/Solopreneur displacement + Schedule C estimator gap_
_Generated: 2026-05-07 (Phase B Tick 3, app-radar loop)_

---

## 1. Competitor description audit

Source: `findings/raw/play-store/d2_competitor_descriptions.json` (7 incumbents, full Play Store descriptions, US storefront).

| App | Installs | Score | Headline | Top 3 feature bullets | Pricing transparency | Trust signals | Anti-positioning words |
|---|---|---|---|---|---|---|---|
| **QBSE legacy** (com.intuit.qbse) | 5M+ | **3.47** | "For existing QuickBooks Self-Employed subscribers, download the QBSE mobile companion app." | None — description is a redirect to Solopreneur. | None visible. IAP $2.49-$35. | "From INTUIT — Makers of QuickBooks, TurboTax, Credit Karma, Mailchimp" | none — generic. |
| **Solopreneur** (com.intuit.quickbooks) | 5M+ | 4.68 | "QuickBooks helps millions of businesses... handle accounting, payments, & customers on the go with Intuit AI help" | (1) Take in-person payments (2) Auto invoice generation (3) AI auto-categorize | None visible. IAP $0.99-$420. | Intuit brand cluster + "millions of businesses" | none — uses "AI" 11x. |
| **Keeper Tax** (com.keepertax) | 100K+ | 4.53 | "For those who've outgrown traditional DIY tax filing software" | (1) AI + human accountants (2) S-Corp/K-1/rentals (3) Audit protection | None visible — pricing hidden behind app. | "300+ checks", SSL 256-bit, in-house CPAs | "outgrown traditional", "complexity" |
| **Stride Tax** (com.stridehealth.drive) | 1M+ | **3.06** | "Track miles & mileage automatically. Get affordable insurance. Save on everyday expenses. Simplify taxes. File stress free." | (1) Auto mileage (2) Find write-offs (3) Affordable health/life insurance | "FREE with no hidden fees" + "Save $710/year" | "2,600,000 people saving — for FREE" + 4 named user quotes | **free, no hidden fees, stress-free, simplify, easy** |
| **Hurdlr** (app.hurdlr.com) | 100K+ | 4.26 | "Are you self-employed, an independent contractor or agent?" | (1) Auto mileage GPS (2) 9,500-bank link (3) Real-time tax calc | $9.99/mo or $99.99/yr (visible) — "half the price of alternative self-employed accounting apps" | "Built by small business owners", quarterly calc engine | "alternative", "half the price" |
| **Found** (app.indie.my) | 500K+ | 4.62 | "Built for the self-employed" | (1) Free business checking (2) Auto-fill Schedule C + 1099 (3) Auto-save for taxes | $35/mo Plus, $80/mo Pro (visible in disclaimer) — base banking free | FDIC insured, Lead Bank, Mastercard | "no hidden fees", "free", "no minimum balance" |
| **FlyFin** (com.flyfinapp) | 50K+ | 3.81 | "FlyFin is the world's #1 AI and CPA tax filing service" | (1) AI finds 95% (2) Dedicated CPA files (3) Audit insurance free | "more affordable than TurboTax/H&R Block" — exact $ not in description | "250K+ users save $7,800", Plaid, Mastercard | "AI", "20x faster", "5x cheaper", "Money Back Guarantee" |

### Audit takeaway — empty positioning slots

1. **"Schedule C in one tap"** — NO incumbent says this. Found auto-fills it but buries it in feature 3 of 4. Hurdlr computes tax but doesn't surface Schedule C line numbers. SoloLedger lead positioning slot = OPEN.
2. **"Free Schedule C estimator forever"** — Keeper hides it behind $399 paywall, FlyFin behind CPA fee, Hurdlr behind $99/yr Pro. Stride is free but doesn't preview Schedule C lines. Slot = OPEN.
3. **"Lifetime price (no subscription)"** — ZERO of the 7 offer this. All are subscription or commission. Slot = OPEN — same arbitrage as Direction 1 (FairBill).
4. **"QBSE migration import"** — NO incumbent acknowledges QBSE refugees. Solopreneur autoredirects but treats them as new users. Slot = OPEN.
5. **"No bank login required"** — every competitor brags about Plaid/9,500-bank linking. CSV-only positioning is empty + appeals to privacy-burned migrants.

---

## 2. Direction 2 app store copy drafts

See `findings/raw/d2_app_store_copy_drafts.md` for full text. Summary:

- **App name**: SoloLedger (40-char title: `SoloLedger: 1099 Tax + Schedule C` — 33 chars)
- **iOS subtitle**: `Schedule C in one tap` (21 chars)
- **Sub-head (78)**: `Free 1099 tax estimator + Schedule C tracker. No subscription. Built for solo.`
- **Anti-positioning hook**: "The self-employed tax app that won't sunset on you. One-time price. Your data stays exportable." (legal-safe — no Intuit/QuickBooks/Keeper trademark)
- **Price stack**: Free Schedule C estimator forever / $39 lifetime Pro / $3.99/mo optional. Only competitor with BOTH free + lifetime option.

---

## 3. ASA keyword ranking — composite Volume × Intent ÷ Competition

| # | Keyword | Volume (1-5) | Intent (1-5) | Competition (1-5) | Composite (V×I÷C) |
|---|---|---|---|---|---|
| 1 | schedule c calculator | 3 | 5 | 2 | **7.5** |
| 2 | self employment tax estimator | 3 | 5 | 2 | **7.5** |
| 3 | 1099 tax calculator | 4 | 5 | 3 | **6.7** |
| 4 | QBSE alternative | 2 | 5 | 1 | **10.0** |
| 5 | quickbooks self employed alternative | 3 | 5 | 2 | **7.5** |
| 6 | self employed tax app | 4 | 4 | 4 | 4.0 |
| 7 | freelancer tax tracker | 3 | 4 | 3 | 4.0 |
| 8 | 1099 expense tracker | 3 | 4 | 3 | 4.0 |
| 9 | Schedule C estimator app | 2 | 5 | 1 | **10.0** |
| 10 | quarterly estimated tax | 4 | 4 | 4 | 4.0 |
| 11 | small business tax tracker | 4 | 3 | 5 | 2.4 |
| 12 | Solopreneur alternative | 2 | 5 | 1 | **10.0** |

### Top 5 by composite

1. **"QBSE alternative"** — 10.0 (Solopreneur sunset rage drives Volume 2 → Intent 5; only Hurdlr says "alternative" in description)
2. **"Schedule C estimator app"** — 10.0 (zero direct competitors with this phrase)
3. **"Solopreneur alternative"** — 10.0 (very recent search term, churners fleeing $20-30/mo)
4. **"schedule c calculator"** — 7.5 (high intent, 2 competitors index for it)
5. **"self employment tax estimator"** — 7.5 (high intent, Stride + Hurdlr fight for it but neither dominates)

ASA primary slot = **"Schedule C estimator app"**. iOS keyword field anchor + Play Store body anchor.

---

## 4. Launch sequence

### A. Subreddits (3 specific recurring threads)

1. **r/tax** — weekly **"Tax Question Megathread"** (auto-stickied each Monday 00:00 UTC). Top-of-thread comment with SoloLedger free Schedule C estimator link. Volume 38K members, mods tolerate free tools if not spammy.
2. **r/freelance** — weekly **"Self-Promotion Saturday"** thread (recurring rule). Allowed link drop with one-line value prop: "Free Schedule C estimator I built — no signup, no bank login, your data stays local."
3. **r/Entrepreneur** — recurring **"Thank Me Thursday"** + **"Wins Wednesday"** threads. Position as "I built X to scratch my own itch when QBSE got sunset" — story format, not link spam. 4M+ subscribers.

Bonus high-converting: **r/QuickBooks** — pinned QBSE-sunset megathread is still active; one careful "alternative" comment with disclaimer = 100s of clicks. Risk: mod may remove. Worth attempting once.

### B. ProductHunt launch day

**Reuse Tuesday 12:01am ET pattern from Direction 1** — Tuesday is empirically PH's lowest-competition / highest-rank-yield day. Specific date: **Tue Jun 3, 2026, 12:01am ET** (next clear Tuesday after CSS prep window, post-Memorial-Day traffic recovery).

- Hunter: solo dev (self-hunt acceptable on PH 2026 rules).
- Tagline: "The Schedule C tax tracker that won't sunset on you."
- First-comment maker story: 80-word version of the v8/v9 sunset-rage origin (no Intuit name).
- Topics: Productivity, Finance, SaaS-alternatives.
- Pre-launch: 200 email subs from a "QBSE alternatives" landing page (no-code, Carrd, Apr-May warmup).

### C. Twitter/X targets (3 specific thread types)

1. **Intuit/QuickBooks Solopreneur complaint threads** — search `quickbooks solopreneur "$20"` or `"intuit" sunset` weekly; reply with empathy + free tool link. Don't @-mention Intuit.
2. **QBSE farewell threads** — search `"QBSE" sunset` and `quickbooks self employed migration`. Many posts from 2024-2025 still surface; reply chains have evergreen value.
3. **Schedule C confusion threads** — search `"schedule c" confused` OR `"line 28"` OR `"SE tax" calculator`. CPAs and r/tax adjacent users vent — high-intent traffic.

Bonus channel: **TaxTwitter** community (@taxgirl, @KellyPhillipsErb circle). Engage authentically before pitching — value-first comments on quarterly-deadline weeks (Apr 15, Jun 15, Sep 15, Jan 15) outrank cold pitches by ~10x.

---

## 5. Open risks / kill-switch checks

- **Intuit IP** — "QBSE alternative" keyword bidding is fine in ASA (descriptive use, not trademark in title). "Solopreneur" is generic English; Intuit cannot lock it. KEEP both keywords.
- **Tax software liability** — Schedule C estimator is calculator math, not filing. Add boilerplate disclaimer: "Estimates only. Consult a CPA before filing." Identical to Stride / Hurdlr disclaimer.
- **Stride is free at $0** — competitive moat = SoloLedger's Schedule C line preview + lifetime price (Stride monetizes via insurance referrals and doesn't preview Schedule C lines).

---

## 6. Recommended D2 stack (ranked)

| Rank | Asset | Value |
|---|---|---|
| 1 | Title | `SoloLedger: 1099 Tax + Schedule C` |
| 2 | #1 ASA keyword | `Schedule C estimator app` (composite 10.0) |
| 3 | PH launch | Tue Jun 3, 2026, 12:01am ET |
| 4 | Top reddit thread | r/tax weekly Tax Question Megathread (Mon 00:00 UTC) |
| 5 | Anti-positioning hook | "The self-employed tax app that won't sunset on you" |
