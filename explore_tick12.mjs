#!/usr/bin/env node
// Tick 12: Kids learn / Budget / Period tracker exploration
import gplay from 'google-play-scraper';
import fs from 'node:fs/promises';

const candidates = {
  kids: [
    { appId: 'com.aofl.abcmouse', name: 'ABCmouse' },
    { appId: 'com.logicappkids', name: 'LogicLike ABC&Math' },
    { appId: 'com.paperboatapps.google.kiddopia', name: 'Kiddopia' },
    { appId: 'com.splash.kids.education.learning.games.free.multiplication.reading.math.grade.app.splashmath', name: 'SplashLearn' },
  ],
  budget: [
    { appId: 'com.droid4you.application.wallet', name: 'Wallet (BudgetBakers)' },
    { appId: 'com.everydollar.android', name: 'EveryDollar (Ramsey)' },
    { appId: 'com.dayspringtech.envelopes', name: 'Goodbudget' },
    { appId: 'com.realbyteapps.moneymanagerfree', name: 'Money Manager (Realbyte)' },
  ],
  period: [
    { appId: 'com.popularapp.periodcalendar', name: 'Period Calendar (Simple Design)' },
    { appId: 'com.stardust.app', name: 'Stardust' },
    { appId: 'com.drip', name: 'drip period & cycle tracker' },
    { appId: 'periodtracker.pregnancy.ovulationtracker', name: 'Ovulation Tracker (Leap Fitness)' },
  ],
};

const NOW = Date.now();
const NINETY_DAYS = 90 * 24 * 3600 * 1000;

async function pullApp(appId) {
  const a = await gplay.app({ appId, country: 'us', lang: 'en' });
  return {
    appId: a.appId, title: a.title, developer: a.developer,
    score: a.score, ratings: a.ratings, reviews: a.reviews,
    installs: a.installs, minInstalls: a.minInstalls,
    histogram: a.histogram, genre: a.genre,
    free: a.free, price: a.price, priceText: a.priceText,
    offersIAP: a.offersIAP, IAPRange: a.IAPRange,
    updated: a.updated, version: a.version,
    contentRating: a.contentRating,
  };
}

async function pullReviews(appId, target = 200) {
  const out = [];
  let token = undefined;
  while (out.length < target) {
    const batch = await gplay.reviews({
      appId, country: 'us', lang: 'en',
      sort: gplay.sort.NEWEST,
      num: Math.min(150, target - out.length),
      paginate: token ? true : false,
      nextPaginationToken: token,
    });
    if (!batch.data?.length) break;
    out.push(...batch.data);
    token = batch.nextPaginationToken;
    if (!token) break;
    await new Promise(r => setTimeout(r, 600));
  }
  return out.slice(0, target);
}

function analyze(reviews) {
  const recent = reviews.filter(r => (NOW - new Date(r.date).getTime()) <= NINETY_DAYS);
  const recentLow = recent.filter(r => r.score <= 3);
  const allLow = reviews.filter(r => r.score <= 3);
  return {
    n_reviews: reviews.length,
    n_recent_90d: recent.length,
    n_recent_low: recentLow.length,
    recent_low_pct: recent.length ? (recentLow.length / recent.length * 100).toFixed(1) : '0',
    n_all_low: allLow.length,
    all_low_pct: reviews.length ? (allLow.length / reviews.length * 100).toFixed(1) : '0',
    sample_low_verbatim: recentLow.slice(0, 5).map(r => ({
      date: r.date, score: r.score, text: r.text?.slice(0, 300),
    })),
  };
}

const result = {};
for (const [niche, list] of Object.entries(candidates)) {
  result[niche] = [];
  for (const c of list) {
    process.stderr.write(`[${niche}] ${c.appId}... `);
    try {
      const meta = await pullApp(c.appId);
      const reviews = await pullReviews(c.appId, 200);
      const an = analyze(reviews);
      result[niche].push({ name: c.name, meta, analysis: an });
      process.stderr.write(`OK (${reviews.length} reviews, ${an.recent_low_pct}% recent low)\n`);
    } catch (e) {
      process.stderr.write(`ERROR: ${e.message}\n`);
      result[niche].push({ name: c.name, error: e.message });
    }
    await new Promise(r => setTimeout(r, 400));
  }
}

await fs.mkdir('findings/raw/play-store', { recursive: true });
await fs.writeFile(
  'findings/raw/play-store/explore_kids_budget_period.json',
  JSON.stringify(result, null, 2),
  'utf8'
);
console.error(`Saved to findings/raw/play-store/explore_kids_budget_period.json`);
