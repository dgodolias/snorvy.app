#!/usr/bin/env node
// Direction 2 competitor description audit — pull full description + meta
// for QBSE, Solopreneur, Keeper, Stride, Hurdlr, Found, FlyFin.
import fs from 'node:fs/promises';
const gplayMod = await import('file:///C:/Users/demosgod/.claude/skills/google-play-reviews/workspace/node_modules/google-play-scraper/index.js');
const gplay = gplayMod.default;

// First-pass appId guesses; unknowns will be resolved via search.
const TARGETS = [
  { label: 'QBSE_legacy',      appId: 'com.intuit.qbse' },
  { label: 'Solopreneur',      appId: 'com.intuit.quickbooks' },
  { label: 'KeeperTax',        appId: 'com.keepertax' },
  { label: 'StrideTax',        search: 'Stride Tax' },
  { label: 'Hurdlr',           search: 'Hurdlr mileage tax' },
  { label: 'Found',            search: 'Found Self-Employed banking' },
  { label: 'FlyFin',           search: 'FlyFin AI Tax' },
];

const out = [];

async function resolveAppId(t) {
  if (t.appId) return t.appId;
  const res = await gplay.search({ term: t.search, country: 'us', lang: 'en', num: 6 });
  // Print top 6 candidates to stderr for debugging
  for (const r of res.slice(0, 6)) {
    process.stderr.write(`  ? ${t.label} candidate: ${r.appId} | ${r.title} | ${r.developer}\n`);
  }
  return res[0]?.appId;
}

for (const t of TARGETS) {
  process.stderr.write(`[d2] ${t.label}... `);
  try {
    const appId = await resolveAppId(t);
    if (!appId) {
      process.stderr.write(`NO APP ID\n`);
      out.push({ label: t.label, error: 'no app id resolved' });
      continue;
    }
    const m = await gplay.app({ appId, country: 'us', lang: 'en' });
    out.push({
      label: t.label,
      appId: m.appId,
      title: m.title,
      summary: m.summary,
      developer: m.developer,
      installs: m.installs,
      minInstalls: m.minInstalls,
      score: m.score,
      ratings: m.ratings,
      reviews: m.reviews,
      free: m.free,
      offersIAP: m.offersIAP,
      IAPRange: m.IAPRange,
      adSupported: m.adSupported,
      released: m.released,
      updated: m.updated ? new Date(m.updated).toISOString() : null,
      genre: m.genre,
      description: m.description,
    });
    process.stderr.write(`OK ${m.appId} (${m.installs})\n`);
  } catch (e) {
    process.stderr.write(`ERR ${e.message}\n`);
    out.push({ label: t.label, error: e.message });
  }
  await new Promise(r => setTimeout(r, 900));
}

await fs.writeFile(
  'findings/raw/play-store/d2_competitor_descriptions.json',
  JSON.stringify(out, null, 2)
);
process.stderr.write('wrote findings/raw/play-store/d2_competitor_descriptions.json\n');
