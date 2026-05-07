#!/usr/bin/env node
// D8 name availability — Play Store search collisions
import fs from 'node:fs/promises';
const gplayMod = await import('file:///C:/Users/demosgod/.claude/skills/google-play-reviews/workspace/node_modules/google-play-scraper/index.js');
const gplay = gplayMod.default;

const NAMES = [
  'Snorta','Sleeptape','Nightlog','Murmur','Hush','Polysom',
  'Drowzy','Bedtape','Snorely','Dorma','Snorvey','Lullen'
];

const SLEEP_KEYWORDS = ['sleep','snore','snoring','snor','dream','rest','nap','bed','night','insomnia','lullaby','relax','meditation','white noise','calm','breath','audio','recorder','record'];

const out = {};

for (const name of NAMES) {
  try {
    const res = await gplay.search({ term: name, country: 'us', lang: 'en', num: 10 });
    // exact-name match (case-insensitive title startswith or equals)
    const exact = res.filter(r => r.title.toLowerCase() === name.toLowerCase() || r.title.toLowerCase().startsWith(name.toLowerCase() + ' ') || r.title.toLowerCase().startsWith(name.toLowerCase() + ':') || r.title.toLowerCase().startsWith(name.toLowerCase() + '-'));
    // sleep-positioned (title or summary contains a sleep keyword)
    const sleepPositioned = res.filter(r => {
      const blob = ((r.title||'') + ' ' + (r.summary||'')).toLowerCase();
      return SLEEP_KEYWORDS.some(k => blob.includes(k));
    });
    out[name] = {
      total: res.length,
      exact_name_matches: exact.map(r => ({ title: r.title, appId: r.appId, dev: r.developer, score: r.score, installs: r.installs })),
      sleep_positioned: sleepPositioned.slice(0,5).map(r => ({ title: r.title, appId: r.appId, dev: r.developer })),
      top3: res.slice(0,3).map(r => ({ title: r.title, appId: r.appId, dev: r.developer }))
    };
    process.stderr.write(`OK ${name}: total=${res.length} exact=${exact.length} sleep=${sleepPositioned.length}\n`);
  } catch (e) {
    out[name] = { error: String(e) };
    process.stderr.write(`ERR ${name}: ${e.message}\n`);
  }
}

await fs.writeFile('findings/raw/d8_name_playstore_raw.json', JSON.stringify(out, null, 2));
console.log('done');
