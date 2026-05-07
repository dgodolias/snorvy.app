# D2 IAP Audit — QBSE / Solopreneur / Keeper Tax (live, US Play Store, 2026-05-07)

## Live IAP ranges (Google Play, US, pulled today)

| App | Android appId | IAP Range (live) | offersIAP | Description signal |
|---|---|---|---|---|
| QBSE legacy | `com.intuit.qbse` | **$2.49 – $35.00 / item** | true | Description redirects new users to `com.intuit.quickbooks` (Solopreneur). Legacy app, mileage-only utility for existing subscribers. |
| Solopreneur (new flagship) | `com.intuit.quickbooks` | **$0.99 – $420.00 / item** | true | Title now "Intuit QuickBooks for Business". AI-led, includes voice notetaking, AI estimate generation. |
| Keeper Tax | `com.keepertax` | **No IAP listed** | **false** | Tax-filing & expenses; pricing ($20/mo or $192/yr) is collected on web/in-app via direct billing, not Google Play IAP. Confirms gap: only Keeper monetizes Schedule C estimator at scale, and only via web. |

## Notes on the QBSE → Solopreneur transition (Intuit)

- QBSE Play store description literally says: *"For a new QuickBooks subscription, go to the QuickBooks Online Accounting app to subscribe and access the new QuickBooks Solopreneur product…"* — i.e. Intuit is sunsetting QBSE for new users and funneling them to a different SKU at higher price tiers.
- Solopreneur IAP ceiling jumped from $35 (QBSE) to **$420** (Solopreneur) — a 12× expansion of the price ceiling. This is consistent with Intuit moving Self-Employed customers up the QuickBooks Online price ladder.
- iOS confirms the consolidation is complete: there is **NO separate iOS QBSE or Solopreneur listing** anymore. Legacy id `1056941055` returns HTTP 404 (deprecated). All iOS Self-Employed traffic now flows through `id 584606479` "Intuit QuickBooks for Business" — a single mega-listing rated 4.72 with 231,695 reviews that masks self-employed sub-segment pain.

## Price-hike evidence from reviews (Solopreneur Android, GB/US)

Sample verbatim from `com.intuit.quickbooks` 1-3★ reviews pulled today:

1. **2026-05-03 / 1★** (UK): *"this calendar year, I'm being double charged. £11.99 & £18.99. Quickbooks can't help, as I subscribe through Google Play. I don't know which is correct."* → confirms two simultaneously-active price tiers post-migration.
2. **2026-05-02 / 1★** (UK): *"Atrocious money-leeching practices. Exactly what I feared the MTD transition would lead to when the government said they'd outsource the software to third parties."*
3. **2026-04-27 / 1★** (UK): *"Quickbooks Self Employed worked well, but this Sole Trader Plus is terrible."* — explicit before/after comparison of the renamed SKU.
4. **2026-04-15 / 2★**: *"really expensive for what you get I miss the old days where you can just buy the program outright and not have to keep pumping money into it"*
5. **2026-04-05 / 2★**: *"over priced"* (single line, US).
6. **2026-04-03 / 1★**: *"they charged me twice and 2 hours later when I tried to use payroll it said I need to make a payment…"*

## Implication for Direction 2

- The Schedule C / Solopreneur category has a **forced-migration price hike actively in flight RIGHT NOW** (2026-04 / 2026-05 reviews show migration pain still acute), with the only real free-tier displacer (QBSE) being deprecated by Intuit itself.
- Keeper Tax (the only credible quarterly-tax-estimate competitor) charges **outside of Play IAP** (web subscription), and has only **100k installs** vs Intuit's 5M+. Long tail of Schedule C self-employed users underserved at the $0–$10/mo tier.
- Pricing wedge for D2: a $0–$5/mo Schedule C quarterly-estimator + mileage tracker (no AI inference, $0 backend) cleanly undercuts Solopreneur ($18.99/mo UK live) and Keeper ($20/mo) by 4-20×.
