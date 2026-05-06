#!/usr/bin/env python
"""Final synthesis: combine ALL evidence (Trends + Play Store + TikTok + Reddit) into ONE scored matrix + recommendation."""
import json, sys, io, os
from collections import Counter, defaultdict
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

BASE = 'c:/Users/demosgod/Desktop/PROJECTS/playstore_app'
def safe_load(p, default):
    if not os.path.exists(p): return default
    try: return json.load(open(p, encoding='utf-8'))
    except: return default

play = safe_load(f'{BASE}/play_deep.json', {})
drill = safe_load(f'{BASE}/drill.json', {})
drill2 = safe_load(f'{BASE}/drill2.json', {})
tiktok_deep = safe_load(f'{BASE}/tiktok_deep.json', {})
tiktok_volumes = safe_load(f'{BASE}/tiktok_clean.json', [])
reddit = safe_load(f'{BASE}/reddit_deep.json', {})
reddit_extra = safe_load(f'{BASE}/reddit_extra.json', {})

# Merge drill + drill2
all_drilled = {**drill, **drill2}

# Niche to TikTok hashtag mapping
NICHE_TO_TAGS = {
    'manifestation': ['manifestation', 'manifesting', '369method', 'manifestacao', 'manifestasyon', 'manifestacion'],
    'tarot': ['tarot', 'tarotreading'],
    'couple': ['couplegoals', 'noteit'],
    'selfcare': ['selfcare'],
    'astrology': ['astrology', 'astrologia', 'astroloji', 'horoscope', 'horoscopo', 'birthchart', 'numerology'],
}

def tiktok_score_for(niche):
    tags = [t.lower() for t in NICHE_TO_TAGS.get(niche, [])]
    return sum(t['views'] for t in tiktok_volumes if t['tag'].lower() in tags)

# Load and aggregate TikTok user-voice signal per niche x country
def tiktok_engagement(country, niche):
    key = f'{country}_{niche}'
    info = tiktok_deep.get(key, {})
    likes = sum(c.get('likes', 0) for v in info.get('videos', []) for c in v.get('comments', []))
    return likes

# COMPUTE SCORES
print("=" * 110)
print("FINAL VERDICT MATRIX — all signals combined")
print("=" * 110)
print()
print(f"{'cell':28} {'top app':35} {'1★%':>5} {'low/100':>7} {'tiktok B':>9} {'tt likes':>9} {'verdict':<20}")
print('-' * 110)

verdicts = []
for country in ['BR', 'MX', 'TR', 'ID']:
    country_data = play.get(country, {})
    for niche in ['manifestation', 'tarot', 'couple', 'selfcare', 'astrology']:
        cell_data = country_data.get(niche, {})
        comps = cell_data.get('competitors', [])
        valid = [c for c in comps if 'histogram' in c and c.get('ratings', 0) > 100]
        if not valid: continue
        top = valid[0]
        h = top.get('histogram', {}) or {}
        s1r = (h.get('1', 0) / max(1, top.get('ratings', 1))) * 100
        # Use drilled data if available
        drill_key = None
        for k in all_drilled:
            if k.startswith(f'{country}_{niche}_') and 'error' not in all_drilled[k]:
                drill_key = k; break
        if drill_key:
            d = all_drilled[drill_key]
            s1r = (d.get('histogram', {}).get('1', 0) / max(1, d.get('ratings', 1))) * 100
            low_pct = d.get('low_reviews_pct', 0)
        else:
            low_pct = sum(c.get('low_reviews_count', 0) for c in valid) / max(1, len(valid))
        tt_views_b = tiktok_score_for(niche) / 1e9
        tt_likes = tiktok_engagement(country, niche)

        # Score components
        score = 0
        verdict = []
        if s1r >= 10: score += 3; verdict.append('vulnerable_competitor')
        elif s1r >= 6: score += 1
        if low_pct >= 15: score += 2; verdict.append('high_recent_complaints')
        elif low_pct >= 8: score += 1
        if tt_views_b >= 100: score += 2
        elif tt_views_b >= 50: score += 1
        if tt_likes >= 5000: score += 2; verdict.append('viral_engagement')
        elif tt_likes >= 1000: score += 1

        v_str = ', '.join(verdict[:2]) or '-'
        print(f"{country+'/'+niche:28} {top.get('title','')[:34]:35} {s1r:>5.1f} {low_pct:>7.1f} {tt_views_b:>9.0f} {tt_likes:>9,} {v_str:<20}")
        verdicts.append((country, niche, score, top.get('title',''), s1r, low_pct, tt_views_b, tt_likes))

print()
print("=" * 110)
print("RANKED CELLS BY COMPOSITE SCORE")
print("=" * 110)
verdicts.sort(key=lambda x: x[2], reverse=True)
for country, niche, score, top_title, s1r, low_pct, tt_v, tt_l in verdicts[:10]:
    print(f"  Score {score:>2} | {country}/{niche:14} | top={top_title[:30]:30} | 1★={s1r:.1f}% low={low_pct:.1f}% TT={tt_v:.0f}B/{tt_l:,}likes")

# THE PROOF QUOTES per top cell
print()
print("=" * 110)
print("PROOF QUOTES per top-3 cells")
print("=" * 110)

for country, niche, score, _, _, _, _, _ in verdicts[:5]:
    drill_key = None
    for k in all_drilled:
        if k.startswith(f'{country}_{niche}_') and 'error' not in all_drilled[k]:
            drill_key = k; break
    if not drill_key: continue
    d = all_drilled[drill_key]
    print(f"\n--- {country}/{niche} | {d['title']} ({d['installs']}, {d['ratings']:,} ratings, {d['score']:.2f}★) ---")
    print(f"    Histogram: {d['histogram']}")
    print(f"    IAP range: {d.get('IAPRange')} | Ad-supported: {d.get('adSupported')}")
    low = sorted(d.get('low_reviews', []), key=lambda r: r.get('thumbs', 0), reverse=True)[:5]
    for r in low:
        text = (r.get('text') or '')[:240].replace('\n', ' ')
        print(f"    [{r['score']}★ 👍{r.get('thumbs', 0)}] {text}")

    # TikTok comment signals
    key = f'{country}_{niche}'
    tt = tiktok_deep.get(key, {})
    if tt:
        all_comments = [c for v in tt.get('videos', []) for c in v.get('comments', [])]
        all_comments.sort(key=lambda c: c.get('likes', 0), reverse=True)
        print(f"\n    TikTok top comments ({len(all_comments)} sampled):")
        for c in all_comments[:3]:
            print(f"      [👍{c.get('likes', 0):,}] {(c.get('text') or '')[:200]}")
