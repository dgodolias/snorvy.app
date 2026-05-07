#!/usr/bin/env python
"""Phase 1.5 + 5: TikTok hashtag volume for new niches + deep comments per cell."""
import json, time, urllib.request, urllib.parse, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

UA = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'

# NEW hashtags to check
NEW_TAGS = [
    'diario', 'journaling', 'bujo', 'bulletjournal',
    'meditacao', 'meditacion', 'meditasyon', 'meditasi',
    'mindfulness', 'mindfullife',
    'sono', 'uyku', 'tidur', 'sleeptok', 'sleepproblems',
    'treino', 'entrenamiento', 'antrenman', 'olahraga', 'workouts',
    'tuvi', 'horoskop',  # Vietnam astrology
]

def fetch_json(url):
    req = urllib.request.Request(url, headers={'User-Agent': UA})
    with urllib.request.urlopen(req, timeout=20) as r:
        return json.loads(r.read())

# Fetch hashtag volumes
print('=== Phase 1.5: TikTok hashtag volumes ===', file=sys.stderr)
hashtags = {}
for tag in NEW_TAGS:
    try:
        d = fetch_json(f'https://www.tikwm.com/api/challenge/info?challenge_name={tag}')
        if d.get('code') == 0 and d.get('data'):
            info = d['data']
            hashtags[tag] = {
                'cha_name': info.get('cha_name'),
                'user_count': info.get('user_count', 0),
                'view_count': info.get('view_count', 0),
            }
            print(f"  {tag:25} {info.get('user_count', 0)/1e6:>8.2f}M users  {info.get('view_count', 0)/1e9:>8.2f}B views", file=sys.stderr)
        else:
            print(f"  {tag:25} not found", file=sys.stderr)
    except Exception as e:
        print(f"  {tag:25} fail {str(e)[:50]}", file=sys.stderr)
    time.sleep(0.5)

with open('c:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings/raw/tiktok/tiktok_new_hashtags.json', 'w', encoding='utf-8') as f:
    json.dump(hashtags, f, ensure_ascii=False, indent=2)
print(f'\nSaved {len(hashtags)} hashtag entries\n', file=sys.stderr)

# Phase 5: deep comment scan for new niche × country combos
print('=== Phase 5: TikTok comments for new cells ===', file=sys.stderr)
NEW_QUERIES = [
    # New niches × existing countries
    ('BR', 'journaling', 'diario'),
    ('BR', 'meditation', 'meditacao'),
    ('BR', 'sleep', 'sono'),
    ('BR', 'fitness', 'treino'),
    ('MX', 'journaling', 'diario personal'),
    ('MX', 'meditation', 'meditacion'),
    ('MX', 'sleep', 'dormir'),
    ('MX', 'fitness', 'entrenamiento'),
    ('TR', 'journaling', 'gunluk'),
    ('TR', 'meditation', 'meditasyon'),
    ('TR', 'sleep', 'uyku'),
    ('TR', 'fitness', 'antrenman'),
    ('ID', 'journaling', 'jurnal'),
    ('ID', 'meditation', 'meditasi'),
    ('ID', 'sleep', 'tidur'),
    ('ID', 'fitness', 'olahraga'),
    # New countries × existing niches
    ('VN', 'astrology', 'tu vi'),
    ('VN', 'tarot', 'tarot'),
    ('VN', 'couple', 'cap doi'),
    ('PH', 'astrology', 'horoscope'),
    ('PH', 'tarot', 'tarot'),
    ('PH', 'couple', 'couple app'),
]

comments_data = {}
for country, niche, term in NEW_QUERIES:
    key = f'{country}_{niche}'
    print(f'[{key}] term="{term}"...', file=sys.stderr, flush=True)
    try:
        qs = urllib.parse.urlencode({'keywords': term, 'region': country, 'count': 5})
        sr = fetch_json(f'https://www.tikwm.com/api/feed/search?{qs}')
        if sr.get('code') != 0:
            print(f'  search fail', file=sys.stderr)
            continue
        videos = (sr.get('data') or {}).get('videos') or []
        out_videos = []
        for v in videos[:3]:
            vid = v.get('video_id')
            if not vid: continue
            try:
                fake_url = f'https://www.tiktok.com/@t/video/{vid}'
                qs2 = urllib.parse.urlencode({'url': fake_url, 'count': 30})
                cd = fetch_json(f'https://www.tikwm.com/api/comment/list?{qs2}')
                cmts = ((cd.get('data') or {}).get('comments') or [])[:30]
                comments_clean = [{
                    'text': (c.get('text') or '')[:300],
                    'likes': c.get('digg_count', 0),
                    'replies': c.get('reply_total', 0),
                    'region': (c.get('user') or {}).get('region', ''),
                } for c in cmts]
            except Exception:
                comments_clean = []
            out_videos.append({
                'video_id': vid,
                'title': (v.get('title') or '')[:300],
                'views': v.get('play_count', 0),
                'likes': v.get('digg_count', 0),
                'comment_count': v.get('comment_count', 0),
                'region': v.get('region', ''),
                'author': (v.get('author') or {}).get('unique_id', ''),
                'comments': comments_clean,
            })
            time.sleep(0.6)
        comments_data[key] = {'term': term, 'videos': out_videos}
        total_cmts = sum(len(v['comments']) for v in out_videos)
        print(f'  ok ({len(out_videos)} videos, {total_cmts} comments)', file=sys.stderr)
    except Exception as e:
        print(f'  FAIL {str(e)[:80]}', file=sys.stderr)
    time.sleep(1.0)

with open('c:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings/raw/tiktok/tiktok_new_deep.json', 'w', encoding='utf-8') as f:
    json.dump(comments_data, f, ensure_ascii=False, indent=2)
print(f'\nDone. {len(comments_data)} cells saved\n', file=sys.stderr)
