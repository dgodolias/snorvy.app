#!/usr/bin/env node
// Pull metadata + review-rating histograms for Direction 1 competitor incumbents.
// Bookipi, Zoho Invoice, Square Invoices, Wave (US Play Store).

import fs from 'node:fs/promises';
const gplayMod = await import('file:///C:/Users/demosgod/.claude/skills/google-play-reviews/workspace/node_modules/google-play-scraper/index.js');
const gplay = gplayMod.default;

const TARGETS = [
  { appId: 'bookipi.invoice.maker.estimate.billing', label: 'Bookipi' },
  { appId: 'com.zoho.invoice', label: 'ZohoInvoice' },
  { appId: 'com.squareup.invoicesapp', label: 'SquareInvoices' },
  { appId: 'com.waveapps.invoice', label: 'WaveInvoice' },
  { appId: 'com.aadhk.woinvoice', label: 'InvoiceSimple_baseline' },
];

const out = { meta: {}, reviews_low_sample: {} };

for (const t of TARGETS) {
  process.stderr.write(`[meta] ${t.label} ${t.appId}... `);
  try {
    const m = await gplay.app({ appId: t.appId, country: 'us', lang: 'en' });
    out.meta[t.label] = {
      appId: m.appId,
      title: m.title,
      developer: m.developer,
      installs: m.installs,
      minInstalls: m.minInstalls,
      score: m.score,
      ratings: m.ratings,
      reviews: m.reviews,
      histogram: m.histogram,
      free: m.free,
      price: m.price,
      offersIAP: m.offersIAP,
      IAPRange: m.IAPRange,
      adSupported: m.adSupported,
      released: m.released,
      updated: m.updated ? new Date(m.updated).toISOString() : null,
      genre: m.genre,
      contentRating: m.contentRating,
      summary: m.summary,
    };
    process.stderr.write(`OK\n`);
  } catch (e) {
    process.stderr.write(`ERR ${e.message}\n`);
    out.meta[t.label] = { error: e.message };
  }
  await new Promise(r => setTimeout(r, 800));

  // Pull 60 most-recent low (1-2 star) reviews
  process.stderr.write(`[reviews:low] ${t.label}... `);
  try {
    const r = await gplay.reviews({
      appId: t.appId, country: 'us', lang: 'en',
      sort: gplay.sort.NEWEST, num: 60,
    });
    const lows = (r.data || []).filter(x => x.score <= 2).slice(0, 30).map(x => ({
      score: x.score,
      date: x.date,
      text: (x.text || '').slice(0, 280),
    }));
    out.reviews_low_sample[t.label] = lows;
    process.stderr.write(`${lows.length} low reviews\n`);
  } catch (e) {
    process.stderr.write(`ERR ${e.message}\n`);
    out.reviews_low_sample[t.label] = { error: e.message };
  }
  await new Promise(r => setTimeout(r, 1000));
}

await fs.writeFile(
  'findings/raw/play-store/v9_direction1_competitors.json',
  JSON.stringify(out, null, 2)
);
process.stderr.write('wrote findings/raw/play-store/v9_direction1_competitors.json\n');
