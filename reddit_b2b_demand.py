#!/usr/bin/env python
"""Reddit explicit-demand sweep for B2B + hobbyist directions.
Looking for users actively seeking alternatives to top vulnerable apps."""
import json, time, urllib.request, urllib.parse, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')
UA = 'research-agent/1.0'

QUERIES = [
    # Invoice / Mobills / QBSE alternative seekers
    ('freelance', 'invoice app', 30),
    ('freelance', 'invoice simple alternative', 20),
    ('freelance', 'best invoice', 30),
    ('Entrepreneur', 'invoice app', 30),
    ('smallbusiness', 'invoice', 30),
    ('UKSmallBusiness', 'invoicing', 30),
    ('selfemployed', 'invoice', 30),
    ('selfemployed', 'mileage tracker', 20),
    ('selfemployed', 'expense', 30),
    ('UKPersonalFinance', 'self employed', 30),
    # QBSE specifically
    ('UKSmallBusiness', 'quickbooks self employed', 20),
    ('selfemployed', 'qbse', 20),
    ('selfemployed', 'mtd', 30),
    # Setmore / scheduling
    ('barber', 'booking app', 20),
    ('Hairstylist', 'appointment app', 20),
    ('massage', 'scheduling app', 20),
    # Bikemap / cycling
    ('cycling', 'tracker app', 30),
    ('cycling', 'best cycling app', 30),
    ('bikecommuting', 'route', 20),
    # Hobbyist
    ('woodworking', 'project app', 20),
    ('knitting', 'pattern app', 20),
    ('flyfishing', 'log app', 20),
    ('homebrewing', 'recipe app', 20),
    # Time tracking
    ('freelance', 'time tracking', 30),
    ('freelance', 'toggl alternative', 20),
]

THEME_KEYS = [
    'invoice simple', 'qbse', 'quickbooks', 'mobills', 'wave',
    'setmore', 'square', 'acuity',
    'bikemap', 'strava', 'komoot',
    'toggl', 'harvest',
    'expense', 'mileage', 'receipt',
    'mtd', 'making tax digital',
    'best app', 'recommend', 'better than', 'switch from',
    'alternative', 'cheaper', 'price hike', 'subscription',
    'looking for', 'need an app', 'is there an app',
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
for t, c in sorted(theme_counts.items(), key=lambda x: -x[1])[:25]:
    if c > 0:
        print(f'  {c:3d}  {t}', file=sys.stderr)

with open('c:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings/raw/reddit/reddit_b2b_demand.json', 'w', encoding='utf-8') as f:
    json.dump({'queries': results, 'theme_counts': theme_counts}, f, ensure_ascii=False, indent=2)
print(f'\nDone. {len(results)} queries, {sum(len(v) for v in results.values())} relevant posts', file=sys.stderr)
