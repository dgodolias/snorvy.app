#!/usr/bin/env node
// Compute recent low_pct (≤2★ over last 90 days) and a verbatim quote per app.
import fs from 'node:fs';
import path from 'node:path';

const DIR = 'c:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings/raw/play-store/tick11';
const NOW = new Date('2026-05-07');
const CUTOFF = new Date(NOW.getTime() - 90 * 24 * 60 * 60 * 1000);

const files = fs.readdirSync(DIR).filter(f => f.endsWith('_reviews.json'));
const out = [];

for (const f of files) {
  const path_ = path.join(DIR, f);
  const data = JSON.parse(fs.readFileSync(path_, 'utf8'));
  const reviews = data.reviews ?? [];
  const recent = reviews.filter(r => new Date(r.date) >= CUTOFF);
  const recentLow = recent.filter(r => r.score <= 2);
  const recentLowPct = recent.length ? (recentLow.length / recent.length * 100).toFixed(1) : 'n/a';
  // pick top thumbs-up low review (most resonant)
  const verbatim = [...recentLow].sort((a, b) => (b.thumbsUp ?? 0) - (a.thumbsUp ?? 0))[0]
    || [...reviews].filter(r => r.score <= 2).sort((a, b) => (b.thumbsUp ?? 0) - (a.thumbsUp ?? 0))[0];
  out.push({
    app: f.replace('_reviews.json', ''),
    appId: data.app,
    total: reviews.length,
    recent_n: recent.length,
    recent_low_n: recentLow.length,
    recent_low_pct: recentLowPct,
    verbatim_score: verbatim?.score ?? null,
    verbatim_date: verbatim?.date ?? null,
    verbatim_thumbs: verbatim?.thumbsUp ?? null,
    verbatim: verbatim?.text?.slice(0, 400) ?? null,
  });
}

out.sort((a, b) => parseFloat(b.recent_low_pct || '0') - parseFloat(a.recent_low_pct || '0'));
console.log(JSON.stringify(out, null, 2));
