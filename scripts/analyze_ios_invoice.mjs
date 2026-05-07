#!/usr/bin/env node
// Analyze iOS Invoice Simple drill across 7 countries.
// Outputs: per-country low_pct + top-10 1-2★ verbatim.
// (App Store does not expose helpful-vote count via the legacy review feed,
//  so we sort 1-2★ by date desc — most-recent low reviews surface first.)

import fs from 'node:fs/promises';
import path from 'node:path';

const COUNTRIES = ['us', 'gb', 'ca', 'au', 'de', 'fr', 'jp'];
const DIR = 'C:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings/raw/play-store';

const out = { generated: new Date().toISOString(), countries: {} };
for (const cc of COUNTRIES) {
  const file = path.join(DIR, `invoice_simple_ios_${cc}.json`);
  const raw = JSON.parse(await fs.readFile(file, 'utf8'));
  const all = raw.reviews || [];
  const lows = all.filter(r => r.score <= 2);
  const top10 = [...lows].slice(0, 10).map(r => ({
    score: r.score, title: r.title, text: r.text, user: r.user, version: r.version,
  }));
  out.countries[cc] = {
    total: all.length,
    low_count: lows.length,
    low_pct: raw.low_pct,
    top10_lows: top10,
  };
}

await fs.writeFile(
  path.join(DIR, 'invoice_simple_ios_analysis.json'),
  JSON.stringify(out, null, 2),
  'utf8',
);

console.log('iOS low_pct per country (Invoice Simple):');
for (const [cc, c] of Object.entries(out.countries)) {
  console.log(`  ${cc.toUpperCase()}: ${c.low_count}/${c.total} = ${c.low_pct}%`);
}
console.log('\nUS top-5 iOS lows (verbatim):');
out.countries.us.top10_lows.slice(0, 5).forEach((r, i) => {
  const t = (r.text || '').replace(/\s+/g, ' ').slice(0, 200);
  console.log(`  ${i + 1}. [${r.score}* | ${r.user}] "${r.title}" — ${t}`);
});
