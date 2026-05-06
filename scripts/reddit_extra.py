#!/usr/bin/env python
"""Targeted Reddit search on specific candidates' subreddits, with full text."""
import json, time, urllib.request, urllib.parse, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

UA = 'research-agent/1.0'

# Candidate-specific subs + body searches
QUERIES = [
    # Tarot — non-AI demand
    ('Tarot', 'app', 50),
    ('TarotReadersOfReddit', 'app', 50),
    # Manifestation — what apps people want
    ('lawofattraction', 'app', 50),
    ('NevilleGoddard', 'app', 50),
    # Couples
    ('LongDistance', 'app', 50),
    ('relationships', 'couple app', 30),
    # Selfcare / habit
    ('decidingtobebetter', 'app', 50),
    ('productivity', 'app', 50),
    # Witchcraft (massive signal earlier)
    ('witchcraft', 'app', 100),  # already have but pulling more
    ('SASSWitches', 'app', 50),
    # Niche country queries
    ('brasil', 'aplicativo', 50),
    ('mexico', 'aplicacion', 50),
    ('Turkey', 'uygulama', 50),
    ('indonesia', 'aplikasi', 50),
]

results = {}
for sub, query, limit in QUERIES:
    key = f'{sub}__{query}'
    print(f'[{sub}] q="{query}" limit={limit}', file=sys.stderr, flush=True)
    try:
        params = {
            'subreddit': sub, 'limit': limit, 'sort': 'desc', 'sort_type': 'created_utc',
            'fields': 'title,score,num_comments,selftext,id,created_utc',
            'title': query,
        }
        url = 'https://arctic-shift.photon-reddit.com/api/posts/search?' + urllib.parse.urlencode(params)
        req = urllib.request.Request(url, headers={'User-Agent': UA})
        with urllib.request.urlopen(req, timeout=20) as r:
            d = json.loads(r.read())
        posts = d.get('data') or []
        # Sort by engagement
        posts.sort(key=lambda p: p.get('score', 0) + p.get('num_comments', 0), reverse=True)
        results[key] = [{
            'id': p.get('id'),
            'title': p.get('title'),
            'score': p.get('score', 0),
            'comments': p.get('num_comments', 0),
            'date': p.get('created_utc'),
            'body': (p.get('selftext') or '')[:1500],  # bigger body for context
        } for p in posts[:30]]
        print(f'  {len(posts)} posts', file=sys.stderr)
    except Exception as e:
        print(f'  FAIL {str(e)[:80]}', file=sys.stderr)
        results[key] = []
    time.sleep(0.8)

with open('c:/Users/demosgod/Desktop/PROJECTS/playstore_app/reddit_extra.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=2)
print(f'\nDone. {len(results)} queries, saved to reddit_extra.json', file=sys.stderr)
