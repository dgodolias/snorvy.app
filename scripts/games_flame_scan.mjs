#!/usr/bin/env node
// Scans 7 game genres × top apps for Flutter Flame opportunity research.
// Pulls metadata + 500 newest reviews per app, computes recent low_pct,
// extracts top 1-2★ reviews by thumbs, and writes one JSON per genre.

import gplay from 'google-play-scraper';
import fs from 'node:fs/promises';
import path from 'node:path';

const OUT_DIR = 'C:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings/raw/play-store';

const GENRES = {
  endless_runner: [
    'com.kiloo.subwaysurf',
    'com.imangi.templerun2',
    'com.sega.sonicdash',
    'com.imangi.templerun',
    'com.djinnworks.StickmanSkate',
  ],
  idle_clicker: [
    'com.kongregate.mobile.adventurecapitalist.google',
    'com.dashnet.cookieclicker',
    'com.ucool.idleheroes',
    'com.auxbrain.egginc',
    'com.fluffyfairygames.idleminertycoon',
  ],
  match3_puzzle: [
    'com.king.candycrushsaga',
    'com.dream.games.royalmatch',
    'com.peakgames.toonblast',
    'com.playgendary.homescapes',
    'com.king.candycrushsodasaga',
  ],
  tower_defense: [
    'com.ninjakiwi.bloonstd6',
    'com.ea.game.pvz2_row',
    'com.ironhidegames.android.kingdomrush',
    'com.ironhidegames.android.kingdomrushvengeance',
    'com.realtech.RDefenseLegends',
  ],
  hyper_casual: [
    'com.ketchapp.stack',
    'com.aa.heliball',
    'com.aa.gen5',
    'com.kayac.helixjumpZ',
    'com.fungames.flightpilot',
  ],
  roguelite_survivor: [
    'com.dxx.firenow',         // Survivor.io
    'com.habby.archero',
    'com.ChillyRoom.SoulKnight',
    'com.dxx.archerocallback',
    'com.tap4fun.spartanwar',
  ],
  snake_arcade: [
    'air.com.hypah.io.slither',
    'com.amelosinteractive.snake',
    'com.snake2',
    'com.feelingtouch.snake.io',
    'com.outfit7.talkingtomgoldrun',
  ],
};

async function safe(fn, fallback = null) {
  try { return await fn(); } catch (e) { return { __error: e.message, fallback }; }
}

function ageDays(ts) {
  return (Date.now() - new Date(ts).getTime()) / 86400000;
}

async function pullApp(appId) {
  const a = await safe(() => gplay.app({ appId, country: 'us', lang: 'en' }));
  if (a?.__error) return { appId, error: a.__error };
  return {
    appId: a.appId, title: a.title, developer: a.developer, genre: a.genre,
    installs: a.installs, minInstalls: a.minInstalls,
    score: a.score, ratings: a.ratings, reviews: a.reviews, histogram: a.histogram,
    free: a.free, price: a.price, offersIAP: a.offersIAP, IAPRange: a.IAPRange,
    adSupported: a.adSupported, updated: a.updated, version: a.version,
    summary: a.summary,
  };
}

async function pullReviews(appId, target = 500) {
  const reviews = [];
  let token = undefined;
  let pages = 0;
  while (reviews.length < target && pages < 8) {
    const batch = await safe(() => gplay.reviews({
      appId, country: 'us', lang: 'en',
      sort: gplay.sort.NEWEST,
      num: Math.min(150, target - reviews.length),
      paginate: token ? true : false,
      nextPaginationToken: token,
    }));
    if (batch?.__error || !batch?.data?.length) break;
    reviews.push(...batch.data);
    token = batch.nextPaginationToken;
    pages++;
    if (!token) break;
    await new Promise(r => setTimeout(r, 400));
  }
  return reviews.map(r => ({
    date: r.date, score: r.score, thumbsUp: r.thumbsUp,
    user: r.userName, text: r.text,
  }));
}

function computeLowPct(reviews) {
  // Among reviews <= 90 days old, fraction with score <= 2
  const recent = reviews.filter(r => ageDays(r.date) <= 90);
  if (recent.length === 0) return { low_pct: null, recent_n: 0 };
  const low = recent.filter(r => r.score <= 2).length;
  return { low_pct: +(low / recent.length * 100).toFixed(1), recent_n: recent.length };
}

