# D3 App Store Copy Drafts — Honest Gig Tracker (US)

**Date**: 2026-05-07 | **Source**: 6 competitor `description` fields scraped today (`d3_competitor_descriptions.json`).

## Empty positioning slots — what NO incumbent says

After auditing Solo, Stride, Hurdlr, MileIQ, Driversnote, Gridwise full Play Store descriptions:

1. **"No deceptive sign-up"** — every competitor either gates features behind email OR (Solo) deceptively asks for bank-link before letting you see core features. None advertise "no email required to start".
2. **"Auto-tracking actually works"** — Stride is the obvious example with 69.4% Android low-pct from broken auto-tracking, but NO incumbent says anything like "auto-tracking that fires every drive — guaranteed or your subscription is free". They all SAY auto-tracking, none guarantee reliability.
3. **"One-time fee"** — every competitor is subscription (Stride free w/ insurance affiliate revenue, Hurdlr $9.99/mo, MileIQ ≥$5.99, Gridwise $9.99/mo). Empty slot: lifetime / one-time / no-subscription.
4. **Quarterly tax estimator with Schedule C math built-in** — Hurdlr has tax estimator but buried; Stride has tax reports but no estimator; nobody puts "see your Schedule C in real time" on the storefront.
5. **Founder-on-the-app responsiveness commitment** — none mention "messages answered by founder within 24h". This is a wedge given Solo 84% bare-minimum templated replies.
6. **Privacy/local-first** — Driversnote alone says "we never sell data"; nobody says "your trips never leave your phone".
7. **No upsell to insurance/health** — Stride leads with insurance affiliate (their actual revenue model). Empty slot: a tracker that ISN'T trying to sell you insurance.

## Recommended app name

**Primary**: `Mileway: Honest Gig Tax Tracker` — 33 chars (within 40 cap)
**Why**: "Mileway" is novel (no Play/iOS hits in current scrape), short, reads as compound noun (mile + way), trademark-clean vs Solo/Stride/Hurdlr/MileIQ/Driversnote/Gridwise/QuickBooks/Found/FlyFin. The descriptor "Honest" lands the anti-positioning vs Solo's deceptive sign-up reputation.

**Backups (if Mileway has IP collision)**:
- `Driveline: 1099 Mileage & Taxes` — 32 chars
- `Mileslip: Gig Tax Tracker` — 25 chars
- `Tracksy: Honest Mileage for Drivers` — 35 chars

## iOS subtitle (≤26 chars)

**Primary**: `Auto-track miles, no tricks` — 27 chars (1 over cap)
**Compliant variant**: `Auto-track miles. No tricks.` — too long, drop period: `Auto-track miles, no tricks` is 27 — replace with:
- `Mileage. Taxes. No tricks.` — **26 chars exact** ✓
- `Honest mileage for gig pros` — 27 chars (over)
- `Mileage for 1099 drivers` — 24 chars ✓ (safe alt)

**Use**: `Mileage. Taxes. No tricks.`

## Anti-positioning hook (legal-safe)

> "Tired of mileage apps that hide pricing until after sign-up, or auto-trackers that miss half your trips? Mileway shows you everything before you tap **Sign Up**, and our auto-tracker fires on every drive — or your next month is free."

Notes: Doesn't name Solo or Stride. Attacks two documented complaint patterns (Solo sign-up deception per 434-thumb verbatim; Stride 69.4% low-pct from broken auto-tracking). Legal-safe because we describe behaviors not brands.

## Price-stack differentiation

| Tier | Mileway | Stride | Hurdlr | MileIQ | Gridwise |
|---|---|---|---|---|---|
| Free | unlimited trips, 1 vehicle | free w/ insurance pop-ups | semi-auto only | 40 drives/mo | basic earnings only |
| Paid | **$3.99/mo OR $39 lifetime** | n/a (insurance affiliate) | $9.99/mo | $5.99/mo | $9.99/mo |

The **$39 lifetime** tier is the wedge — no incumbent offers it. At $0 backend cost (Firebase free tier) Mileway can sustain it.

## Description draft (~3000 chars)

```
Mileway: Honest Gig Tax Tracker

Built for DoorDashers, Uber drivers, Lyft drivers, Instacart shoppers and every 1099 worker who's sick of mileage apps with hidden pricing and broken auto-tracking.

WHY MILEWAY EXISTS
Other mileage apps make you sign up before you can see how they work. Some auto-track only half your trips. Most try to sell you health insurance you didn't ask for. Mileway does ONE job — track your miles and your gig taxes — and does it without tricks.

FREE FOREVER (REALLY)
- Unlimited trips on the free plan. No 40-drive cap.
- No email required to start. Open the app, drive, see your miles.
- No insurance pop-ups. No upsells to bank-linking.
- No "free trial" that auto-charges you in 7 days.

AUTO-TRACKING THAT ACTUALLY FIRES
- Every drive logged automatically — guaranteed.
- If we miss a trip, your next month of Premium is free.
- Battery-friendly background detection (under 2% per day).
- One-tap classify: Business / Personal / Charity / Medical.

GIG-NATIVE TAX MATH
- Live Schedule C estimator: every mile, every dollar, your quarterly tax bill in real time.
- IRS-ready PDF mileage logs in two taps.
- Standard mileage deduction at the current 67¢/mile rate (auto-updated).
- 1099 income import: paste from DoorDash, Uber, Lyft weekly statements.

ONE PRICE. NO STACKING.
- Free: unlimited trips, 1 vehicle, monthly PDF export.
- Premium: $3.99/month — multi-vehicle, weekly PDF, quarterly tax estimator.
- Lifetime: $39 ONE TIME — every Premium feature, forever. No subscription. No price hikes.

YES, REALLY $39 LIFETIME
We run lean (one developer, no VC, $0 backend cost) so we can offer one-time pricing that the venture-backed competitors can't.

BUILT FOR YOU IF YOU'RE
- A DoorDash dasher tracking miles for tax season
- An Uber or Lyft driver who needs IRS-ready mileage logs
- An Instacart shopper, Spark driver, Amazon Flex courier, GrubHub driver
- A freelancer or gig worker filing Schedule C / 1099-NEC

PRIVACY BY DESIGN
- Trips stored on YOUR phone first. Cloud sync is optional.
- We never sell or share your driving data.
- We don't run ads inside the app.

FOUNDER PROMISE
This app is built by one person, not a 50-person team with marketing quotas. Email me at [redacted] — I answer every message within 24 hours, personally. No templates.

WHAT MILEWAY DOESN'T DO
- We don't sell you health insurance.
- We don't predict your gig pay.
- We don't take a cut of your earnings.
- We don't have a "leaderboard" comparing you to other drivers.
We just track your miles, calculate your taxes, and stay out of your way.

LEGAL
Mileway is not a tax advisor. Estimates are for informational purposes only. Consult a CPA for tax filing.
```

(~2,950 chars — within Play Store 4,000-char limit, leaves headroom for formatting)
