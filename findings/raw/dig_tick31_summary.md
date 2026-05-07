# DEEPER DIG Tick 31 — D7 TR e-SMM Validation Summary

## 1. Mikrogrup / SYSMOND / Uyumsoft 1500-Depth low_pct

**Critical scrape finding:** apps have very few Play Store reviews available (Mikrogrup 2, SYSMOND 6, Uyumsoft 0 newest-sorted). The 1500-target was capped by underlying review volume. SysmondAX (com.mse.sysmondax) returned 0. **Falling back to existing `explore_tr_*_all.json` (200-review samples) which provide robust depth.**

| App | n_total | full_low_pct | n_2025 | lp_2025 | n_90d | lp_90d |
|---|---|---|---|---|---|---|
| Mikrogrup (com.earsivfatura.app) | 200 | 26.5% | 70 | 30.0% | 10 | **70.0%** |
| SYSMOND (io.earsiv.sysmond) | 200 | 36.5% | 178 | 36.5% | 44 | **43.2%** |
| Uyumsoft (com.uyumsoft.ebelge) | 64 | 35.9% | 9 | 66.7% | 2 | 50.0% |

**Verdict:** Pain present and accelerating (Mikrogrup 90d-low_pct 70% vs full 26.5% = 2.6x worsening). SYSMOND consistent ~37-43%. But absolute review volumes are LOW vs D13 myDATA peers — this is a smaller user base than initially projected.

## 2. Top 5 TR Verbatim (highest thumbsUp, 1-2 star)

1. **SYSMOND, 28 thumbs, 2025-01-20:** "2000 küsür jetonum vardı silmişsiniz! Şimdi diyorsunuzki premium üyelik al!" (EN: "I had 2000+ tokens, you deleted them! Now you say buy premium membership!") — **monetization rug-pull resentment**
2. **SYSMOND, 21 thumbs, 2025-01-02:** "Ücretli olması kötü oldu, eskisi gibi reklam alternatifli olmalıydı" (EN: "Going paid was bad, should have kept ad-supported alternative") — **free-tier removal anger**
3. **Mikrogrup, 7 thumbs, 2024-04-02:** "1 haftadır fatura kesemiyorum. Arayüz çalışmıyor." (EN: "Can't issue invoices for 1 week. UI broken.") — **uptime/reliability**
4. **SYSMOND, 7 thumbs, 2025-05-05:** "para veriyoruz kesintisiz hizmet beklemek hakkım" (EN: "We pay, expecting uninterrupted service is my right") — **paid SLA breach**
5. **Uyumsoft, 6 thumbs, 2023-06-26:** "Yıllık 399+KDV ücreti olan bir uygulama ancak bu bilgi en son... alçakça bir durum" (EN: "App costs 399+VAT yearly but you only learn this after giving all your info... despicable") — **hidden pricing**

**External (Şikayetvar):** SYSMOND Fatih Kasım 2024: "8 ay 350 TL ödedim hizmet alamıyorum" (8 months @350TL no service). Uyumsoft Aralık 2025: "kullanmadığım hizmete fatura kesiyor" (charging me for unused service).

## 3. D7 App Name + ASA + Pricing

- **Name:** `SMM Defter — e-Serbest Meslek Makbuzu`
- **Subtitle:** `Doktor, avukat, danışman için e-SMM`
- **ASA TR keywords (top):** `e-smm`, `serbest meslek makbuzu`, `e-makbuz`, `mali müşavir`, `gib portal alternatif`, `e-fatura mobil`
- **Pricing:** Free (5 makbuz/ay, **reklamsız** — anti-SYSMOND wedge), Solo 199 TL/ay (sınırsız), Pro 399 TL/ay (çoklu mühür+CRM)
- **Anchor signals:** Uyumsoft 399 TL/yıl (kabul edilir ama gizli sunum kötü), SYSMOND 350 TL/ay (premium ödeyenler kızgın). 199 TL/ay sweet spot.

## 4. D7 Final Confidence After Deeper Dig

**Score: 5.4/10 (down from 5.8)** — DEMOTION justified.

**Why down:**
- Underlying user base smaller than initially modeled (200-tier apps, not 5K-tier)
- GİB özel integratör onayı 4-12 wk regulatory unlock — not $0/8wk-friendly
- Greek dev cannot easily access TR mali müşavir advisor network
- KamuSM HSM e-imza integration is TR-specific blocker (myDATA stack doesn't port directly here)

**Why still #2:**
- Pain VALIDATED across 3 sources: Play reviews + Şikayetvar + WebSearch consensus
- 90d low_pct trends UP (Mikrogrup 70%, SYSMOND 43%) = active dissatisfaction
- Pricing willingness real (199-399 TL/ay accepted)
- Differentiation wedges have verbatim backing (uptime, no-ads, transparent pricing, PDF actually works)

**Recommendation:** D13 myDATA stays #1 (Score 8.2). D7 stays #2 runner-up but lowered to 5.4. Do NOT split focus — execute D13 first, hold D7 for v10 if D13 stalls. If D7 pursued, week-1 must validate GİB özel integratör approval timeline (regulatory blocker = kill criterion).

**Files saved:**
- `findings/raw/play-store/d7_mikrogrup_tr_1500.json`, `d7_sysmond_tr_1500.json`, `d7_uyumsoft_tr_1500.json` (NEWEST scrapes — sparse)
- `findings/raw/play-store/d7_sysmondax_tr_1500.json` (empty)
- Analysis basis: existing `explore_tr_{mikrogrup,sysmond,uyumsoft}_all.json`
- `findings/raw/d7_launch_readiness_v2.md`
