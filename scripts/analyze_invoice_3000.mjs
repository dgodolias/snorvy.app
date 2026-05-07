#!/usr/bin/env node
// Analyze the 3000-review Invoice Simple Android pulls (US, GB).
// - Compute low_pct on the 3000-review window.
// - Surface top 30 highest-thumb 1-2★ reviews per country.
// - Theme cluster top complaints with multilingual keyword bank.

import fs from 'node:fs/promises';

const THEMES = {
  pricing_rage: [
    'price hike', 'raised', 'increased', 'doubled', 'tripled', 'expensive',
    'too much', 'subscription', 'subscribe', 'paywall', 'pay wall', 'pay per',
    'free trial', 'cancel', 'refund', 'money grab', 'rip off', 'ripoff',
    'used to be free', 'now charging', 'теперь дороже', 'fiyat', 'pahalı',
    'preço', 'caro', 'preis', 'teuer', 'tarif', 'cher', '値上げ', '高い',
  ],
  export_lockin: [
    'export', 'lock', 'cannot save', "can't save", 'cant save', 'pdf',
    'limit', 'limited', 'paywall pdf', 'exporter', 'speichern', 'sauvegarder',
    '保存', 'lock in', 'hostage', 'trapped',
  ],
  bugs_crashes: [
    'crash', 'crashes', 'freeze', 'frozen', 'broken', "doesn't work",
    'does not work', 'glitch', 'bug', "won't open", 'wont open', 'lag',
    'slow', 'force close', 'abstürzen', 'absturz', 'plante', 'plantage',
    '落ちる', 'バグ', 'unusable',
  ],
  support_ghost: [
    'support', 'no response', 'no reply', 'unanswered', 'customer service',
    'help center', 'service', 'kundeservice', 'assistance', 'サポート',
    'no help', 'ignored', 'ghosted', 'never respond',
  ],
  ai_autocategorize: [
    'ai', 'auto-categorize', 'auto categorize', 'autocategoriz', 'machine learning',
    'wrong category', 'miscategoriz', 'auto-fill', 'autofill wrong',
  ],
  data_loss: [
    'lost data', 'lost all', 'lost my', 'gone', 'disappeared', 'wiped',
    'deleted', 'daten verloren', 'données perdues', 'データ', '消えた',
    'lost invoices', 'lost clients',
  ],
  features_missing: [
    'feature', 'missing', 'wish', 'should have', 'would be nice', 'add',
    'no option', 'no way to', 'lack of', 'limited to',
  ],
  ads_intrusive: [
    'ads', 'advertisement', 'pop up', 'popup', 'intrusive',
  ],
};

function classify(text) {
  if (!text) return [];
  const t = text.toLowerCase();
  const hits = [];
  for (const [theme, kws] of Object.entries(THEMES)) {
    if (kws.some(k => t.includes(k))) hits.push(theme);
  }
  return hits;
}

async function analyzeCountry(file, label) {
  const raw = JSON.parse(await fs.readFile(file, 'utf8'));
  const all = raw.reviews || [];
  const total = all.length;
  const lows = all.filter(r => r.score <= 2);
  const lowPct = total ? (lows.length / total * 100).toFixed(2) : '0';

  // Theme freq across LOW reviews only.
  const themeCounts = {};
  for (const r of lows) {
    for (const th of classify(r.text)) {
      themeCounts[th] = (themeCounts[th] || 0) + 1;
    }
  }

  // Top 30 1-2★ by thumbsUp.
  const top30 = [...lows].sort((a, b) => (b.thumbsUp || 0) - (a.thumbsUp || 0)).slice(0, 30);

  return {
    label, file, total,
    low_count: lows.length, low_pct: parseFloat(lowPct),
    theme_counts: themeCounts,
    top_thumb_reviews: top30.map(r => ({
      date: (r.date || '').slice(0, 10),
      score: r.score,
      thumbsUp: r.thumbsUp,
      user: r.user,
      text: r.text,
    })),
    date_range: {
      earliest: all.length ? all[all.length - 1].date?.slice(0, 10) : null,
      latest: all.length ? all[0].date?.slice(0, 10) : null,
    },
  };
}

const us = await analyzeCountry(
  'C:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings/raw/play-store/invoice_simple_us_3000.json',
  'US',
);
const gb = await analyzeCountry(
  'C:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings/raw/play-store/invoice_simple_gb_3000.json',
  'GB',
);

const out = { generated: new Date().toISOString(), us, gb };
await fs.writeFile(
  'C:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings/raw/play-store/invoice_simple_3000_analysis.json',
  JSON.stringify(out, null, 2),
  'utf8',
);

// Console report.
for (const c of [us, gb]) {
  console.log(`\n=== ${c.label} ===`);
  console.log(`Total: ${c.total} | Low (1-2*): ${c.low_count} (${c.low_pct}%)`);
  console.log(`Date range: ${c.date_range.earliest} -> ${c.date_range.latest}`);
  console.log('\nTheme frequency among LOW reviews:');
  Object.entries(c.theme_counts).sort((a, b) => b[1] - a[1])
    .forEach(([t, n]) => console.log(`  ${t}: ${n}`));
  console.log('\nTop 10 highest-thumb low reviews:');
  c.top_thumb_reviews.slice(0, 10).forEach(r => {
    const txt = (r.text || '').replace(/\s+/g, ' ').slice(0, 200);
    console.log(`  [${r.score}* | thumbs ${r.thumbsUp} | ${r.date}] ${r.user}: ${txt}`);
  });
}
