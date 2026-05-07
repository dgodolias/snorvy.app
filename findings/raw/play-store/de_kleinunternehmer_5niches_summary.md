# DE Kleinunternehmer + 5 Sub-Niches Drill — Summary

Date: 2026-05-07. Pulled via `google-play-scraper` (newest sort, country-scoped).

## Task 1 — DE Invoice / Buchhaltung Apps (de country, de language)

| App | Installs | Score | Free | IAP range | Reviews pulled | low_pct (≤2★) |
|---|---|---|---|---|---|---|
| **sevDesk** (`de.sevdesk.sevdeskgo`) | 100k+ | 4.12 | Free w/ IAP | €11.90–€370.80 | 300 | **78.7%** |
| FastBill (`de.fastbill.androidapp`) | 5k+ | 3.56 | Free | — | 46 | 34.8% |
| Accountable (`com.hivearts.accountable`) | 500k+ | 4.57 | Free w/ IAP | €11.99–€849.99 | 167 | 29.3% |
| Lexware/lexoffice (`de.lexoffice.android`) | 100k+ | 4.72 | Free | (web sub) | 300 | 24.3% |
| Invoice Simple DE (`com.aadhk.woinvoice`) | 5M+ | 4.51 | Free w/ IAP | €4.49–€414.99 | 300 | 18.7% |
| Billdu (`de.minirechnung`) | 100k+ | 4.58 | Free w/ IAP | €7.99–€239.99 | 271 | 8.9% |
| Einfach Rechnung (`app.invoice_maker`) | 500k+ | 4.67 | Free w/ IAP | €5.99–€199.99 | 129 | 8.5% |
| SpeedInvoice ZUGFeRD (`au.com.speedinvoice.android`) | 1M+ | 4.83 | Free w/ IAP | €0.66–€76.95 | 300 | 2.7% |

### Kleinunternehmer-positioning
- **Only `app.invoice_maker` ("Einfach Rechnung schreiben") explicitly mentions "Kleinunternehmer" as primary target** in description ("perfekte Rechnungs-App für Kleinunternehmer, Auftragnehmer und Freiberufler").
- Lexware mentions "Kleinunternehmern" once but positions as full-stack Buchhaltung for "Selbstständige, Startups und kleine Unternehmen".
- sevDesk, FastBill, Accountable, Billdu, Invoice Simple DE, SpeedInvoice — **none** target Kleinunternehmer §19 specifically. They're either generic invoicing or full Buchhaltung.

### Pricing reality (Kleinunternehmer ceiling ≈ €5/mo)
- ALL paid tiers blow past €5/mo: sevDesk €11.90 entry, Lexware ~€12 entry, Accountable €11.99, Billdu €7.99, Einfach Rechnung €5.99 (only just under), Invoice Simple €4.49 (lowest, but tiered with limits).
- **NO incumbent offers a no-watermark, unlimited-invoices, truly-free Kleinunternehmer tier** — Invoice Simple caps at 3/month even on €7.99 plan; Einfach Rechnung gates PDF export behind paid.

### Top 3 complaint themes (DE Kleinunternehmer apps, low-star reviews)
1. **Predatory pricing & limit hikes mid-subscription** — Invoice Simple: "Mitten im bezahlten Jahr wurde mir auf 3 Rechnungen/Monat zusammen gekürzt"; Bookipi: forced into €99/yr; Billdu: silent limit hikes pushing €200/yr.
2. **App quality regression / data loss** — sevDesk: "Update nur dreist und schlecht... Funktionen werden schrittweise implementiert" (101 thumbs); "Beleg scannen funktioniert überhaupt nicht mehr"; Lexware: "Unbekannter Fehler bei verschiedensten Aktionen"; Billdu: "alle Kunden und Rechnungen verschwunden".
3. **Missing E-Rechnung / XRechnung / GoBD trust** — Speedinvoice: "Daten auf ausländischen Servern... verstößt gegen Datenschutz"; Accountable: "keine BWA Funktion und keine Lohn".

## Task 1 → Top 3 most-vulnerable DE apps

