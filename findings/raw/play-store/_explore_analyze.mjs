#!/usr/bin/env node
// Compute low_pct (1-2 star %) for each app's _all.json, plus top 3 verbatim from low reviews.
import fs from 'node:fs';
import path from 'node:path';

const DIR = path.dirname(new URL(import.meta.url).pathname.replace(/^\//, ''));
const apps = [
  // TR invoice/e-SMM/e-Fatura
  ['TR', 'sysmond (e-Arşiv Fatura)', 'explore_tr_sysmond_all.json'],
  ['TR', 'mikrogrup (e-Arşiv Portal)', 'explore_tr_mikrogrup_all.json'],
  ['TR', 'uyumsoft (e-Belge)', 'explore_tr_uyumsoft_all.json'],
  // Voice recorders
  ['US', 'quality apps Voice Recorder', 'explore_voice_quality_all.json'],
  ['US', 'Easy Voice Recorder (Digipom)', 'explore_voice_easy_all.json'],
  ['US', 'Smart Voice Recorder (SmartMob)', 'explore_voice_smart_all.json'],
  // Sleep/alarm
  ['US', 'Yawn Sleep Tracker (Leap)', 'explore_sleep_yawn_all.json'],
  ['US', 'ShutEye Sleep Tracker', 'explore_sleep_shuteye_all.json'],
  ['US', 'Alarmy', 'explore_sleep_alarmy_all.json'],
];

function recentLowPct(reviews) {
  if (!reviews || reviews.length === 0) return { total: 0, low: 0, pct: 0, recentISO: null };
  // recent = last 90 days from newest review date
  const sorted = [...reviews].sort((a, b) => new Date(b.date) - new Date(a.date));
  const newestDate = new Date(sorted[0].date);
  const cutoff = new Date(newestDate.getTime() - 90 * 24 * 3600 * 1000);
  const recent = sorted.filter(r => new Date(r.date) >= cutoff);
  const low = recent.filter(r => r.score <= 2).length;
  return {
    total: recent.length,
    low,
    pct: recent.length ? (low / recent.length * 100).toFixed(1) : 0,
    newestDate: newestDate.toISOString().slice(0, 10),
    cutoffDate: cutoff.toISOString().slice(0, 10),
    overall_low_pct: (reviews.filter(r => r.score <= 2).length / reviews.length * 100).toFixed(1),
  };
}

function topVerbatim(reviews, n = 3) {
  return reviews
    .filter(r => r.score <= 2 && r.text && r.text.length > 30)
    .sort((a, b) => (b.thumbsUp || 0) - (a.thumbsUp || 0))
    .slice(0, n)
    .map(r => ({
      score: r.score,
      date: r.date.slice(0, 10),
      thumbs: r.thumbsUp,
      text: r.text.slice(0, 280),
    }));
}

const out = [];
for (const [country, label, file] of apps) {
  const fp = path.join(DIR, file);
  if (!fs.existsSync(fp)) { out.push({ country, label, error: 'missing file' }); continue; }
  const data = JSON.parse(fs.readFileSync(fp, 'utf8'));
  const reviews = data.reviews || [];
  const stats = recentLowPct(reviews);
  const verbatim = topVerbatim(reviews, 3);
  out.push({ country, label, stats, verbatim });
}

console.log(JSON.stringify(out, null, 2));
