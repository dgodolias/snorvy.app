# Direction 1 — Launch Readiness Pack (FairBill / Invoice Simple Displacement)

_Generated: 2026-05-07 · v9 Direction 1 · US/GB primary, CA/AU follow-on_
_Constraints: $0 cost research · Greek solo dev · highest-ROI keywords are "invoice maker no subscription" + "self employed invoice" + "invoice simple alternative"_

Raw competitor data: `findings/raw/play-store/d1_competitor_descriptions.json`
Full app store copy drafts: `findings/raw/d1_app_store_copy_drafts.md`

---

## 1. Competitor description audit

| App | Headline (line 1) | Top 3 feature bullets | Pricing transparency | Trust signals | Anti-positioning words used |
|---|---|---|---|---|---|
| **Invoice Simple** (5M+, 4.8★, $4.99–$399.99) | "Easily create & send professional invoices, estimates, and bill receipts on the go!" | (1) Simple to use Invoice Creator (2) Invoice Anywhere (3) Get Organized | OPAQUE — "Free Trial / Essentials / Plus / Premium" tiers, no $ shown in store | "Trusted by hundreds of thousands of businesses" | None ("Free Trial" only) |
| **Bookipi** (1M+, 4.6★, $7.49–$174.99) | "Invoice Maker & Estimate App trusted by +2.5m small businesses worldwide…" | (1) Create invoices in minutes (2) Get paid on time (3) Flexible payment options | SEMI — "First three documents are absolutely free" | "+2.5m small businesses", "150 countries", "ISO 27001 certified", "award-winning" | "free" (×3), "without limits on features" |
| **Zoho Invoice** (1M+, 4.8★, FREE no-IAP) | "Zoho Invoice is an online invoicing software packed with all the essentials…" | (1) Swift invoicing (2) Versatile templates (3) Efficient expense management | TRANSPARENT — explicitly "100% free" | 2 named customer testimonials | "100% free", "no" (re: complexity) |
| **Freebie Invoice Maker** (Tough Jobs, 500k+, 4.8★, $5.99–$199.99) | "Invoice Maker Simple 2 go is a fast and easy invoice app for sending invoices…" | (1) Customize invoice template (2) Discount/tax on item or total (3) PDF invoice maker | SEMI — "free up to 5 invoices and 5 estimates per year" | "#1 invoice app" (unverified) | "free" (×8), "Freebie" branding | 
| **Square Invoices** (1M+, 4.7★, $20/mo) | "The free Square Invoices app is your go-to invoice maker that lets you get paid from anywhere." | (1) Estimates & invoices in taps (2) Accept any payment (3) Auto-reminders & tracking | TRANSPARENT — "no monthly fees or commitments" (then upsells $20/mo Square Plus) | "Block, Inc." parent, Oakland HQ | "no monthly fees", "free" |

**Audit takeaway**: Only Zoho is fully free and only Square uses "no monthly fees" anti-positioning. NONE of the 5 competitors uses "no subscription," "lifetime pricing," or "your data exports anywhere" — these are open positioning lanes for FairBill.

---

## 2. App store copy drafts (summary — full drafts in `d1_app_store_copy_drafts.md`)

### Play Store headline (recommended)
**Title (40 chars)**: `FairBill: Invoice Maker, No Subscription`
**Sub-head (78 chars)**: `Lifetime invoice app for self-employed. No subscription. Offline. No account.`

### iOS subtitle (26 chars)
`No subscription. Pay once.`

### Anti-positioning hook (works on both stores, legal-safe):
> "Tired of subscription invoice apps tripling their price every year?"

This pattern attacks Invoice Simple's $59 → $199 hike (validated in v8 verbatim 👍198) without naming the competitor — Apple/Google compliant.

### Price-stack differentiation
- Free forever: 3 invoices/mo, 2 templates, no watermark
- Lifetime: **$39 one-time** ("we promise: your price stays")
- Monthly: $4.99/mo (vs Invoice Simple $50/yr min for 3 invoices/mo)

---

## 3. ASA keyword ranking — composite score

Composite = (Volume × Intent) ÷ Difficulty. Volume estimated from prior `eu_expansion_invoice` + `iap_search_*` results.

| # | Keyword | Volume (1-5) | Intent (1-5) | Competition density (1-5) | Effort | Composite | Why |
|---|---|---|---|---|---|---|---|
| 1 | **invoice maker no subscription** | 4 | 5 | 2 | LOW | **10.0** | Direct displacement intent; only Square + Bookipi tangentially compete. ZERO apps title-match this exact phrase. |
| 2 | **invoice simple alternative** | 3 | 5 | 1 | LOW | **15.0** | Highest pure intent; almost no organic supply. Top result today is Invoice Simple itself (irrelevant). True open lane. |
| 3 | **no monthly invoice app** | 3 | 5 | 2 | LOW | **7.5** | Same intent cluster as #1; lower volume but near-zero competition. Bundle into title. |
| 4 | **free invoice no watermark** | 4 | 4 | 3 | MEDIUM | **5.3** | Strong pain point in v8 review data. Several apps fight for it. |
| 5 | **self employed invoice** | 5 | 5 | 4 | MEDIUM | **6.3** | Highest volume in the set; Invoice Simple, Bookipi, Zoho all rank. Long-game keyword — combine with "uk" for easier ranking. |
| 6 | **invoice app uk small business** | 4 | 5 | 3 | MEDIUM | **6.7** | UK-specific carve-out lets a small app rank in GB Top-20 fast. |
| 7 | **freelancer invoice** | 5 | 4 | 5 | HIGH | **4.0** | Saturated; Invoice2Go, Bookipi, Wave all dominate. Brand keyword only. |
| 8 | **1099 invoice generator** | 3 | 5 | 2 | LOW-MED | **7.5** | US-only seasonal spike Q1; ties to "self employed" cluster. Easy ranking outside Jan-Apr. |
| 9 | **small business invoice** | 5 | 3 | 5 | HIGH | **3.0** | Too broad, low intent for displacement product. De-prioritize. |
| 10 | **self employed bookkeeper** | 3 | 2 | 4 | MEDIUM | **1.5** | Wrong intent (bookkeeping ≠ invoicing). Drop. |

