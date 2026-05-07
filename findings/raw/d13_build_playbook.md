# D13 Bloki — 7-Week Build Playbook

**Goal:** Soft launch Jul 2026 → public launch Aug-Sep 2026 → ride Oct 1 mandate.
**Dev:** Greek solo, $0 budget (€350 ASA only).
**Stack assumption:** Flutter (Android-first per project context) + Cloudflare Worker proxy + Firebase free tier (Auth + Firestore).

## Week 1 (May 11-17): Foundations + AADE Sandbox Access

**Deliverables**
- AADE Taxisnet → ERP user subscription registered (prod + sandbox keys obtained)
- Cloudflare Worker scaffold deployed (free tier, holds subscription key as secret)
- Flutter project init, Material 3 with Greek locale (`el_GR`) as DEFAULT
- Trademark search: "Bloki" on EUIPO + GGE Greek registry (file €40 deferred to wk6)
- Domain: `bloki.gr` purchase (~€10/yr) OR `bloki.app`

**API milestone:** First successful `RequestVatInfo` call against sandbox.

## Week 2 (May 18-24): Core API Integration

**Deliverables**
- `SendInvoices` flow working (sandbox) — happy path only
- `RequestDocs` + `RequestTransmittedDocs` for reading inbox
- Local SQLite cache layer (offline-read of last 30 days of docs)
- Error handling for AADE schema validation failures (dev-friendly Greek error messages)

**API milestone:** Round-trip an invoice and read it back in <5s.

## Week 3 (May 25-31): UI/UX — Greek-First

**Deliverables**
- 3 main screens: Dashboard (MTD income/expenses), Issue Invoice (3-tap), Inbox
- Greek typography pass: Roboto/Inter with Greek subsets, no clipped tonos
- Test 5 screens with 3 real Greek freelancers (insomnia.gr DM outreach starts now)
- Onboarding: Taxisnet OAuth-style "paste your subscription key" with QR helper

**Greek UX test #1:** Watch 3 freelancers do "issue an invoice for €500 to client X" cold. Target: <60s.

## Week 4 (Jun 1-7): Classification + Periodic Returns

**Deliverables**
- `SendIncomeClassification` / `SendExpensesClassification` — preset templates per profession (μηχανικός, ιατρός, designer, IT)
- `RequestE3Info` dashboard widget — "your annual E3 so far"
- Push notifications for: new doc received, deadline reminders (10/20/30 of month)
- Accountant review #1: hire λογιστής for 1 hour (€80) to validate classification logic — DEFERRED if budget zero, replace with `r/greece` accountant ask

## Week 5 (Jun 8-14): Beta Testers + Polish

**Deliverables**
- TestFlight equivalent on Play Console internal track — 20 beta slots
- **Beta recruitment plan:**
  - `r/greece` post: "Solo Greek dev shipping a free myDATA app — beta testers wanted (5 spots, lifetime free)"
  - `insomnia.gr` /tech subforum: same post in Greek
  - LinkedIn: 30 cold DMs to Greek freelancer profiles tagged #freelancer #ελληνας
  - Target: 15 active beta users by end of week
- Crash analytics (Firebase Crashlytics, free)
- Greek UX test #2: 5 new users, measure NPS + drop-off

## Week 6 (Jun 15-21): Trademark + Pre-Launch Compliance

**Deliverables**
- File "Bloki" trademark Greek class 9+42 (€100 self-file via OBI.gr)
- Privacy policy + ToS in Greek (use OpenAI for first draft, accountant 30-min review)
- GDPR: data residency note (Cloudflare EU edge), DPO not required <250 employees
- Play Store listing assets:
  - Greek title: "Bloki — myDATA για ελεύθερους επαγγελματίες"
  - Greek description (4000 char) with keywords: μύδατα, παραστατικά, ΑΑΔΕ, τιμολόγια, λογιστική
  - 8 Greek-language screenshots
  - Feature graphic 1024×500
- Accountant review #2 (paid €150 if budget allows) — final compliance signoff

## Week 7 (Jun 22-28): Soft Launch + ASA Prep

**Deliverables**
- Production `SendInvoices` validated against real AFM (dev's own freelancer test)
- Open beta on Play Store (Greece-only geo) — 100 invite-friend codes
- Apple Search Ads campaign drafts (€350 budget, target keywords: μύδατα, mydata, παραστατικά, ΑΑΔΕ τιμολόγιο, λογιστικό app)
- Press kit: 1-pager Greek/English emailed to:
  - taxheaven.gr (myDATA editorial)
  - epixeiro.gr
  - sepe.gr newsletter
  - r/greece pinned post
- **Ship date for public launch:** Mon **Jul 6, 2026**

## Post-launch hooks (Aug-Sep)

- Aug: weekly content drops on TikTok (`@bloki_gr`) — "myDATA σε 60 δευτερόλεπτα" series
- Sep 1: paid tier launches (€4.99/mo) once free has 500 MAU
- Oct 1: **mandate hits** — push update with "READY for Oct 1 — εσύ είσαι;" hero banner

## Ship-date targets summary

| Milestone | Date |
|---|---|
| Sandbox green | May 17 |
| End-to-end flow | May 31 |
| Beta open | Jun 14 |
| **Soft launch (open beta)** | **Jun 28** |
| **Public launch** | **Jul 6** |
| Paid tier | Sep 1 |
| Mandate ride | Oct 1 |

## Pre-launch checklist (gates Jul 6)

- [ ] Trademark filed (not granted, just filed)
- [ ] Privacy + ToS in Greek, accountant-reviewed
- [ ] Production AADE keys validated with real invoice
- [ ] Play Store listing 100% Greek + English
- [ ] 8 Greek screenshots + feature graphic
- [ ] At least 10 beta users with 7+ days of usage
- [ ] Crash-free rate >99.5%
- [ ] ASA campaign drafted (not live yet)
