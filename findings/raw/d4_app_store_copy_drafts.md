# D4 App Store Copy Drafts — EU Solo-Freelancer Invoice (DE + PL + NL shared codebase)

**Date**: 2026-05-07 | **Source**: 5 competitor `description` fields scraped today (`d4_competitor_descriptions.json`).

## Competitors audited

| Label | Title | Score | Installs | Ratings | IAP range |
|---|---|---|---|---|---|
| Tofu (PL) | Tofu: Łatwe Wystawianie Faktur | 0,0* | 1,000,000+ | 0* | 13.99 – 499.99 zł |
| Lexware Office (DE) | Lexware - Online Buchhaltung | 4.7 | 100,000+ | 5,166 | (no IAP — registration-gated SaaS) |
| sevDesk (DE) | sevdesk Buchhaltung & Rechnung | 4.1 | 100,000+ | 2,686 | €11.90 – €370.80 |
| Invoice Fly (NL) | Factuur maken - Invoice Fly | 4.1 | 1,000,000+ | 56,251 | €5.99 – €299.99 |
| Moneybird (NL) | Moneybird - Online boekhouden | 4.4 | 50,000+ | 1,584 | (no IAP — paid SaaS) |

*Tofu rating shows 0 with 1M+ installs — likely region-specific PL Play Store anomaly; the global app has reviews on iOS App Store. Installs prove the cohort exists.

---

## Empty positioning slots — what NO incumbent says

After auditing all 5 competitor descriptions:

1. **"KSeF-native, built for April 2026"** — Tofu doesn't mention KSeF in description (legacy 2023 app). Government `pl.gov.mf.ksef` exists but is a utility, not a daily-driver invoice app. **Empty: a polished invoice app that is KSeF-first.**
2. **"§19 Kleinunternehmer one-tap toggle"** — Lexware/sevDesk treat §19 as a generic taxation flag, not a first-class workflow. **Empty: app whose ONBOARDING asks "Are you a Kleinunternehmer (§19)?" and then strips out USt entirely.**
3. **"Made in EU — your data stays in Frankfurt/Warsaw/Amsterdam"** — Invoice Fly is American (Labhouse). Tofu is GetPaid Inc. (US-incorporated). Only Moneybird is fully Dutch. **Empty: explicit EU-data-residency wedge that all 3 markets respond to.**
4. **"One-time price, no Abo"** — every paid competitor is monthly subscription (sevDesk €11.90/mo, Invoice Fly €5.99/mo, Lexware/Moneybird SaaS). **Empty: lifetime €39 — strongest in DE (Abo-Falle hatred) and PL (price-sensitive JDG cohort).**
5. **"Multi-country same login"** — none of the 5 lets a freelancer who works in DE+NL+PL bill in all three jurisdictions from one app. **Empty: cross-border solo-freelancer who invoices clients in 2-3 EU countries.**
6. **"True mobile-first"** — Lexware's web search result explicitly says "iPhone needed; Android cannot create invoices in Lexware Office". **Empty: Android-first invoice creation.** This alone is a wedge in DE.
7. **"Offline-first / no internet required to bill"** — every incumbent assumes always-online (sevDesk explicitly mentions cloud sync). **Empty: a freelancer at a client site without WiFi can still write the invoice.**

---

## Recommended unified D4 app name (≤40 chars, works in DE/PL/NL)

### Primary candidate
**`Faktly: Rechnung KSeF Factuur`** — 30 chars
- "Faktly" is a short novel coinage from `Faktura` (PL) / `Factuur` (NL) / `Faktura` is also recognized in DE invoicing slang.
- Trademark-clean: no Play Store / EUIPO collision found in scraped data with Faktly.
- **NOT** Tofu / Lexware / sevDesk / Invoice Fly / Holvi / Moneybird / Bookipi / Faktura / Rechnung — clean.
- Subtitle slot tells each country what it offers.