### Top 5 by composite (use in this order in the title/keyword field):
1. **invoice simple alternative** (15.0) — primary differentiation hook
2. **invoice maker no subscription** (10.0) — primary feature hook
3. **no monthly invoice app** (7.5)
4. **1099 invoice generator** (7.5) — US seasonal
5. **invoice app uk small business** (6.7) — GB-specific

iOS keyword field (96 chars): `invoice,billing,receipt,estimate,freelancer,1099,selfemployed,contractor,sole,trader,vat,tax,pdf`

---

## 4. Launch sequence — Reddit + ProductHunt + Twitter

### A. Reddit launch — 3 specific subreddits (NOT just r/freelance)

| Subreddit | Specific thread/topic to target | Why |
|---|---|---|
| **r/selfemployed** | Search "invoice simple price" — there is a recurring weekly complaint thread pattern. Reply once, then post a "Show HN-style" launch thread titled `[Tool] I'm a solo dev and I built a one-time-pay invoice app because I got tired of the price hikes` | Audience is 100% target persona. r/selfemployed has 380k+ subs and tolerates self-promo if framed as "I built this for myself." |
| **r/UKSmallBusiness** | Post in the recurring "Tools & Software you use" weekly thread; offer GB-localized version (£ default, VAT-aware) | UK angle is your easiest geographic moat — Invoice Simple is US-tax-defaulted. Subreddit allows tool recs in megathreads. |
| **r/Entrepreneur** (or r/sidehustle) | Find the recurring "What's the cheapest invoicing app?" megathread — search for posts in the last 90 days asking about Invoice Simple, Wave, or Zoho. Reply with your launch + free tier. | High volume of pre-qualified searchers; Wave/Zoho mentioned weekly. r/sidehustle (1.5M subs) more permissive. |

### B. ProductHunt launch day plan

- **When**: Tuesday 12:01am PST (best historical launch slot; Mon = noisy, Wed = "Wednesday slump"). Avoid Thanksgiving / July 4 / Christmas weeks.
- **Tagline (60 chars max)**: `One-time-pay invoice app. No subscription. Yours forever.`
- **Lead with**: A 60-second screen recording showing (a) creating an invoice in 45s without signing up, (b) the pricing screen with `$39 lifetime — your price stays`, (c) one-tap PDF export to email.
- **First 3 hours**: Post in PH Slack/Discord, ping all newsletter signups, message the 5 most-active makers in the "SaaS / B2B" category from the prior week to ask for upvotes (give first, ask later).
- **Prep assets**:
  - 3 GIFs (under 3MB each)
  - Maker comment pinned at top: "Hi PH — I'm a solo dev. I built this after 5+ years of watching Invoice Simple users in the App Store reviews complain about price hikes ($59 → $199). FairBill is $39 one-time. AMA."
  - Reply within 5 min to every comment for the first 6 hours.
- **Goal**: Top 5 of the day = 800-2,000 visits + ~50-200 paid lifetime conversions = $2k-8k week 1.

### C. Twitter/X — 3 reply targets (engage AFTER launch is live)

1. **Search query**: `"invoice simple" (subscription OR price OR "raised")` — sort by Latest. Reply to 1-star complaint tweets with a single non-spammy line: "If you're shopping around, FairBill is one-time-pay (no subscription) — figured I'd mention it since I just launched it for exactly this reason." Link only when asked.
2. **@InvoiceSimple mentions** — search for users tagging Invoice Simple's official handle in complaint context. Same reply pattern. Avoid replying to their official account directly (visibility throttling).
3. **Specific accounts to monitor weekly**: Levelsio (`@levelsio`), Marc Lou (`@marc_louvion`), and any indie hacker who has tweeted about subscription fatigue in the last 30 days. When they tweet about pricing/SaaS bloat, reply with FairBill as the example case study. These accounts have 100k+ engaged solo-dev followers who are also your buyers.

**Twitter rule**: Never lead with the link. Lead with the story ("I built X because Y"). Drop the link only on direct ask or in your bio.

---

## Launch checklist (post-Direction-1-pick)

- [ ] Register `fairbill.app` (or alternate: `flatbill.app`, `oncebill.app`) — verify free
- [ ] Buy Apple Developer ($99/yr) + Google Play ($25 one-time)
- [ ] Build MVP in Flutter (3-5 weeks per v8 estimate)
- [ ] Set up Stripe lifetime + monthly SKUs
- [ ] Privacy policy + 1-page Terms (€200 lawyer template — already budgeted)
- [ ] Landing page with Invoice Simple comparison table (legal: nominative fair use)
- [ ] Pre-launch: collect 200+ emails from Reddit pre-launch waitlist post
- [ ] Day 0: PH launch + 3 subreddit posts simultaneously + Twitter reply blitz
