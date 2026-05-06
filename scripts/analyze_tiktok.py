#!/usr/bin/env python
"""Extract real user-voice from TikTok comments in target language."""
import json, sys, io, re
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

d = json.load(open('c:/Users/demosgod/Desktop/PROJECTS/playstore_app/tiktok_deep.json', encoding='utf-8'))

print("=" * 100)
print("TIKTOK COMMENTS — overview per cell")
print("=" * 100)

stats = []
for k, info in d.items():
    vids = info.get('videos', [])
    comments = []
    for v in vids:
        for c in v.get('comments', []):
            comments.append(c)
    n = len(comments)
    likes_total = sum(c.get('likes', 0) for c in comments)
    stats.append((k, len(vids), n, likes_total, info.get('term', ''), comments))
    print(f"  {k:25} videos={len(vids)} comments={n:>3} total_likes={likes_total:>5}  term={info.get('term','')!r}")

print()
print("=" * 100)
print("TOP-LIKED COMMENTS PER CELL (likely user voice)")
print("=" * 100)

# Pain/desire keywords
KEY = {
    'BR': ['queria', 'preciso', 'falta', 'odeio', 'horrível', 'péssimo', 'cadê', 'porque', 'qual app', 'quero', 'gostaria'],
    'MX': ['quiero', 'necesito', 'falta', 'odio', 'horrible', 'pésimo', 'porque', 'cuál app', 'quisiera', 'me gustaría'],
    'TR': ['istiyorum', 'lazım', 'olmuyor', 'berbat', 'kötü', 'nerede', 'hangi app', 'hangi uygulama', 'olsa', 'keşke'],
    'ID': ['mau', 'butuh', 'kurang', 'jelek', 'kenapa', 'aplikasi apa', 'sebaiknya', 'andai'],
}

for k, _, n, _, term, comments in stats:
    if n == 0: continue
    country = k.split('_')[0]
    keys = KEY.get(country, [])
    # Top by likes
    top = sorted(comments, key=lambda c: c.get('likes', 0), reverse=True)[:8]
    print(f"\n--- {k} (term={term!r}, {n} comments) ---")
    for c in top:
        text = c.get('text', '').replace('\n', ' ')[:250]
        likes = c.get('likes', 0)
        # Highlight user voice keywords
        flagged = any(kw in text.lower() for kw in keys)
        marker = '🔥' if flagged else '  '
        print(f"  {marker} [👍{likes:>4}] {text}")
