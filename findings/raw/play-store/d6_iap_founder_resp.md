# D6 — Top 3 Idle Games: Live IAP + Founder Responsiveness

Date: 2026-05-07
Source: google-play-scraper (live), 200-newest 1-3★ window (after filter)

## App Metadata Snapshot

| App | Dev | Installs | Score | Ratings | 1★ count | IAP Range | Ad Supported |
|---|---|---|---|---|---|---|---|
| AdVenture Capitalist | Hyper Hippo | 10M+ (max ~27.9M) | 4.52 | 1.65M | 71,044 | **$0.49 – $99.99** | YES |
| Egg, Inc. | Auxbrain Inc. | 10M+ | 4.68 | 1.40M | 27,855 | **$3.99 – $19.99** | (no, opt-in only) |
| Cookie Clicker | Orteil & Opti (DashNet) | 5M+ | 4.46 | 37,391 | 2,615 | **(none listed)** | YES (separate paid version exists) |

## Live IAP Ceiling (key metric)

- **AdCap: $99.99 ceiling** — predatory whale-tier IAP confirmed. Combined with subscription-to-remove-ads model.
- **Egg Inc: $19.99 ceiling** — modest ceiling, fair pricing, no rage signal.
- **Cookie Clicker: NO IAPs in this listing** — uses dual-app strategy: free with ads + paid ad-less version (Orteil sells the premium version separately). This is precisely the "pay once, no ads" model D6 wants to replicate.

## Founder Responsiveness Rate (200 newest 1-3★, capped at returned)

| App | Reviews returned | Replies | Responsiveness % | Pattern |
|---|---|---|---|---|
| AdVenture Capitalist | 114 | 93 | **81.6%** | Template-driven, polite, deflective ("watch rewarded ads", "contact in-app support") |
| Egg Inc | 14 | 0 | **0.0%** | Silent — at this 1-3★ tail there are very few low reviews to begin with |
| Cookie Clicker | 28 | 0 | **0.0%** | Silent — Orteil is a one-person dev, doesn't engage |

### Anti-positioning insight (counter-intuitive)

AdCap's 81.6% responsiveness LOOKS strong, but in 30+ sampled replies the dev consistently:
- **deflects to in-app support** ("please contact our Support Team")
- **upsells** ("watch rewarded ads, or make a small shop purchase will lessen pop-up ads")
- **never apologises for the subscription change**

This is the predatory tell. "We respond" is theater for the algorithm; the actual answer is "pay us more". Tycoon Zero anti-positioning hook: **dev replies that solve, not sell**.

## Top "Predatory Pattern" Phrase Counts (AdCap, 114 reviews)

| Phrase | Hits |
|---|---|
| "one time" (paid ONCE for no ads) | 4 |
| "greedy" | 3 |
| "subscription" / "monthly" / "$15" | 1 each (small but present in vocal long-form rage reviews) |
| "ads" mentions | dominant — 60%+ of all 1-3★ reviews mention forced ads |

### Money quotes (AdCap reviews, verbatim, abbreviated)

- *"you now have to pay monthly to remove forced ads. I have been playing for years, and now I will never play again. Deleted… 2 minutes into playing and there is an 80 second non skippable ad."* — 1★
- *"I paid for no ads at one time and now you have [ads]"* — 2★
- *"Now on top of at least 3 different mechanics involving watching ads, you now get automatically pushed into an ad when you try to open menus."* — 1★
- *"used to be a great game. now it forces ads to do basic game play."* — 1★ (got templated reply: "watch the rewarded ads as this will lessen the amount of pop-up ads")
- *"Ads used to be voluntary. Ads now pop up every 3-4 menus you access."* — 1★

## Implication for D6 (Tycoon Zero)

1. **AdCap IS rage-vulnerable**: subscription pivot + forced-menu-ads = highest user betrayal signal in the category.
2. **Cookie Clicker validates the "pay once, no ads" wedge** at the IAP-strategy level (Orteil already proved the dual-app model works).
3. **Founder-responsiveness wedge** for D6 = "every reply is from the dev, every fix ships in <72h" (vs AdCap's CS-template deflection at 81.6%).
4. **Egg Inc is NOT vulnerable here** — score 4.68, only 14 of 200 newest reviews are 1-3★. Skip as primary target; reference only.

Files:
- `findings/raw/play-store/d6_adcap_info.json`
- `findings/raw/play-store/d6_egginc_info.json`
- `findings/raw/play-store/d6_cookieclicker_info.json`
- `findings/raw/play-store/d6_adcap_reviews.json`
- `findings/raw/play-store/d6_egginc_reviews.json`
- `findings/raw/play-store/d6_cookieclicker_reviews.json`
