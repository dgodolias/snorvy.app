# Tick 13 Exploration — Water / Reading / Pet (US)

Date: 2026-05-07. v9 has 9 directions (29% weekly, ~6pp headroom). Goal: find 3 niches to fill budget.

## 1. Water tracker niche — REJECT

11 candidates surfaced; 4 pulled deep. Market is **saturated commodity**.

| App | Installs | Score | Recent low_pct |
|---|---|---|---|
| Water Drink Reminder (Leap Fitness) | 10M+ | 4.60 | 15.0% |
| Plant Nanny (SPARKFUL) | 5M+ | 4.65 | 6.0% |
| Drink Water Reminder (Better Life) | 1M+ | 4.62 | 18.0% |
| Water Reminder Daily (VGFIT) | 500k+ | 4.64 | 12.5% |

**Avg low_pct: 12.9%** — modest displacement. Top complaint = ad spam + paywalls on basic features (e.g. custom goals locked).
Verbatim Plant Nanny: *"I do not need to drink 2L of water a day... I'll fail the goal if I don't yet can't adjust [without paywall]."*
Verbatim Better Life: *"the reminder does not work at all. Only gave a reminder once at the start of the day and never does it again."*

**Verdict:** Leap+SPARKFUL duopoly with $0 ARPU dynamics, 14-yr-old leader. Hyper-commodity. No defensible wedge for solo dev. **REJECT.**

## 2. Reading tracker niche — REJECT (mostly loved or corp-owned)

5 candidates pulled; results polarized.

| App | Installs | Score | Recent low_pct | Note |
|---|---|---|---|---|
| Bookmory | 1M+ | 4.77 | **3.0%** | users adore it |
| StoryGraph | 1M+ | 4.53 | **3.5%** | users adore it |
| Bookly | 500k+ | 4.19 | 20.0% | candidate, but timer-required friction |
| Fable (Scribd) | 1M+ | 4.65 | 27.0% | corp moat (Scribd) — caution |
| Goodreads | 100M+ | — | — | REJECT (Amazon) |

**Bookly verbatim ★2:** *"I paid for the yearly and still didn't use it after April... so annoying to literally go to the app to start a timer everytime I read. Then it would be inaccurate because I would fall asleep reading."*
**Fable verbatim ★1:** *"This app does not like Android users... dark mode does not exist. I'm missing a lot of titles... very hard to get books added."*

**Verdict:** Bookmory + StoryGraph have <4% recent low_pct = users love them. Only Bookly (20%) is a soft target but its 500k cap + timer-friction is not a 6-8wk wedge a solo dev wins. Fable's 27% is misleading — most complaints are about Scribd's e-book paywall behavior, not core tracking. **REJECT.**

## 3. Pet activity niche — REJECT (thin market)

| App | Installs | Score | Recent low_pct |
|---|---|---|---|
| DogCat Pet Care Tracker | 100k+ | 4.33 | 12.0% |
| DogLog | 100k+ | 4.56 | **28.0%** |
| Doggy Time | 50k+ | 4.45 | 20.0% |

**DogLog verbatim ★2:** *"Loved it until recently. The filter used to work. Now, when I select a dog and/or an event, it is telling me, 'No events logged for your dog yet.' If I first scroll through the log first, then the filter will show me only those events that I scrolled through."*
**Doggy Time verbatim ★1:** *"Paid to upgrade but the app has now stopped working. It won't sync with my partner anymore. I can't see anything that he has logged. It keeps telling me that I need to upgrade to unlock features that I have already paid for."*

**Verdict:** Highest single low_pct of all 11 apps (DogLog 28%) BUT install ceiling is 150k max across all viable candidates. TAM for a US-only solo dev pet-care-tracker is structurally tiny. Hardware-bundled apps (Tractive, Whistle, Fi, Petivity) own the category for serious users; software-only segment is hobbyist. **REJECT.**

## 4. Best NEW direction: **none**

Across all three territories, none clears the v9 admission bar:
- Water = saturated commodity with corp-grade incumbents.
- Reading = top apps loved (low_pct ≤3.5%), only Bookly soft + Fable corp.
- Pet = highest displacement (28%) but install ceiling 150k = sub-scale.

**Recommendation:** Do not add a 10th v9 direction from these niches. Keep ~6pp headroom for tightening v9's existing 9 directions OR a future tick targeting a different vertical (e.g. menstrual tracking, sleep, ADHD planners — where corp leaders have known recent revolts).

---
Files:
- `findings/raw/play-store/explore_water_book_pet.json` — full candidate metadata + low_pct
- `findings/raw/play-store/_t13_*.json` — raw 200-review pulls (11 apps)
