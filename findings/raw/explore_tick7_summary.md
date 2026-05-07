# Tick 7 Exploration — ID market / Travel / Recipe

Date: 2026-05-07. Methodology: Play Store search → top candidates → 200 newest reviews → recent_low_pct (1-2 star within 90d). Min sample threshold for "vulnerable" claim: ≥10 recent reviews.

## A) Indonesia market — top 3 vulnerable cells

| App | Installs | Score | Recent (90d) | low_pct | IAP |
|---|---|---|---|---|---|
| com.bukuwarung (BukuWarung UMKM) | 5M+ | 3.19 | 200 | **73.0%** | Free + premium |
| com.fastwork.app (Fastwork freelance) | 1M+ | 4.42 | 25 | 28.0% | n/a |
| bookipi.invoice.maker.estimate.billing | 1M+ | 4.67 | 7 | 28.6% (low n) | Rp 119k–2.79M |

Verbatims (all original ID, translation in brackets):
- BukuWarung 1★: *"saya mau bayar token listrik, gak bisa terus, kemudian semua saldo saya mau tak ambil, eh tidak mau"* [I want to pay electricity token, can't, all my balance I want to withdraw, won't]
- BukuWarung 2★: *"dalam pengiriman ke bank lama banget pending terussss"* [bank transfers pending forever]
- Sribu (freelance, low n=9): 55.6% low — *"Aplikasi tidak jelas, tidak rekomendasi bagi freelance"* [App unclear, not recommended for freelance]
- Bookipi 1★: *"Dulu iklannya gratis selamanya tanpa batas, sekarang dibatasi dan mesti langganan"* [Used to be free forever, now limited and requires subscription]

**e-Faktur legal feasibility for solo dev: NO-GO.** PKP/e-Faktur threshold = IDR 4.8B (~$300k USD) annual gross turnover. Real e-Faktur compliance requires DJP system integration (electronic tax invoice issuing through government portal). Below 4.8B threshold, UMKM operate under simplified 0.5% PPh regime and DON'T need e-Faktur. The actual UMKM pain layer (BukuWarung complaints) is **bookkeeping + payment gateway uptime**, NOT invoice/e-Faktur. That's a different beast — payment rails require fintech partnerships, not buildable solo.

## B) Travel/itinerary — top 3 vulnerable cells

| App | Installs | Score | Recent (90d) | low_pct | IAP |
|---|---|---|---|---|---|
| com.tripomatic (Tripomatic/Sygic) | 1M+ | 4.30 | 13 | **92.3%** | $3.99–29.99 |
| com.roadtrippers | 1M+ | 2.33 | 30 | **83.3%** | $6.99–59.99 |
| com.stippl.stippl | 100k+ | 3.71 | 16 | 75.0% | $4.49–28.99 |

Verbatims:
- Tripomatic 1★: *"I paid for this app and with the new 2026 update the UI is not user friendly like it use to be. it's hard to navigate."*
- Roadtrippers 1★: *"I paid $39 to get nothing. we have driven for days and the app keeps saying I have to upgrade to pro... at $39. this is a big waste of money."*
- Roadtrippers 1★: *"Haven't used the app in a while only to find that it is now completely unusable without a ridiculous subscription"*
- Stippl 1★: *"having lots of issues with the app it freezes up frequently and now the document uploading is not working via email"*

Theme: **subscription rage + UI regressions on "trip planner" power users**. But: travel apps need maps/POI/booking integrations → API costs → violates $0-backend. Local-first itinerary (no maps API, just lists/dates/notes/checklists) is buildable but the wedge is thin against Wanderlog (1M+, 4.75 score, 25% low — strong incumbent).

## C) Recipe/meal — top 3 vulnerable cells (≥1M installs)

| App | Installs | Score | Recent (90d) | low_pct | IAP |
|---|---|---|---|---|---|
| com.eatthismuch | 1M+ | 4.70 | 12 | 41.7% (low n) | $0.99–84.99 |
| com.stashbox.stashcook | 500k+ | 4.47 | **200** | **39.5%** | $3.99–139.99 |
| com.mealime | 1M+ | 4.56 | 64 | 35.9% | $2.99–49.99 |
| com.recime.app | 1M+ | 4.65 | 200 | 34.0% | $6.99–69.99 |
| ch.publisheria.bring (Bring!) | **10M+** | 4.17 | 34 | 32.4% | $0.99–8.99 |

Verbatims:
- Stashcook 2★: *"it would be a handy app to have but I am so sick of everything having subscriptions. I'm NOT paying"*
- Stashcook 1★: *"paywall"* (verbatim, single word)
- ReciMe 1★: *"You have to subscribe. Why would I do that?"*
- Mealime 1★: *"I got a new phone and have tried to use it and now I can't get past the set up reminders screen, so I can't even begin to use the app"*
- EatThisMuch 1★: *"it won't filter recipes by pantry, which makes it pretty useless"*

Theme: **subscription rage is universal across recipe vertical, and incumbents have huge IAP ceilings ($84–139)**. Cohort signal: 4 of 5 incumbents ≥1M installs with ≥30% recent low_pct on healthy review volume.

## Best NEW direction candidate

**Recipe/Meal vertical — $0 lifetime "subscription-free recipe keeper + grocery list" — US.**

Why it could compete with v9 top 9:
- Cohort breadth: 5 vulnerable competitors, all 1M+ installs → demand is dense
- User-voice is binary clean: "paywall" / "I'm NOT paying" — direct fit for $0-backend pitch
- Build feasibility: local SQLite recipe storage + import from URL (HTML scrape) + grocery list export → 4-8 wk solo build, NO AI inference, NO backend, low legal risk
- Wedge: explicit "$0 forever, no subscriptions, no accounts" — the Stashcook user voice almost begs for this

Risk: AnyList (com.purplecover.anylist 1M+, 4.84, 2.5% low_pct) is dominant in grocery-list and barely complained about → splitting wedge from it requires recipe-first not grocery-first positioning. Bring! 10M+ is the ad-supported free option but has 32.4% low_pct.

Verdict: **Plausible new candidate, but unclear it beats existing v9 top 9** without knowing v9's #9. Recipe/$0/US scores well on demand density (5 cells × 30%+ low) but the differentiation thesis ("$0 forever") competes with Bring! and SuperCook (both free). Final ranking should compare it head-to-head with v9 #7-#9.

ID market verdict: **NO-GO**. e-Faktur legal moat blocks invoicing entry; UMKM pain layer is payment gateway not buildable solo.
