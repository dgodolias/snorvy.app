# EXPLORE TICK 2 — v9 New-Direction Hunt

Date: 2026-05-07 | Author: research-agent (app-radar loop) | Scope: 3 NEW direction candidates D/E/F to fill 8pp budget under 35% weekly cap.

Method: 9 Play Store searches (BR + US), metadata + 200 newest reviews per app for 15 apps total, recent_low_pct (last 90d) computed, top thumbs-up verbatims surfaced. WebSearch for BR MEI 2026 regulatory facts.

---

## 1. BR MEI invoicing — Candidate D

**Regulatory facts (2026):**
- ~14M+ active MEIs; DAS rose to **R$ 81,05/mo** (commerce/industry) due to min-wage hike
- **NFS-e Nacional Emissor mandatory** for Simples Nacional ME/EPP from Sep 1, 2026 (Res. 189/2026)
- Brazilian government **provides free Emissor Nacional** (NFSe Mobile, br.gov.nfsemobileemissor) — no third-party emitter needed
- MEI **NOT affected by IBS/CBS in 2026** (delayed to 2027); only DAS value rises
- Full third-party NFS-e emission requires per-município certificate integration + carries **fiscal-document liability** if invalid

**Apps tested (BR market):**

| App | Installs | Score | Recent low_pct | Comment |
|---|---|---|---|---|
| MaisMei | 5M+ | 4.80 | **29.5%** (n=200) | DAS/INSS/notas multi-tool, dominant incumbent |
| Total MEI | 1M+ | 4.46 | 25% | Same dev as DAS MEI |
| DAS MEI | 500k+ | 4.73 | **30.4%** | Boleto-routing failures (paid app, govt didn't receive) |
| Emitte | 100k+ | 3.47 | 87.5% (n=8) | Pure NFe emitter — legal-risk zone |
| MEI Digital | 100k+ | 4.40 | 18.8% | Smaller player |

**Top verbatim (DAS MEI, 19 thumbs):** "O aplicativo gerou um boleto completamente diferente do que está disponível na receita. Usei o app para fazer o pagamento por quase um ano e isso nunca havia acontecido. Até que o pagamento do mês passado não entrou e só agora me dei conta que foi para um banco completamente diferente. Não caiam no…" (Aug 2025, 1★)

**Top verbatim (MaisMei, 9 thumbs):** "Sempre me atendeu muito bem, infelizmente não consigo emitir mais notas, tentei contato diversas vezes durante 4 meses não obtive nenhum retorno. Concluo que não precisam do cliente ou não se importam." (Mar 2026, 2★)

**Simplified-billing-niche feasibility (NOT full NFe — adjacent):**
- DAS reminder + revenue tracker + INSS-benefit dashboard = $0-cost, simple-build (~6-8wk), low legal risk
- BUT MaisMei (5M+ installs at 4.80★) dominates this exact slot
- Wedge would need to be: ad-free + no-paywall + offline-only + honest payment-flow (use govt API directly, never intermediate funds)
- BR ARPU low; revenue ceiling ≈ ads or one-time R$ 9-19 unlock

**Verdict: GO-CONDITIONAL but BELOW v9 top 6.** Real pain exists (boleto-routing failures, support black-hole) but incumbent loyalty + low ARPU + non-Portuguese Greek dev = poor fit vs. existing TR/AR/EN cells.

---

## 2. Meditation — Candidate E

**Top 3 vulnerable cells:**

| App | Installs | Score | Recent low_pct | Vulnerability |
|---|---|---|---|---|
| Meditopia | 10M+ | 4.51 | 72.7% (n=11) / **37% overall** (n=200) | Auto-renewal scam + AI-bot support |
| Aura | 1M+ | 4.55 | 26.9% | Quiz-then-paywall + no-skip onboarding rage |
| Simple Habit | 1M+ | 4.59 | 25% (n=4 small) | Borderline |

**Top verbatim (Meditopia, 25 thumbs):** "THIS IS A SCAM! They offer you a free 7 day trial, and then they charge your credit card immediately for the full amount. There is no easy way to cancel, no website you can use, and their customer service is an AI bot incapable of figuring out what you're saying you need." (Nov 2025, 1★)

**Top verbatim (Aura, 38 thumbs):** "Nope. Not the one. Immediately forces you to take their quiz about yourself, and then after, it forces you to create an account before you can do literally anything on the app. No option to skip, no option to try without signing up. needs a skip button." (Mar 2025, 1★)

**Wedge thesis:** "Honest Calm" — free meditation library, NO auto-renew, NO quiz wall, NO sign-up wall, real human support email. Strong user-voice. **BUT content licensing/recording for guided meditations is non-zero cost** (must license royalty-free narrators or record original audio, both $$). Violates strict $0-budget unless using public-domain Buddhist/yoga audio (limits differentiation).

---

## 3. Pomodoro — Candidate F

**Top 3 cells:**

| App | Installs | Score | Recent low_pct | Notes |
|---|---|---|---|---|
| Focus To-Do | 10M+ | 4.62 | 16.5% (n=200) | Sync paywall complaints, watch bugs |
| Goodtime | 1M+ | 4.60 | 6.5% | Healthy |
| Engross ADHD | 500k+ | 4.42 | 4.4% | Healthy |
| Focus Keeper | 100k+ | 3.94 | 41.5% overall | Old Apple port, tiny install |

**Top verbatim (Focus To-Do, 5 thumbs):** "A conceited developer who doesn't answer questions. He doesn't even bother to comment on why he didn't add this reordering feature that's found in every app. A to-do list without reordering." (Mar 2026, 1★)

**Top verbatim (Focus Keeper, 17 thumbs):** "Isn't it counterproductive to have ads on the very screen that is supposed to be a focus screen? The whole point is to avoid distractions and lock in and that can't happen with Ads dancing around the screen." (Apr 2025, 1★)

**Verdict: SATURATED, NO WEDGE.** Niche dominated by healthy 4.4-4.8★ indie apps (Goodtime open-source-flavor). Build is trivial (3-5wk) but no displacement signal AND users expect free-forever — no monetization path.

---

## 4. BEST NEW DIRECTION CANDIDATE

**None of D/E/F clearly beats v9 top 6.**

- **D (BR MEI)** — best low_pct cell among all 3 (DAS MEI 30.4%, MaisMei 29.5% on n=200), but incumbent moat at 5M installs + low BR ARPU + Portuguese-language barrier for solo Greek dev
- **E (Meditation)** — strongest user-voice rage (auto-renewal scam, paywall hostility) and biggest target (Meditopia 10M+, Aura 1M+) but **content-creation cost violates $0-budget**
- **F (Pomodoro)** — saturated, no wedge

**If forced to add ONE:** Candidate D (BR MEI honest DAS-tracker) is closest to constraints but ranks below v9 #6.

**Recommendation:** Do NOT promote any of D/E/F into v9 top 6. Continue spending the remaining ~8pp budget on deepening v9 #1-3 (TR Couples Tracker Şeffaf, etc.) rather than diluting with weaker cells.
