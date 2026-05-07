# TR Invoice Market — Exploration Tick 1

## Legal landscape (verified via WebSearch May 2026)

- **e-Fatura mandatory threshold**: 3,000,000 TL annual revenue (companies). Below this → not required.
- **Serbest meslek erbabı (freelancers)**: NOT required to use e-Fatura. They MUST use **e-SMM (e-Serbest Meslek Makbuzu)** — a separate Revenue Administration (GIB) system.
- e-SMM is mandatory for freelancers with regular professional income (consultants, designers, lawyers, engineers, etc.).
- e-SMM documents auto-transmit to GIB; no separate notification required.

**Implication**: There are TWO distinct TR markets:
  1. e-Fatura (small business/esnaf, esp. those crossing 3M TL threshold)
  2. e-SMM (every freelancer doing knowledge work)

## Vulnerable cells (recent 90-day low_pct)

| App | Low_pct (recent) | n_recent | Verbatim signal |
|---|---|---|---|
| **com.earsivfatura.app (Mikrogrup e-Arşiv Portal)** | **66.7%** | 12 | "1 haftadır fatura kesemiyorum. Arayüz çalışmıyor. Onay mesajları gelmiyor." (1 week unable to issue invoice) |
| io.earsiv.sysmond (SYSMOND) | 41.3% | 46 | "Tamamen ücretliye döndü… 1 jeton kalmış. Ayıp ayıp" (fully turned paid, 50 free tokens dropped to 1 in 4 invoices — bait & switch) |
| com.uyumsoft.ebelge | 50% | 2 (low n) | "Şifremi kabul etmiyor… kullanılmamak üzere ayarlanmış" (auth broken) |

## Top complaint themes (TR fatura/e-SMM)
1. **Bait-and-switch monetization**: free tokens given, then aggressively depleted ("50 jeton hediye verip 4 faturada 9 jetona düşmez")
2. **Outright broken**: cannot issue invoice for days; PDF/HTML sharing fails
3. **No e-SMM-first mobile app surfaced** in TR invoice search — most results are e-Fatura/e-Arşiv. e-SMM is a hidden underserved sub-niche.

## $0-cost & 3-8 week build feasibility

- **e-SMM mobile app**: GIB integration is via free dijital.gib.gov.tr endpoint (no paid middleware required). Can be built as a thin client to GIB's free portal — similar architecture to D1 FairBill. NO backend infrastructure needed beyond Firebase.
- **Legal risk**: LOW. e-SMM is government-mandated; building a compliant client is not a regulated activity (vs. e.g. payment processing).
- **Greek dev advantage**: Cultural proximity (Aegean trade, Istanbul/Izmir freelancer density), some Turkish words have Greek/Latin roots (fatura ← Italian fattura). Translation cost low.

## Verdict: GO

Greek solo dev can build **e-SMM-first mobile app** (Turkish freelancer receipt issuer) targeting underserved sub-segment. Top incumbent complaint = bait-and-switch token monetization → wedge = honest flat-fee or true freemium with ad-supported tier. Estimated $0-cost build in 5-7 weeks. Vulnerable cells confirmed at 41-67% recent low_pct — beats v9 D1 baseline (23%).
