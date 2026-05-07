#!/usr/bin/env node
// Pull iOS reviews for Invoice Simple (id 694831622) across 7 countries.
// Saves one JSON per country with full reviews list.

import { createRequire } from 'node:module';
import fs from 'node:fs/promises';
import path from 'node:path';

const require = createRequire('C:/Users/demosgod/.claude/skills/google-play-reviews/workspace/');
const store = require('app-store-scraper');

const APP_ID = 694831622;
const COUNTRIES = ['us', 'gb', 'ca', 'au', 'de', 'fr', 'jp'];
const OUT_DIR = 'C:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings/raw/play-store';
const TARGET = 500;

async function fetchAll(country) {
  const all = [];
  for (let page = 1; page <= 10; page++) {
    try {
      const batch = await store.reviews({
        id: APP_ID,
        country,
        sort: store.sort.RECENT,
        page,
      });
      if (!batch || !batch.length) break;
      all.push(...batch);
      if (all.length >= TARGET) break;
      await new Promise(r => setTimeout(r, 800));
    } catch (e) {
      process.stderr.write(`[${country}] page ${page} failed: ${e.message}\n`);
      break;
    }
  }
  return all;
}

for (const cc of COUNTRIES) {
  process.stderr.write(`Fetching iOS ${cc.toUpperCase()}... `);
  const reviews = await fetchAll(cc);
  const slim = reviews.map(r => ({
    id: r.id,
    date: r.updated || r.date || null,
    score: r.score,
    title: r.title,
    text: r.text,
    user: r.userName,
    version: r.version,
    url: r.url,
  }));
  const total = slim.length;
  const lows = slim.filter(r => r.score <= 2).length;
  const lowPct = total ? (lows / total * 100).toFixed(1) : '0.0';
  const out = {
    appId: APP_ID,
    country: cc,
    total_pulled: total,
    low_count: lows,
    low_pct: parseFloat(lowPct),
    reviews: slim,
  };
  const file = path.join(OUT_DIR, `invoice_simple_ios_${cc}.json`);
  await fs.writeFile(file, JSON.stringify(out, null, 2), 'utf8');
  process.stderr.write(`${total} reviews, ${lows} low (${lowPct}%) -> ${file}\n`);
}
