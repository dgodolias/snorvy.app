# D9 Competitive Timeline (Tick 14)

## Obsidian mobile capture roadmap — what's already shipped and what's next

### Already shipped (as of May 2026)
- **Obsidian 1.11 Mobile (released Jan 12, 2026)** — Lock Screen + Control Center + Home Screen widgets. Capture shortcuts to "open a note, open daily note, capture to a note." iOS shortcuts append/prepend text without opening the app.
- **Obsidian 1.12 Desktop (released through 1.12.7 by March 2026)**.

### Critical caveat
The Jan 2026 quick-capture widgets STILL require the full Obsidian app to load before creating a note — vault loads first, then capture happens. The Obsidian Rocks community wrote: "the full Obsidian app opens and loads your entire vault before creating a new note, which still doesn't work well for quick capture." Third-party "Widgets for Obsidian" iOS app exists to fill this gap.

### What's coming in 1.12 mobile (kepano confirmed via X)
"We made this version of Obsidian so much faster, smoother, and more ergonomic. And there's lots more coming in 1.12." → 1.12 mobile is in active development as of late Jan 2026 X post. No public dated roadmap for mobile-1.12 release; based on Obsidian's prior cadence (1.10 → 1.11 was ~6 months), mobile 1.12 is **Q3 2026 most-likely**, possibly Q4.

### Implication for D9
- Obsidian's TRUE mobile-capture-without-loading-vault is NOT shipped yet. Jan 2026 widgets are partial. The "Obsidian shipping mobile capture" worry is real but not as imminent as feared.
- D9's window is **6-12 months** before Obsidian 1.12 mobile likely closes the gap on capture latency.
- HOWEVER: even after Obsidian fixes capture, Obsidian remains BARRIER-TOO-HIGH for the average Evernote refugee (22% low_pct, complaints about "house but you get a lot of bricks" setup pain). D9's senior-friendly + .enex one-tap import wedge is structural, not just a timing arb.

## UpNote feature releases since 2024

- **iOS 9.16.3 (Jan 28, 2026)** — stability improvements
- **iOS 9.16.1 (Dec 26, 2025)** — editor reliability fixes
- New: line breaks within lists without new list items
- New: merge multiple notes into a new note
- iOS 18 optimization, dark/tinted icon support
- Linux .deb format support; to-do completion auto-bottom
- Czech + Dutch localization added
- **Android 9.15.2 - 9.16.4 (Jan 26, 2026)** — stability

UpNote is in maintenance mode, not feature-expansion mode. They have NOT added .enex import. They have NOT loosened lock/attachment/table requirements off Premium. **D9's wedge against UpNote is the FREE tier scope** (UpNote paywalls table + attachment + unlimited notes; D9 gives them away).

## Evernote (Bending Spoons era) recent moves

- **Aug 2024**: Bending Spoons completes Evernote acquisition.
- **Dec 4, 2024**: 50-note + 1-notebook free-tier limit imposed on existing free users.
- **2024-2026**: Personal plan price climbs from $40-50/yr → $80-120+/yr → renewal quotes hitting $230-$350/yr (Trustpilot/forum verified).
- **2025-2026**: AI features force-injected; multiple 1-2★ reviews specifically rage about AI ("Turn off AI. Is Evernote done? If they keep going down the AI route then they are.").
- **In-app ads** added 2025-2026 (33% of 1-2★ rage theme — top complaint).
- **Forced updates** breaking app on the road (verbatim review).
- **No reverse course** signaled. Bending Spoons playbook = monetize-acquired-base aggressively.

## D9 launch window estimate

| Timeline | What happens | D9 readiness |
|---|---|---|
| **NOW (May 2026)** | Evernote rage at 88.2% last-90d; refugees actively migrating; Obsidian mobile capture is partial; UpNote in maintenance | D9 spec ready, build window 6-8wk |
| **Aug 2026** | Earliest realistic D9 launch (build + Play approval) | Window still wide-open |
| **Q3-Q4 2026** | Likely Obsidian 1.12 mobile release with vault-bypass capture | D9 should be live and accumulating reviews/installs by this point |
| **Q1 2027** | Obsidian + community plugins likely close most non-import gaps | D9 needs senior-UI + .enex moat to defend |
| **Q2 2027+** | Evernote refugee wave likely tapers (most who hated BS have already left) | New-install velocity decays; ARPU from existing base must carry |

## D9 launch urgency rating

**URGENT.**

Rationale: The Evernote refugee wave is at PEAK velocity NOW (88.2% last-90d low_pct, the highest reading observed across the entire research program). Every month of delay loses refugees to UpNote (already explicitly named as destination in 437-thumb reviews). Obsidian's full mobile capture is 6-12 months out, but UpNote is the immediate threat — and UpNote is free for the basic tier. D9 must launch by **August-September 2026** to capture the bulk of the wave. After Q1 2027, refugee inflow decays and D9 becomes a "smaller market share of an already-distributed base" play instead of a "ride the migration" play.

Build complexity verdict: 6-8 weeks (per prior tick spec). The .enex parser is the only non-trivial engineering piece. Drive/iCloud sync via SDK is well-documented. Lock + biometric is platform-API. Senior-UI is design + accessibility flags. **All pieces ship-able by Aug 2026 at solo-dev pace if work begins immediately.**
