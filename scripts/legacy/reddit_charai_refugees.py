#!/usr/bin/env python
"""r/CharacterAI refugee migration validation: are users actively seeking alternatives?"""
import json, time, urllib.request, urllib.parse, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')
UA = 'research-agent/1.0'

QUERIES = [
    ('CharacterAI', 'alternative', 50),
    ('CharacterAI', 'face', 30),
    ('CharacterAI', 'verification', 30),
    ('CharacterAI', 'roar', 30),
    ('CharacterAI', 'leaving', 30),
    ('CharacterAI', 'switching', 30),
    ('CharacterAI', 'best app', 30),
    ('CharacterAITech', 'alternative', 30),
    ('CharacterAI_NSFW', 'alternative', 30),
    ('CAIRefugees', 'alternative', 30),
    # Specific competitor mentions
    ('CharacterAI', 'janitor', 30),
    ('CharacterAI', 'chai', 30),
    ('CharacterAI', 'spicychat', 30),
    ('CharacterAI', 'crushon', 30),
    # Replika refugees
    ('replika', 'alternative', 30),
    ('replika', 'leaving', 30),
    # Adjacent
    ('AICompanions', 'best', 30),
    ('chatGPT', 'replacement', 30),
]

THEME_KEYS = [
    'alternative', 'switch', 'leaving', 'left', 'quit', 'cancel',
    'face scan', 'face verification', 'age verification', 'id check',
    'roar mode', 'roar', 'pipsqueak', 'memory', 'censor',
    'janitor', 'chai', 'spicychat', 'crushon', 'character.ai',
    'replika', 'before update', 'used to be', 'not what it was',
    'character ai sucks', 'cancel sub', 'refund',
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

with open('c:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings/raw/reddit/reddit_charai_refugees.json', 'w', encoding='utf-8') as f:
    json.dump({'queries': results, 'theme_counts': theme_counts}, f, ensure_ascii=False, indent=2)
print(f'\nDone. {len(results)} queries, {sum(len(v) for v in results.values())} relevant posts', file=sys.stderr)
