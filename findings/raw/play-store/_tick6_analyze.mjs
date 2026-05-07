// Analyze tick6 Evernote 1500 + competitor + misc niches.
// low_pct = share of 1-2★ reviews. windows: full, 2025+, last 90d
import fs from 'node:fs';
const ROOT='C:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings/raw/play-store/';

function load(name){try{return JSON.parse(fs.readFileSync(ROOT+name,'utf8'));}catch(e){return null;}}
function arr(d){return Array.isArray(d)?d:(d?.reviews||d?.data||[]);}

function lowPct(reviews){
  if(!reviews.length) return {n:0, low_pct:0, lows:0};
  const lows=reviews.filter(r=>r.score<=2).length;
  return {n:reviews.length, lows, low_pct:+(100*lows/reviews.length).toFixed(1)};
}

function inWindow(reviews, fromDate){
  return reviews.filter(r=>{
    const t=new Date(r.date).getTime();
    return !isNaN(t) && t>=fromDate.getTime();
  });
}

function analyze(name, file){
  const d=load(file);
  if(!d){console.log(name+' MISSING'); return null;}
  const all=arr(d);
  const dates=all.map(r=>new Date(r.date)).filter(d=>!isNaN(d));
  const oldest=dates.length?new Date(Math.min(...dates.map(d=>d.getTime()))):null;
  const newest=dates.length?new Date(Math.max(...dates.map(d=>d.getTime()))):null;
  const y2025=inWindow(all, new Date('2025-01-01'));
  const y2026=inWindow(all, new Date('2026-01-01'));
  const last90=inWindow(all, new Date(Date.now()-90*24*3600*1000));
  console.log(`\n=== ${name} (${file}) ===`);
  console.log(`  total n=${all.length} window=${oldest?.toISOString().slice(0,10)} -> ${newest?.toISOString().slice(0,10)}`);
  console.log(`  full     low_pct=${lowPct(all).low_pct}% (${lowPct(all).lows}/${all.length})`);
  console.log(`  2025+    low_pct=${lowPct(y2025).low_pct}% (${lowPct(y2025).lows}/${y2025.length})`);
  console.log(`  2026+    low_pct=${lowPct(y2026).low_pct}% (${lowPct(y2026).lows}/${y2026.length})`);
  console.log(`  last90d  low_pct=${lowPct(last90).low_pct}% (${lowPct(last90).lows}/${last90.length})`);
  return {name,all,y2025,last90};
}

const targets=[
  ['EVERNOTE-1500','d9_evernote_us_1500.json'],
  ['UPNOTE-200','d9_upnote_us_200.json'],
  ['OBSIDIAN-200','d9_obsidian_us_200.json'],
  ['JOPLIN-200','d9_joplin_us_200.json'],
  ['CALC991-200','explore_tick6_calc991.json'],
  ['REALCALC-200','explore_tick6_realcalc.json'],
  ['PLANETVPN-200','explore_tick6_planetvpn.json'],
  ['ITRANSLATE-200','explore_tick6_itranslate.json'],
];

const results={};
targets.forEach(([n,f])=>{results[n]=analyze(n,f);});

// Top thumbs-up 1-2★ verbatim quotes for Evernote
console.log('\n\n=== EVERNOTE TOP 25 RAGE QUOTES (1-2★ by thumbsUp) ===');
const ev=results['EVERNOTE-1500'];
if(ev){
  const lows=ev.all.filter(r=>r.score<=2).sort((a,b)=>(b.thumbsUp||0)-(a.thumbsUp||0)).slice(0,25);
  lows.forEach((r,i)=>{
    console.log(`[${i+1}] ${r.score}★ thumbs=${r.thumbsUp} ${r.date?.slice(0,10)}`);
    console.log(`    "${(r.text||'').slice(0,300).replace(/\n/g,' ')}"`);
  });

  // Theme classification
  console.log('\n=== EVERNOTE THEME COUNTS (1-2★ in 2025+) ===');
  const lows25=ev.y2025.filter(r=>r.score<=2);
  const themes={
    data_loss:0, sync_break:0, bending_spoons:0, price_hike:0,
    note_limit:0, ads:0, performance:0, login_locked:0
  };
  lows25.forEach(r=>{
    const t=(r.text||'').toLowerCase();
    if(/lost|gone|disappear|missing|deleted|wipe/.test(t)) themes.data_loss++;
    if(/sync|won't sync|not sync|cannot sync/.test(t)) themes.sync_break++;
    if(/bending|spoon|new owner|acquired/.test(t)) themes.bending_spoons++;
    if(/price|expensive|raised|hike|too much|\$|cost|subscription/.test(t)) themes.price_hike++;
    if(/limit|50 notes|two device|2 device|free user/.test(t)) themes.note_limit++;
    if(/ad |ads |advertisement|banner/.test(t)) themes.ads++;
    if(/slow|laggy|crash|freeze|broken/.test(t)) themes.performance++;
    if(/login|sign in|locked out|password|account/.test(t)) themes.login_locked++;
  });
  console.log(`  total 1-2★ 2025+: ${lows25.length}`);
  Object.entries(themes).forEach(([k,v])=>console.log(`  ${k.padEnd(16)} ${v} (${(100*v/lows25.length).toFixed(0)}%)`));
}

// quick rage quotes for the alt-notes apps
['UPNOTE-200','OBSIDIAN-200','JOPLIN-200','CALC991-200','REALCALC-200','PLANETVPN-200','ITRANSLATE-200'].forEach(name=>{
  const r=results[name];
  if(!r) return;
  const lows=r.all.filter(rv=>rv.score<=2).sort((a,b)=>(b.thumbsUp||0)-(a.thumbsUp||0)).slice(0,5);
  console.log(`\n--- ${name} top 5 rage ---`);
  lows.forEach((rv,i)=>console.log(`  [${i+1}] ${rv.score}★ ${rv.date?.slice(0,10)} t=${rv.thumbsUp} "${(rv.text||'').slice(0,180).replace(/\n/g,' ')}"`));
});
