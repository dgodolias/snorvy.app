# Greek Solo Dev Execution Intelligence - FairBill (v9 Direction 1)

**Scope**: Concrete pre-launch + launch checklist for a Greek solo dev shipping a paid B2B utility app to global (US/GB/DE/AU) markets. Cost-floor + 3-5 wk build constraint. Today: 2026-05-07.

---

## 1. Greek Business Setup - Minimum Required

### 1.1 Sole Proprietor (Ατομική Επιχείρηση) - cheapest legal structure

- **Form**: Δ211 via myAADE / TAXISnet -> instant digitally-signed certificate
- **KAD code**: **62.01.11.01 / 62.01.21** (παραγωγή πρωτοτύπων λογισμικού / υπηρεσίες σχεδιασμού-ανάπτυξης λογισμικού)
- **Prerequisite**: AFM (already has, every Greek adult does) + TAXISnet credentials + EU citizenship/residence
- **Cost**: €0 to register. NO Επιμελητήριο fee for IT freelancer if KAD 62.x.
- **Note**: AADE platform offline 01.03.2026 - 10.03.2026 for KAD remapping migration. **Register BEFORE 01.03 or AFTER 10.03.** ([AADE start sole prop](https://www.gov.gr/en/arxes/anexartete-arkhe-demosion-esodon-aade/anexartete-arkhe-demosion-esodon-aade/enarxe-atomikes-epikheireses))

### 1.2 VAT (ΦΠΑ) - GOOD NEWS

- **Threshold**: €10,000/year. Below = **VAT-exempt small business regime** (no ΦΠΑ filings, no ΦΠΑ on invoices). ([EY Greece small ent. exemption](https://www.ey.com/en_gr/technical/tax/tax-alerts/new-special-vat-exemption-scheme-for-small-enterprises))
- **Apple/Google as Merchant of Record**: Both collect & remit VAT in EU. Your payouts arrive **net of VAT and platform fee**. You do NOT file VAT MOSS. You do NOT collect VAT from end users. ([Appfigures VAT explainer](https://appfigures.com/support/kb/616/how-vat-is-handled-by-apple-and-google-play))
- For Y0 with FairBill projected <€10k revenue: opt into the small-business VAT-exempt regime at registration (Form Δ211 checkbox).

### 1.3 Income Tax (Φορολογία)

- Net profit (revenue - deductible expenses) declared annually on E1 + E3
- Brackets 2025 (likely held for 2026): **9% to €10k, 22% €10-20k, 28% €20-30k, 36% €30-40k, 44% >€40k**
- Source: επιχειρηματική (Α' πηγή). Apple/Google revenue is "εισοδήματα από επιχειρηματική δραστηριότητα". ([taxlaw.gr freelance tax](https://www.taxlaw.gr/en/special-topics/taxation-freelance-activity-sole-trader-business-in-greece-standard-greek-tax-rules/))

### 1.4 e-EFKA (Social Security)

- **Lowest class (Κατηγορία 1)**: ~**€250/month** principal pension+health = ~**€3,000/year** mandatory (deductible from taxable income)
- Selection deadline for the 2026 class: 31/01/2026 (already passed -> defaults to Κατηγορία 1 if didn't opt). ([epimetol e-EFKA 2026](https://www.epimetol.gr/en/e-%CE%B5%CF%86%CE%BA%CE%B1-%CE%BC%CE%AD%CF%87%CF%81%CE%B9-%CF%80%CF%8C%CF%84%CE%B5-%CF%80%CF%81%CE%AD%CF%80%CE%B5%CE%B9-%CE%BD%CE%B1-%CE%B3%CE%AF%CE%BD%CE%B5%CE%B9-%CE%B5%CF%80%CE%B9%CE%BB%CE%BF/))

### 1.5 myDATA / Ηλεκτρονική Τιμολόγηση

- B2B mandatory: Phase 1 **2 March 2026** (revenue >€1M), Phase 2 **1 October 2026** (everyone else). ([EDICOM Greece B2B](https://edicomgroup.com/blog/greece-mandatory-electronic-invoice))
- Solo dev path: use **timologio.aade.gov.gr** (free official AADE app) to issue + transmit invoices automatically. Zero software cost. ([AADE timologio](https://www.aade.gr/en/timologio))
- **IMPORTANT for FairBill**: you almost never issue Greek B2B invoices (Apple/Google pay you as a US/IE entity, not Greek B2B). myDATA still requires you log Apple/Google receipts as "Λήψη Παραστατικού από Αλλοδαπή" in myDATA. timologio handles it.

---

## 2. Apple + Google Console Setup

| Item | Cost | Notes for Greek dev |
|---|---|---|
| Apple Developer Program | **$99/yr (~€92)** | Pay with Greek IBAN/credit card. AFM required in App Store Connect Tax info. Greek bank account works for payouts via SEPA/IBAN. Apple-fee VAT (24%) charged on the $99 -> ~€114 total. ([Apple developer agreement](https://developer.apple.com/support/terms/apple-developer-program-license-agreement/)) |
| Google Play Console | **$25 one-time** | Pay with Greek card. Greek bank IBAN for payouts (EUR). |
| Apple payout threshold | $40 USD min before payout (~€37) | Net 45 days after fiscal month close. ([Apple min payment threshold](https://developer.apple.com/help/app-store-connect/reference/reporting/minimum-payment-threshold/)) |
| Google Play payout threshold | $1 minimum (effectively monthly) | Direct EUR to Greek IBAN |

**Stripe Atlas / Delaware LLC -> NOT NEEDED.** Apple+Google handle merchant-of-record for ALL global app sales. No US LLC needed. Greek sole prop is sufficient. (Stripe Atlas would add $300/yr DE franchise tax + IRS Form 5472 + accountant cost. Skip.)

---

## 3. Phase-by-Phase Checklist

### Phase 0 - Pre-build (Week 0)

1. **Register sole prop** via myAADE Δ211 (KAD 62.01.21, opt into small-biz VAT exemption). Cost: €0. Time: 1 day.
2. **Apple Developer enrollment** at developer.apple.com -> Individual account (NOT organization, no D-U-N-S needed). Cost: ~€114 incl VAT. Time: 24-48h verification.
3. **Google Play Console**: play.google.com/console -> Personal -> €23 one-time + ID verification. Time: 1-2 days.
4. **Trademark search "FairBill"**: USPTO TESS (free), EUIPO eSearch plus (free), WIPO Global Brand Database. Skip Madrid Protocol filing for Y0 (basic fee 653 CHF + per-country = €1500+ -- defer until €5k MRR). For Y0 just do EUIPO €850 if revenue justifies, otherwise skip and rely on common-law mark.
5. **Domain**: fairbill.app or getfairbill.com via Namecheap/Porkbun. Cost: ~€10-15/yr.
6. **Privacy policy**: **Termly.io free generator** (sufficient for paid utility, no PII beyond device-local invoice data). DO NOT pay a lawyer. Cost: €0.

### Phase 1 - Build (Weeks 1-3)

- React Native/Expo or native Swift/Kotlin. Local-first SQLite. PDF gen via react-native-pdf-lib. No backend (S3 for optional cloud backup later). Cost: €0.

### Phase 2 - Pre-launch (Week 4)

- App Store Connect: bundle ID, screenshots (iPhone 6.7" + 6.1" + iPad), App Privacy questionnaire (mark "no data collected" if local-first), Tax info (Greek AFM, W-8BEN-E for US tax), banking IBAN.
- Google Play Console: same flow, Data Safety form, Content Rating questionnaire.
- **Greek tax angle**: declare anticipated Apple/Google revenue as "ακαθάριστα έσοδα" on the next year's E3 form. No quarterly filings needed if VAT-exempt.

### Phase 3 - Launch (Week 4-5)

- **Product Hunt**: schedule for Tuesday-Thursday 12:01 AM PST. Pre-warm hunters/supporters 7 days ahead.
- **Reddit**: r/freelance, r/Entrepreneur, r/smallbusiness, r/digitalnomad, r/Etsy, r/Plumbing, r/Electricians (B2B targeted) -- post AFTER PH launch. Format: "I built X because [pain]. Free for first 100." NO link in title.
- **X/Twitter**: 10-tweet launch thread. Tag @ProductHunt, @indiehackers.

### Phase 4 - Post-launch (Week 5+)

- **Crisp.chat free tier** (2 agents, basic chat) > HelpScout ($25/mo). Cost: €0.
- **Apple Search Ads Basic**: $5/day floor, no minimum spend. Allocate **$50 of $350 budget** to ASA, **$300 to Google UAC** (better volume). ([Business of Apps ASA costs](https://www.businessofapps.com/marketplace/apple-search-ads/research/apple-search-ads-costs/))
- **Firebase Crashlytics** free unlimited.
- **AppFollow free tier** for review monitoring (1 app, 1 country) OR weekly manual scrape.

---

## 4. Y0 Total Setup Cost (€)

| Item | EUR |
|---|---|
| Sole prop registration | 0 |
| Apple Dev Program (incl 24% VAT) | 114 |
| Google Play Console | 23 |
| Domain (.app or .com) | 12 |
| Privacy/ToS (Termly free) | 0 |
| Trademark (skip Madrid Y0; optional EUIPO) | 0 (or 850) |
| myDATA timologio | 0 |
| Crisp/Firebase/AppFollow | 0 |
| e-EFKA Class 1 (annualized, mandatory) | ~3,000 |
| **TOTAL excl EFKA** | **~€150** |
| **TOTAL incl mandatory EFKA** | **~€3,150** |
| Ad budget (separate) | 350 |

EFKA is unavoidable if going legit. The PURE setup cost (one-time, app-related) is **~€150**.

---

## 5. Critical Greek-dev Gotchas

1. **AADE platform downtime 01.03.2026 - 10.03.2026** for KAD remapping. If sole-prop registration falls in this window, blocked. Register the week of 11-15 May 2026 (this week!) BEFORE the next maintenance window risk.
2. **Apple charges 24% Greek VAT on the $99 dev fee** ($99 -> ~$123 total). Budget for it -- it's deductible as "δαπάνη επιχείρησης" on E3.
3. **Defaulted to e-EFKA Class 1**: if you didn't opt-in by 31/01/2026, you're paying ~€250/mo regardless of revenue. This is the REAL cost of legitimacy in Y0 (~€3k), not the app costs.
4. **Greek bank wire to Apple/Google is fine** -- Eurobank/Piraeus/Alpha all support outbound EUR card payments without FX gotchas. Use Revolut Business (free) to hedge if needed.

---

## Sources

- [AADE sole prop start](https://www.gov.gr/en/arxes/anexartete-arkhe-demosion-esodon-aade/anexartete-arkhe-demosion-esodon-aade/enarxe-atomikes-epikheireses)
- [taxlaw.gr freelance Greek tax](https://www.taxlaw.gr/en/special-topics/taxation-freelance-activity-sole-trader-business-in-greece-standard-greek-tax-rules/)
- [EY Greece small enterprise VAT exemption](https://www.ey.com/en_gr/technical/tax/tax-alerts/new-special-vat-exemption-scheme-for-small-enterprises)
- [AADE timologio free e-invoice](https://www.aade.gr/en/timologio)
- [EDICOM Greece B2B e-invoicing](https://edicomgroup.com/blog/greece-mandatory-electronic-invoice)
- [Apple min payment threshold](https://developer.apple.com/help/app-store-connect/reference/reporting/minimum-payment-threshold/)
- [Apple Developer Program License Agreement](https://developer.apple.com/support/terms/apple-developer-program-license-agreement/)
- [Appfigures VAT explainer Apple/Google](https://appfigures.com/support/kb/616/how-vat-is-handled-by-apple-and-google-play)
- [Business of Apps ASA costs 2026](https://www.businessofapps.com/marketplace/apple-search-ads/research/apple-search-ads-costs/)
- [link.com.gr e-EFKA 2026 contributions](https://www.link.com.gr/en/self-employed-contributions-greece-2026/)
- [WIPO Madrid System fees](https://www.wipo.int/en/web/madrid-system/fees/ind_taxes)
