// Niche × Country heatmap scan via Google Trends
// Runs 5-keyword compare per (niche-bucket × country), with 12s delay + 3 retries.
import googleTrends from 'google-trends-api';

const FIVE_YEARS = 5 * 365 * 86400000;
const sleep = ms => new Promise(r => setTimeout(r, ms));

// Niche buckets — 5 each so they fit in compare mode (max 5 keywords)
const buckets = {
  bucket_a: ['manifestation', 'habit tracker', 'period tracker', 'journal', 'meditation'],
  bucket_b: ['couple app', 'aesthetic widget', 'mood tracker', 'workout tracker', 'sleep app'],
  bucket_c: ['astrology', 'tarot', 'numerology', 'horoscope', 'birth chart'],
};

// Local-language buckets per country
const localBuckets = {
  BR: {  // Portuguese
    a_pt: ['manifestacao', 'rastreador de habitos', 'calendario menstrual', 'diario', 'meditacao'],
    b_pt: ['app casal', 'widget aesthetic', 'rastreador humor', 'treino app', 'app sono'],
    c_pt: ['astrologia', 'tarot', 'numerologia', 'horoscopo', 'mapa astral'],
  },
  MX: {  // Spanish
    a_es: ['manifestacion', 'rastreador de habitos', 'calendario menstrual', 'diario', 'meditacion'],
    b_es: ['app pareja', 'widget aesthetic', 'rastreador animo', 'app entrenamiento', 'app sueno'],
    c_es: ['astrologia', 'tarot', 'numerologia', 'horoscopo', 'carta astral'],
  },
  TR: {  // Turkish
    a_tr: ['manifestasyon', 'aliskanlik takip', 'regl takvimi', 'gunluk', 'meditasyon'],
    b_tr: ['cift uygulamasi', 'estetik widget', 'duygu durum', 'antrenman', 'uyku'],
    c_tr: ['astroloji', 'tarot', 'numeroloji', 'burc', 'dogum haritasi'],
  },
  ID: {  // Indonesian
    a_id: ['manifestasi', 'pelacak kebiasaan', 'kalender menstruasi', 'jurnal', 'meditasi'],
    b_id: ['aplikasi pasangan', 'widget estetik', 'pelacak suasana', 'pelacak olahraga', 'aplikasi tidur'],
    c_id: ['astrologi', 'tarot', 'numerologi', 'horoskop', 'peta kelahiran'],
  },
};

async function fetchSummary(keywords, geo, retries = 3) {
  for (let i = 0; i < retries; i++) {
    try {
      const raw = await googleTrends.interestOverTime({
        keyword: keywords, startTime: new Date(Date.now() - FIVE_YEARS), geo,
      });
      const j = JSON.parse(raw);
      const tl = j.default.timelineData;
      if (!tl?.length) return [];
      return keywords.map((kw, idx) => {
        const series = tl.map(p => p.value[idx]);
        const avg = Math.round(series.reduce((a, b) => a + b, 0) / series.length);
        const peak = Math.max(...series);
        const q = Math.floor(series.length / 4);
        const first = series.slice(0, q).reduce((a, b) => a + b, 0) / q;
        const last = series.slice(-q).reduce((a, b) => a + b, 0) / q;
        const change = first === 0 ? null : Math.round(((last - first) / first) * 100);
        return { kw, avg, peak, change, now: series[series.length - 1] };
      });
    } catch (e) {
      if (i < retries - 1) await sleep(15000 + i * 5000);
      else throw e;
    }
  }
}

const COUNTRIES = ['BR', 'MX', 'TR', 'ID'];
const allResults = [];

for (const country of COUNTRIES) {
  process.stderr.write(`\n=== ${country} ===\n`);
  // English universal first
  for (const [name, kws] of Object.entries(buckets)) {
    process.stderr.write(`  ${country}/${name}: `);
    try {
      const res = await fetchSummary(kws, country);
      res.forEach(r => allResults.push({ country, lang: 'en', ...r }));
      process.stderr.write('ok\n');
    } catch (e) {
      process.stderr.write('FAIL ' + e.message?.slice(0, 50) + '\n');
    }
    await sleep(8000);
  }
  // Local language
  const local = localBuckets[country];
  for (const [name, kws] of Object.entries(local)) {
    process.stderr.write(`  ${country}/${name}: `);
    try {
      const res = await fetchSummary(kws, country);
      res.forEach(r => allResults.push({ country, lang: name.split('_')[1], ...r }));
      process.stderr.write('ok\n');
    } catch (e) {
      process.stderr.write('FAIL ' + e.message?.slice(0, 50) + '\n');
    }
    await sleep(8000);
  }
}

// Print final table sorted by current value
allResults.sort((a, b) => b.now - a.now);
console.log(JSON.stringify(allResults, null, 2));
