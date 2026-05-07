#!/usr/bin/env node
// Tick 7 explorer: pull metadata + 200 reviews for candidate apps,
// compute recent low_pct (1-2 star pct in last 90d).
//
// Usage:
//   node _t7_pull.mjs --apps com.x,com.y --country id --lang id --out out.json

import gplay from 'google-play-scraper';
import fs from 'node:fs/promises';

const args = Object.fromEntries(
  process.argv.slice(2).reduce((acc, v, i, a) => {
    if (v.startsWith('--')) acc.push([v.slice(2), a[i + 1] ?? true]);
    return acc;
  }, [])
);

if (!args.apps || !args.out) {
  console.error('Usage: --apps com.x,com.y --country id --lang id --out file.json');
  process.exit(1);
}
const country = (args.country ?? 'us').toLowerCase();
const lang = args.lang ?? 'en';
const apps = args.apps.split(',').map(s => s.trim()).filter(Boolean);

const NOW = Date.now();
const NINETY_D = 90 * 24 * 3600 * 1000;

async function pullReviewsAll(appId, target = 200) {
  const all = [];
  let token = undefined;
  while (all.length < target) {
    try {
      const batch = await gplay.reviews({
        appId, country, lang,
        sort: gplay.sort.NEWEST,
        num: Math.min(150, target - all.length),
        paginate: token ? true : false,
        nextPaginationToken: token,
      });
      if (!batch.data?.length) break;
      all.push(...batch.data);
      token = batch.nextPaginationToken;
      if (!token) break;
      await new Promise(r => setTimeout(r, 600));
    } catch (e) {
      console.error(`reviews err ${appId}: ${e.message}`);
      break;
    }
  }
  return all;
}

const out = [];
for (const appId of apps) {
  let meta = null;
  try {
    meta = await gplay.app({ appId, country, lang });
  } catch (e) {
    console.error(`META err ${appId}: ${e.message}`);
    out.push({ appId, error: e.message });
    continue;
  }
  const reviews = await pullReviewsAll(appId, 200);
  const recent = reviews.filter(r => r.date && (NOW - new Date(r.date).getTime()) <= NINETY_D);
  const low = recent.filter(r => r.score <= 2);
  const lowPct = recent.length ? +(low.length / recent.length * 100).toFixed(1) : 0;

  // pull a few sample low-star verbatims (by recency)
  const sampleLows = low.slice(0, 6).map(r => ({
    date: r.date, score: r.score, text: (r.text ?? '').slice(0, 360),
  }));

  out.push({
    appId,
    title: meta.title,
    developer: meta.developer,
    installs: meta.installs,
    minInstalls: meta.minInstalls,
    score: meta.score,
    ratings: meta.ratings,
    histogram: meta.histogram,
    free: meta.free,
    offersIAP: meta.offersIAP,
    IAPRange: meta.IAPRange,
    adSupported: meta.adSupported,
    released: meta.released,
    updated: meta.updated,
    summary: meta.summary?.slice(0, 240),
    pulled_reviews: reviews.length,
    recent_90d_count: recent.length,
    recent_low_count: low.length,
    recent_low_pct: lowPct,
    sample_low_reviews: sampleLows,
  });
  console.error(`OK ${appId}: ${meta.installs ?? '?'} installs, ${recent.length} recent, low_pct=${lowPct}`);
  await new Promise(r => setTimeout(r, 400));
}

await fs.writeFile(args.out, JSON.stringify(out, null, 2), 'utf8');
console.error(`Wrote ${out.length} apps to ${args.out}`);
