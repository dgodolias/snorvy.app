# D13 Bloki — AADE myDATA REST API Research

**Date:** 2026-05-07 | **Tick 26** | **Status:** Build feasibility = GREEN

## 1. API Endpoints

| Environment | Purpose | Registration URL |
|---|---|---|
| **Production** | Live transmission to AADE | Via `https://www1.aade.gr/saadeapps2/bookkeeper-web` |
| **Sandbox (dev)** | Free testing, no fiscal effect | `https://mydata-dev-register.azurewebsites.net` |
| **Developer Portal** | API console, docs | `https://mydata-dev.portal.azure-api.net/` |

Latest spec: **v2.0.1 (Jan 2026)** — official PDF: `aade.gr/sites/default/files/2026-01/myDATA API Documentation v2.0.1_preofficial_erp.pdf`

## 2. Developer Registration (ERP user track — what Bloki needs)

**NOT** the "Provider" track (that's heavy regulated certification, multi-month compliance committee). Bloki = **ERP user** = self-service, ~1 hour.

Steps:
1. Login to `bookkeeper-web` with **personal Taxisnet credentials** (the dev's own AFM)
2. Select "Subscribe to myDATA REST API" → "New user subscription"
3. Fill form: username, password, email
4. Receive **Subscription Key** (string, unique per AFM)
5. For sandbox: separate registration at `mydata-dev-register.azurewebsites.net`

**Cost:** €0. No fees, no certification, no documentation submission for ERP-user track.

**Required documents:** Just a Greek AFM (tax ID) + Taxisnet account. The dev (Greek solo, has both).

## 3. Authentication

- **Method:** API Key (header-based, NOT OAuth2)
- **Headers required on every call:**
  - `aade-user-id: <username>`
  - `Ocp-Apim-Subscription-Key: <subscription_key>`
- **Transport:** HTTPS (TLS verification can be relaxed in dev only)

This is the simplest possible auth — no token refresh, no OAuth dance, no JWT signing. Solo-dev friendly.

## 4. Rate Limits

**Not officially published.** Community libraries (firebed/aade-mydata, attheodo/mydatanaut) do not document hard caps. Azure API Management backs the endpoint → typical default ~600 calls/min per subscription key. For Bloki's use case (a freelancer reading their own invoices once/day, posting 5-50/month), rate limits are a non-issue.

## 5. Supported Endpoints (v2.0.1)

13 primary + 6 digital goods movement methods. The ones Bloki needs:
- `SendInvoices` — issue invoice → AADE
- `CancelInvoice` — void
- `RequestDocs` / `RequestTransmittedDocs` — read inbox
- `RequestMyIncome` / `RequestMyExpenses` — fetch dashboard data
- `SendIncomeClassification` / `SendExpensesClassification` — categorize
- `RequestVatInfo` / `RequestE3Info` — periodic returns
- `ValidateVatNumber` — counterparty AFM lookup

## 6. Existing Open-Source Wrappers (saves weeks)

| Library | Lang | Quality | Use |
|---|---|---|---|
| `firebed/aade-mydata` | PHP | Active, fluent API, 13 methods | Reference architecture |
| `attheodo/mydatanaut` | Python | Maintained | Backend if needed |
| `yiannis-spyridakis/mydata-client` | TS/JS | Provider-doc | TypeScript port reference |

**Bloki strategy:** Mobile-first (Flutter or React Native) → talks to thin Cloudflare Worker proxy (free tier) → proxy holds subscription key + calls myDATA. This avoids shipping the key in-app.

## 7. Build Feasibility Verdict

**GREEN — buildable by solo dev in 7 weeks, $0 cost.**

- API: simple REST + API key. No exotic auth.
- Sandbox: free, fully featured.
- Docs: official PDF v2.0.1 (Greek + English).
- Reference implementations: 3+ open-source libraries.
- Risk: AADE schema can change (v2.0.1 just landed Jan 2026 — Bloki must abstract the XML schema layer to absorb future bumps).

**Integration time estimate: 5-7 working days** for a competent dev to wire SendInvoices + RequestDocs end-to-end against sandbox.

## Sources

- [myDATA Official AADE](https://www.aade.gr/en/mydata)
- [Test Environment](https://www.aade.gr/en/mydata-electronic-books/mydata/test-environment)
- [v2.0.1 PDF Spec](https://www.aade.gr/sites/default/files/2026-01/myDATA%20API%20Documentation%20v2.0.1_preofficial_erp.pdf)
- [firebed/aade-mydata GitHub](https://github.com/firebed/aade-mydata)
- [MyDataEase registration walkthrough](https://mydataease.gr/?p=3231&lang=en)
- [Wealthy Backpacker freelancer guide 2025](https://thewealthybackpacker.com/2025/06/02/digital-tax-compliance-in-greece-using-mydata-for-freelancers-and-businesses-in-2025/)
