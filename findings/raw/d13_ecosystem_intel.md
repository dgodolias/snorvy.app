# D13 — Greek Tax-Tech Ecosystem Intel (Tick 30 deeper dig)

Date: 2026-05-07. Sources: WebSearch (no auth). Time spent: ~10 min.

## Who built the AADE myDATAapp?

- Developer of record: **AADE (Independent Authority for Public Revenue)** itself — public-sector software, not outsourced under a publicly disclosed brand.
- No identifiable LinkedIn vendor team. The Play Store listing shows AADE as the publisher only.
- Last-update cadence (per public AADE PDFs): manuals/quick-guides dated 2025-01 and 2025-02; Athens-Times confirmed an upgrade in 2025 ("AADE Enhances Digital Customer Register and myDATAapp"). Public docs: only first-half-2025 versions, no 2026 release notes surfaced.
- Third-party developer ecosystem around the **myDATA REST API** is healthy: open-source SDKs `firebed/aade-mydata` (PHP) and `ppapapetrou76/go-mydata-aade` (Go) on GitHub, plus SAP SCPI integration guides. This proves the API is documented and accessible — friendly for an indie wedge app that talks to myDATA on the user's behalf.

## Epsilon Smart (incumbent #1)

- Parent: **Epsilon Net SA**, listed on Athens Stock Exchange (EPSIL.AT).
- Scale: 1,700+ employees, 27 subsidiaries, EBITDA margin ~33%, 2023 turnover ≈ €100M (USD), 2025 plan target €150M.
- Epsilon Smart subscriptions disclosed at **>50,000** (PR mentioning 80,000+ in another asset).
- Pricing: subsidized 90% via Greek "Digital Tools for SMEs" RRF program — i.e. heavily incumbent-locked into a state-grant moat.
- Strategic partnership with NBG (National Bank of Greece). Acquisition-led growth.
- Implication for D13: **incumbent is a public-stock heavyweight, not a beatable startup**. Wedge must avoid head-on competition; survive on UX gap (mobile-first, simpler UI) the AADE 1★ reviews repeatedly demand.

## Timologic (the abandoned competitor)

- Confirmed: last update **2023-09-23** on Play Store (`gr.lomsoft.timologic`).
- Vendor: "Lomsoft" (per package name); no public founder identity surfaced via search; LinkedIn page exists for "Timologic" but minimal staffing signal.
- No publicly documented "shutdown event" — appears to be a quiet abandonment, not an acquisition or pivot. Combined with the 2026 e-invoicing mandate postponement (KPMG, EDICOM), the field is open-but-uncertain.

## SoftOne, Singular Logic, Datacomm

- **SoftOne** (Olympia Group): IAPR-certified e-invoicing provider, B2B/B2C/B2G. Enterprise positioning, "feels outdated" per freelancer reviews.
- **Singular Logic**: legacy enterprise; cited as "outdated and overly complex".
- **Datacomm**: no Greek e-invoicing presence found; likely not a tax-tech competitor.

## Modern challengers

- **Elorus** (founded 2014, two-founder Athens team): freemium ($0 free → $9/$19/$39), 98% G2 satisfaction, 182 reviews. Native myDATA integration. **This is D13's nearest peer.** Web-first, not mobile-first.
- **Ruul, InvoiceOcean**: international tools with Greek localization.

## VC / funding patterns

- No Greek tax-tech-specific VC pattern surfaced; Epsilon Net's growth is via acquisitions + RRF state grants, not venture rounds.
- Mandatory B2B e-invoicing **postponed past Feb 2026** (KPMG, Sovos, EDICOM) — regulatory tailwind delayed but not killed.

## Implications for D13 wedge

1. AADE app's pain (tablet incompat, login/auth failures, no PDF export) is unaddressed even as of May 2026 — incumbent inertia is real.
2. Elorus is web-only; mobile-first freelancer wedge is uncontested.
3. Epsilon Smart wins on enterprise/state-grant; loses on mobile UX. D13 differentiation = **mobile-native + Greek-language + freelancer-priced**.
4. Open SDKs + documented myDATA API keep $0-budget plausible.
