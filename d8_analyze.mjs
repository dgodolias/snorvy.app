// D8 ShutEye launch readiness analysis - Tick 15
import fs from 'fs';
import path from 'path';

const BASE = 'C:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings/raw/play-store';
const today = new Date('2026-05-07T00:00:00Z');
const d90 = new Date(today.getTime() - 90 * 86400000);
const y2025 = new Date('2025-01-01T00:00:00Z');

function load(f) {
  return JSON.parse(fs.readFileSync(path.join(BASE, f), 'utf8'));
}

function lowPct(reviews) {
  if (!reviews?.length) return null;
  const low = reviews.filter(r => r.score <= 2).length;
  return { n: reviews.length, low, pct: (low / reviews.length * 100).toFixed(1) };
}

function windowStats(reviews) {
  const all = lowPct(reviews);
  const r2025 = reviews.filter(r => new Date(r.date) >= y2025);
  const r90 = reviews.filter(r => new Date(r.date) >= d90);
  return { all, r2025: lowPct(r2025), r90: lowPct(r90) };
}

// Task 1: ShutEye 1500
console.log('=== TASK 1: ShutEye 1500-review drill ===');
const shut = load('d8_shuteye_us_1500.json');
console.log('Pulled:', shut.total_pulled, 'After filter:', shut.total_after_filter);
const shutStats = windowStats(shut.reviews);
console.log('Full window low_pct:', shutStats.all);
console.log('2025+ low_pct:', shutStats.r2025);
console.log('Last 90d low_pct:', shutStats.r90);

// Top 20 by thumbsUp 1-2 star
const top20 = shut.reviews
  .filter(r => r.score <= 2)
  .sort((a, b) => (b.thumbsUp || 0) - (a.thumbsUp || 0))
  .slice(0, 20);

console.log('\n=== Top 20 highest-thumb 1-2 star ===');
top20.forEach((r, i) => {
  console.log(`#${i + 1} (${r.thumbsUp || 0} thumbs, ${r.score}*, ${r.date.slice(0, 10)}): ${(r.text || '').slice(0, 220).replace(/\n/g, ' ')}`);
});

// Task 2: Competitors
console.log('\n=== TASK 2: Sleep tracker competitive ===');
const comps = [
  ['Sleep Cycle', 'd8_sleepcycle_us_200.json'],
  ['Sleep as Android', 'd8_sleepasandroid_us_200.json'],
  ['Calm', 'd8_calm_us_200.json'],
];
const compResults = [];
for (const [name, file] of comps) {
  const data = load(file);
  const stats = windowStats(data.reviews);
  console.log(`\n${name} (${data.total_after_filter} reviews)`);
  console.log('  Full:', stats.all, '| 2025+:', stats.r2025, '| 90d:', stats.r90);
  // Subscription rage signal
  const subRage = data.reviews.filter(r => r.score <= 2 && /subscript|trial|cancel|charged|refund|free trial|rip ?off|scam/i.test(r.text || '')).length;
  console.log(`  Subscription-rage 1-2★ count: ${subRage}/${data.reviews.length}`);
  compResults.push({ name, full: stats.all, r2025: stats.r2025, r90: stats.r90, subRage });
}

// Task 3: KW scoring
console.log('\n=== TASK 3: ASA Keyword Scoring ===');
const kws = [
  ['honest sleep tracker', 'd8_kw1_honest.json'],
  ['sleep recorder no subscription', 'd8_kw2_norecsub.json'],
  ['ShutEye alternative', 'd8_kw3_shuteyealt.json'],
  ['sleep tracker offline', 'd8_kw4_offline.json'],
  ['snore recorder pay once', 'd8_kw5_snorepayonce.json'],
  ['sleep tracker no trial', 'd8_kw6_notrial.json'],
  ['sleep tracker free no ads', 'd8_kw7_freenoads.json'],
  ['Sleep Cycle alternative', 'd8_kw8_cyclealt.json'],
];

// Composite proxy: Vol = how many results returned AND populated (semantic match);
// Intent = how specific & buyer-intent the phrase is;
// Comp = top result install/score weight
const kwScores = [];
for (const [term, file] of kws) {
  const data = load(file);
  const results = Array.isArray(data) ? data : (data.results || []);
  const n = results.length;
  // Top-3 weighted score = sum of (5-star) * sqrt(installs/100k) — proxy for competition strength
  const top3 = results.slice(0, 3);
  // Whales = known incumbent IDs (high competition signal)
  const whaleIds = new Set([
    'com.northcube.sleepcycle','com.urbandroid.sleep','com.calm.android',
    'health.sleep.sounds.tracker.alarm.calm','com.headspace.android','sleeptrakcer.sleeprecorder.sleepapp.sleep',
    'cz.mobilesoft.appblock','com.droid27.transparentclockweather'
  ]);
  let compStrength = 0;
  for (const r of top3) {
    const sc = r.score || 0;
    const isWhale = whaleIds.has(r.appId) ? 4 : 1;
    compStrength += sc * isWhale;
  }
  const compNorm = Math.max(1, compStrength);
  // Intent score (manual ordering) — how purchase-ready the search phrase is
  const intentMap = {
    'honest sleep tracker': 4,
    'sleep recorder no subscription': 9,
    'ShutEye alternative': 8,
    'sleep tracker offline': 6,
    'snore recorder pay once': 9,
    'sleep tracker no trial': 9,
    'sleep tracker free no ads': 7,
    'Sleep Cycle alternative': 7,
  };
  const intent = intentMap[term] || 5;
  // Volume proxy: number of returned results (higher = more market activity)
  // Normalize to 1-10
  const vol = Math.min(10, n / 3);
  const composite = (vol * intent) / compNorm;
  kwScores.push({ term, n, vol: vol.toFixed(1), intent, comp: compNorm.toFixed(1), composite: composite.toFixed(2) });
  console.log(`KW: "${term}" | n=${n} | vol=${vol.toFixed(1)} | intent=${intent} | comp=${compNorm.toFixed(1)} | composite=${composite.toFixed(2)}`);
}

// Top 5
console.log('\n=== TOP 5 KEYWORDS BY COMPOSITE ===');
kwScores.sort((a, b) => parseFloat(b.composite) - parseFloat(a.composite));
kwScores.slice(0, 5).forEach((k, i) => {
  console.log(`#${i + 1} "${k.term}" — composite ${k.composite} (vol ${k.vol}, intent ${k.intent}, comp ${k.comp}, n=${k.n})`);
});

// Save sleep_competitive.json
fs.writeFileSync(
  path.join(BASE, 'd8_sleep_competitive.json'),
  JSON.stringify({ shuteye: { stats: shutStats, top20_quotes: top20.map(r => ({ thumbs: r.thumbsUp, score: r.score, date: r.date, text: r.text })) }, competitors: compResults, keywords: kwScores }, null, 2)
);
console.log('\nWrote: d8_sleep_competitive.json');