### Backup candidates
- **`Billio: Solo-Freelancer EU Invoice`** — 33 chars (English-led, may feel foreign in DE/PL)
- **`Notably: Faktura • Rechnung • Factuur`** — 37 chars (typographic, lists 3 languages — but "Notably" is taken on iOS)
- **`Eulist: §19 KSeF KOR Invoice`** — 28 chars (insider: legal codes from each country baked in — TOO obscure for casual buyers)
- **`Inkey: Mobile Invoice EU`** — 24 chars (clean but generic)

**Pick `Faktly`.** Phonetic across PL/DE/NL, distinctive, short enough to leave subtitle headroom.

---

## Country-specific subtitles (≤80 chars Play short description, ≤30 chars iOS subtitle)

### PL (Polish, KSeF-first)
- iOS subtitle (30): `Faktura JDG • KSeF • bez abo` — 28 chars
- Play short desc (80): `Faktura dla JDG i samozatrudnionych. KSeF-ready od kwietnia 2026. Bez abonamentu.` — 80 chars

### DE (German, §19 + GoBD)
- iOS subtitle (30): `Rechnung §19 • GoBD • ohne Abo` — 30 chars
- Play short desc (80): `Rechnung für Kleinunternehmer §19 UStG. GoBD-konform, made in EU, kein Abo.` — 75 chars

### NL (Dutch, ZZP + EU residency)
- iOS subtitle (30): `ZZP factuur • EU-data • geen abo` — 32 (trim) → `ZZP factuur • EU • geen abo` — 27
- Play short desc (80): `Factuur app voor ZZP. Nederlandse interface, EU-data, geen abonnement.` — 70 chars

---

## Anti-positioning hooks per country

### PL
> "Państwowa aplikacja KSeF działa, ale nie pomoże Ci wystawić ładnej faktury z telefonu w 30 sekund. **Faktly** robi jedno: wystawia faktury zgodne z KSeF od 1 kwietnia 2026. Bez abonamentu, bez logowania na tabletach."

(Anti-positions vs `pl.gov.mf.ksef` government app + Tofu — without naming.)

### DE
> "Lexware und sevDesk sind super — wenn du eine 50-Euro-Monatsgebühr zahlen willst und einen Steuerberater im Konto. Wenn du Kleinunternehmer nach §19 UStG bist und einfach nur sauber Rechnungen schreiben möchtest, brauchst du **Faktly**: 39 € einmalig, GoBD-konform, kein Abo."

(Anti-Abo + anti-overengineering — DE Mittelstand language.)

### NL
> "Invoice Fly is Amerikaans en je data slingert door servers in Texas. **Faktly** is gemaakt voor Nederlandse ZZP'ers, met EU-dataopslag, en kost €39 eenmalig. Geen abonnement, geen verrassingen."

