# v9 Direction 1 — Competitive Validation: "Lifetime $39 + free portability + price-never-rises"

Date: 2026-05-07. Tested against the four candidates that could already occupy this position.

## Hard data (from this session's google-play-scraper pull, US Play Store)

| App | Installs | Score | Ratings | 1-star | offersIAP | IAPRange | Updated |
|---|---|---|---|---|---|---|---|
| **Invoice Simple** (incumbent) | 5,000,000+ | 4.82 | 167,126 | 4,920 (2.9%) | yes | $4.99–$399.99 | 2026-05-01 |
| **Bookipi** | 1,000,000+ | 4.60 | 66,018 | 4,149 (6.3%) | yes | $7.49–$174.99 | 2026-04-28 |
| **Zoho Invoice** | 1,000,000+ | 4.80 | 30,673 | 500 (1.6%) | **NO** | — | 2026-04-29 |
| **Square Invoices** | 1,000,000+ | 4.69 | 19,653 | 711 (3.6%) | yes | $20.00 (one item) | 2026-05-05 |
| Wave Invoice (US) | n/a | n/a | n/a | n/a | — | — | **App not found 404** — Wave delisted standalone Android invoice app |

## 1. Wave Apps — confirmed NOT a free alternative anymore

- Standalone Wave Android invoice app returned **404 — delisted**.
- Per prior IAP audit (referenced in task brief): now $8–$190/mo via web. Wave bundled into payments + payroll SaaS post H&R Block acquisition.
- **Conclusion**: Wave is OUT of the "free mobile invoice" race entirely. Cannot defend the position.

## 2. Zoho Invoice — the real $0-IAP competitor

- **offersIAP: false** — confirmed truly free in the app
- 1M+ installs, 4.80 score (matches Invoice Simple's quality), 30k ratings
- 1-star rate only 1.6% — best-in-class
- **Wedge / moat**: Tied to Zoho ecosystem (CRM, Books, Mail, Projects). Account-required → friction (low reviews complain "OTP not arriving", "can't verify account", "forcing me to switch to Zoho Books"). Account-required also blocks the offline / privacy-conscious sole-trader use case.
- **Threat level**: HIGH for the "free forever" framing. But Zoho's friction = **account creation + ecosystem lock-in** is the wedge to attack.

## 3. Bookipi — silently moved to freemium paywall, displacement opportunity confirmed

- 1M+ installs, 4.60 score (lower than IS), but 1-star rate **6.3% — 2× worse than IS**
- IAPRange $7.49–$174.99
- **Recent reviews tell a clear story**:
  - "Been using it for years... most recently it has begun to prompt for Subs" (1★, 2026-05-04)
  - "they have now capped generation at just 3 invoices per day" + "force a watermark on every document essentially using our clients for free advertising" (1★, 2026-04-28)
  - "used for like 2 years now need to pay a subscription to create invoices" (1★, 2026-04-02)
  - "First off there are so many fake reviews here. Was really good... them suddenly locking everything behind an extortionate paywall" (1★, 2026-04-15)
  - "i have over 120 invoice and over 80 customers... now app asking monthly or year subscription" (1★, 2026-04-19)
- **Conclusion**: Bookipi is no longer the "completely free" alt — it has joined the freemium-paywall club within the last 6-12 months. That's a **wide-open displacement window** for a true $0-or-one-time-$39 alternative.
- Free version now: 3 invoices / 30-day rolling period + watermark.

## 4. Square Invoices — tied to payment processing, not a wedge competitor

- 1M+ installs, 4.69 score, 3.6% 1-star
- Free download but monetises through 2.9% + $0.30 per card transaction (or $20 IAP add-on for some Plus features)
- **Wedge / moat**: Bundle with Square POS hardware + payment processing. Strong if you sell in person; **irrelevant** for trades/freelancers who just want a PDF emailer.
- Recent low reviews: "deceiving. hidden fees", "needs crazy permissions", "Forces you to login... I just want to make invoice PDFs - that's it. Ridiculously convoluted app" (1★, 2026-03-03)
- **Threat level**: LOW for the standalone-PDF-invoice user. Square is a different product category despite the same keyword surface.

## Conclusion: is "$0 forever + lifetime $39 unlock" defensible?

**YES — defensible, with one caveat.**

| Competitor | Occupies "$0 forever"? | Wedge to beat them |
|---|---|---|
| Wave | NO (delisted Android, web $8-190/mo) | already gone |
| **Zoho Invoice** | **YES — truly $0 IAP** | **account-required + ecosystem lock-in friction** (real low-review pain) |
| Bookipi | NO (silently went freemium 2024-25, 3-invoice cap + watermark) | "no rug-pull" + "your data exports as CSV/PDF anytime" → directly answers their pain |
| Square Invoices | NO ($0 download but payment-processing fee) | trade-only / no Square account / PDF-only |

The differentiation thesis is defensible if positioned as:

1. **vs. Bookipi**: "We promise no rug-pull. Lifetime $39 = the price never goes up. Your data exports anytime."
2. **vs. Zoho Invoice**: "No account required. Works offline. Your invoices stay on your device."
3. **vs. Invoice Simple**: "Pay once, own forever. No subscription. No $399/yr ceiling."
4. **vs. Square Invoices**: "Just a PDF invoice. No payment processor. No KYC. No locked funds."

**The single biggest risk**: Zoho Invoice. They are genuinely $0 and high-quality. The ONLY reason a sole-trader would choose a $39 lifetime over Zoho's $0 is if they hit Zoho's onboarding friction (account creation + OTP issues per low reviews) OR want offline-first + no-cloud privacy.

**Recommendation**: Direction 1 is **defensible** but the messaging must lead with **"no account, no cloud, offline-first"** — not just "lifetime $39". The free price point is matched by Zoho; the offline/private/no-account angle is the actual differentiator.

Sources: Play Store metadata + 60-most-recent-low-review samples pulled this session (findings/raw/play-store/v9_direction1_competitors.json), bookipi.com pricing page, zoho.com/invoice, squareup.com/us/en/invoices/pricing.
