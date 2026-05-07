# Faladdin Research — TR/Tarot Native Incumbent

**Date pulled:** 2026-05-07. Sources: Play Store live scrape (`com.faladdin.app`), App Store TR (`id1201725025`), Crunchbase, Rest of World, Turkish Minute, Daily Sabah, IntelliNews, Türkiye Today, Diken, MWM/Mondaq, Tech Company News.

## 1. Company background
- **Founder:** Sertaç Taşdelen, 42, Bilkent University business grad, ex-Ernst & Young Dubai. **Co-founder/CTO:** Kaya Diker.
- **Origin:** Launched **Binnaz** (named after his mother) in **2012**; spun out **Faladdin in Jan 2017** (Play Store release: 18 Jan 2017).
- **Legal entity on Play Store:** "Truemium Ou" (Estonian OÜ — used to receive offshore revenue). Underlying TR company: **Arteria Yazılım**.
- **Funding:** Bootstrapped. Founder publicly stated in 2021 the company grew **without external VC**. No Crunchbase funding rounds disclosed.
- **Team:** Mid-size (Istanbul HQ, content team of in-house "fortune tellers" + ML/NLP engineers). Not solo, not VC-backed — a profitable founder-owned consumer app.

## 2. Revenue model
- **Free + ad-supported + IAP** (`offersIAP: true`, `adSupported: true`). IAP range **$0.99–$149.99 per item** (Play Store live).
- **Three monetization layers:** (a) rewarded video ads → "altın" (gold) credits, capped ~10 readings/day; (b) **consumable jeton/credit packs** (one-shot purchases for live-chat readings & premium tarot spreads); (c) **weekly/monthly subscription** ("premium").
- **AI Live-Chat (Faladdin/Cassandra/Genie personas)** = highest-margin product — paid per chat session.
- **Disclosed numbers:** 25M registered users, ~5M MAU, **~1M readings/day**, 50M total downloads, 4.7★ avg across stores. **Revenue figure was not publicly disclosed**, but TR prosecutors froze ~₺107.5M (≈ **$3.3M**) of Taşdelen's assets in July 2025 as suspected illicit gains — implying meaningful 8-figure-TL annual cash flow at minimum, with a chunk routed to overseas accounts and crypto wallets via the Estonian Truemium OÜ.

## 3. Why it dominates Turkey (vs Labyrinthos)
Labyrinthos is a Western tarot-learning app (English, deck-mechanics focused). Faladdin wins TR because:
- **Kahve falı (coffee-cup reading)** is the killer culturally-native feature: user photographs the inside of an upturned Turkish coffee cup → AI vision model returns symbol-by-symbol interpretation (love, money, travel). Labyrinthos has nothing equivalent.
- **AI personas** (Lamba Cini "Genie in lamp", Cassandra astrologer, live tarot chat) — entertainment + parasocial loop, in **Turkish**.
- **Free tier with daily reward-ad readings** — fits TR price sensitivity; Labyrinthos uses paid decks/courses.
- **Coverage of full TR mystical stack:** kahve falı + tarot + el falı (palm) + astroloji + numeroloji + rüya yorumu (dream).
- **Lifestyle category #1 in Google Play TR** (ahead of Tinder per Rest of World, 2020).
- **Native Turkish copy + 24/7 TR support team replying within ~1 day** (visible in review responses).

## 4. Vulnerabilities — live 1-2★ Turkish reviews (pulled 2026-05-07)
**Histogram:** 235k ratings, 4.4★, but **21,008 1★** (8.9%) and 6,895 2★. Dominant complaint themes:

