# Games Focused Scan — 9 Apps × 300 Reviews (Replacement for Stalled Agent 7)
Date: 2026-05-07 | Country: US | Sort: NEWEST | Engine target: Flutter Flame (2D)

## 1. Per-Genre Tables

### Genre A — Endless runner (Flame feasibility: HIGH)
| App | Installs | Overall | Recent low_pct (n=300) | Top 1-2★ quote (👍) | Flame fit |
|---|---|---|---|---|---|
| Subway Surfers | 1B+ | 4.55 | 5.7% | "Irritating ads. Too many ads. Just can't play the game." (👍3) | HIGH (rail runner) |
| Temple Run 2 | 1B+ | 4.10 | **11.7%** | "The game was going good, but now ads are not opening" (👍14) | HIGH (rail runner) |
| Sonic Dash | 500M+ | 4.69 | 2.3% | "spinn wheel rework is straight cheeks. There's now no way to earn headstart…" (👍48) | HIGH (rail runner) |

Verdict: Top-3 endless-runner space is **fortified by ad-rev cash machines** (1B+ installs, 4.5+ rating). Dissatisfaction concentrated on ads, but volume is too low to suggest a swing-vote audience. **Not vulnerable.**

### Genre B — Idle/clicker (Flame feasibility: HIGH)
| App | Installs | Overall | Recent low_pct (n=300) | Top 1-2★ quote (👍) | Flame fit |
|---|---|---|---|---|---|
| **AdVenture Capitalist** | 10M+ | 4.52 | **52.0%** | "Imagine charging $15 A MONTH to get rid of ads…ads are intrusive and full-screen. All the ads used to be optional." (👍3) | HIGH (numbers + tap loops) |
| Egg, Inc. | 10M+ | 4.68 | 5.0% | "the whole coop thing is getting ridiculous…" (👍2) | HIGH (sim/idle) |
| Cookie Clicker (free w/ads) | 5M+ | 4.46 | 10.7% | "the ad version is far behind the adless version. over a year since the last update…both mobile versions are essentially abandoned." (👍2) | HIGH (pure tap loop) |

Verdict: **AdVenture Capitalist is the genre's bleeding wound** — recent reviewers are openly looking for a non-predatory replacement. Cookie Clicker mobile is officially abandoned per users. Egg Inc. holds steady. **Vulnerable cell present.**

### Genre C — Roguelike-lite / Vampire Survivors-style (Flame feasibility: MEDIUM)
| App | Installs | Overall | Recent low_pct (n=300) | Top 1-2★ quote (👍) | Flame fit |
|---|---|---|---|---|---|
| Survivor.io | 50M+ | 4.53 | 18.0% | "this game is just plain pay to win…the last mission was to obtain 20'000 gems and I had no way to get it in under 10 hours other than buying them" (👍5) | MED (auto-attack swarm) |
| **Archero** | 50M+ | 4.31 | **35.0%** | "Pay to win trash game that gets worse with every update and event…you hate your players…you rig every event." (👍15) | MED (twin-stick lite) |
| Soul Knight | 50M+ | 4.59 | 33.7% | "I missed those days where I can just play this game without an internet connection…now contains a lot of In-app purchases" (👍4) | MED (top-down dungeon) |

Verdict: **All three roguelike-lites are bleeding** — but root cause is "former offline/fair game went predatory online." Real demand exists for a genuine **offline, no-IAP** roguelike-lite. Soul Knight quote literally says "now they ruin it by making the game online."

---

## 2. TOP 3 Vulnerable Game Cells (ranked by low_pct × predatory complaint density)

| Rank | App | low_pct | predatory density of low reviews | combined score | dominant complaint |
|---|---|---|---|---|---|
| 1 | **AdVenture Capitalist** | 52.0% | 78% | **4056** | Forced full-screen ads after monetization rug-pull (105/122 low reviews mention ads, 12 mention P2W) |
| 2 | **Archero** | 35.0% | 36% | **1260** | P2W + RNG manipulation + greedy ad redirects (14 ads + 13 P2W + 7 grind in 105 low reviews) |
| 3 | **Survivor.io** | 18.0% | 31% | **558** | P2W + stat-check progression walls + grind (5 ads + 6 P2W + 5 grind in 54 low reviews) |

