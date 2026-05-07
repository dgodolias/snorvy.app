# D4 — IAP Audit + Founder-Responsiveness EU Competitors (Phase D Tick 1)

Generated: 2026-05-07. Sources: live `google-play-scraper` `app()` + `reviews()` calls. Reply-rate sampled on up to 200 newest 1–3★ reviews per app.

## IAP Live Pricing Matrix

| App | Country | IAP? | Range (Play-billed) | ★ | Installs | Notes |
|---|---|---|---|---|---|---|
| Tofu | PL | yes | 13,99 PLN — 499,99 PLN | n/a | 1M+ | (~€3.30 — €118 weekly→annual ladder) |
| Invoice Fly | NL | yes | €5.99 — €299.99 | 4.10 | 1M+ | Weekly sub trap mentioned in 1★s |
| sevDesk | DE | yes | €11.90 — €370.80 | 4.12 | 100K+ | Recently rebuilt; Android churning hard |
| Lexware Office | DE | **NO** in-app | n/a (web sub only) | 4.72 | 100K+ | Pricing on lexware.de, mobile is companion |
| Accountable | DE | yes | €11.99 — €849.99 | 4.57 | 100K+ | Highest ceiling; targets professionals |
| Bookipi | NL | yes | €8.49 — €199.99 | 4.81 | 1M+ | Foreign Aussie dev, no NL localisation |
| Faktura Proste (Inv. Simple) | PL | yes | 17,49 PLN — 1.819,99 PLN | 4.65 | 10M+ | Massive PLN ceiling (~€430) |
| Fakturownia | PL | yes | 15,99 PLN — 109,99 PLN | 4.94 | 10K+ | Mobile companion to web SaaS, KSeF native |

Price-hike evidence: sevDesk reviews describe "kosten für Buchhaltung 2025 um 440 Euro gestiegen". Tofu reviews describe stealth weekly→annual conversion ($899 PHP / 1659 PKR / $5.99-9 weekly auto-charge cited 6x in top-10 thumbed). German "Abo-Falle" pattern most visible at sevDesk DE (mid-tier €370 ceiling) but the highest-trap-quote density is Tofu (98.9% reply rate masks billing complaints).

## Founder-Responsiveness Rate (1–3★ replies / 1–3★ pulled)

| App | Reply rate | Cohort | Tone of replies |
|---|---|---|---|
| Bookipi NL | **95.5%** (147/154) | newest | Templated apology, deflects to support email |
| Tofu PL | **98.9%** (87/88) | newest | Cheerful Polish/EN, asks user to email "for refund" |
| Accountable DE | 77.8% (14/18) | newest | Professional German, explicit fix promises |
| Lexware Office DE | 70.0% (7/10) | newest | Brief German "danke für Feedback" |
| sevDesk DE | 64.7% (11/17) | newest | Acknowledges bugs, generic |
| Faktura Proste PL | 26.8% (34/127) | newest | Sparse Polish, often ignored |
| Fakturownia PL | 0% (0/1) | n/a | Single review pulled — too sparse to judge |
| Invoice Fly NL | **0%** (0/56) | newest | Fully unresponsive on NL store |

## Key Vulnerabilities

- **Invoice Fly NL = 0% reply** with 8.4% low_pct rising — anti-foreign sentiment + abandoned support is exploitable for any local NL launcher who answers in Dutch.
- **sevDesk DE = 78.6% recent low_pct** with only 64.7% replies — German pros openly migrating; reviews say "einfach nur dreist und schlecht" (101 thumbs, June 2025). Mobile rebuild stripped features.
- **Faktura Proste PL = 26.8% reply** despite 10M+ installs — but they're the price ceiling (1.8K PLN / €430). KSeF Apr 2026 mandate breaks their model if they don't ship native KSeF (Fakturownia already has it).
- **Bookipi NL** is technically responsive (95.5%) but template-only and entirely English/Aussie — same anti-foreign vector as Invoice Fly.

## Implications for solo-dev EU launch

The "answer in native language + ship native legal compliance (Kleinunternehmer §19 / KSeF / KOR)" wedge is open in all three countries, but most acute in NL (Invoice Fly's 0% reply rate alone) and DE (sevDesk price-hike rage + 78.6% recent low_pct).
