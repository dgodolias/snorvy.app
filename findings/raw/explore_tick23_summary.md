# Tick 23 — GR/AT/CH Market Scan

Date: 2026-05-07. Mode: EXPLORATION. User context: Greek solo dev, $0 budget.

## 1. Greece (GR) — STRONG SIGNAL, NEW DIRECTION CANDIDATE

### Legal verdict: myDATA — NO EXEMPTION
- **No sector or entity is exempt** from myDATA participation (per Eurofast, AADE, RTC Suite, VAT Update sources).
- **B2B e-invoicing mandatory** for ALL businesses (incl. solo professionals "μπλοκάκι") **from 2026-10-01** (large biz already from 2026-02-02).
- Penalty precedent: €3,928 fine upheld 2025. Constitutional challenge pending Council of State, but transmission obligation stands.
- **Implication**: ~700k Greek solo professionals + small businesses are now CAPTIVE in myDATA. They MUST issue/transmit electronic invoices via a myDATA-compatible app or accountant SaaS.

### Top vulnerable cell: AADE's own myDATAapp
| App | Installs | Score | Recent low_pct | Lifetime low_pct | Status |
|---|---|---|---|---|---|
| **gr.aade.mydataapp** (myDATAapp official) | 100k+ | 3.31 | **57.9%** (11/19 newest) | 37.9% | CRITICAL |
| com.appodixi (receipt verifier official) | 100k+ | 3.09 | high | 41.3% | CRITICAL |
| com.myaadeapp (general AADE) | 500k+ | 4.12 | ~40% sampled | 18.9% | mid |
| gr.lomsoft.timologic (3rd party) | 10k+ | 4.20 | low | 17.1% | STALE since 2023-09 |

### User voice (myDATAapp 1-star, recent):
- "για άλλη μια φορά το κράτος μας δυσκολεύει την ζωή. μετά το τελευταίο update **εξαφανίστηκε το ψηφιακό πελατολόγιο** από την εφαρμογή... ελπίζω να αναλάβετε και το πιθανό **πρόστιμο**" (Dec 2025)
- "Σου βάζει να κάνεις φιλικούς κωδικούς και σου λέει **δεν έχεις πρόσβαση**, τι εξυπηρετεί ακριβως αυτή η εφαρμογή;"
- "**A monster of a civilian service web ecosystem.** Convoluted, redundant, unclever, buggy, slow, grossly time-consuming."
- "μετά την τελευταία ενημέρωση δεν ανοίγει..."

The official AADE app is so broken that solo professionals are PAYING for SaaS (Timologic, Epsilon, etc.) just to comply. Timologic itself is stale (last updated Sept 2023) — competitive vacuum.

## 2. Austria (AT) — WEAK SIGNAL

- Kleinunternehmer threshold = €35k (verified: different from DE €25k).
- Search returned mostly **EU/DE generic invoice apps** (Bookipi, Invoice Simple, Square, Zoho QuickBooks). No AT-native invoicing app discovered ≥10k installs.
- FinanzOnline [+] is gov tax filing, not invoicing.
- **Verdict**: AT users are served by German-language apps already (Faktly's D4 already targets DE/AT/CH). Adding AT-specific Kleinunternehmer config (€35k threshold, AT VAT rates 10/13/20%) is a CHEAP localization extension to D4, not a new direction.

## 3. Switzerland (CH) — REAL BUT TINY

- **Magic Heidi** (ch.magicheidi.app.magic_heidi): solo dev Nathan Ganser, Swiss-only, AI receipts + QR bills, IAP CHF 30–300, score 4.45 — but only **1,000+ installs after 3+ years**.
- **Swiss QR Bill** (ch.raciborski): brand new (Jan 2026), 50+ installs, offline-only, CHF 9 IAP.
- **Verdict**: Swiss QR-bill format is a real local need, but ceiling ~5–10k installs. NOT viable standalone. Solid Faktly D4 extension: add Swiss QR-bill format + CHF + Swiss MWST rates (8.1/2.6/3.8%).

## 4. Best NEW Direction — D12 candidate "myDATA Survival Kit" (GR)

**Niche × Country**: Greek solo professionals (μπλοκάκι, ~700k pop) × GR
**Differentiation thesis**: AADE's official myDATA tooling is broken (3.31 stars, 57.9% recent 1-star), Timologic is abandoned, and the Oct-2026 mandatory B2B deadline creates a forced-purchase event for every Greek freelancer. A Greek-native, simple, offline-first app for: (a) issuing myDATA-compliant invoices, (b) maintaining the digital customer list (πελατολόγιο), (c) verifying receipts via QR. Price: low one-time CHF/EUR, no subscription tax (which is what irks myDATAapp users — `δεν χρειάζεται να πληρώνω σε συνδρομητικές πλατφόρμες`).
**User has native Greek + lives in regulatory context** = unbeatable localization moat vs Timologic (stale) or any foreign Bookipi/Zoho competitor that can never integrate myDATA properly.
**Monetization**: €9.99 one-time or €4.99/month, captive market with deadline-forced demand.
**Confidence**: HIGH. Vulnerability cell verified, deadline verified, competitor staleness verified, native advantage verified.
**Risk**: AADE may finally fix the official app; private SaaS players (Timologic-PRO, Epsilon, MegaSoft) may incumbents. Need to confirm minInstalls trajectory and Reddit/forum sentiment before promotion to top-5.

## Reporter notes
- Faktly D4 should absorb AT €35k + CH QR-bill as cheap extension (no new direction needed for AT/CH).
- GR myDATA Survival Kit deserves Tick 24 deeper validation: pull 200+ reviews of myDATAapp + appodixi + Timologic, scan Reddit r/greece + insomnia.gr forums for sentiment, check google-trends for "myDATA" + "ηλεκτρονική τιμολόγηση" growth curve into Oct 2026 deadline.
