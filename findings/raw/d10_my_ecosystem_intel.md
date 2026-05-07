# D10 Malaysia e-Invoicing Ecosystem Intel — Tick 32 DEEPER DIG

## Competitive landscape (Malaysian e-Invoicing space, May 2026)

### LHDN MyInvois (govt) — `my.gov.hasil.myinvois`
- Free, mandatory access portal/app provided by Lembaga Hasil Dalam Negeri (LHDN)
- Vendor: "Aplikasi Mobile HASiL" (govt-internal)
- Live since Oct 2024 (Lowyat.NET coverage)
- 26 total Play reviews. Of those: 22 ≤2★ → **84.6% lifetime low_pct**.
- Recent (last 6 months, Nov 2025–May 2026): **8/8 reviews ≤2★ = 100% recent low_pct.**
- Free tier capped at 30 invoices/day per LHDN guidelines.

### Bukku — `com.nukleus.bukku` (MiniPOS) + bukku.my web
- Local Malaysian SME accounting software, only platform with **permanently free** e-invoicing tier
- LHDN-compliant + Authorised Peppol service provider
- Paid plans <RM2/day (~RM60/mo) per bukku.my pricing
- MiniPOS app: only 5 reviews (~3.6★ avg, 1×1★, 1×3★ → 40% low_pct, but n=5 so weak signal)
- Bukku is web-first; mobile is a thin POS companion not a full mobile e-Invois experience

### Financio (ABSS / Asian Business Software Solutions) — `com.abssasia.connect` + `com.financio.payroll`
- ABSS = ex-MYOB Malaysia, established local accounting vendor
- "Built specifically for Malaysian market, Malay-language invoices, SST calc, native LHDN" (Airwallex 2026)
- ABSS Connect: 22 reviews lifetime, mixed 14×5★/2×4★/2×3★/3×1★/1×2★ → **18% low_pct lifetime**, but most reviews 2020–2023 (stale, no MyInvois mandate context)
- Financio Payroll app: only 4 reviews, 2×5★ "Terbaik" + 2 negative (login/auto-login issues) → 50% low_pct
- Web-first; mobile apps low engagement

### JomeInvoice — `my.jomeinvoice.consumer` + `my.jomeinvoice.app`
- Top-3 named middleware in Malaysian press (Airwallex, Jomeinvoice press)
- Mobile presence: **0 reviews on either Android app** — Play Store launch but no user base
- Web-only de-facto

### Other named alternatives (web/SaaS, no mobile):
- Synergy Accounting (synergysoftware.com.my)
- Kiizen
- BizTrak
- ClearTax MY
- Xero (via Invoici middleware connector)
- QuickBooks (via Sovos middleware) — both NOT native MY

## LHDN technical support vendor for govt MyInvois mobile app
"Aplikasi Mobile HASiL" — internal LHDN dev team. **Reviews show classic govt-IT failure modes**: WebView wrappers, crashing on Vivo/Xiaomi/Pixel, QR scanner broken, 10-day record retention only, OAuth 500 errors, login loops, screen cutout collisions. Devs unresponsive (zero reply on any of 26 reviews vs Financio's 100% reply rate in 2020).

## Top app alternatives mentioned on Lowyat.NET / forum / press
1. **Bukku** — most-mentioned free tier alternative
2. **Financio (ABSS)** — most-mentioned local paid alternative
3. **JomeInvoice** — most-mentioned middleware brand (no mobile traction)
- Reddit r/Malaysia: not surfaced in WebSearch (likely behind reddit block); Lowyat thread "Every Malaysian have to use MyInvois?" exists but is consumer-confusion, not app reviews

## Pricing benchmarks (RM/mo)
| Vendor | Free tier | Entry paid |
|---|---|---|
| MyInvois (LHDN) | Free, 30 inv/day cap | n/a |
| Bukku | **Forever-free e-invoice** | <RM60/mo (~RM2/day) |
| Financio | 30-day trial | ~RM50–80/mo |
| JomeInvoice | Free trial only | ~RM40–80/mo (middleware) |
| Xero+Invoici | None | RM150+/mo combined |

## Key 2026 mandate facts
- **Phase 4: 1 Jan 2026** — RM1M–RM5M turnover MUST file e-Invois
- 6-month grace period to 30 Jun 2026 (consolidation allowed)
- From 1 Jan 2026: **transactions >RM10K must be individual e-invoice** (no consolidation)
- Below RM150K: exempt; Below RM1M: deferred (not yet mandatory)
- ~240,000 MSMEs in mandated bracket per LHDN
- MSME Digital Grant 2025/26 subsidies available

## Pain points distilled (govt app + Apple App Store + WebSearch)
1. **App crashes on launch** on Vivo, Xiaomi, Pixel devices ("apps will exit automatically")
2. **QR scanner broken** ("black screen", "scan QR invoice pun failed")
3. **Only 10–31 days of record retention** ("uploaded documents are no longer retrievable by the subsequent month")
4. **Cannot export e-invoice as PDF** — only JSON (per Apple App Store reviews 2026)
5. **No MyDigital ID login** — only manual OAuth that throws HTTP 500
6. **Address/phone form bug** — save loop: address requires phone, phone requires address
7. **No Bahasa-first UI** — generic govt Malay, no Bahasa accounting glossary
8. **Forced compliance** — "biggest failure of government is building an half baked app and force everyone to use"
9. **No offline mode** for poor connectivity rural MSMEs (LHDN guidance: "approach nearest IRBM state office")
10. **No PDF receipt flow** for B2C MSMEs — incumbent retail POS integration broken

## D10 wedge thesis sharpened (vs incumbents)
- **MyInvois govt**: hated, mandatory, no PDF, no MyDigital ID, crashes — *attack vector: just be reliable + PDF + MyDigital ID*
- **Bukku**: web-first, mobile is just thin MiniPOS — *attack vector: mobile-first Bahasa UX*
- **Financio**: stale, low engagement — *attack vector: post-2026-mandate-aware design*
- **JomeInvoice**: zero mobile traction — *attack vector: own the "mobile e-Invois" semantic slot*
- **Greek dev edge**: Greek myDATA experience (similar EU e-invoicing mandate); Greek devs already shipped EU-mandate apps. Pair with Bahasa translator → ship Bahasa-first MyInvois reader/submitter that works on cheap Vivo/Xiaomi devices govt app crashes on.

## Build-time refinement
- **Wedge feature stack** (in priority):
  1. PDF export of any e-Invois (govt only does JSON) — TOP user complaint
  2. Reliable QR scanner that doesn't black-screen on Vivo/Xiaomi
  3. MyDigital ID login (govt app missing it)
  4. ≥12-month record retention (govt: 10 days)
  5. Bahasa-first form labels w/ accounting glossary
  6. Offline draft mode (poor rural connectivity)
  7. Auto-fill address/phone (govt app broken)
  8. Push reminder when invoice >RM10K (post-Jan-2026 individual-invoice rule)
- Build estimate: 8–10 weeks solo + 2 weeks Bahasa polish via Fiverr translator (~$200)
- Backend: $0 — Firebase free tier or pure local SQLite (govt MyInvois API is REST/JSON, free)
- Monetization: **freemium @ RM12/mo unlock for >50 invoices/mo** (undercut Bukku ~RM60, premium reliability vs free govt app)
- TAM: 240K MSMEs in Phase 4 bracket × 5–10% capture × RM12/mo × 12 = RM1.7M–RM3.5M ARR ceiling