function topLowQuotes(reviews, n = 10) {
  return reviews
    .filter(r => r.score <= 2 && r.text && r.text.length > 30)
    .sort((a, b) => (b.thumbsUp ?? 0) - (a.thumbsUp ?? 0))
    .slice(0, n)
    .map(r => ({
      score: r.score, thumbsUp: r.thumbsUp,
      date: new Date(r.date).toISOString().slice(0, 10),
      text: r.text.slice(0, 400),
    }));
}

const THEMES = {
  ads_intrusive: /(\bads?\b|video ad|advert|commercial|every (move|round|level) ad|forced ad|pra continuar|anuncio|reklam|werbung|publicidad)/i,
  paywall: /(pay to play|p2w|paywall|have to pay|money grab|paywalled|pay-?wall)/i,
  iap_predatory: /(gacha|lootbox|loot ?box|\$\d{2,}|expensive|rip ?off|overpriced|whale|pay to win)/i,
  ads_for_basic_features: /(watch (an? )?ad to (continue|revive|skip|unlock)|ad to (continue|revive|skip|unlock)|forced.{0,10}ad)/i,
  energy_gating: /(wait \d+ (hour|hr|min)|energy system|out of (lives|moves|hearts|energy)|run out of moves|lives system)/i,
  bait_and_switch: /(was free|got worse|added ads|update ruined|used to be|nerf|nerfed|since the (update|new))/i,
  broken_progress: /(lost (progress|data|account)|save (broken|gone|lost)|wiped|reset my)/i,
  cheaters_unfair: /(cheater|hacker|bots|unfair|rigged|scripted)/i,
  matchmaking_broken: /(matchmaking|too hard|impossible|wall|level wall)/i,
};

function themeFreq(reviews) {
  const recent = reviews.filter(r => ageDays(r.date) <= 90 && r.score <= 2);
  const counts = Object.fromEntries(Object.keys(THEMES).map(k => [k, 0]));
  for (const r of recent) {
    const t = r.text ?? '';
    for (const [theme, re] of Object.entries(THEMES)) {
      if (re.test(t)) counts[theme]++;
    }
  }
  const total = recent.length || 1;
  const pct = Object.fromEntries(
    Object.entries(counts).map(([k, v]) => [k, +(v / total * 100).toFixed(1)])
  );
  return { recent_low_n: recent.length, counts, pct };
}

async function main() {
  await fs.mkdir(OUT_DIR, { recursive: true });
  const summary = {};

  for (const [genre, ids] of Object.entries(GENRES)) {
    process.stderr.write(`\n=== ${genre} ===\n`);
    const apps = [];
    for (const appId of ids) {
      process.stderr.write(`  ${appId} ... `);
      const meta = await pullApp(appId);
      if (meta.error) {
        process.stderr.write(`META ERR: ${meta.error}\n`);
        apps.push({ appId, error: meta.error });
        continue;
      }
      const reviews = await pullReviews(appId, 500);
      const lp = computeLowPct(reviews);
      const quotes = topLowQuotes(reviews, 10);
      const themes = themeFreq(reviews);
      process.stderr.write(`${reviews.length} reviews, low_pct=${lp.low_pct}\n`);
      apps.push({ ...meta, ...lp, total_reviews_pulled: reviews.length, top_low_quotes: quotes, themes });
    }
    const out = { genre, scanned_at: new Date().toISOString(), apps };
    const fp = path.join(OUT_DIR, `games_genre_${genre}.json`);
    await fs.writeFile(fp, JSON.stringify(out, null, 2), 'utf8');
    process.stderr.write(`Wrote ${fp}\n`);
    summary[genre] = apps.map(a => ({
      appId: a.appId, title: a.title, installs: a.installs,
      score: a.score, low_pct: a.low_pct, recent_n: a.recent_n,
      themes_pct: a.themes?.pct,
    }));
  }
  await fs.writeFile(path.join(OUT_DIR, 'games_flame_scan_index.json'),
    JSON.stringify(summary, null, 2), 'utf8');
  process.stderr.write('\nDONE\n');
}

main().catch(e => { console.error(e); process.exit(1); });
