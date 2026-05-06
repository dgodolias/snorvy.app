#!/usr/bin/env python
"""Join all three deep scans + the TikTok hashtag volumes into a scored matrix."""
import json, sys, io, os
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

BASE = 'c:/Users/demosgod/Desktop/PROJECTS/playstore_app'

# Load all sources
def safe_load(path, default):
    if not os.path.exists(path): return default
    try: return json.load(open(path, encoding='utf-8'))
    except json.JSONDecodeError: return default

play = safe_load(f'{BASE}/play_deep.json', {})
tiktok_deep = safe_load(f'{BASE}/tiktok_deep.json', {})
tiktok_volumes = safe_load(f'{BASE}/tiktok_clean.json', [])
reddit = safe_load(f'{BASE}/reddit_deep.json', {})

# Map TikTok hashtag volumes to niche
NICHE_TO_TAGS = {
    'manifestation': ['manifestation', 'manifesting', '369method', 'manifestacao', 'manifestasyon', 'manifestacion'],
    'tarot': ['tarot', 'tarotreading'],
    'couple': ['couplegoals', 'noteit', 'lockerwidget'],
    'selfcare': ['selfcare'],
    'astrology': ['astrology', 'astrologia', 'astroloji', 'horoscope', 'horoscopo', 'birthchart', 'numerology'],
}

def tiktok_volume_for(niche):
    tags = NICHE_TO_TAGS.get(niche, [])
    total_views = sum(t['views'] for t in tiktok_volumes if t['tag'].lower() in [x.lower() for x in tags])
    total_users = sum(t['users'] for t in tiktok_volumes if t['tag'].lower() in [x.lower() for x in tags])
    return total_views, total_users

# Score each (country × niche) cell
print("=" * 100)
print("MATRIX: niche × country (top competitor signals)")
print("=" * 100)

matrix = {}
for country, niches in play.items():
    matrix[country] = {}
    for niche, info in niches.items():
        comps = info.get('competitors', [])
        if not comps: continue
        # Aggregate signals across top 3 competitors
        valid = [c for c in comps if 'histogram' in c and c.get('ratings', 0) > 100]
        if not valid: continue
        top = valid[0]
        avg_score = sum(c.get('score', 0) for c in valid) / len(valid)
        avg_1star_ratio = sum((c.get('star1_ratio') or 0) for c in valid) / len(valid)
        total_installs = sum(c.get('histogram', {}).get('5', 0) + c.get('histogram', {}).get('1', 0) for c in valid)
        avg_low_reviews_recent = sum(c.get('low_reviews_count', 0) for c in valid) / len(valid)
        # Collect actual review samples
        all_low_quotes = []
        for c in valid:
            for r in c.get('sample_low_reviews', []):
                if r.get('text') and len(r['text']) > 20:
                    all_low_quotes.append({
                        'app': c.get('title', '')[:30],
                        'score': r['score'],
                        'thumbs': r.get('thumbs', 0),
                        'text': r['text'],
                    })
        all_low_quotes.sort(key=lambda x: x['thumbs'], reverse=True)

        matrix[country][niche] = {
            'top_app': top.get('title', '')[:40],
            'top_appId': top.get('appId'),
            'avg_score': round(avg_score, 2),
            'avg_1star_ratio_pct': round(avg_1star_ratio, 1),
            'avg_low_recent': round(avg_low_reviews_recent, 1),
            'top_app_installs': top.get('installs', ''),
            'top_app_ratings': top.get('ratings', 0),
            'top_app_offersIAP': top.get('offersIAP'),
            'top_app_IAPRange': top.get('IAPRange'),
            'top_low_quotes': all_low_quotes[:5],
        }

# Print compact table
print(f"\n{'country':5} {'niche':14} {'avg★':>5} {'1★%':>6} {'low/100':>8} {'top installs':>16} {'top app':30}")
print('-' * 100)
for c in matrix:
    for n, info in matrix[c].items():
        print(f"{c:5} {n:14} {info['avg_score']:>5.2f} {info['avg_1star_ratio_pct']:>6.1f} {info['avg_low_recent']:>8.1f} {info['top_app_installs']:>16} {info['top_app']:30}")

# Now print top quotes per cell
print("\n" + "=" * 100)
print("TOP-VOTED 1-2★ COMPLAINT QUOTES (real user voice)")
print("=" * 100)
for c in matrix:
    for n, info in matrix[c].items():
        if not info['top_low_quotes']: continue
        print(f"\n--- {c}/{n} (top app: {info['top_app']}) ---")
        for q in info['top_low_quotes'][:3]:
            print(f"  [{q['score']}★ 👍{q['thumbs']}] [{q['app']}] {q['text']}")

# TikTok virality summary
print("\n" + "=" * 100)
print("TIKTOK VIRALITY (cumulative views across niche-related hashtags)")
print("=" * 100)
for niche in NICHE_TO_TAGS:
    views, users = tiktok_volume_for(niche)
    print(f"  {niche:14} {views/1e9:>8.1f} B views   {users/1e6:>6.1f} M creators")

# Reddit signal — count app-related discussions per niche
print("\n" + "=" * 100)
print("REDDIT signal: count of app-related discussions per niche subreddit")
print("=" * 100)
for k, posts in reddit.items():
    if not k.startswith('niche_'): continue
    sub = k.split('_', 1)[1]
    # Top 3 most-engaged posts
    engaged = sorted(posts, key=lambda p: p.get('score', 0) + p.get('comments', 0), reverse=True)[:3]
    print(f"\n  r/{sub} ({len(posts)} relevant posts)")
    for p in engaged:
        print(f"    [↑{p['score']} 💬{p['comments']}] {p['title'][:90]}")

# TikTok deep (comments per niche x country) — count unique non-empty comments
print("\n" + "=" * 100)
print("TIKTOK COMMENTS sampled per cell (n = unique non-trivial comments collected)")
print("=" * 100)
for k, info in tiktok_deep.items():
    vids = info.get('videos', [])
    n_comments = sum(len(v.get('comments', [])) for v in vids)
    n_videos = len(vids)
    sample_views = [v.get('views', 0) for v in vids]
    print(f"  {k:25} videos={n_videos} comments={n_comments:3} top_views={max(sample_views) if sample_views else 0:>12,}")

print("\nDone.")
