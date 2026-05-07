#!/usr/bin/env python
"""Reddit gig-worker demand sweep: r/doordash, r/uberdrivers, r/instacartshoppers, r/lyftdrivers etc."""
import json, time, urllib.request, urllib.parse, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')
UA = 'research-agent/1.0'

QUERIES = [
    ('doordash', 'tracker app', 50),
    ('doordash', 'mileage app', 30),
    ('doordash', 'tax app', 30),
    ('doordash', 'best app', 30),
    ('doordash', 'solo app', 20),
    ('uberdrivers', 'tracker app', 30),
    ('uberdrivers', 'mileage', 30),
    ('uberdrivers', 'tax', 30),
    ('uberdrivers', 'best app', 30),
    ('lyftdrivers', 'tracker', 30),
    ('lyftdrivers', 'mileage', 30),
    ('instacartshoppers', 'tracker', 30),
    ('instacartshoppers', 'tax', 30),
    ('GigWork', 'app', 30),
    ('Sidehustle', 'tracker', 30),
    ('Sidehustle', 'gig app', 30),
    # Specific competitor mentions
    ('doordash', 'stride', 20),
    ('doordash', 'hurdlr', 20),
    ('doordash', 'gridwise', 20),
    ('doordash', 'everlance', 20),
    ('uberdrivers', 'stride', 20),
    ('uberdrivers', 'hurdlr', 20),
    ('uberdrivers', 'gridwise', 20),
]

THEME_KEYS = [
    'mileage', 'tax', 'tracker', 'expense', 'receipt',
    'stride', 'hurdlr', 'gridwise', 'solo', 'everlance', 'mileiq', 'triplog', 'para',
    'best app', 'recommend', 'looking for', 'better than', 'switch from',
    'alternative', 'cheaper', 'price', 'subscription', 'free',
    'guaranteed earnings', 'irs', 'tax deduction', 'schedule c',
    'auto track', 'manual track',
]

results = {}
for sub, query, limit in QUERIES:
    key = f'{sub}__{query}'
    print(f'[{key}]', file=sys.stderr, flush=True)
    try:
        params = {'subreddit': sub, 'limit': limit, 'sort': 'desc', 'sort_type': 'created_utc',
                  'fields': 'title,score,num_comments,selftext,id,created_utc',
                  'title': query}
        url = 'https://arctic-shift.photon-reddit.com/api/posts/search?' + urllib.parse.urlencode(params)
        req = urllib.request.Request(url, headers={'User-Agent': UA})
        with urllib.request.urlopen(req, timeout=20) as r:
            d = json.loads(r.read())
        posts = d.get('data') or []
        filtered = []
        for p in posts[:30]:
            title = (p.get('title') or '').lower()
            body = (p.get('selftext') or '').lower()
            combined = title + ' ' + body
            theme_hits = [t for t in THEME_KEYS if t in combined]
            if theme_hits or p.get('score', 0) >= 10 or p.get('num_comments', 0) >= 5:
                filtered.append({
                    'id': p.get('id'),
                    'title': p.get('title'),
                    'score': p.get('score', 0),
                    'comments': p.get('num_comments', 0),
                    'date': p.get('created_utc'),
                    'themes_matched': theme_hits,
                    'body': (p.get('selftext') or '')[:600],
                })
        results[key] = filtered
        print(f'  {len(posts)} -> {len(filtered)} ({sum(len(p["themes_matched"]) for p in filtered)} themes)', file=sys.stderr)
    except Exception as e:
        print(f'  FAIL {str(e)[:80]}', file=sys.stderr)
        results[key] = []
    time.sleep(0.6)

theme_counts = {t: 0 for t in THEME_KEYS}
for posts in results.values():
    for p in posts:
        for t in p.get('themes_matched', []):
            theme_counts[t] += 1
print('\n=== Theme tally ===', file=sys.stderr)
for t, c in sorted(theme_counts.items(), key=lambda x: -x[1])[:20]:
    if c > 0:
        print(f'  {c:3d}  {t}', file=sys.stderr)

with open('c:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings/raw/reddit/reddit_gig_demand.json', 'w', encoding='utf-8') as f:
    json.dump({'queries': results, 'theme_counts': theme_counts}, f, ensure_ascii=False, indent=2)
print(f'\nDone. {len(results)} queries, {sum(len(v) for v in results.values())} posts', file=sys.stderr)
