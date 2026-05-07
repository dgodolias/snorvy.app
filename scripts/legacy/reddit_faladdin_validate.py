#!/usr/bin/env python
"""Direction 3 validation: do TR/Reddit users discuss Faladdin alternatives,
kahve falı apps, AI fortune-telling? Post-arrest vacuum signal check."""
import json, time, urllib.request, urllib.parse, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')
UA = 'research-agent/1.0'

QUERIES = [
    ('Turkey', 'fal', 50),
    ('Turkey', 'faladdin', 30),
    ('Turkey', 'kahve falı', 30),
    ('Turkey', 'kaave', 30),
    ('Turkey', 'tarot', 30),
    ('Turkey', 'astroloji uygulama', 30),
    ('Turkiye', 'fal', 30),
    ('Turkiye', 'kahve falı', 30),
    ('AskTurkey', 'fal', 30),
    ('AskTurkey', 'faladdin', 30),
    ('AskTurkey', 'kahve falı', 30),
    ('AskTurkey', 'astroloji', 30),
    ('TurkeyJerky', 'fal', 30),
    # Multi-language portuguese for Direction 3 expansion
    ('astrologia', 'app', 30),
    ('Espiritismo', 'app', 30),
    # Indonesian astro
    ('indonesia', 'ramalan', 30),
    ('indonesia', 'horoskop app', 30),
]

THEME_KEYS = [
    'fal', 'kahve falı', 'kahve fali', 'faladdin', 'kaave', 'tarot',
    'astroloji', 'horoskop', 'burç', 'ramalan', 'horóscopo',
    'reklam', 'abonelik', 'para tuzağı', 'subscription trap',
    'reklam izlettir', 'krediler bitiyor', 'fal tutmuyor',
    'falımı bakti', 'kandırma', 'ai fal', 'yapay zeka fal',
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
            if theme_hits or p.get('score', 0) >= 5 or p.get('num_comments', 0) >= 5:
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
        print(f'  {len(posts)} -> {len(filtered)} relevant ({sum(len(p["themes_matched"]) for p in filtered)} theme hits)', file=sys.stderr)
    except Exception as e:
        print(f'  FAIL {str(e)[:80]}', file=sys.stderr)
        results[key] = []
    time.sleep(0.7)

theme_counts = {t: 0 for t in THEME_KEYS}
for posts in results.values():
    for p in posts:
        for t in p.get('themes_matched', []):
            theme_counts[t] += 1
print('\n=== Theme tally ===', file=sys.stderr)
for t, c in sorted(theme_counts.items(), key=lambda x: -x[1])[:15]:
    if c > 0:
        print(f'  {c:3d}  {t}', file=sys.stderr)

with open('c:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings/raw/reddit/reddit_faladdin_validate.json', 'w', encoding='utf-8') as f:
    json.dump({'queries': results, 'theme_counts': theme_counts}, f, ensure_ascii=False, indent=2)
print(f'\nDone. {len(results)} queries, {sum(len(v) for v in results.values())} relevant posts', file=sys.stderr)
