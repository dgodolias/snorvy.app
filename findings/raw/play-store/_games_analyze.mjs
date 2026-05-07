#!/usr/bin/env node
// Analyze 9 game apps: low_pct on recent 300, top thumb 1-2★ quotes,
// predatory monetization complaint density (forced ads, P2W, energy/gating, gacha/lootbox).
import fs from 'node:fs';
import path from 'node:path';

const dir = 'C:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings/raw/play-store';

const apps = [
  // genre, label, file, installs, overall_score
  ['Endless runner', 'Subway Surfers',     'games_subwaysurf_300.json',   '1B+',   4.55],
  ['Endless runner', 'Temple Run 2',       'games_templerun2_300.json',   '1B+',   4.10],
  ['Endless runner', 'Sonic Dash',         'games_sonicdash_300.json',    '500M+', 4.69],
  ['Idle/clicker',   'AdVenture Capitalist','games_advcapitalist_300.json','10M+',  4.52],
  ['Idle/clicker',   'Egg, Inc.',          'games_egginc_300.json',       '10M+',  4.68],
  ['Idle/clicker',   'Cookie Clicker',     'games_cookieclicker_300.json','5M+',   4.46],
  ['Roguelike-lite', 'Survivor.io',        'games_survivorio_300.json',   '50M+',  4.53],
  ['Roguelike-lite', 'Archero',            'games_archero_300.json',      '50M+',  4.31],
  ['Roguelike-lite', 'Soul Knight',        'games_soulknight_300.json',   '50M+',  4.59],
];

// predatory keyword groups
const groups = {
  forcedAds:   /\b(ads?|advertisement|advert|commercial|video ad|too many ads|forced ads|unskippable|every \d+ second|nonstop ad|constant ads|pop[- ]?ups?|popups)\b/i,
  p2w:        /\b(pay[- ]?to[- ]?win|p2w|paywall|whale|spend money|spend hundreds|need to pay|forced to pay|cash grab|money grab|micro[- ]?transaction|microtransactions|expensive|rip[- ]?off|ripoff|greedy|too expensive|costs? a fortune|wallet|broke the bank)\b/i,
  energy:     /\b(energy|stamina|wait|waiting|cooldown|timer|time gate|gated|locked behind|stuck behind|grind|grinding|grindy|impossible to progress|can'?t progress|progression wall|progress wall)\b/i,
  gacha:      /\b(gacha|loot ?box|lootbox|chest|drop rate|rng|random|odds|gamble|gambling|lucky)\b/i,
};

const results = [];
let aggTopQuotes = [];

for (const [genre, label, file, installs, overallScore] of apps) {
  const p = path.join(dir, file);
  if (!fs.existsSync(p)) { console.error('MISSING', file); continue; }
  const data = JSON.parse(fs.readFileSync(p, 'utf8'));
  const reviews = data.reviews ?? [];
  if (reviews.length === 0) { console.error('EMPTY', file); continue; }

  const total = reviews.length;
  const low = reviews.filter(r => r.score <= 2);
  const lowCount = low.length;
  const lowPct = (lowCount / total * 100).toFixed(1);

  // recent date span
  const dates = reviews.map(r => new Date(r.date)).sort((a,b)=>a-b);
  const dateSpan = `${dates[0].toISOString().slice(0,10)}..${dates[dates.length-1].toISOString().slice(0,10)}`;

  // predatory hits across ALL reviews and across LOW reviews
  const counts = { forcedAds:0, p2w:0, energy:0, gacha:0 };
  const lowCounts = { forcedAds:0, p2w:0, energy:0, gacha:0 };
  for (const r of reviews) {
    const t = (r.text||'');
    for (const g of Object.keys(groups)) {
      if (groups[g].test(t)) {
        counts[g]++;
        if (r.score <= 2) lowCounts[g]++;
      }
    }
  }
  const predLow = lowCounts.forcedAds + lowCounts.p2w + lowCounts.energy + lowCounts.gacha;
  const predDensity = (predLow / Math.max(1,lowCount) * 100).toFixed(0); // % of low reviews that mention any predatory theme (multi-count)

  // top quotes among 1-2★ by thumbsUp, that mention predatory themes
  const lowSorted = [...low].sort((a,b)=> (b.thumbsUp||0)-(a.thumbsUp||0));
  const lowPredOnly = lowSorted.filter(r => {
    const t = r.text||'';
    return groups.forcedAds.test(t) || groups.p2w.test(t) || groups.energy.test(t) || groups.gacha.test(t);
  });
  const topQuotes = (lowPredOnly.length >= 5 ? lowPredOnly : lowSorted).slice(0,5).map(r => ({
    score: r.score, thumbs: r.thumbsUp, text: (r.text||'').replace(/\s+/g,' ').trim()
  }));

  results.push({
    genre, label, installs, overallScore, total,
    dateSpan, lowCount, lowPct: Number(lowPct),
    counts, lowCounts, predLow, predDensity: Number(predDensity),
    topQuote: topQuotes[0] ?? null,
    topQuotes,
  });

  for (const q of topQuotes.slice(0,3)) {
    aggTopQuotes.push({ app: label, ...q });
  }
}

// rank: low_pct * predDensity (cap quote length)
const ranked = [...results].sort((a,b) => (b.lowPct * b.predDensity) - (a.lowPct * a.predDensity));

console.log('=== PER-APP TABLE ===');
console.log('genre | app | installs | overall | n | dateSpan | low_pct | predDensity | predLow | breakdownLow(forcedAds/p2w/energy/gacha)');
for (const r of results) {
  console.log(`${r.genre} | ${r.label} | ${r.installs} | ${r.overallScore} | ${r.total} | ${r.dateSpan} | ${r.lowPct}% | ${r.predDensity}% | ${r.predLow} | ${r.lowCounts.forcedAds}/${r.lowCounts.p2w}/${r.lowCounts.energy}/${r.lowCounts.gacha}`);
}
console.log('');
console.log('=== RANKED BY low_pct * predDensity ===');
for (const r of ranked) {
  console.log(`${(r.lowPct*r.predDensity).toFixed(0)}\t${r.label}\t low=${r.lowPct}%\t predDens=${r.predDensity}%`);
}
console.log('');
console.log('=== TOP QUOTES PER APP (1-2★, sorted by thumbs, predatory-filtered when possible) ===');
for (const r of results) {
  console.log(`\n--- ${r.label} (${r.genre}) ---`);
  for (const q of r.topQuotes) {
    console.log(`  [${q.score}★, 👍${q.thumbs}] ${q.text.slice(0,260)}`);
  }
}

// dump JSON for inspection
fs.writeFileSync(path.join(dir, 'games_focused_summary.json'), JSON.stringify({ results, ranked: ranked.map(r=>({label:r.label, score:r.lowPct*r.predDensity, lowPct:r.lowPct, predDensity:r.predDensity})) }, null, 2));