1. **sevDesk** — 78.7% low_pct on 300 newest reviews. Top 1★ (101 thumbs, 2025-06-07): *"The new app/update is just brazen and bad. Yes, features are being rolled out gradually. But what the hell is the point? I don't need an app that doesn't work! I want to use the app to do bookkeeping fast to save time."*
2. **FastBill** — 34.8% on 46 reviews (small sample, app discontinued-feel). Top 1★ (12 thumbs, 2019): *"App seems to take photos only at very low resolution... I can count the pixels. The scan function is useless."* (Note: only 5k installs, fading.)
3. **Accountable** — 29.3% on 167 reviews. Top 1★ (49 thumbs, 2024-01): *"No scan capability like Papierkram. Only normal photos. Compared to Lexoffice, Papierkram, Wiso etc very expensive. Support very slow but nice people. No P&L function and no payroll. And crashes very often."*

## DE GAP verdict — CLEAR OPENING

Verdict: **GO. The "Kleinunternehmer §19 free invoice generator" niche is structurally open.**
- All 8 incumbents either (a) charge >€5/mo, (b) cap free-tier invoices, or (c) include unwanted full-Buchhaltung complexity.
- sevDesk's 78.7% recent low_pct + recent app rewrite that broke core features = active user exodus, no immediate replacement marketed at micro-segment.
- The ONLY direct positioning-competitor (`app.invoice_maker`) has 8.5% low_pct but gates PDF export behind subscription — leaves "no-paywall, no-watermark, GoBD-compliant local archive" wedge wide open.
- Localization gap (Invoice Simple "Übersetzung kaum zu verstehen") + price gap + sevDesk implosion all converge on same Kleinunternehmer §19 user.

## Task 2 — 5 Sub-Niches Vulnerability Scan (US store, 300 newest each)

| Niche | App (top vulnerable) | low_pct | Top 1★ verbatim |
|---|---|---|---|
| **Receipt scanner** | **Smart Receipts** (`wb.receipts`, 1M+) | **57.0%** | "Despite all the updates, they only seem to work for paid subscriptions. Still zero reason why we can not do a manual backup of the file to our local device" (41 thumbs, 2025-12) |
| **Car maintenance** | **Simply Auto** (`mrigapps.andriod.fuelcons`, 500k+) | **45.3%** | "Tried the sync option to allow my wife and I both to enter data, and lost literally about 8 years of data for multiple vehicles" (70 thumbs, 2024-03) |
| **Estimate/Quote** | **Bookipi Invoice** (1M+) | 30.3% | "Eventually ended up paying for this app... you continuously speak to an AI bot that says help is on the way within an hour but it's been weeks" (29 thumbs, 2025-12) |
| **eBay inventory** | **eProfit AI** (50k+) | 22.3% | "Do NOT Download — Terrible Support & Unauthorized Charges! Downloaded just to try it out... turned into [nightmare]" (49 thumbs, 2025-08) |
| **Photo gallery / proofing** | **Shutterfly** (10M+) | 25.3% | "I press the back button or try to add more photos, I lose all the work I put into the order" (78 thumbs, 2026-02) |

(Worth noting: Easy Expense 28.3%, CARFAX 26%, Drivvo 22.3% — multiple cells in 20–30% band, but none crack the 40% threshold besides Smart Receipts and Simply Auto.)

## Best new candidate cell (>40% low_pct + $0-cost feasible + simple build)

**Winner: Receipt scanner for self-employed (US) targeting Smart Receipts displacement (57% low_pct).**

Why:
- 57% low_pct on 300 newest reviews — outright the highest measured incumbent vulnerability across this scan AND most prior research.
- Dominant complaint: paywalled basic features + **no local backup option** — both solvable with a $0-backend, on-device-storage app.
- Adjacent cell **Simply Auto (45.3%)** is also a strong runner-up — same complaint pattern (data loss after sync, paywall regression). Both feasibly built as on-device-only apps with optional CSV export, no servers needed.

Build thesis: **"Receipts Local — pure on-device, no account, no subscription, CSV/PDF export"** for US 1099 self-employed, taps the sub-segment that explicitly rejected Smart Receipts' cloud-only paid model. ~6-8 week solo build, $0 backend (SQLite + on-device OCR via ML Kit), low legal risk (no PII server-side).

Constraints met: $0 backend (local SQLite + ML Kit OCR), 6-8 week build, low legal risk (no data leaves device unless user exports), Android-heavy market match.

## Files

- Raw search merged: `findings/raw/play-store/de_kleinunternehmer_search.json` (37 unique DE apps)
- DE drill: `findings/raw/play-store/de_kleinunternehmer_drill.json` (8 apps, full meta + 300 newest reviews, top-5 thumbs lows)
- 5-niche drill: `findings/raw/play-store/b2b_5niches_drill.json` (15 apps, full meta + 300 newest, top-5 thumbs lows)
