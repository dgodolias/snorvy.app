# Explore Tick 4 Summary — 2026-05-07

Loop: app-radar EXPLORATION MODE. v9 has 5 directions drilled, currently 27% weekly cap 35%.
Two NEW direction candidates scanned: J (photo editor / doc scanner) and K (language / vocab).
Constraints checked: $0 backend, no AI inference, no marketplace, simple build, low legal risk.

---

## J. Photo editor / Document scanner — Top 3 vulnerable cells

| App | Installs | recent_low_pct (90d, n=200) | IAP range | Notes |
|---|---|---|---|---|
| **VSCO (com.vsco.cam)** | 100M+ | **65.3%** | $0.99-$29.99 | Score crashed to 2.7. Rage = forced server-auth, broken bio edit, "pay-to-use without warning" |
| **Adobe Acrobat Reader (com.adobe.reader)** | 500M+ | **45.0%** | $1.99-$299.99 | "Trial requires subscription first… nonsense"; users feel trapped. Corporate/legal-heavy though |
| **Picsart (com.picsart.studio)** | 1B+ | **25.0%** | $0.99-$219.99 | "all important tools are paid"; refund denial complaints; force-close bugs |
| YouCam Perfect | 100M+ | 22.5% | $0.69-$119.99 | "cannot cancel subscription… scam" |
| CamScanner | 500M+ | 17.0% | mid | Rage muted; entrenched |
| Adobe Scan / Genius Scan / Adobe PS | 10-100M | 8-12% | low-mid | Loved; not displaceable |

**Verbatim (VSCO):** *"A pay-to-use app that doesn't show a paid subscription is required before installation."*
**Verbatim (Adobe Reader):** *"On app it says trial free for few days but to even access to free trial need to add subscription first... nonsense"*

**Direction J assessment:** VSCO 65% rage IS impressive, BUT photo editor build = native image processing libs + filters + heavy on-device storage. NOT $0 backend (still possible) BUT competes with 1B+ install giants like Picsart on UX. Build complexity: 8-12 weeks for credible MVP. Niche feels saturated. Adobe Reader rage is real but PDF reader dev = legal-heavy / format-spec hell. Doc scanners (CamScanner 17%, Adobe Scan 8%) are NOT vulnerable enough — incumbents loved.

**Verdict on J:** Moderate. VSCO displacement is interesting but UX-heavy. Doesn't beat existing v9 top 6.

---

## K. Language learning / Vocabulary — Top 3 vulnerable cells

| App | Country | Installs | recent_low_pct | IAP range | Notes |
|---|---|---|---|---|---|
| **Mondly TR (com.atistudios.mondly.languages)** | TR | 50M+ | **51.5%** | ₺10-₺4.7K | "abonelik yapmadım… 1 yıllık para kesilmiş onaysız resmen dolandırıcılık" — outright billing fraud accusations |
| **HelloTalk US (com.hellotalk)** | US | 10M+ | **43.5%** | $0.49-$399.99 | Score 3.4. "really exploitative"; translation paywall rage |
| **Beelinguapp (com.david.android.languageswitch)** | US | 5M+ | **40.5%** | $1.99-$398 | "incredibly scummy pricing… use anki"; forces decision in first 30 min |
| Vocabulary daily (com.hrd.vocabulary) | US | 5M+ | 38.5% | $2.99-$149.99 | "hidden fees. subscription based not free as an app of this level of simplicity should be" |
| Mondly US | US | 50M+ | 34.0% | $0.49-$249.90 | "automatically renews without consent… basically a scam" |
| Quizlet | US | 50M+ | 26.0% | mid | "AI junk now"; "not free anymore" |
| Duolingo TR | TR | 500M+ | 15.0% | mid | Loved despite some rage — REJECT |

**Verbatim (Mondly TR):** *"abonelik yapmadım sadece uygulama telefonumda kalmış bir hafta sonra benden bir yıllık abonelik parası kesilmiş onaysız resmen dolandırıcılık bu"* (I didn't subscribe, app just sat on my phone, a week later they took a year's subscription money without consent — this is literally fraud)

**Verbatim (Beelinguapp):** *"incredibly scummy pricing. forces you to make a decision in the first 30 minutes, before you can even try the app. total waste. use anki."*

**Direction K assessment:**
- **Mondly TR 51.5% rage** is a REAL signal — TR Pearson-owned product with billing-fraud accusations. v8 already noted Duolingo TR 19%. TR vocab/lang gap is REAL.
- **However:** Building a credible language app requires content (curriculum, audio, translations). Without AI inference (HARD constraint), curriculum production = either licensing $$$ or weeks of manual content work. Audio recording for 41 languages = impossible solo.
- **A vocab-flashcard app** with spaced repetition (no AI) is buildable in 4-6 weeks ($0 backend, on-device SQLite). User-generated decks like Anki — but Anki is open-source/loved. Differentiation = Turkish-first + non-scammy onboarding.

**Best K sub-cell: TR vocabulary/flashcard app, free + one-time $5 unlock, no auto-renew, Turkish UI first.** Mondly TR billing-fraud rage = direct displacement angle. Build = 4-6 weeks. $0 backend (Firebase free tier or fully local). No AI inference needed (SRS algorithm = SM-2, public domain).

---

## BEST NEW DIRECTION CANDIDATE across both: **K-sub: TR Vocabulary SRS (anti-Mondly)**

Score vs existing v9 top 6:
- **Vulnerability:** Mondly TR 51.5% recent low + ₺4.7K IAP rage = HIGH
- **Build cost:** 4-6 weeks solo, on-device SQLite + SM-2 algorithm. $0 backend.
- **Legal risk:** Low (no UGC chat, no payments to merchants)
- **Constraints fit:** All HARD constraints satisfied
- **Risk:** Anki dominates English market for free; TR vocabulary niche is smaller; monetization = one-time unlock only
- **TAM concern:** TR-only vocab learners = narrow. ARPU low.

**Comparison to v9 top 1 (TR Couples Tracker "Şeffaf"):**
- Couples tracker has ~equal vulnerability (Love8 32.8%) BUT broader TAM (couples > vocab learners) AND higher willingness-to-pay (relationship apps 2-3x ARPU vs ed-tech).
- **Verdict: TR Vocabulary does NOT beat v9 top 6.** Backlog candidate at best.

**Direction J (VSCO/photo):** Does NOT beat v9 top 6. Build complexity too high vs differentiation thesis.

---

## Recommendation
Neither J nor K beats existing v9 top 6. File both as backlog. v9 top 6 remains current.
- J-VSCO worth re-checking if v9 top 6 attrits.
- K-TR-vocab worth attaching to TR Couples Tracker direction as cross-sell candidate.

Files written:
- `findings/raw/play-store/explore_photo_scanner.json` (8 cells, 200 reviews each)
- `findings/raw/play-store/explore_language.json` (14 cells, 200 reviews each)