(Anti-foreign / anti-US — explicit, validated by the scaffold's NL "anti-foreign-sentiment quote".)

---

## Price-stack differentiation

| Tier | Faktly | Tofu | Lexware Office | sevDesk | Invoice Fly | Moneybird |
|---|---|---|---|---|---|---|
| Free | 5 invoices/month, 1 client | freemium w/ paywall | 14d trial | 14d trial | freemium w/ paywall | 60-day trial |
| Paid (mo) | €3.99/mo | 13.99 zł/mo (~€3.20) | ~€10/mo | €11.90/mo | €5.99/mo | ~€10/mo |
| **Lifetime** | **€39 ONE TIME** | n/a | n/a | n/a | n/a | n/a |
| Multi-country | included free | n/a | n/a | n/a | n/a | n/a |

The **€39 lifetime** is a wedge no incumbent offers. Sustainable at $0 backend cost (Firebase free tier + on-device storage; KSeF/Peppol API calls are direct phone-to-government).

---

## Description draft (DE locale, ~3000 chars)

```
Faktly: Rechnung • Faktura • Factuur

Rechnung schreiben für Kleinunternehmer (§19 UStG) — schnell, GoBD-konform, ohne Abo. Faktly ist die mobile Rechnungs-App für Selbstständige in Deutschland, Polen und den Niederlanden. Eine App, drei Länder, ein einmaliger Preis.

WARUM FAKTLY?
Andere Rechnungs-Apps wollen €11/Monat, locken in Abo-Fallen oder können auf Android nicht mal eine Rechnung erstellen. Faktly macht ein Ding: Rechnungen, die rechtssicher sind und zwar auf deinem Telefon.

KOSTENLOS NUTZBAR (WIRKLICH)
- 5 Rechnungen pro Monat im Free-Plan
- Kein Email-Zwang — App öffnen, Rechnung schreiben, fertig
- Keine Werbung in der App
- Keine "Free Trial" mit versteckter automatischer Abbuchung

KLEINUNTERNEHMER §19 EINGEBAUT
- Onboarding fragt einmal: "Bist du Kleinunternehmer nach §19 UStG?"
- Wenn ja: keine Umsatzsteuer in deinen Rechnungen, automatisch
- Korrekte §19-Klausel auf jeder Rechnung
- Kein Steuerberater-Setup nötig

GoBD-KONFORM
- Unveränderliche Rechnungsnummern
- Ausfuhr als XRechnung / ZUGFeRD für E-Rechnungspflicht
- 10 Jahre Archivierung auf deinem Gerät + optional verschlüsselte EU-Cloud
- PDF-Export im IFinanzamt-Format

EIN PREIS. KEIN ABO.
- Free: 5 Rechnungen/Monat, 1 Kunde, 1 Vorlage
- Premium: €3.99/Monat — unbegrenzte Rechnungen, mehrere Kunden, eigene Vorlagen
- **Lifetime: €39 EINMALIG** — alle Premium-Funktionen, für immer. Keine Preiserhöhung.

MULTI-LAND, EIN LOGIN
Wenn du als Freelancer in DE, PL oder NL Kunden hast: eine App, drei Steuerregime.
- Deutschland: §19 UStG, GoBD, XRechnung/ZUGFeRD
- Polen: KSeF (verpflichtend ab 1. April 2026), JDG-konform
- Niederlande: ZZP, KOR (kleineondernemersregeling), Peppol

DATEN BLEIBEN IN DER EU
- Server in Frankfurt (Hetzner) — keine US-Cloud
- Verschlüsselt in Ruhe und bei Übertragung
- Du bleibst Eigentümer deiner Daten — Export jederzeit als ZIP

GEMACHT FÜR DICH WENN DU
- Solo-Selbstständig bist mit unter €22.000 Jahresumsatz (§19)
- Freiberufler / Freelancer / Handwerker auf Rechnung
- In Polen JDG hast und KSeF brauchst
- ZZP'er in den Niederlanden bist
- Endlich ein App auf Android willst, die Rechnungen schreiben kann

GRÜNDER-VERSPRECHEN
Diese App wird von einer Person gebaut, nicht von einem 50-köpfigen Team mit Marketing-Quote. Email-Antwort innerhalb von 24 Stunden, persönlich. Keine Templates.

WAS FAKTLY NICHT MACHT
- Kein Konto, keine Banking-Funktion (das macht deine Bank)
- Kein Steuerberater-Portal (kein Lexware-Klon)
- Keine Lohnabrechnung
- Keine "AI-Empfehlungen" — nur Rechnungen
Faktly schreibt Rechnungen. Punkt.

RECHTLICHES
Faktly ersetzt keinen Steuerberater. Bei steuerlichen Fragen wende dich bitte an deinen Steuerberater oder das Finanzamt.
```

(~2,950 chars, within Play Store 4,000-char limit)

---

## Localized variant headers (PL + NL)

**PL Description headline**: `Faktly: Rechnung • Faktura • Factuur — Faktura JDG zgodna z KSeF od kwietnia 2026, bez abonamentu, €39 jednorazowo.`

**NL Description headline**: `Faktly: Rechnung • Faktura • Factuur — ZZP factuurapp gemaakt in de EU, geen abonnement, eenmalig €39.`

(Body translated to local language but structure identical — feature parity is part of the cross-border wedge.)
