#!/usr/bin/env python
"""Phase 13: Reddit deep sweep for 8 NEW niches + Arab world country subs."""
import json, time, urllib.request, urllib.parse, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')
UA = 'research-agent/1.0'

QUERIES = [
    # Recipes
    ('Cooking', 'app', 50), ('MealPrepSunday', 'app', 30), ('eatcheapandhealthy', 'recipe app', 30),
    # Photo editing
    ('iPhoneography', 'app', 30), ('photography', 'editing app', 30), ('mobilephotography', 'app', 30),
    # Video editing
    ('VideoEditing', 'app', 50), ('NewTubers', 'editing app', 30), ('CapCut', 'app', 30),
    # Kids/parenting
    ('Parenting', 'app', 50), ('toddlers', 'app', 30), ('Mommit', 'app', 30),
    # Finance/budget
    ('personalfinance', 'budget app', 50), ('YNAB', 'app', 30), ('PovertyFinance', 'budget app', 30),
    # Dating
    ('Tinder', 'app', 30), ('OnlineDating', 'app', 50), ('datingoverthirty', 'app', 30),
    # Language learning
    ('languagelearning', 'app', 50), ('Duolingo', 'app', 30), ('learnspanish', 'app', 30),
    # Quiz
    ('AskReddit', 'quiz app', 30), ('Quiz', 'app', 30),
    # Arab world
    ('saudiarabia', 'app', 30), ('UAE', 'app', 30), ('egypt', 'app', 30), ('Thailand', 'app', 30),
]

KEY_PHRASES = ['wish','looking for','need','recommend','best app','is there','hate','frustrating','missing',
               'should','help me find','app that','i want','ideal app','free app',
               'queria','preciso','procurando','falta','busco','necesito','quisiera',
               'önerisi','arıyorum','olsa','cari','butuh','rekomendasi','tìm','cần']

results = {}
for sub, query, limit in QUERIES:
    key = f'{sub}__{query}'
    print(f'[{key}]', file=sys.stderr, flush=True)
    try:
        params = {'subreddit': sub, 'limit': limit, 'sort': 'desc', 'sort_type': 'created_utc',
                  'fields': 'title,score,num_comments,selftext,id,created_utc', 'title': query}
        url = 'https://arctic-shift.photon-reddit.com/api/posts/search?' + urllib.parse.urlencode(params)
        req = urllib.request.Request(url, headers={'User-Agent': UA})
        with urllib.request.urlopen(req, timeout=20) as r:
            d = json.loads(r.read())
        posts = d.get('data') or []
        posts.sort(key=lambda p: p.get('score', 0) + p.get('num_comments', 0), reverse=True)
        filtered = []
        for p in posts[:30]:
            title = (p.get('title') or '').lower()
            body = (p.get('selftext') or '').lower()
            combined = title + ' ' + body
            if any(k in combined for k in KEY_PHRASES) or p.get('num_comments', 0) >= 5 or p.get('score', 0) >= 10:
                filtered.append({'id': p.get('id'), 'title': p.get('title'),
                                 'score': p.get('score', 0), 'comments': p.get('num_comments', 0),
                                 'date': p.get('created_utc'), 'body': (p.get('selftext') or '')[:1200]})
        results[key] = filtered
        print(f'  {len(posts)} → {len(filtered)} relevant', file=sys.stderr)
    except Exception as e:
        print(f'  FAIL {str(e)[:80]}', file=sys.stderr)
        results[key] = []
    time.sleep(0.7)

with open('c:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings/raw/reddit/reddit_xpand.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=2)
print(f'\nDone. {len(results)} queries', file=sys.stderr)
