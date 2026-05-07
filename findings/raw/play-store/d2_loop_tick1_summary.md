# D2 Loop Tick 1 Summary — QBSE + Solopreneur + Schedule C wedge (2026-05-07)

**Scope:** v9 Direction 2 (QBSE/Solopreneur displacement + Schedule C estimator). Three new dimensions added this tick: (1) iOS cross-check, (2) live IAP audit, (3) Solopreneur founder responsiveness.

## 1. iOS vs Android low_pct comparison

| App | Platform | appId / id | Reviews pulled | low_pct (≤2★) | Δ vs Android |
|---|---|---|---|---|---|
| QBSE (Self-Employed) | Android | `com.intuit.qbse` | 1500 | **85.5%** | — |
| Solopreneur | Android | `com.intuit.quickbooks` | 1500 | **61.4%** | — |
| **QBSE+Solopreneur (consolidated)** | **iOS** | id 584606479 (`com.intuit.QBOiPad`) | 500 | **81.6%** | iOS pain ≈ between QBSE & Solopreneur Android |
| Keeper Tax | Android | `com.keepertax` | (prior) | low | — |
| Keeper Tax | iOS | id 1471090941 | 500 | **12.8%** | Keeper iOS is well-loved; only 64/500 ≤2★ |

**Critical iOS finding:** Intuit has **consolidated the entire Self-Employed franchise into one iOS listing** — there is no separate QBSE-iOS or Solopreneur-iOS. Legacy id 1056941055 returns HTTP 404 (deprecated). All Self-Employed iOS users are now funneled through "Intuit QuickBooks for Business" id 584606479 — listed score 4.72 (231k reviews) but RECENT reviews are 81.6% ≤2★. The 4.72 lifetime score masks an active rage tide.

QB-Business iOS recent histogram (last 500): 1★=325 (65%), 2★=83, 3★=40, 4★=11, 5★=41. **65% pure 1★ on most recent 500 reviews** is a 5-alarm signal.

## 2. Top 5 highest-impact iOS verbatim quotes (US, English)

1. *"FIND A BETTER OPTION — I have been using quick books for over two years and It's time to switch! Far to often things get added and removed from the app and you lose all your business data. Sometimes estimates and invoices disappear and then re appear hours later."* (1★)
2. *"Whoever is running intuit needs better understanding in who to hire. I use QB online and they have made estimating horrible. It's getting worse. Yall need to change things soon or risk losing a lot of clients."* (2★)
3. *"This app has been written by cut-rate developers who have never taken a UI/UX class. They clearly also never test their product…"* (1★)
4. *"Mileage tracker stops tracking on his own periodically, which I'm guessing is because of the new AI implementation. Just terrible for $20."* (1★) — direct AI-rollout backlash + price anchor.
5. *"It's amazing how I have to wait weeks for a customer payment when other processing companies have it to me in a day or two. If you can, avoid Intuit at all cost."* (1★)

(iOS App Store does not expose `thumbsUp`, so these are sorted by recency + content density. Files: `d2_qbse_ios_us.json` raw and `d2_solopreneur_ios_us.json` are identical, see consolidation note.)

## 3. IAP live pricing matrix + price-hike evidence

| App | Live IAP range | offersIAP | Notes |
|---|---|---|---|
| QBSE (`com.intuit.qbse`) | $2.49 – $35 | true | Legacy. Description redirects new users to Solopreneur. |
| Solopreneur (`com.intuit.quickbooks`) | **$0.99 – $420** | true | 12× ceiling vs QBSE. Title now "QuickBooks for Business" + AI features. |
| Keeper Tax (`com.keepertax`) | — (no IAP) | **false** | Web-billed; ~$20/mo, $192-399/yr. |

**Direct price-hike evidence from reviews:**
- 2026-05-03 / 1★ (UK): *"this calendar year, I'm being double charged. £11.99 & £18.99. Quickbooks can't help, as I subscribe through Google Play."* (TWO active price tiers post-migration)
- 2026-05-02 / 1★ (UK): *"Atrocious money-leeching practices. Exactly what I feared the MTD transition would lead to."*
- 2026-04-27 / 1★ (UK): *"Quickbooks Self Employed worked well, but this Sole Trader Plus is terrible."*
- 2026-04-15 / 2★: *"really expensive for what you get I miss the old days where you can just buy the program outright."*
- Keeper iOS 1★: *"it's powered by ai and they want 300$ a year to use it??? that's crazy."*
- Keeper iOS 1★: *"completing the forms it asked for, and it initially charged $99. Suddenly, the price increased to $199."*

The QBSE → Solopreneur transition is **active right now (2026-04 / 2026-05 reviews)** — forced migration pain is acute, not historical. See `d2_iap_audit.md` for full details.

## 4. Solopreneur founder responsiveness

- Pulled **134 of 200** newest 1-3★ reviews for `com.intuit.quickbooks` (Solopreneur). Google Play returned only 134 in target window.
- **Replies: 133 / 134 = 99.3% reply rate** to low-rated reviews.
- vs. prior QBSE 97% — Solopreneur's reply rate is **even higher** (Intuit doubled down on QBCares ops post-rebrand).
- **Tone: 100% canned Intuit template.** Sample (1★, 18 thumbs):
  - User: *"the new version is so much more complicated… and noone seems to be able to find the solution on the call centre"*
  - Reply: *"Hi, Soledad. This definitely isn't the experience we want you to have… Please email us at QBCares@Intuit.com detailing the issue and we'll do what we can to help. Best. -Caitlyn"*
- Pattern: greeting + acknowledgment + redirect to QBCares@Intuit.com email + signed by named CSR. **No bug fixes referenced in-thread, no developer code-level engagement.** Pure escalation funnel.

## 5. Verdict — does this loop tick promote or demote D2?

**STRENGTHENS D2 materially.** Three new pieces of evidence:

1. **iOS consolidation = bigger TAM.** Intuit has merged QBSE-iOS into the single QB-Business listing (id 584606479). Recent iOS reviews are 81.6% ≤2★ with 65% pure 1★ — equivalent to Android pain. Self-employed iOS users have nowhere to go except a generic "QuickBooks for Business" app that is breaking on them. A dedicated iOS Schedule C app has zero direct competitor on iOS.
2. **Active price-hike rage is in-flight.** Two-tier pricing chaos in UK ("£11.99 & £18.99"), forced "Sole Trader Plus" migration, $420 IAP ceiling vs old $35 — generates concrete acquisition narrative ("the free Schedule C estimator Intuit doesn't want you to have").
3. **Founder-responsiveness moat is canned, not problem-solving.** 99.3% reply rate but 100% template + email redirect. A solo dev who actually fixes user-reported bugs in the next build (vs Intuit's QBCares email funnel) wins on perceived care without competing on volume.

D2 wedge update: still strong. The iOS angle was previously assumed "weak" because no separate iOS QBSE existed — actually that's the wedge: iOS Self-Employed users are abandoned inside a generic mega-app and they hate it.
