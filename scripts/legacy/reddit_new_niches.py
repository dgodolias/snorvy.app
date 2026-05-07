#!/usr/bin/env python
"""Phase 6: Reddit deep sweep for new niches (journaling, meditation, sleep, fitness)
   + check niche-specific subs for explicit demand."""
import json, time, urllib.request, urllib.parse, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

UA = 'research-agent/1.0'

QUERIES = [
    # Journaling
    ('Journaling', 'app', 50),
    ('bujo', 'app', 50),
    # Meditation
    ('Meditation', 'app', 50),
    ('Mindfulness', 'app', 50),
    # Sleep
    ('sleep', 'app', 50),
    ('insomnia', 'app', 50),
    # Fitness
    ('Fitness', 'app', 50),
    ('workout', 'app', 50),
    ('bodyweightfitness', 'app', 50),
    # Vietnam, Philippines country subs
    ('vietnam', 'app', 50),
    ('Philippines', 'app', 50),
    # Couples app extras
    ('couple', 'app', 50),
    ('LongDistance', 'shared journal', 30),
]

KEY_PHRASES = [
    'wish', 'looking for', 'need', 'recommend', 'best app', 'is there',
    'anyone know', 'hate', 'frustrating', 'missing', 'why no', 'why does',
    'should', 'help me find', 'app that', 'i want', 'ideal app', 'free app',
    # Portuguese
    'queria', 'preciso', 'procurando', 'falta',
    # Spanish
    'busco', 'necesito', 'quisiera',
    # Turkish
    'önerisi', 'arıyorum', 'olsa',
    # Indonesian
    'cari', 'butuh', 'rekomendasi',
    # Vietnamese
    'tìm', 'cần',
    # Tagalog
    'naghahanap',
]

results = {}
for sub, query, limit in QUERIES:
    key = f'{sub}__{query}'
    print(f'[{key}] q="{query}" limit={limit}', file=sys.stderr, flush=True)
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
        # Filter for explicit demand keywords
        filtered = []
        for p in posts[:30]:
            title = (p.get('title') or '').lower()
            body = (p.get('selftext') or '').lower()
            combined = title + ' ' + body
            hit = any(k in combined for k in KEY_PHRASES)
            if hit or p.get('num_comments', 0) >= 5 or p.get('score', 0) >= 10:
                filtered.append({
                    'id': p.get('id'),
                    'title': p.get('title'),
                    'score': p.get('score', 0),
                    'comments': p.get('num_comments', 0),
                    'date': p.get('created_utc'),
                    'body': (p.get('selftext') or '')[:1200],
                })
        results[key] = filtered
        print(f'  {len(posts)} posts → {len(filtered)} relevant', file=sys.stderr)
    except Exception as e:
        print(f'  FAIL {str(e)[:80]}', file=sys.stderr)
        results[key] = []
    time.sleep(0.8)

with open('c:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings/raw/reddit/reddit_new.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=2)
print(f'\nDone. {len(results)} queries → reddit_new.json', file=sys.stderr)
