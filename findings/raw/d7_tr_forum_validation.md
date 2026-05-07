# D7 — Turkish e-SMM Mobile App Forum Validation

**Date:** 2026-05-07
**Method:** WebSearch + WebFetch on Şikayetvar (Turkish complaint platform), R10.net forum, ekşi sözlük (blocked HTTP 403), search-engine snippets
**Direction tested:** "Honest flat-fee e-SMM mobile app for Turkish freelancers (post-Mikrogrup, post-Sysmond bait-and-switch)"

---

## 1. Verbatim Turkish Complaint Quotes

### Source A — Şikayetvar.com / Mikrogrup (formerly Zirve Yazılım)

**Q1 (Seren, 2024-07-05):**
> "1 Temmuz itibari ile Zirve Yazılım Mikrogrup e-Faturaya geçtim, geçmez olaydım. Ben böyle bir teknik destek ekibi görmedim. Olay kısaca şu; ben fatura kesiyorum, taslak kaydediyorum. Faturalara geliyorum ve taslaklarımda faturalarım yok, ortada fatura yok. Şaka değil, gerçek; 10 adet fatura ortada yok."
> EN: "Switched to Zirve/Mikrogrup e-Invoice on July 1st — biggest mistake. I cut invoices, save drafts, and they vanish. Not a joke — 10 invoices simply gone."

**Q2 (Ali, 2024-07-24):**
> "Buradan hiçbir şekilde sağlıklı hizmet alınamıyor. Ücreti yatırana kadar ilgi var, ücretinizi yattırdıktan sonra destek sıfır."
> EN: "Impossible to get decent service. Until you pay, they care; once you've paid, support is zero."

**Q3 (Orkun, 2024-06-06) — bait-and-switch pricing:**
> "120 kontör hediye ve 100 kontör fiyatı 195 TL, 200 kontör 300 TL gibi bir fiyatla reklam yapmalarına rağmen, fatura programı kurulduktan sonra 120 kontör yüklemenin fiyatı 600 TL olmuş."
> EN: "They advertised 120 free tokens + 100 tokens at 195 TL, 200 tokens at 300 TL, but once installed the price for 120 tokens jumped to 600 TL." (PRICING BAIT-AND-SWITCH CONFIRMED)

**Q4 (Ömer, 2023-10-20) — UX/export complaints:**
> "Mikrogrup e fatura programı detaylı exceli kesinlikle işe yaramaz bir halde. Excel raporlamada nokta ve virgül hatası, KDV ayrı bir sütunda yok, sayılar hiçbir hesaplamaya veya programa aktarıma uygun değil."
> EN: "The detailed Excel export is completely useless. Decimal-comma errors, VAT not in a separate column, numbers don't import anywhere."

### Source B — Şikayetvar.com / Sysmond

**Q5 (Sysmond user, 2026):**
> "350 TL ödeyerek tekrardan Premium abonelik satın aldım fakat hizmet alamıyorum… Ücretini ödediğimiz uygulama düzgün çalışmıyor. Ödediğiniz ücret çöpe gidiyor. Uzun zamandır uygulamaya girilemiyor; girilse bile imza işlemi yapılamıyor."
> EN: "Paid 350 TL again for Premium and got no service. The app we pay for doesn't work. Your money goes in the trash. Can't even log in for long stretches; even when you can, signing fails."

---

## 2. Most-Named Alternative Apps (where Turkish freelancers migrate TO)

| App | Provider | Notes |
|---|---|---|
| **Paraşüt** | Logo subsidiary | Most-recommended for cloud + iOS/Android. "Hiç sıkıntı yaşamadığını belirtmişlerdir." Has 14-day free trial. Also has billing-without-consent complaints (~14k TL renewal incident, 2026-03). |
| **Logo İşbaşı** | Logo Yazılım | Power-user pick. "Fatura kesimi çok hızlı." Same parent as Paraşüt. |
| **GİB Portal** | Govt. (free) | Free fallback but UX hostile: requires permanent e-imza/mali mühür plug, no Chrome support, **no mobile**. |
| **KolayBi'** | Mikrogrup-adjacent | "Free e-SMM" market position. |
| **QNB eSolutions / Uyumsoft / İzibiz** | Bank/enterprise integrators | Less freelancer-focused. |
| **MikroX / Bizim Hesap** | Mikro | Comparison-mentioned but not preferred. |

**Key insight:** No native-mobile-first, **flat-fee** e-SMM app surfaced. Paraşüt is the cloud leader but uses subscription auto-renewal that has its own complaint cluster.

---

## 3. Pricing Willingness Range (TL)

- Sysmond Premium reference: **350 TL** for what users expect to be a working e-SMM app
- Mikrogrup token packages cited: 195–600 TL for 100–200 kontör (each kontör ≈ 1 invoice)
- Paraşüt advertised: ~14k TL annual renewal triggered a major complaint (so monthly equivalent ~1100 TL is at the *upper* limit of acceptance)
- **Implied sweet spot for "honest flat-fee" e-SMM mobile app: 99–250 TL/month** with no token games

---

## 4. Is "Honest flat-fee e-SMM" something Turkish freelancers explicitly want?

**YES — high-confidence.** The pain pattern is consistent across 3 vendors (Mikrogrup, Sysmond, Paraşüt complaints):
1. **Pre-purchase bait, post-purchase silence** — explicit verbatim ("Ücreti yatırana kadar ilgi var…")
2. **Token/kontör opacity** — Mikrogrup multiplied stated price 3× after install
3. **Hidden auto-renewal billing** — Paraşüt 14k TL surprise charge complaint
4. **Mobile-first is unmet** — GİB Portal has no mobile, Sysmond mobile crashes, Mikrogrup is desktop-first

The wedge "**flat fee + mobile-first + no kontör games + transparent renewal**" lines up 1:1 with the verbatim pain.

---

## Confidence change

**YES — increase D7 confidence.** Forum complaints corroborate the Play-Store-derived thesis: Mikrogrup token-price bait-and-switch and Sysmond pay-but-doesn't-work are real, repeated, and named by users. Three competitors share the same complaint cluster, and the recommended alternative (Paraşüt) has its own auto-renewal complaint cluster — the niche is genuinely under-served at the freelancer flat-fee tier.

**Caveat:** Limited Reddit/ekşi access (eksisozluk 403). Add a Tier-2 sweep of `r/Turkey` + `r/KGBTR` next tick if budget allows.
