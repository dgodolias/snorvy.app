#!/usr/bin/env python
"""Reddit r/Turkey + r/Turkiye signal for Direction 1 (TR/couple) — independent triangulation
of "konum yanlis", "Love8 alternatif", "sevgili takip" themes."""
import json, time, urllib.request, urllib.parse, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')
UA = 'research-agent/1.0'

QUERIES = [
    ('Turkey', 'sevgili', 50),
    ('Turkey', 'sevgili takip', 30),
    ('Turkey', 'konum', 30),
    ('Turkey', 'love8', 30),
    ('Turkey', 'çift uygulama', 30),
    ('Turkey', 'life360', 30),
    ('Turkiye', 'sevgili takip', 30),
    ('Turkiye', 'çift', 30),
    ('Turkiye', 'konum paylaşım', 30),
    ('AskTurkey', 'sevgili', 30),
    ('AskTurkey', 'çift uygulaması', 30),
    ('AskTurkey', 'sevgili takip', 30),
    ('AskTurkey', 'konum', 30),
    ('TurkeyJerky', 'sevgili', 20),
    ('NamusVerelim', 'sevgili', 30),
    # Adjacent: trust + privacy in TR couples
    ('Turkey', 'aldatma uygulama', 30),
    ('AskTurkey', 'güvenmiyorum', 30),
]

THEME_KEYS = [
    'sevgili takip', 'konum', 'çift uygulama', 'love8', 'çift uygulaması',
    'life360', 'find my friends', 'aldatma', 'güvenmiyorum', 'kıskanç',
    'karşılıklı onay', 'gizli takip', 'paylaşım', 'şüphe',
    'eşim', 'kocam', 'karım', 'partner takip',
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
            if theme_hits or p.get('score', 0) >= 15 or p.get('num_comments', 0) >= 10:
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
print('\n=== Theme tally across r/Turkey + r/Turkiye ===', file=sys.stderr)
for t, c in sorted(theme_counts.items(), key=lambda x: -x[1])[:15]:
    if c > 0:
        print(f'  {c:3d}  {t}', file=sys.stderr)

with open('c:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings/raw/reddit/reddit_tr_couple_validate.json', 'w', encoding='utf-8') as f:
    json.dump({'queries': results, 'theme_counts': theme_counts}, f, ensure_ascii=False, indent=2)
print(f'\nDone. {len(results)} queries, {sum(len(v) for v in results.values())} relevant posts', file=sys.stderr)