- **"Kahve falı kayboldu" — coffee fortune REMOVED from TR interface.** After the July 2025 seizure they stripped paid divination from the TR build. Devs reply: *"bazı hizmetler Türkiye bölgesinde kullanıma kapatılmıştır"* — admit shutdown. Massive churn driver. Quotes: *"kahve falı yok yeni güncelleme berbat"*, *"şu anda Türkiye'den uygulamamıza erişim sağlanamıyor"* (dev's own reply, Aug 2025).
- **"Lamba Cini yok"** — Genie persona also pulled in TR. Azeri user: *"lamba cin yok, kahve fali yox"*.
- **Reklam tuzağı (ad trap):** *"bir dakikalık reklam üstüne tekrar reklam"*, *"reklam izle diyor izliyorsun ve yine aynisini diyor"*, watch ad → no credit delivered.
- **Subscription/refund fraud complaints:** *"iki kez abonelik parası çektiniz, uygulama açılmıyor"*, *"beni dolandırdınız ücretleeimi iade edin… dava edeceğim"*, double-charged premium that doesn't unlock.
- **Crashes / login errors** (post-Aug 2025): *"sistemde sorun var"*, *"hata verip giriş yapamıyorum"*.
- **AI-generated readings backlash:** *"kahve falı yapay zeka olarak değişmiş… yapay zekaya fal baktıracaksam Faladdin'e ne gerek kalıyor"* — users want **human** falcı, not LLM.

## 5. Recent moves (last 12 mo)
- **2025-07-16:** Istanbul Chief Prosecutor's Office orders seizure of Faladdin + Binnaz; Taşdelen detained; ₺107.5M assets frozen.
- **2025-07-18:** Court formally arrests him for "laundering assets derived from criminal activity" (3-7 yr indictment).
- **2025-08+:** Access blocked from Turkey; app continues operating globally. Kahve falı + Lamba Cini + paid divination **removed from the TR-facing build**, kept on Global build.
- **App still updated** (v5.1.19, Apr 2026). Pivoting toward "Yapay Zeka, Sohbet" (AI chat / friendship) framing in TR title to dodge fortune-telling regulation.
- **No iOS app currently on Turkish App Store under the Faladdin brand** (search returns competitors Kaave, Kismet, Derya Abla, Fal Diyarı first; old iOS id 1201725025 listed in US store as "Faladdin: Zodiac & Love"). **De-listed or hidden from TR App Store search post-arrest.**

## 6. iOS Turkey
Live App Store TR search for "Faladdin" returns **zero Faladdin results in top 5** — instead **Kaave (Didilabs)** is iOS leader at 4.66★, 139k reviews. Faladdin's iOS presence in TR is effectively dead since the July 2025 block. US App Store still lists `id1201725025` under MWM publisher.

## 7. Strategic implication for Direction 5 (TR/tarot)
**COMPETE — but do not clone.** Faladdin is a **wounded incumbent**:
- TR users actively churning (1★ wave Aug 2025 → Apr 2026), kahve falı stripped, founder in jail, brand toxic.
- iOS TR is a vacuum.
- Competitors Kaave (4.66★ iOS) and Kısmet are filling the gap on iOS but neither has Faladdin's AI live-chat depth.

**Winning angle:**
1. **Lead with kahve falı + tarot bundle** (the feature Faladdin pulled). Cultural moat Western apps can't ship.
2. **Be explicit about AI vs human**: offer a "real falcı" tier (live human chat, marketplace-style) — directly attacks the *"yapay zekaya ne gerek"* complaint cluster.
3. **Clean monetization:** transparent credit packs, no rewarded-ad bait-and-switch, instant refunds — directly attacks the dolandırıcılık / abonelik review cluster.
4. **Compliance-first:** register as TR legal entity, avoid Estonian-OÜ offshore optics; position as MASAK-compliant from day 1 to avoid Faladdin's fate.
5. **iOS-first launch in TR** while Faladdin is absent there.

**Verdict: Direction 5 is MORE attractive post-research, not less.** The 25M-user incumbent is mid-collapse, a clear user-voice gap exists, and the cultural moat (kahve falı) keeps Western competitors out.

## Sources
- https://play.google.com/store/apps/details?id=com.faladdin.app
- https://restofworld.org/2020/faladdin-turkey-coffee-fortune/
- https://turkishminute.com/2025/07/16/turkey-detains-faladdin-founder-seizes-assets-over-ai-powered-fortune-telling-gains/
- https://turkishminute.com/2025/07/18/judge-orders-arrest-of-faladdin-founder-over-ai-powered-fortune-telling-gains/
- https://www.turkiyetoday.com/nation/turkiye-arrests-founder-of-popular-fortune-telling-app-faladdin-3204384
- https://www.dailysabah.com/turkiye/investigations/turkiye-arrests-founder-fortune-telling-app-over-money-laundering
- https://www.intellinews.com/beyond-the-bosporus-turbulence-in-the-crystal-ball-as-turkey-seizes-online-fortune-teller-faladdin-391627/
- https://www.diken.com.tr/faladdin-ve-binnaza-sorusturma-sertac-tasdelen-gozaltinda/
- https://www.crunchbase.com/organization/faladdin
- https://turkishtechnews.com/introducing-turkish-startups-faladdin-an-ai-fortune-telling-app/
- https://www.mondaq.com/turkey/new-technology/789064/from-coffee-grounds-to-millions-faladdin
- App Store TR live search (app-store-scraper)