Honorable mention (low n but loud): **Soul Knight** — 7/13 low reviews call out energy/gating + offline removal; specifically targetable but predDensity diluted because complaints are "feature regression" not classic predatory monetization.

---

## 3. Best Direction 6 Game Candidate — 1-sentence pitch

**"Tycoon Zero" — a clean, fully-offline idle/tycoon clicker (Flame engine, AdVenture Capitalist clone in spirit but with one-time $2.99 unlock, zero forced ads, zero gacha, zero energy timers, cloud save via free Firestore tier).**

**Flame patterns to use:**
- `flame_audio` for satisfying tap SFX
- `Component`/`HasGameRef` for the vertical scrolling business list
- `TextComponent` + `BigInt` for the trillion/quadrillion number cascade
- `SpriteAnimationComponent` for unlock-celebration flourishes
- `flame_riverpod` (or just ValueNotifier) for state — no backend needed
- Local state in `shared_preferences` + Firestore free tier for cross-device sync
- 8-12 weeks solo realistic (no networking, no PvP, no multiplayer = scope-friendly)

The verbatim user voice supports this exactly: *"I hope this is some kind of meta joke about capitalism. Many other apps have a $1-$5 ONE TIME charge to remove ads permanently"* and *"Ads gave rewards and were only 30 seconds long. Now ads are up to 2 mins total and if you click on anything BAM ad."* — i.e. the audience is asking out loud for the exact product.

**Backup positioning if AdCap angle feels too narrow:** "Pure roguelike-lite, no internet required" (Soul Knight refugees). But this is a HARDER 8-12wk build for a solo dev (combat, enemy AI, weapon rolls, room-gen) than the idle/tycoon route.

---

## 4. VERDICT — Does games belong in v9 top 5?

**RECOMMENDATION: SEPARATE "FUN PROJECT" PATH, not top-5 v9.**

Reasoning (vs. B2B utilities the user has already validated):
- **Revenue ceiling:** Idle/tycoon premium games typically cap at $0.50–$2 ARPDAU even at scale; B2B utilities convert at $5–$15 MAU. With $350 ad budget + organic-only TikTok, the unit economics favor B2B by ~5-10×.
- **Discovery is brutal in games:** Play Store games chart dominated by 50M+/1B+ install incumbents with ad-rev war chests. ASO + $350 cannot meaningfully compete against IronSource/Unity Ads-fueled installs from Habby/Sybo/Hyper Hippo.
- **Confidence delta:** The vulnerability signal IS real (AdCap 52% low_pct is genuinely rare), BUT the user's existing TR Couples / Halal Marriage / B2B Hobbyist directions all have ≥35% low_pct AND a clear paying-customer wedge AND a defensible language/cultural moat. Games have neither moat.
- **Build risk:** A solo Flutter/Flame dev with no prior game-shipping history attempting an idle/tycoon polished enough to displace AdCap = realistic 14-20 wk build, not 8-12. Timer/UI polish in idle games is deceptively hard.
- **Greek dev advantage = zero in games:** The user's geographic/language edge (Arabic, Turkish, Greek) helps in regional B2B/utility/lifestyle apps. Mobile games are language-agnostic and the user gains no edge.

**PROPOSED v9 PLACEMENT:**
- Do NOT replace any of the current top-5 directions with games.
- ADD as **"Direction 6 — Side Project / Portfolio play"** with a clear caveat: lower-confidence, longer build, but Flame engine experience builds dev capability that compounds. Pitch as the "fun" outlet to balance B2B grind, NOT as primary revenue path.
- If forced to fill 5 slots and games MUST be one: pick **Tycoon Zero / no-ads idle clicker** (AdCap displacement). Skip endless runners and roguelike-lites entirely.
