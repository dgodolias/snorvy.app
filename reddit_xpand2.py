#!/usr/bin/env python
"""More Reddit deep — adjacent niche subs not yet covered."""
import json, time, urllib.request, urllib.parse, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')
UA = 'research-agent/1.0'

QUERIES = [
    # Vacuum/post-incumbent topics
    ('AskTurkey', 'fal', 50),
    ('Turkey', 'kahve falı', 30),
    ('Turkey', 'tarot', 30),
    ('Turkey', 'love8', 50),
    ('Turkey', 'çift uygulaması', 30),
    # Brazilian astro/manifestation deeper
    ('astrologia', 'app', 50),
    ('LeideAtraçao', 'app', 30),
    # Mexican alternatives
    ('mexico', 'astrologia', 30),
    ('mexico', 'manifestacion', 30),
    # MENA dating (research direction 2)
    ('exmuslim', 'dating', 30),
    ('saudiarabia', 'dating', 30),
    ('UAE', 'married', 30),
    ('egypt', 'app dating', 30),
    # Habit / wellness adjacency
    ('selfimprovement', 'habit', 50),
    ('GetMotivated', 'streak', 30),
    # Indonesian/Vietnamese
    ('indonesia', 'aplikasi pacar', 30),
    ('VietNam', 'tinder', 30),
    ('VietNam', 'cap doi', 20),
]

KEY_PHRASES = ['wish','looking for','need','recommend','best app','is there','hate','frustrating','missing',
               'should','help me find','app that','i want','ideal app','free app','better than',
               'queria','preciso','procurando','falta','busco','necesito','quisiera',
               'önerisi','arıyorum','olsa','keşke','daha iyi','cari','butuh','rekomendasi',
               'tìm','cần','muốn']

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
            if any(k in combined for k in KEY_PHRASES) or p.get('num_comments', 0) >= 3 or p.get('score', 0) >= 5:
                filtered.append({'id': p.get('id'), 'title': p.get('title'),
                                 'score': p.get('score', 0), 'comments': p.get('num_comments', 0),
                                 'date': p.get('created_utc'), 'body': (p.get('selftext') or '')[:1200]})
        results[key] = filtered
        print(f'  {len(posts)} -> {len(filtered)} relevant', file=sys.stderr)
    except Exception as e:
        print(f'  FAIL {str(e)[:80]}', file=sys.stderr)
        results[key] = []
    time.sleep(0.7)

with open('c:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings/raw/reddit/reddit_xpand2.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=2)
print(f'\nDone. {len(results)} queries', file=sys.stderr)
