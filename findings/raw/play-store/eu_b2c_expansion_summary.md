# EU + B2C Expansion Scan Summary (v9 supplemental)
Generated: 2026-05-07. Scope: PL/CZ/NL/SE invoice market + photographer / FSBO / pet-care B2C niches.

## 1. PL / CZ / NL / SE Invoice Market — Vulnerable Cells

| Country | App (appId) | Installs | Hist low% | Recent low% (200) | Top quote |
|---|---|---|---|---|---|
| PL | Faktura Proste / Invoice Simple (com.aadhk.woinvoice) | 5M+ | 8% | **18%** | "150€ za 10 Rachunków, to jakiś żart!" (150€ for 10 invoices — a joke!) + "Numer faktury narzucony z góry, nieczytelna, nieintuicyjna" |
| PL | Bookipi Invoice Maker (bookipi.invoice.maker.estimate.billing) | 1M+ | 2% | 4% | "wszystko bylo super dopóki nie wprowadzili opłaty" (great until they added fees) |
| PL | Tofu (com.tofu.invoices) | 1M+ | ?% | 0% | New entrant Dec 2023, already 1M+ — proves rapid adoption is possible |
| CZ | Invoice Simple (com.aadhk.woinvoice) | 5M+ | 6% | 9% | "Donedávna spokojenost i s cenou, momentalně zrušeno z důvodu ceny která udělala x2 na 6 600,- ročně" (was happy until price doubled to 6,600 CZK/yr) |
| CZ | Simple Invoice Manager (com.invoiceapp) | 5M+ | **40%** | 0% | Tacktile Systems IN-built — historical pain massive |
| NL | Invoice Simple (com.aadhk.woinvoice) | 5M+ | 10% | 10% | "Subscription costs €204.99... You would expect [price stability]" + "use to pay €60... now they want to charge €211 😱" |
| NL | **Invoice Fly / Labhouse** (io.labhouse.invoicesapp) | 1M+ | 10% | **50%** | "Best wel prijzig voor beginnende ondernemers" — pricing too high for starting entrepreneurs |
| NL | Invoice2Go (com.invoice2go.invoice2goplus) | 1M+ | 18% | 23% | **"dit is een bedrijf uit de VS. dus niet meer doen. nu een Nederlands bedrijf genomen"** — explicit anti-foreign sentiment |
| SE | (no native invoice apps surface) | — | — | — | Search returns POS apps (Square 50% hist_low, SumUp 21%/22%) — invoice-app vacuum but PoS dominates |

## 2. EU Regulatory Exempt Categories (the "Kleinunternehmer" wedge analog)

| Country | Scheme | Threshold | Wedge strength |
|---|---|---|---|
| PL | Zwolnienie podmiotowe z VAT (Art 113) | 200,000 zł 2025 → **240,000 zł from Jan 2026** | Strong. Plus: **KSeF mandatory e-invoicing Apr 1 2026 for all VAT-registered, Jan 1 2027 for micro** — active compliance scramble TODAY |
| CZ | OSVČ DPH osvobození | CZK 2,000,000 / 12mo rolling | Moderate. Higher threshold = larger free pool |
| NL | Kleineondernemersregeling (KOR) | €20,000/yr | Strong but small audience. Invoice must say "factuur vrijgesteld van OB o.g.v. artikel 25 Wet OB" — exact text feature |
| SE | Småföretag undantag | SEK 80k → **SEK 120k from 2025** | Weak — recently relaxed, low installed base of invoice apps |

## 3. Best EU Country to Expand Direction-4 Strategy

**WINNER: Poland (PL)**

Why PL beats CZ/NL/SE on combined criteria:
- **Vulnerable incumbent**: Same `com.aadhk.woinvoice` (Invoice Simple) at 5M+ installs with same pricing complaint pattern as DE — PL recent_low 18% vs DE comparable.
- **Active regulatory wedge**: KSeF mandatory e-invoicing for JDG hits Apr 1 2026 (in production NOW) — every JDG sole trader must adopt e-invoicing by then. App "Fakturownia - faktury w KSeF" (Polish-built, score 4.94) and "Invoice.app: Faktury KSeF" already surfacing — proves market understands. New entrant Tofu (Dec 2023 → 1M+ installs in <2 yrs) proves a clean app can win share fast.
- **Largest TAM**: ~3M+ JDG vs ~1M CZ OSVČ vs ~1.5M NL ZZP. PL = 3x CZ, 2x NL.
- **Language tractability for Greek dev**: Polish is NOT closer to Greek than NL/SE, but the **KSeF XML schema is government-published** — most localization is structured data, not idiomatic UI copy. Polish UI strings can be translated with AI + native review pass.
- **Pricing pain quote density**: PL > CZ > NL > SE based on review sampling.

Runner-up: NL — "I switched to a Dutch company" quote shows latent demand for non-US incumbent. Smaller market but Invoice2Go vulnerable (recent_low 23%). Labhouse Invoice Fly's recent_low 50% suggests acute pricing collapse window.

CZ: viable but smaller TAM, no regulatory catalyst.

SE: **REJECT** — no localized invoice-app market depth; POS apps dominate the search query (Square, SumUp). Swedish freelancers use desktop SaaS (Bokio, Visma) not mobile. Skip.

## 4. Photographer / FSBO / Pet-care Top Cells

### Photographer client gallery (US) — REJECT
Search returns commodity gallery apps (Google Photos, Snapseed, PicCollage). Pic-Time, Pixieset, ShootProof are web-first SaaS without significant Android footprint. **No Android-vulnerable target. Skip niche.**

### FSBO (US) — REJECT
- Zillow: 50M+ installs, recent_low 44% → CORPORATE moat, reject per constraint
- Redfin: 10M+, recent_low 39% → CORPORATE
- Trulia: 10M+, recent_low 20% → Zillow-owned
- OfferUp: marketplace requiring two-sided liquidity → reject
**Verdict: blocked by corporate dominance + marketplace liquidity requirement.**

### Pet groomer / dog walker (US) — REJECT
| App | Installs | hist_low | recent_low | Type |
|---|---|---|---|---|
| Wag! | 1M+ | **39%** | **56%** | Marketplace |
| Rover | 5M+ | 10% | 51% | Marketplace |
| TrustedHousesitters | 500k+ | 28% | 68% | Marketplace |
| PetBacker | 1M+ | 18% | 18% | Marketplace |
| Pawshake | 500k+ | 26% | 10% | Marketplace |

Wag! quote: *"So pushy and predatory. They push walkers on you even if all you want to do is browse through options"*
Rover quote: *"charges overly inflated fees for barely any customer service. App glitches always."*
TrustedHousesitters: *"I pay a €130 membership but can't talk to a real person... charge sitters €10 per sit after we pay a membership!"*

**ALL category players are two-sided marketplaces requiring liquidity → rejected per constraint.** A pure solo-practitioner CRM (no marketplace) might thread this needle but no incumbent is competing on that axis — would be blue-ocean cold-start, not displacement.

## 5. Best New B2C Niche Candidate for Direction 6

**None of the three scanned niches passes the (>40% low_pct + $0-cost + simple-build) filter.** All B2C niches scanned are blocked by corporate moats (FSBO) or marketplace-liquidity requirements (pet care). Photographer gallery has no Android target.

**Recommend keeping Direction 6 as defined or dropping the slot.** Re-scan with different niches: solo trades CRM (handyman/electrician), tutor session-tracker, music-teacher attendance, ESL home-tutor billing — all single-sided service-pro tools.
