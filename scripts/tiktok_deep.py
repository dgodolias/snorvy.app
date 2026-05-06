#!/usr/bin/env python
"""Deep TikTok scan: top 3 videos + 30 comments per niche x country."""
import json, time, urllib.request, urllib.parse, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

UA = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'

QUERIES = [
    ('BR', 'manifestation', 'manifestacao'),
    ('BR', 'tarot', 'tarot'),
    ('BR', 'couple', 'app casal'),
    ('BR', 'selfcare', 'autocuidado'),
    ('BR', 'astrology', 'astrologia'),
    ('MX', 'manifestation', 'manifestacion'),
    ('MX', 'tarot', 'tarot'),
    ('MX', 'couple', 'app pareja'),
    ('MX', 'selfcare', 'autocuidado'),
    ('MX', 'astrology', 'astrologia'),
    ('TR', 'manifestation', 'manifestasyon'),
    ('TR', 'tarot', 'tarot'),
    ('TR', 'couple', 'cift uygulamasi'),
    ('TR', 'selfcare', 'oz bakim'),
    ('TR', 'astrology', 'astroloji'),
    ('ID', 'manifestation', 'manifestasi'),
    ('ID', 'tarot', 'tarot'),
    ('ID', 'couple', 'aplikasi pasangan'),
    ('ID', 'selfcare', 'perawatan diri'),
    ('ID', 'astrology', 'astrologi'),
]

def fetch_json(url):
    req = urllib.request.Request(url, headers={'User-Agent': UA})
    with urllib.request.urlopen(req, timeout=20) as r:
        return json.loads(r.read())

def search_videos(country, term, count=5):
    qs = urllib.parse.urlencode({'keywords': term, 'region': country, 'count': count})
    return fetch_json(f'https://www.tikwm.com/api/feed/search?{qs}')

def fetch_comments(video_id, count=30):
    fake_url = f'https://www.tiktok.com/@t/video/{video_id}'
    qs = urllib.parse.urlencode({'url': fake_url, 'count': count})
    return fetch_json(f'https://www.tikwm.com/api/comment/list?{qs}')

results = {}
for country, niche, term in QUERIES:
    key = f'{country}_{niche}'
    print(f'[{key}] term="{term}"...', file=sys.stderr, flush=True)
    try:
        sr = search_videos(country, term, count=5)
        if sr.get('code') != 0:
            print(f'  search FAIL code={sr.get("code")} msg={sr.get("msg")}', file=sys.stderr)
            continue
        videos = (sr.get('data') or {}).get('videos') or []
        out_videos = []
        for v in videos[:3]:
            vid = v.get('video_id')
            if not vid: continue
            try:
                cd = fetch_comments(vid)
                cmts = ((cd.get('data') or {}).get('comments') or [])[:30]
                comments_clean = [{
                    'text': (c.get('text') or '')[:300],
                    'likes': c.get('digg_count', 0),
                    'replies': c.get('reply_total', 0),
                    'region': (c.get('user') or {}).get('region', ''),
                } for c in cmts]
            except Exception as e:
                comments_clean = []
                print(f'  comments fail vid={vid}: {str(e)[:80]}', file=sys.stderr)
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
        results[key] = {'term': term, 'videos': out_videos}
        print(f'  ok ({len(out_videos)} videos, {sum(len(v["comments"]) for v in out_videos)} total comments)', file=sys.stderr)
    except Exception as e:
        print(f'  FAIL {str(e)[:120]}', file=sys.stderr)
    time.sleep(1.0)

with open('c:/Users/demosgod/Desktop/PROJECTS/playstore_app/tiktok_deep.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=2)
print(f'\nDone. {len(results)} cells, saved to tiktok_deep.json', file=sys.stderr)
