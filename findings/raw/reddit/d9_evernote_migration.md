# D9 — Evernote Refugee Reddit Migration Validation

**Date:** 2026-05-07
**Method:** Arctic Shift archive (reddit-search skill), 8 queries × 5 subreddits, 6 comment-trees fetched
**Direction tested:** "Evernote refugee notes-vault app — capitalize on Bending Spoons collapse + 84% recent low ratings"

---

## 1. Top 6 Posts by Engagement (score × num_comments)

| Rank | Sub | ID | Title | ↑ | 💬 |
|---|---|---|---|---|---|
| 1 | Evernote | [1680za9](https://www.reddit.com/r/Evernote/comments/1680za9/) | "Your account will be permanently closed" — my reasons for leaving Evernote as a loyal user since 2011 | 208 | 83 |
| 2 | Notion | [18v72nn](https://www.reddit.com/r/Notion/comments/18v72nn/) | Coming from Evernote. Why doesn't Notion feel like a notebook? | 124 | 62 |
| 3 | Evernote | [18jmx3t](https://www.reddit.com/r/Evernote/comments/18jmx3t/) | What Bending Spoons is doing, and why you should care | 115 | 91 |
| 4 | ObsidianMD | [1ro7h83](https://www.reddit.com/r/ObsidianMD/comments/1ro7h83/) | For those who switched from Evernote to Obsidian | 102 | 62 |
| 5 | ObsidianMD | [1isjwb0](https://www.reddit.com/r/ObsidianMD/comments/1isjwb0/) | After 10 Years with Evernote, I Switched to Obsidian — 2 things would make it perfect | 95 | 53 |
| 6 | Evernote | [1g91we4](https://www.reddit.com/r/Evernote/comments/1g91we4/) | Due to the crazy price increase, I am leaving Evernote after more than a decade | 67 | 57 |

---

## 2. Top 5 Verbatim Quotes (with vote counts)

**V1 — OP /r/Evernote/1680za9 (208↑) — the cornerstone refugee story:**
> "As a long-time lurker, today I step into the light to bid farewell. Just this week, I received the long-awaited email *'Change to your Evernote subscription price'*… **TL;DR: I have completed the move of 12 years worth of 150+ notebooks and 10K+ notes from Evernote into Obsidian, canceled my subscription, and closed my account.**"

**V2 — OP /r/Evernote/1g91we4 (67↑):**
> "I suspect that somebody in the C-suite at Evernote made a decision that they could absorb a certain number of un-subscribers in return for setting a price that is **2.5× higher** than it is currently. Interesting decision, but you can count me among those who are leaving."

**V3 — Comment on Bending Spoons thread (20↑):**
> "Yes, changing the free tier at short/no notice was a hostile move. If you are a paid user you should not think this hostility does not apply to you. Or 'First they came for the Free Tier Subscribers — and I did not speak out…'. This has been the deal breaker for me."

**V4 — Comment on Obsidian-switch thread 1isjwb0 (40↑) — the unmet feature:**
> "**Mobile capture is an issue** — it's currently planned, but I use the Markor app with my vault synced to my phone via syncthing."

**V5 — Comment on Obsidian-switch thread 1ro7h83 (29↑) — second unmet feature:**
> "The biggest thing I miss in Evernote is the **auto OCR of PDFs** so that the text for them can be searched even if the PDF originally came from a document scanner. That was amazingly handy and **I haven't managed to replace it**."

**V6 (bonus) — Comment on 1g91we4 (16↑) — quantifying the migration:**
> "So far I've moved **3,500 of my notes** off Evernote, about 2,000 to go. Been a paying Evernote user for 13 years and I'm out."

---

## 3. Migration Patterns (Evernote → X, why)

| Destination | Frequency | Why migrating |
|---|---|---|
| **Obsidian** | Dominant (~60% of explicit destinations across threads) | Plain-text/markdown, local-first, plugin ecosystem (Notebook Navigator etc.), Obsidian Sync $96/yr (~25% cheaper than Evernote Personal). Pain: steep curve, weak mobile capture, no auto-OCR. |
| **Notion** | Strong (~20%) | Modern UI, free tier. Pain: "feels like a project-management tool, not a notebook" (top comment 460↑). |
| **OneNote (Office 365)** | Moderate (~10%) | Bundled w/ Office, "may be cheaper". |
| **Plain text files (sive.rs/plaintext philosophy)** | Niche (~5%) | "Most reliable, flexible, long-lasting". |
| **Joplin / UpNote** | Mentioned but rare | Not surfaced in top engagement clusters. |

---

## 4. Most-Named Alternative + Sentiment

**Winner: Obsidian** (clear margin) — high satisfaction once past learning curve.

Sentiment quotes:
> "Obsidian is so much better." (8↑)
> "Finally free from Evernote!!" (150↑ standalone post)
> "Sync works great I just renewed $96 for the year" (27↑)

But explicit unmet needs (the gap an opportunist app could fill):
- **WYSIWYG editor** (Obsidian is markdown-only)
- **Mobile quick-capture** (still planned in Obsidian roadmap)
- **Auto-OCR PDF search** (no Obsidian plugin replacement)
- **Web Clipper** parity (Obsidian's clipper is improving but inconsistent)
- **Notion is overkill** for users who just wanted "a notebook"

---

## 5. Explicit Feature Requests for "Perfect Evernote Replacement"

Synthesized from comment trees:
1. **WYSIWYG markdown editor** (best of both worlds)
2. **Mobile-first quick-capture** (camera, audio, web clipper)
3. **Auto-OCR PDF & image search** (Evernote's killer feature)
4. **Local-first + optional cheap sync** (≤$50/yr, vs Evernote's now ~$130/yr)
5. **Painless EN-import** (.enex parser that preserves notebooks/tags/attachments)
6. **No subscription auto-rug-pull** — explicit trust signal: "won't get acquired by Bending Spoons"
7. **Notion-style block UX BUT scoped to a notebook**, not a project tool

---

## Confidence change

**YES — increase D9 confidence.** Five-year-deep refugee user-voice with concrete migration receipts (10K+ notes moved), named destinations (Obsidian dominant), and crisply unmet feature gaps (mobile capture, auto-OCR, WYSIWYG) that are individually tractable for a solo dev. The 2.5× price hike + "permanently closed" account email is a recurring trauma trigger across multiple OPs, not just one viral post.

**Risk:** Obsidian is fast-shipping (Notebook Navigator plugin, mobile capture on roadmap). The window is open NOW; in 6–12 months Obsidian likely closes it. Recommend FAST execution — focus on **mobile-first capture + .enex importer + auto-OCR** as the wedge, not a full vault clone.
