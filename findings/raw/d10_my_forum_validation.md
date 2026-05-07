# D10 — MY Freelancer Forum Validation (MyInvois Companion)

**Date:** 2026-05-07 (Tick 20)
**Goal:** Validate Direction 10 demand by sampling Bahasa Malaysia / Malaysian English complaints about the official LHDN MyInvois app and Phase 4 mandate readiness.

## Sources scraped
- Lowyat.NET forum/topic/5452632 ("Every Malaysian have to use MyInvois?")
- Lowyat.NET forum/topic/5519608 ("e-Invoicing for freelancer with foreign clients")
- Google Play Store listing my.gov.hasil.myinvois (review summary via search)
- WebSearch aggregate: "MyInvois aplikasi rosak", "tak boleh guna", "mobile app bug crash 2026"

## Top 5 verbatim complaints (with English gloss)

### 1. App doesn't scale on phones, broken buttons (Play Store reviewer aggregate)
> "The app doesn't scale properly with phones, making certain buttons unclickable, and e-invoices cannot be exported to PDF format—only to JSON script."

**Implication for D10:** Govt app fails the most basic mobile UX test. A clean responsive Flutter UI alone is a wedge.

### 2. Persistent bugs in 2026 (Play Store, English/BM mix)
> "Too many bugs, including the inability to update notification emails and TIN information... as of 2026 the app is still buggy."

**Implication:** Even after 18 months of iteration, LHDN can't ship stable email/TIN edit. A solo dev can.

### 3. Last-minute mandate panic (Lowyat user "Natsukashii", BM-EN code-switch)
> "pretty much a lot of stuff is not ready.. people also don't have enough knowledge about it, then suddenly comes last minute deadline"

**English:** "A lot of stuff still isn't ready, people don't know enough about it, and suddenly the deadline is on us."
**Implication:** Education + onboarding is a wedge. App can ship a "What is e-Invois?" Bahasa explainer flow.

### 4. Doubled paperwork pain (Lowyat freelancer foreign clients thread)
> "it's obviously twice the amount of paperwork on my end"
> "Feels like a lot of work just to keep track of these tiny fees individually"

**Implication:** Freelancers want a tool that auto-handles forex notes / micro-fees. Big differentiation room.

### 5. Unclear guidance, govt push only (Lowyat "LonelyHart16", BM)
> "Seems like details unclear. Only thing that is clear is gamen die2 want implement einv."

**English:** "Details unclear. Only thing clear is the government really wants e-Invois implemented."
**Implication:** Confusion = market opening. App can be the trusted Bahasa-first guide.

## Named alternative apps (competitive landscape)

| App | Positioning | Threat to D10 |
|---|---|---|
| **Bukku** | Free permanent plan, MDEC-accredited Peppol provider | HIGH — strongest free competitor, but desktop-first |
| **InvoisPro** | 20 free invoices/month, Peppol + LHDN | MEDIUM — web-first, no strong mobile |
| **JomeInvoice** | Flexible, retail/freelance focus | MEDIUM — paid, no killer mobile UX |
| **Financio** | Micro-entrepreneur focus | LOW-MEDIUM — accounting-first, complex |
| **IRIS MyInvois** | B2B integration | LOW — enterprise, not MSME |
| **Zoho Books / Wave** | Generic invoicing + LHDN plug-in | LOW — not Malaysia-native, EN-only UX |

**Verdict:** Bukku is the only serious threat for free MSME segment. Their weakness: desktop-first, not "phone-in-pocket" for gig workers / freelancers. **D10 wedge stands: mobile-native + Bahasa-first + Phase-4-onboarding-as-a-feature.**

## Pain density signal
- Play Store official MyInvois app: persistent 2026 bugs after >12 months
- Lowyat users: "details unclear", "twice the paperwork", "stuff not ready"
- 100% recent low_pct (from prior scrape) is corroborated by independent forum data
