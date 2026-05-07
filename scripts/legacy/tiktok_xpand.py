#!/usr/bin/env python
"""Phase 12: TikTok hashtags + comments for new niches/countries."""
import json, time, urllib.request, urllib.parse, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')
UA = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'

NEW_TAGS = [
    # Recipes
    'cooking','recipes','recipevideos','easyrecipes','cookingtips','foodtok',
    'receitas','recetas','yemektarifi','resepmasakan',
    # Photo/video editing
    'photoediting','capcut','videoediting','reels','editingtutorial',
    # Kids
    'parenting','toddlers','newparent','babyactivities',
    # Finance
    'personalfinance','financetips','budgeting','moneytips',
    'financaspessoais','finanzaspersonales','kisiselfinans','keuanganpribadi',
    # Dating
    'datingtips','onlinedating','tinder','bumble',
    # Language learning
    'languagelearning','duolingo','spanishlanguage','englishlearning','ingilizceogren',
    # Arabic content tags
    'تطبيقات','الأبراج','تاروت',
]

def fetch_json(url):
    req = urllib.request.Request(url, headers={'User-Agent': UA})
    with urllib.request.urlopen(req, timeout=20) as r:
        return json.loads(r.read())

print('=== Phase 12.1: TikTok hashtag volumes ===', file=sys.stderr)
hashtags = {}
for tag in NEW_TAGS:
    try:
        d = fetch_json(f'https://www.tikwm.com/api/challenge/info?challenge_name={tag}')
        if d.get('code') == 0 and d.get('data'):
            info = d['data']
            hashtags[tag] = {'cha_name': info.get('cha_name'),
                             'user_count': info.get('user_count', 0),
                             'view_count': info.get('view_count', 0)}
            print(f"  {tag:25} {info.get('user_count', 0)/1e6:>8.2f}M users  {info.get('view_count', 0)/1e9:>8.2f}B views", file=sys.stderr)
    except Exception as e:
        print(f"  {tag:25} fail {str(e)[:50]}", file=sys.stderr)
    time.sleep(0.4)

with open('c:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings/raw/tiktok/tiktok_xpand_hashtags.json', 'w', encoding='utf-8') as f:
    json.dump(hashtags, f, ensure_ascii=False, indent=2)

print('\n=== Phase 12.2: TikTok comments for high-priority new cells ===', file=sys.stderr)
NEW_QUERIES = [
    # Top new niches in BR/MX/TR
    ('BR', 'recipes', 'receita facil'), ('MX', 'recipes', 'recetas faciles'),
    ('TR', 'recipes', 'kolay yemek'), ('ID', 'recipes', 'resep mudah'),
    ('BR', 'finance', 'controle gastos'), ('MX', 'finance', 'controlar gastos'),
    ('TR', 'finance', 'butce takip'), ('ID', 'finance', 'atur keuangan'),
    ('BR', 'language', 'aprender ingles'), ('MX', 'language', 'aprender ingles'),
    ('TR', 'language', 'ingilizce ogren'), ('ID', 'language', 'belajar inggris'),
    # Arab markets
    ('SA', 'astrology', 'الأبراج'), ('EG', 'astrology', 'الأبراج'),
    ('SA', 'tarot', 'تاروت'), ('AE', 'selfcare', 'العناية بالنفس'),
    # Thailand
    ('TH', 'astrology', 'ดูดวง'), ('TH', 'tarot', 'ทาโรต์'),
]

comments_data = {}
for country, niche, term in NEW_QUERIES:
    key = f'{country}_{niche}'
    print(f'[{key}] {term}', file=sys.stderr, flush=True)
    try:
        qs = urllib.parse.urlencode({'keywords': term, 'region': country, 'count': 5})
        sr = fetch_json(f'https://www.tikwm.com/api/feed/search?{qs}')
        if sr.get('code') != 0:
            print(f'  search fail', file=sys.stderr); continue
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
                comments_clean = [{'text': (c.get('text') or '')[:300],
                                   'likes': c.get('digg_count', 0),
                                   'replies': c.get('reply_total', 0),
                                   'region': (c.get('user') or {}).get('region', '')} for c in cmts]
            except Exception:
                comments_clean = []
            out_videos.append({'video_id': vid, 'title': (v.get('title') or '')[:300],
                               'views': v.get('play_count', 0), 'likes': v.get('digg_count', 0),
                               'comment_count': v.get('comment_count', 0),
                               'region': v.get('region', ''),
                               'author': (v.get('author') or {}).get('unique_id', ''),
                               'comments': comments_clean})
            time.sleep(0.5)
        comments_data[key] = {'term': term, 'videos': out_videos}
        total_cmts = sum(len(v['comments']) for v in out_videos)
        print(f'  {len(out_videos)} videos, {total_cmts} comments', file=sys.stderr)
    except Exception as e:
        print(f'  FAIL {str(e)[:80]}', file=sys.stderr)
    time.sleep(0.8)

with open('c:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings/raw/tiktok/tiktok_xpand_deep.json', 'w', encoding='utf-8') as f:
    json.dump(comments_data, f, ensure_ascii=False, indent=2)
print(f'\nDone. {len(hashtags)} tags, {len(comments_data)} cells', file=sys.stderr)
