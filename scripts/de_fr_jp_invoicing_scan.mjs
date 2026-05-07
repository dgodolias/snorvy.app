#!/usr/bin/env node
// Scan DE/FR/JP Play Store for localized invoicing apps, then drill metadata
// + 300 recent low reviews per top-3 incumbent.
//
// Usage: node scripts/de_fr_jp_invoicing_scan.mjs

import fs from 'node:fs/promises';
// Dynamically import the ESM-only google-play-scraper from the workspace's node_modules.
const gplayMod = await import('file:///C:/Users/demosgod/.claude/skills/google-play-reviews/workspace/node_modules/google-play-scraper/index.js');
const gplay = gplayMod.default;

const QUERIES = {
  de: [
    { term: 'Rechnung App', lang: 'de' },
    { term: 'Rechnungsstellung', lang: 'de' },
  ],
  fr: [
    { term: 'facture freelance', lang: 'fr' },
    { term: 'facturation auto-entrepreneur', lang: 'fr' },
  ],
  jp: [
    { term: '請求書 アプリ', lang: 'ja' },
    { term: '個人事業主 請求書', lang: 'ja' },
  ],
};

const result = { searches: {}, top_incumbents: {} };

// Step 1 — search & collect candidates per country.
for (const [cc, qs] of Object.entries(QUERIES)) {
  result.searches[cc] = [];
  const seen = new Map(); // appId -> meta
  for (const q of qs) {
    process.stderr.write(`[${cc}] search "${q.term}"... `);
    try {
      const hits = await gplay.search({
        term: q.term, country: cc, lang: q.lang, num: 20, throttle: 5,
      });
      process.stderr.write(`${hits.length} hits\n`);
      for (const h of hits) {
        if (!seen.has(h.appId)) {
          seen.set(h.appId, {
            appId: h.appId, title: h.title, developer: h.developer,
            score: h.score, free: h.free, url: h.url,
            from_query: q.term,
          });
        }
      }
    } catch (e) {
      process.stderr.write(`ERR ${e.message}\n`);
    }
    await new Promise(r => setTimeout(r, 1200));
  }
  // Filter generic non-invoicing matches by keyword in title.
  const KW = /(invoice|invoicing|rechnung|facture|請求|estimate|billing|quote|abrechnung)/i;
  const candidates = [...seen.values()].filter(c => KW.test(c.title));
  result.searches[cc] = candidates;
}

// Step 2 — for each country, fetch metadata for all candidates, pick top-3 by minInstalls (or ratings count proxy).
async function pickTop3(cc, candidates, lang) {
  const enriched = [];
  for (const c of candidates) {
    try {
      const a = await gplay.app({ appId: c.appId, country: cc, lang });
      enriched.push({
        appId: a.appId, title: a.title, developer: a.developer,
        score: a.score, ratings: a.ratings, reviews: a.reviews,
        installs: a.installs, minInstalls: a.minInstalls, maxInstalls: a.maxInstalls,
        histogram: a.histogram, free: a.free, IAPRange: a.IAPRange,
        updated: a.updated, version: a.version,
      });
      await new Promise(r => setTimeout(r, 700));
    } catch (e) {
      process.stderr.write(`[${cc}] meta ${c.appId}: ${e.message}\n`);
    }
  }
  enriched.sort((a, b) => (b.minInstalls || 0) - (a.minInstalls || 0));
  return enriched.slice(0, 3);
}

const langMap = { de: 'de', fr: 'fr', jp: 'ja' };

for (const cc of Object.keys(QUERIES)) {
  process.stderr.write(`\n[${cc}] enriching ${result.searches[cc].length} candidates...\n`);
  const top3 = await pickTop3(cc, result.searches[cc], langMap[cc]);
  result.top_incumbents[cc] = [];
  for (const inc of top3) {
    process.stderr.write(`[${cc}] reviews ${inc.appId} (${inc.title.slice(0, 30)})...\n`);
    let reviews = [];
    let token;
    while (reviews.length < 300) {
      try {
        const batch = await gplay.reviews({
          appId: inc.appId, country: cc, lang: langMap[cc],
          sort: gplay.sort.NEWEST, num: Math.min(150, 300 - reviews.length),
          paginate: !!token, nextPaginationToken: token,
        });
        if (!batch.data?.length) break;
        reviews.push(...batch.data);
        token = batch.nextPaginationToken;
        if (!token) break;
        await new Promise(r => setTimeout(r, 800));
      } catch (e) {
        process.stderr.write(`  review fetch err: ${e.message}\n`);
        break;
      }
    }
    const lows = reviews.filter(r => r.score <= 2);
    const lowPct = reviews.length ? (lows.length / reviews.length * 100).toFixed(1) : '0';
    const slim = reviews.map(r => ({
      date: r.date, score: r.score, thumbsUp: r.thumbsUp,
      user: r.userName, text: r.text,
    }));
    result.top_incumbents[cc].push({
      ...inc,
      total_reviews_pulled: reviews.length,
      low_count: lows.length,
      low_pct: parseFloat(lowPct),
      sample_reviews: slim,
    });
  }
}

await fs.writeFile(
  'C:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings/raw/play-store/de_fr_jp_invoicing_scan.json',
  JSON.stringify(result, null, 2),
  'utf8',
);
process.stderr.write('\nDone -> findings/raw/play-store/de_fr_jp_invoicing_scan.json\n');
