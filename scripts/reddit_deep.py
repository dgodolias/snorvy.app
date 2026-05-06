#!/usr/bin/env python
"""Deep Reddit scan via Arctic Shift archive — niche subs + country subs."""
import json, time, urllib.request, urllib.parse, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

UA = 'research-agent/1.0'

NICHE_SUBS = [
    'manifestation', 'Tarot', 'astrology', 'witchcraft',
    'WitchesVsPatriarchy', 'selfimprovement', 'GetMotivated',
    'selfcare', 'BabyBumps', 'SomebodyMakeThis', 'AppIdeas',
]

COUNTRY_SUBS = ['brasil', 'brasilivre', 'mexico', 'Turkey', 'indonesia']

KEY_PHRASES = [
    'wish', 'looking for', 'need', 'recommend', 'best app', 'is there',
    'anyone know', 'hate', 'frustrating', 'missing', 'why no', 'why does',
    'should', 'help me find', 'app that', 'i want', 'ideal app',
    # Portuguese
    'queria', 'preciso', 'procurando', 'falta',
    # Spanish
    'busco', 'necesito', 'quisiera',
    # Turkish
    'önerisi', 'arıyorum', 'olsa',
    # Indonesian
    'cari', 'butuh', 'rekomendasi',
]

def fetch_posts(sub, query=None, limit=50):
    params = {
        'subreddit': sub, 'limit': limit, 'sort': 'desc', 'sort_type': 'created_utc',
        'fields': 'title,score,num_comments,selftext,id,created_utc',
    }
    if query: params['title'] = query
    qs = urllib.parse.urlencode(params)
    url = f'https://arctic-shift.photon-reddit.com/api/posts/search?{qs}'
    req = urllib.request.Request(url, headers={'User-Agent': UA})
    with urllib.request.urlopen(req, timeout=20) as r:
        return json.loads(r.read())

def filter_posts(posts):
    out = []
    for p in posts:
        title = (p.get('title') or '').lower()
        body = (p.get('selftext') or '').lower()
        combined = title + ' ' + body
        hit = any(k in combined for k in KEY_PHRASES)
        if hit or p.get('num_comments', 0) >= 5 or p.get('score', 0) >= 10:
            out.append({
                'id': p.get('id'),
                'title': p.get('title'),
                'score': p.get('score', 0),
                'comments': p.get('num_comments', 0),
                'date': p.get('created_utc'),
                'body': (p.get('selftext') or '')[:600],
            })
    return out

results = {}

for sub in NICHE_SUBS:
    print(f'[niche/{sub}] fetching app posts...', file=sys.stderr, flush=True)
    try:
        d = fetch_posts(sub, query='app', limit=50)
        if d.get('error'):
            print(f'  err: {d["error"]}', file=sys.stderr)
            results[f'niche_{sub}'] = []
            continue
        posts = d.get('data') or []
        filtered = filter_posts(posts)
        results[f'niche_{sub}'] = filtered
        print(f'  {len(posts)} posts → {len(filtered)} relevant', file=sys.stderr)
    except Exception as e:
        print(f'  FAIL {str(e)[:80]}', file=sys.stderr)
        results[f'niche_{sub}'] = []
    time.sleep(0.8)

for sub in COUNTRY_SUBS:
    print(f'[country/{sub}] fetching...', file=sys.stderr, flush=True)
    try:
        d = fetch_posts(sub, query='app', limit=50)
        if d.get('error'):
            print(f'  err: {d["error"]}', file=sys.stderr)
            results[f'country_{sub}'] = []
            continue
        posts = d.get('data') or []
        filtered = filter_posts(posts)
        results[f'country_{sub}'] = filtered
        print(f'  {len(posts)} posts → {len(filtered)} relevant', file=sys.stderr)
    except Exception as e:
        print(f'  FAIL {str(e)[:80]}', file=sys.stderr)
        results[f'country_{sub}'] = []
    time.sleep(0.8)

with open('c:/Users/demosgod/Desktop/PROJECTS/playstore_app/reddit_deep.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=2)
print(f'\nDone. {len(results)} subs, saved to reddit_deep.json', file=sys.stderr)
