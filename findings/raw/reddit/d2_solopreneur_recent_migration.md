# D2 SoloLedger — Reddit Recent Migration Patterns (Tick 10, last 90 days)

Time window: 2026-02-06 → 2026-05-07 (after=1770384565). Subs: r/QuickBooks, r/smallbusiness, r/freelance, r/IRS, r/personalfinance.

## Top 5 verbatim quotes (last 90 days)

1. **[65↑] r/personalfinance "Self employed and taxes are destroying me"** (post 1rg5zbr, 57 comments)
   > "The tax burden is virtually the same as a regular job, you're not doing anything wrong. Everybody pays federal. Everybody pays state. You have to pay your own FICA (the self employment tax) which is normally split between the employee and the employer."

2. **[16↑] same thread — quarterly estimates pain**
   > "Did you pay quarterly estimates? If not, there are penalties baked in at the end in addition to the taxes. Make sure you pay every quarter (yes, that means paying in April for 2026 plus paying the 2025 taxes that you have due). I've got a spreadsheet set up and use that to determine an estimate. I've got the 15.3% there for self employment taxes, plus an estimate for regular income taxes."

3. **[5↑] r/QuickBooks "Best Quickbooks alternative for invoicing?"** (post 1r6uxee, 21 comments) — alternatives named:
   > "Sage 50" / "XPenses - perfect for small business owners" / "Wave. It's really good. Just don't use payroll." / "Honestly for just invoicing and bookkeeping I like FreshBooks, just make sure you get at least the middle package because you want to ensure you have double entry accounting."

4. **[2↑] r/IRS Schedule C audit advice** (post 1s4rkhp, 6 comments)
   > "Mail-in audits don't update in real time — the next step is simply the examiner contacting you if they need anything else… I had high expenses as this was my first full year in business and I rolled everything back into the business. They asked for everything expense related to the business so I just provided a receipt for every expense and how it was paid. I created a detailed spreadsheet and made notes on every expense."

5. **[3↑] r/smallbusiness "self-employed... underclaiming on Schedule C"** (post 1shbdnr)
   > "Or….Have two accounts. One personal and one business. Amazon is solid for that. You get a free business account that is completely separate from your personal one with a prime membership."

## Migration patterns (Solopreneur → X)

- The QB-alternative thread (1r6uxee) shows the Solopreneur user fled to a **DIVERSE** set: Sage 50, XPenses, Wave (with explicit "don't use payroll" warning), FreshBooks (with "middle tier minimum" gotcha). **No single dominant winner** — this confirms the unbundled landscape and SoloLedger's gap thesis.
- Schedule C threads (1s4rkhp, 1shbdnr, 1s6i179) repeatedly show users **building their own spreadsheets** with "made notes on every expense" — manual workaround dominance. One offered a "Free bookkeeping template for schedule c filers" (1s6i179).
- Migration is reactive (audit / new biz year-1) not proactive. Users discover they need a tool only when filing or audited.

## "$39 lifetime" — explicit demand check

**Not directly mentioned in last 90 days.** No single post used "lifetime" or "one-time" pricing language. However:
- Recurring frustration with FreshBooks "middle package" requirement (forced upsell)
- "Wave… don't use payroll" implies users actively avoiding subscription add-ons
- Spreadsheet self-rolling = strong implicit price-sensitivity ($0 they currently pay)

**Conclusion:** The $39 lifetime hypothesis is **price-sensitivity-validated** (users picking Wave-free, building spreadsheets, choosing tiered FreshBooks reluctantly), but **not explicitly stated** as user-voiced demand. SoloLedger's lifetime price is a developer-side wedge, not a user-articulated request.

## Net signal for v9

- **Positive**: Confirms migration off QBSE/Solopreneur is happening, no winner-takes-all replacement, manual spreadsheets dominate.
- **Caveat**: Direct r/QuickBooks "Solopreneur" mentions are SCARCE (only 1 post in 90 days). Volume of explicit Solopreneur-refugee posts is THIN — Direction relies more on QBSE+Schedule-C combo signal than a roaring migration crisis.
- **Risk flag**: If volume stays this low, organic Reddit acquisition channel for SoloLedger will be slow.

## Files
- `tick10/d2_qb_solopreneur.json`, `d2_qb_alternative.json`, `d2_sb_schedulec.json`, `d2_freelance_qb.json`, `d2_irs_schedulec.json`, `d2_pf_selfemployed.json`
- Trees: `d2_tree_1rg5zbr.json` (57c), `d2_tree_1r6uxee.json` (21c), `d2_tree_1rffjbk.json` (48c), `d2_tree_1rc33ih.json` (33c), `d2_tree_1shbdnr.json` (3c), `d2_tree_1s4rkhp.json` (6c)
