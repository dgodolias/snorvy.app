# Exploration Tick 22 — Final Fresh Territory Scan

Date: 2026-05-07. Time spent: ~25 min. Goal: surface 1-2 final NEW direction candidates OR validate v9 11-direction set is full.

## A) Crypto wallet / DeFi tracker (privacy-first, $0 backend)

**Verdict: REJECT for $0-budget solo dev.**

Top indie candidates surveyed:
- **DeBank** (`com.debank.meme`): score 3.4. Recent (Nov 2025+) sample only N=13 (very low review velocity), low_pct 61.5%. Verbatims: *"microphone access?! for what?! uninstalled immediately"*, *"Total trash and bias"*. Cell IS vulnerable but tiny audience.
- **CoinStats** (`com.coinstats.crypto.portfolio`): 4.4 score, 142 recent reviews, low_pct 24.6%. Verbatims: *"New version is terrible, permanent ads at the top of the screen"*, *"direct debited $250 despite me not using the app for almost a year"*. Subscription/ad rage exists but score is healthy.

**Why reject**: (1) Crypto wallets require multi-chain RPC infra → NOT $0 backend (Infura/Alchemy free tiers throttle hard at any traction). (2) Self-custody key handling = legal/security liability for solo dev with no audit budget. (3) Trust required is enormous — users won't move funds to unknown brand. Violates user constraints.

## B) Crossword / word puzzle / sudoku (high-engagement B2C)

**Verdict: STRONG VULNERABLE CELL. Best new candidate of tick.**

Top vulnerable apps (both PlaySimple Games — owned by MTG/Modern Times Group, a Swedish PE-backed corp):
- **Daily Themed Crossword** (`in.crossy.daily_crossword`): 10M+ installs, 4.82 score, **recent low_pct 33.5%** (67/200). 4014 lifetime 1-stars.
- **Crossword Puzzle Explorer** (`in.daily_puzzle.crossword`): 1M+ installs, 4.84 score, **recent low_pct 32.0%** (64/200). 863 lifetime 1-stars.

**Verbatim user-voice (rage at corp ad-load)**:
> "way too many pop-ups! And ads on top of that. Basically unplayable"
> "ridiculous amount of ads, 2 minutes of ads for a level that takes less than half that"
> "False advertising claimed no ads, but there are ads before and after every puzzle"
> "I watched an ad for 5 min and using the back arrow or home button does nothing"
> "ad fixed on my screen in the middle of another game, downloaded twice, can't get rid of it!!"

Sudoku cell is saturated by quality indies (Sudoku.com 4.6, Cronoprice "Sudoku without ads" 4.7, Dustland "The Clean One" 4.6) — already well-served. Crossword cell is the gap: the indie ad-free crossword equivalent of "Cronoprice Sudoku" does not exist at scale.

**Wedge thesis**: One-time $2.99 IAP ad-free crossword w/ daily themed puzzle bank. $0 backend (puzzles shipped in-bundle + monthly OTA JSON drop). Audience: 50+ demographic Americans (Daily Themed Crossword's actual user base — see "soo many ads", "I had to uninstall because I couldn't figure out how to get to the next puzzle" — older users frustrated by adtech).

**Build cost**: 4-6 weeks. Generate puzzles via open dictionary + GPL crossword constructors (e.g., Phil, Crossword Compiler community grids). Localize to EN-US first.

**Score (rough)**: vuln 7/10, build-fit 8/10, $0-fit 10/10, revenue 5/10 ($2.99 × ~10k = $30k ARR ceiling — small but solo-fundable).

## C) IT (Italy) deeper micro-niche

**Verdict: DEAD ZONE for non-invoice IT verticals.**

Searches "agenda professionista", "spese partita iva", "gestione spese professionisti", "prenotazione appuntamenti" all surface either (a) global-English apps (Todoist, Setmore, Booking.com, BudgetBakers Wallet) or (b) tiny IT apps with <100 installs (`it.daikongroup.appuntamenti` = 50+ installs). The Italian SMB/freelancer market on Play is monoculturally captured by the invoice/fattura cluster (Fatture in Cloud, Aruba etc.) already covered in v9. No second IT-specific micro-niche emerges with a vulnerable incumbent ≥100k installs.

## 4) Best NEW direction candidate

**D12 candidate — "Quiet Crossword: Ad-Free Daily Puzzles" (US, 50+ demographic)**

- Cell vuln: 33.5% recent low_pct on 10M-install incumbent (Daily Themed Crossword, PlaySimple/MTG corp).
- Wedge: $2.99 one-time IAP, zero ads ever, large-text mode, offline-first, daily themed puzzle drop.
- $0 cost: puzzles bundled + monthly GitHub-hosted JSON, no auth, no server.
- Build: 4-6 weeks Flutter + open puzzle bank.
- Risk: dictionary licensing (mitigation: GPL crossword grids or hand-curate first 365 puzzles).

**Recommendation**: Add as **D12 candidate** for v10 ranking, but BELOW current top 3 (TR Couples, Halal Marriage, Greek wedding). Crossword opportunity is real but ARR ceiling is modest ($30-60k) vs. cornerstone directions. Worth tracking, not worth pivoting to.

## Verdict on opportunity-set completeness

v9's 11 directions + the Crossword candidate (D12) likely represent the FULL viable opportunity set under user constraints ($0 backend, solo dev, $350 ads). Remaining unexplored cells (crypto, IT non-invoice, hardware-IoT, regulated health) all violate at least one hard constraint. Recommend EXPLORATION mode close at this tick.
