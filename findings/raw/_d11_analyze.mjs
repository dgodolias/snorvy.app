// Analyze D11 review pulls. low_pct = pct of 1-2 star reviews.
import fs from 'node:fs';

const files = [
  ['Clockify', 'findings/raw/play-store/d11_clockify_us_1500.json'],
  ['Toggl', 'findings/raw/play-store/d11_toggl_us_1500.json'],
  ['QB Workforce', 'findings/raw/play-store/d11_qbworkforce_us_1500.json'],
];

const now = new Date('2026-05-07T00:00:00Z');
const since2025 = new Date('2025-01-01T00:00:00Z');
const sinceLast90 = new Date(now.getTime() - 90 * 86400e3);

function pct(low, total) {
  return total === 0 ? 0 : (low / total) * 100;
}

const allLowReviews = [];

for (const [name, path] of files) {
  if (!fs.existsSync(path)) { console.log(`${name}: MISSING`); continue; }
  const j = JSON.parse(fs.readFileSync(path, 'utf8'));
  const reviews = j.reviews || [];
  let totalAll = 0, lowAll = 0;
  let total25 = 0, low25 = 0;
  let total90 = 0, low90 = 0;
  for (const r of reviews) {
    const d = new Date(r.date);
    const isLow = r.score <= 2;
    totalAll++;
    if (isLow) lowAll++;
    if (d >= since2025) {
      total25++;
      if (isLow) low25++;
    }
    if (d >= sinceLast90) {
      total90++;
      if (isLow) low90++;
    }
    if (isLow) allLowReviews.push({ app: name, ...r });
  }
  console.log(`\n=== ${name} (${path.split('/').pop()}) ===`);
  console.log(`  Total reviews:        ${totalAll}`);
  console.log(`  All-time low_pct:     ${pct(lowAll, totalAll).toFixed(1)}% (${lowAll}/${totalAll})`);
  console.log(`  2025+ low_pct:        ${pct(low25, total25).toFixed(1)}% (${low25}/${total25})`);
  console.log(`  Last 90d low_pct:     ${pct(low90, total90).toFixed(1)}% (${low90}/${total90})`);
  if (reviews.length > 0) {
    const dates = reviews.map(r => new Date(r.date)).sort((a, b) => a - b);
    console.log(`  Date range:           ${dates[0].toISOString().slice(0,10)} -> ${dates[dates.length-1].toISOString().slice(0,10)}`);
  }
}

// Top 15 highest-thumb 1-2 star verbatim per app
console.log('\n\n=== TOP 15 HIGHEST-THUMB 1-2 STAR (across all 3 apps) ===');
allLowReviews.sort((a, b) => (b.thumbsUp || 0) - (a.thumbsUp || 0));
const top15 = allLowReviews.slice(0, 15);
for (const r of top15) {
  console.log(`\n[${r.app}] ${r.score}* ${(r.date||'').slice(0,10)} thumbs=${r.thumbsUp||0}`);
  console.log(`   "${(r.text||'').slice(0,300).replace(/\s+/g,' ')}"`);
}

// Also separately: top 5 per app
console.log('\n\n=== TOP 5 HIGHEST-THUMB 1-2 STAR PER APP ===');
for (const [name] of files) {
  const top = allLowReviews.filter(r => r.app === name).slice(0, 5);
  console.log(`\n--- ${name} ---`);
  for (const r of top) {
    console.log(`  ${r.score}* thumbs=${r.thumbsUp||0} ${(r.date||'').slice(0,10)}`);
    console.log(`     "${(r.text||'').slice(0,250).replace(/\s+/g,' ')}"`);
  }
}
