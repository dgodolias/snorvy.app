#!/usr/bin/env python
"""Cross-source Reddit validation: do MENA Reddit users actually discuss
fake profiles / ID verification / paywall complaints in halal-marriage apps?
This triangulates Direction 2's complaint themes from a non-Play-Store source."""
import json, time, urllib.request, urllib.parse, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')
UA = 'research-agent/1.0'

# Subreddits + themes specifically targeting MENA marriage app discourse
QUERIES = [
    # Arab/Muslim subreddits
    ('saudiarabia', 'muzz', 30),
    ('saudiarabia', 'mawada', 30),
    ('saudiarabia', 'salams', 30),
    ('saudiarabia', 'matrimonial app', 30),
    ('UAE', 'muzz', 30),
    ('UAE', 'matrimonial', 30),
    ('UAE', 'halal dating', 30),
    ('egypt', 'muzz', 30),
    ('egypt', 'mawada', 30),
    ('arabs', 'muzz', 30),
    ('arabs', 'mawada', 30),
    ('arabs', 'salams', 30),
    ('arabs', 'halal marriage app', 30),
    # Muslim-religious subreddits
    ('islam', 'muzz', 50),
    ('islam', 'salams app', 30),
    ('islam', 'halal marriage app', 50),
    ('islam', 'matrimonial app', 50),
    ('islam', 'fake profiles', 30),
    ('MuslimMarriage', '*', 50),  # the subreddit itself
    ('MuslimLounge', 'app', 30),
    # ex-Muslim and skeptical (catches "what they tried that failed")
    ('exmuslim', 'muzz', 30),
    ('exmuslim', 'matrimonial', 30),
]

# Themes we want to validate: are these complained about on Reddit too?
THEME_KEYS = [
    'fake profile', 'fake profiles', 'scam', 'scammer', 'catfish', 'fake account',
    'verification', 'verify', 'verified', 'id check', 'national id',
    'paywall', 'subscription', 'pay to message', 'pay to chat', 'cant message',
    'not serious', 'looking for hookup', 'serious marriage', 'wasting time',
    'recycled profiles', 'same profiles', 'same matches',
    'bot', 'fake user',
]

results = {}
for sub, query, limit in QUERIES:
    key = f'{sub}__{query}'
    print(f'[{key}]', file=sys.stderr, flush=True)
    try:
        params = {'subreddit': sub, 'limit': limit, 'sort': 'desc', 'sort_type': 'created_utc',
                  'fields': 'title,score,num_comments,selftext,id,created_utc'}
        if query != '*':
            params['title'] = query
        url = 'https://arctic-shift.photon-reddit.com/api/posts/search?' + urllib.parse.urlencode(params)
        req = urllib.request.Request(url, headers={'User-Agent': UA})
        with urllib.request.urlopen(req, timeout=20) as r:
            d = json.loads(r.read())
        posts = d.get('data') or []
        # Filter by relevance: post mentions one of THEME_KEYS OR has high engagement
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
                    'body': (p.get('selftext') or '')[:800],
                })
        results[key] = filtered
        print(f'  {len(posts)} -> {len(filtered)} relevant ({sum(len(p["themes_matched"]) for p in filtered)} theme hits)', file=sys.stderr)
    except Exception as e:
        print(f'  FAIL {str(e)[:80]}', file=sys.stderr)
        results[key] = []
    time.sleep(0.7)

# Tally per theme
theme_counts = {t: 0 for t in THEME_KEYS}
for posts in results.values():
    for p in posts:
        for t in p.get('themes_matched', []):
            theme_counts[t] += 1
print('\n=== Theme tally across MENA halal subreddits ===', file=sys.stderr)
for t, c in sorted(theme_counts.items(), key=lambda x: -x[1])[:15]:
    if c > 0:
        print(f'  {c:3d}  {t}', file=sys.stderr)

with open('c:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings/raw/reddit/reddit_halal_validate.json', 'w', encoding='utf-8') as f:
    json.dump({'queries': results, 'theme_counts': theme_counts}, f, ensure_ascii=False, indent=2)
print(f'\nDone. {len(results)} queries, {sum(len(v) for v in results.values())} relevant posts', file=sys.stderr)
