#!/usr/bin/env python
"""Phase 6 deep: fetch comment-trees for top engagement Reddit threads from existing findings."""
import json, time, urllib.request, urllib.parse, sys, io, os
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

UA = 'research-agent/1.0'
BASE = 'c:/Users/demosgod/Desktop/PROJECTS/playstore_app/findings/raw/reddit'

def safe_load(p):
    if not os.path.exists(p): return None
    try: return json.load(open(p, encoding='utf-8'))
    except: return None

# Pool all posts from existing reddit data
all_posts = []
for fname in os.listdir(BASE):
    if not fname.endswith('.json') or 'tree' in fname: continue
    d = safe_load(f'{BASE}/{fname}')
    if not d: continue
    if isinstance(d, dict):
        for key, val in d.items():
            if isinstance(val, list):
                for p in val:
                    if isinstance(p, dict) and p.get('id'):
                        all_posts.append({**p, '_source': fname, '_query': key})
    elif isinstance(d, list):
        for p in d:
            if isinstance(p, dict) and p.get('id'):
                all_posts.append({**p, '_source': fname})

# Dedupe by id
seen, unique = set(), []
for p in all_posts:
    if p['id'] not in seen:
        seen.add(p['id'])
        unique.append(p)

# Top 12 by engagement (score + comments) — but only those NOT already in tree files
existing_trees = {f.replace('tree-', '').replace('.json', '') for f in os.listdir(BASE) if f.startswith('tree-')}
candidates = [p for p in unique if p['id'] not in existing_trees]
candidates.sort(key=lambda p: (p.get('score', 0) or 0) + (p.get('comments', 0) or 0), reverse=True)
top = candidates[:12]

print(f'Pool: {len(unique)} unique posts, fetching trees for top {len(top)} (skip {len(existing_trees)} already done)', file=sys.stderr)
print(file=sys.stderr)

for p in top:
    pid = p['id']
    print(f"  [↑{p.get('score',0)} 💬{p.get('comments',0)}] {p.get('title','')[:80]}", file=sys.stderr)
    try:
        url = f'https://arctic-shift.photon-reddit.com/api/comments/tree?link_id={pid}&limit=100'
        req = urllib.request.Request(url, headers={'User-Agent': UA})
        with urllib.request.urlopen(req, timeout=20) as r:
            data = json.loads(r.read())
        with open(f'{BASE}/tree-{pid}.json', 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        comments_count = len(data.get('data', []))
        print(f'    saved tree ({comments_count} comments)', file=sys.stderr)
    except Exception as e:
        print(f'    FAIL {str(e)[:80]}', file=sys.stderr)
    time.sleep(1.0)

print(f'\nDone. Trees saved.', file=sys.stderr)
