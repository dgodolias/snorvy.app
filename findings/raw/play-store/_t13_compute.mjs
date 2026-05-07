import { readFileSync, writeFileSync } from 'fs';

const apps = [
  { id: 'northpark_drinkwater', niche: 'water', name: 'Water Drink Reminder (Leap)' },
  { id: 'plantnanny', niche: 'water', name: 'Plant Nanny (SPARKFUL)' },
  { id: 'ascendik', niche: 'water', name: 'Drink Water Reminder (Better Life)' },
  { id: 'vgfit', niche: 'water', name: 'Water Reminder Daily (VGFIT)' },
  { id: 'bookmory', niche: 'book', name: 'Bookmory' },
  { id: 'bookly', niche: 'book', name: 'Bookly' },
  { id: 'storygraph', niche: 'book', name: 'StoryGraph' },
  { id: 'fable', niche: 'book', name: 'Fable (Scribd)' },
  { id: 'dogcat', niche: 'pet', name: 'DogCat Pet Care Tracker' },
  { id: 'doglog', niche: 'pet', name: 'DogLog' },
  { id: 'doggytime', niche: 'pet', name: 'Doggy Time' },
];

const out = [];
for (const app of apps) {
  const path = `C:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings/raw/play-store/_t13_${app.id}.json`;
  const data = JSON.parse(readFileSync(path, 'utf8'));
  const reviews = Array.isArray(data) ? data : (data.reviews || data.data || []);
  const total = reviews.length;
  const low = reviews.filter(r => r.score <= 2);
  const low_pct = total ? (low.length / total * 100).toFixed(1) : 'NA';
  // Top low verbatims (longest text)
  const topLow = low
    .filter(r => r.text && r.text.length > 50)
    .sort((a, b) => (b.text?.length || 0) - (a.text?.length || 0))
    .slice(0, 3)
    .map(r => ({ score: r.score, text: r.text.slice(0, 400), date: r.date }));
  out.push({ ...app, total_recent: total, low_count: low.length, low_pct, topLow });
}
writeFileSync('C:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings/raw/play-store/_t13_lowpct.json', JSON.stringify(out, null, 2));
console.log(JSON.stringify(out.map(o => ({ niche: o.niche, name: o.name, low_pct: o.low_pct, low_count: o.low_count })), null, 2));
console.log('\n--- TOP VERBATIMS ---');
for (const a of out) {
  console.log(`\n[${a.niche}] ${a.name} (low_pct=${a.low_pct}%)`);
  for (const v of a.topLow) {
    console.log(`  ★${v.score}: ${v.text.slice(0, 280).replace(/\n/g, ' ')}`);
  }
}
