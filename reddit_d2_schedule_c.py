#!/usr/bin/env python
"""Reddit deep scan for Direction 2: Schedule C + QBSE displacement pain."""
import json, time, urllib.request, urllib.parse, sys, io, os
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')
UA = 'research-agent/1.0'

QUERIES = [
    ('personalfinance', 'schedule c', 20),
    ('personalfinance', 'self employment tax', 20),
    ('smallbusiness', 'quickbooks self employed', 20),
    ('smallbusiness', 'QBSE alternative', 20),
    ('freelance', 'schedule c', 20),
    ('freelance', 'tax estimator', 20),
    ('freelance', 'schedule c calculator', 20),
    ('IRS', 'schedule c', 20),
    ('IRS', '1099', 20),
    ('tax', 'self employed', 20),
    ('Solopreneur', 'tax tracker', 20),
    ('Entrepreneur', 'QBSE', 20),
    ('Entrepreneur', 'quickbooks alternative', 20),
    # bonus likely-rich subs
    ('selfemployed', 'schedule c', 20),
    ('selfemployed', 'qbse', 20),
    ('taxpros', 'schedule c', 20),
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
        with urllib.request.urlopen(req, timeout=25) as r:
            d = json.loads(r.read())
        posts = d.get('data') or []
        results[key] = []
        for p in posts:
            results[key].append({
                'id': p.get('id'),
                'title': p.get('title'),
                'score': p.get('score', 0),
                'comments': p.get('num_comments', 0),
                'date': p.get('created_utc'),
                'selftext': (p.get('selftext') or '')[:1000],
                'engagement': (p.get('score', 0) or 0) * (p.get('num_comments', 0) or 0),
            })
        print(f'  {len(results[key])} posts', file=sys.stderr, flush=True)
    except Exception as e:
        print(f'  ERR {e}', file=sys.stderr, flush=True)
        results[key] = []
    time.sleep(0.7)

# Rank all posts by engagement
all_posts = []
for k, v in results.items():
    for p in v:
        p['source'] = k
        all_posts.append(p)
all_posts.sort(key=lambda x: x.get('engagement', 0), reverse=True)

# Filter to relevant + dedupe by id
seen = set()
RELEVANT = ['tax', 'qbse', 'quickbook', 'schedule c', '1099', 'self-employ', 'self employ',
            'estimator', 'estimat', 'deduct', 'mileage', 'expense', 'freelance',
            'wave', 'hurdlr', 'keeper', 'stride', 'freshbook', 'bookkeeper',
            'alternative', 'switch', 'better', 'recommend', 'looking for', 'wish']
top_relevant = []
for p in all_posts:
    if p['id'] in seen:
        continue
    seen.add(p['id'])
    text = (p.get('title','') + ' ' + p.get('selftext','')).lower()
    if any(k in text for k in RELEVANT):
        top_relevant.append(p)

os.makedirs('findings/raw/reddit', exist_ok=True)
with open('findings/raw/reddit/d2_schedule_c_search.json', 'w', encoding='utf-8') as f:
    json.dump({'queries': QUERIES, 'results': results, 'top_relevant_ranked': top_relevant[:30]}, f, indent=2, ensure_ascii=False)

print('\n=== TOP 15 BY ENGAGEMENT (relevant) ===', file=sys.stderr, flush=True)
for p in top_relevant[:15]:
    print(f"  [{p['engagement']:>6}] {p['score']:>4}up {p['comments']:>3}c  {p['source']:<40} {p['id']} | {p['title'][:90]}", file=sys.stderr, flush=True)
