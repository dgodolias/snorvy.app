import fs from 'node:fs';
import path from 'node:path';

const FILES = [
  ['Invoice Simple PH', '_t18_invsim_ph.json', 'com.aadhk.woinvoice', 'PH', '5M+'],
  ['Bookipi PH', '_t18_bookipi_ph.json', 'bookipi.invoice.maker.estimate.billing', 'PH', '?'],
  ['Invoice Simple MY', '_t18_invsim_my.json', 'com.aadhk.woinvoice', 'MY', '5M+'],
  ['Bookipi MY', '_t18_bookipi_my.json', 'bookipi.invoice.maker.estimate.billing', 'MY', '1M+'],
  ['Zoho Invoice MY', '_t18_zoho_my.json', 'com.zoho.invoice', 'MY', '1M+'],
  ['Invoice Simple TH', '_t18_invsim_th.json', 'com.aadhk.woinvoice', 'TH', '5M+'],
  ['MyInvois MY (govt)', '_t18_myinvois.json', 'my.gov.hasil.myinvois', 'MY', '10K+'],
  ['Planbook US', '_t18_planbook.json', 'com.planbook.lessonplanner', 'US', '10K+'],
  ['Tuition Lesson Tracker', '_t18_tuition.json', 'odt.com.ozel_ders_takip_uyg', 'US', '1K+'],
  ['Tutoring Tracker', '_t18_ttrkr.json', 'com.mhhijab.tutoring_tracker', 'US', '100+'],
];

const DIR = 'c:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings/raw/play-store/';
const RECENT_DAYS = 180;
const cutoff = Date.now() - RECENT_DAYS*24*3600*1000;

const out = [];
for (const [name, file, app, country, installs] of FILES) {
  const fp = path.join(DIR, file);
  if (!fs.existsSync(fp)) continue;
  const j = JSON.parse(fs.readFileSync(fp, 'utf8'));
  const reviews = j.reviews || [];
  if (reviews.length === 0) {
    out.push({ name, app, country, installs, total: 0, recent: 0, low_pct: null });
    continue;
  }
  const recent = reviews.filter(r => new Date(r.date).getTime() > cutoff);
  const low = recent.filter(r => r.score <= 2);
  const low_pct = recent.length ? (low.length/recent.length*100).toFixed(1) : 'n/a';
  // top 3 verbatim
  const verbatims = low.slice(0, 3).map(r => ({date: r.date.slice(0,10), score: r.score, text: r.text.slice(0,200)}));
  out.push({ name, app, country, installs, total: reviews.length, recent: recent.length, low_pct: low_pct + '%', sample_low: verbatims });
}

console.log(JSON.stringify(out, null, 2));
