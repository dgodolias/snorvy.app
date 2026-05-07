# D7 TR e-SMM Launch Readiness v2 — Tick 31 DEEPER DIG

## App Identity

**Recommended app name (Play Store):** `SMM Defter — e-Serbest Meslek Makbuzu`
**Alternative:** `Makbuz+ : e-SMM Mobil`
**Subtitle (TR, ≤30 chars):** `Doktor, avukat, danışman için e-SMM`
**Short description (TR, 80 chars):** `GİB onaylı e-Serbest Meslek Makbuzu — 30 saniyede kesin, mobilden imzalayın.`

## ASA — Turkish Keywords (Play Console)

Primary: `e-smm`, `serbest meslek makbuzu`, `e-makbuz`, `mali müşavir`, `serbest meslek`
Secondary: `e-fatura mobil`, `gib makbuz`, `doktor makbuz`, `avukat makbuz`, `freelancer fatura`
Long-tail: `e-smm mobil uygulama`, `serbest meslek makbuzu kesme`, `gib portal alternatif`, `mali mühür mobil`

## Pricing Model

**Tier structure (TL, KDV dahil):**
- **Free:** 5 makbuz/ay, GİB raporlama, PDF paylaşım. Reklamsız. (Anti-pattern: SYSMOND'un reklam dolu free tier'ı kullanıcıyı yaktı — review #2 ve #5)
- **Solo (199 TL/ay or 1.999 TL/yıl):** sınırsız makbuz, müşteri CRM, KDV otomasyonu, e-imza
- **Pro (399 TL/ay):** çoklu mali mühür, muhasebeci paylaşımı, Excel/CSV export (Mikrogrup'un Excel fail'i — kategori review)

**Pricing willingness signal (Şikayetvar + Eksi):**
- Uyumsoft: 399 TL/yıl (kullanıcı: "alçakça gizli" — review #11) → fiyat OK ama saklı maliyet kötü
- SYSMOND Premium: 350 TL/ay (Şikayetvar Fatih Kasım 2024) → 8 ay ödeyip hizmet alamamış
- Anchor: 199-399 TL/ay aralığı kabul edilebilir; piyasa Greek myDATA'dan ~3x daha bilinçli

## Differentiation Wedges (verbatim user-pain backed)

1. **Sunucu kararlılığı (uptime SLA garanti)** — SYSMOND #8: "para veriyoruz kesintisiz hizmet beklemek hakkım"; Mikrogrup #6: "1 haftadır fatura kesemiyorum"
2. **Reklamsız free tier** — SYSMOND #2: "eskisi gibi reklam alternatifli olmalıydı"
3. **Şeffaf fiyatlandırma (gizli ücret yok)** — Uyumsoft #11: "tüm bilgilerinizi aldıktan sonra fiyat veriliyor — alçakça"
4. **PDF/HTML paylaşım gerçekten çalışır** — Mikrogrup #9, #12, #13: paylaşım hatası birikti
5. **iOS+Android paritesi** — Mikrogrup'ta iPhone çalışıyor Android çalışmıyor (review #7)
6. **Türkçe canlı destek (chat, 1 saatten az yanıt)** — Şikayetvar tüm 3 incumbent'in #1 şikayeti müşteri hizmetleri

## Greek Dev vs Turkish Dev — Competitive Considerations

**Greek dev disadvantages (be aware):**
- Mali mühür (e-imza HSM) entegrasyonu — TR'ye özel KamuSM/TÜBİTAK altyapısı; uzaktan testi zor
- Vergi mevzuatı değişiklikleri (KDV 1/4 beyannamesi) — Türk muhasebeci danışmanı şart (Uyumsoft Şikayetvar #2 = "KDV1 KDV4 yok" → mevzuat takibi kritik)
- Türkçe nüansları + GİB API dökümanı sadece Türkçe
- TR Play Store policy + KVKK uyumu (KVKK ≠ GDPR fully)

**Greek dev advantages:**
- myDATA D13'ten kazanılan e-belge backend mimarisi direkt port edilebilir (XML+digital signature pattern)
- Aynı VAT/KDV state machine (Greek FNH ↔ TR e-belge formatı UBL-TR XML)
- Lower BL-fee than istanbul devs ($0 budget'a uygun)

**Recommended Mitigation:**
- Yerel TR muhasebeci advisor ($0: Reddit r/maliyet, freelance forum) — content review için
- GİB Test Ortamı sandbox-only başla (fatura mocking)
- Pre-launch: 5 TR mali müşavir beta (App Lab + Discord)

## Launch Sequence (8 hafta)

- **W1-2:** GİB e-belge sandbox + UBL-TR XML generator (myDATA codebase port)
- **W3-4:** mali mühür entegrasyonu (KamuSM API), local NSI TC kimlik doğrulama
- **W5:** Android UI (Flutter) — Mikrogrup UX kritik fail noktaları reverse-engineer
- **W6:** iOS parity, Play/App Store listing TR + ASA
- **W7:** 5 mali müşavir kapalı beta, GİB test fatura kesme
- **W8:** Public soft launch İstanbul + Ankara hedef, $350 Google Ads

## Risk Register

- **HIGH:** GİB özel entegratör onayı 4-12 hafta sürebilir (yetkili integratör listesi gerekli)
- **HIGH:** TR market education farklı — kullanıcılar "ücretsiz GİB Portal" alternatifini biliyor
- **MED:** Greek dev TR muhasebeci network'ü kurmak zaman alır
- **MED:** Incumbent'lar kötü ama market education yaptılar — pull-through avantajı

## Confidence

**D7 final score after deeper dig:** 5.4/10 (was 5.8 before). Down because:
- Mikrogrup/SYSMOND/Uyumsoft Play Store review volumes düşük (200 her biri) — D13 myDATA Score 8.2 vs D7 5.4
- Müşteri pain validate ✓ ama market size belirsiz (serbest meslek erbabı sayısı vs küçük işletme)
- D13 SHOULD remain #1; D7 #2 runner-up confirmed
