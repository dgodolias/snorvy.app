#!/usr/bin/env node
import gplay from 'google-play-scraper';
const apps = [
  ['io.earsiv.sysmond', 'tr', 'tr'],
  ['com.earsivfatura.app', 'tr', 'tr'],
  ['com.uyumsoft.ebelge', 'tr', 'tr'],
  ['com.perasis.faturaport', 'tr', 'tr'],
  ['health.sleep.sounds.tracker.alarm.calm', 'us', 'en'],
  ['sleeptrakcer.sleeprecorder.sleepapp.sleep', 'us', 'en'],
  ['com.andrwq.recorder', 'us', 'en'],
];
for (const [appId, country, lang] of apps) {
  try {
    const a = await gplay.app({ appId, country, lang });
    console.log(JSON.stringify({
      appId, title: a.title, installs: a.installs, ratings: a.ratings, score: a.score,
      developer: a.developer, free: a.free, priceText: a.priceText,
      offersIAP: a.offersIAP, IAPRange: a.IAPRange,
    }));
  } catch (e) { console.log(JSON.stringify({ appId, error: e.message })); }
}
