#!/usr/bin/env python
"""Extract themes from D2 comment trees."""
import json, sys, io, os, re
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

THREADS = {
    's8zghv':   ('Alternatives to quickbooks self employed?', 39, 61, 'r/smallbusiness'),
    '12gju8v':  ('Quickbooks Self Employed Alternative?', 25, 11, 'r/smallbusiness'),
    '162tyfn':  ('Quickbooks alternative for self employed l/sole proprietorship LLC?', 8, 26, 'r/smallbusiness'),
    '1ncy3h':   ('alternative to quickbooks?', 9, 14, 'r/Entrepreneur'),
    '1gswo3a':  ('Looking for an alternative to Quickbooks self employed', 6, 15, 'r/smallbusiness'),
    '1mu5cqm':  ('Bookkeeping for simple, solo Schedule C clients?', 24, 21, 'r/taxpros'),
}

ALT_APPS = ['wave', 'hurdlr', 'keeper tax', 'keeper', 'stride tax', 'stride',
            'freshbooks', 'freshbook', 'bookkeeper.com', 'bookkeeper',
            'xero', 'zoho', 'gnucash', 'manager.io', 'wave apps',
            'fyle', 'expensify', 'quickbooks online', 'qbo', 'bonsai',
            'mint', 'rocketmoney', 'honeybook', 'shoeboxed',
            'iprosper', 'ledger', 'simplifi']

DEMAND_PATTERNS = [
    r"i('?d| would) (gladly )?pay",
    r"willing to pay",
    r"i wish there",
    r"i('?m| am) looking for",
    r"there should be",
    r"someone (should|needs to) (build|make)",
    r"need(ed)? an? (app|tool|software) that",
    r"if (only )?there w(as|ere) an? (app|tool)",
    r"want(ed)? an? (app|tool|software)",
]

MIGRATION_PATTERNS = [
    r"(switch(ed|ing)?|migrat(ed|ing)|moved|moving|left) (from|away from) ([\w\.\s]{2,30})",
    r"(switch(ed|ing)?|migrat(ed|ing)|moved|moving) (to|over to) ([\w\.\s]{2,30})",
    r"(used to use|been using|was using) ([\w\.\s]{2,30})",
    r"(replaced|dumped|ditched|dropped) (qbse|quickbooks[\w\s]{0,20}|[\w\.\s]{2,30}) (with|for)",
    r"(now (i )?use|now using|currently use)",
]


def flatten(tree, out=None):
    if out is None:
        out = []
    if isinstance(tree, dict):
        if tree.get('kind') == 't1' and 'data' in tree:
            d = tree['data']
            out.append({'body': d.get('body', ''), 'score': d.get('score', 0),
                        'author': d.get('author', ''), 'id': d.get('id', '')})
            for r in d.get('replies', []) or []:
                flatten(r, out)
        elif 'data' in tree:
            for r in tree.get('data', []) or []:
                flatten(r, out)
        else:
            for v in tree.values():
                if isinstance(v, (dict, list)):
                    flatten(v, out)
    elif isinstance(tree, list):
        for item in tree:
            flatten(item, out)
    return out


def app_mentions(txt):
    t = txt.lower()
    found = set()
    for a in ALT_APPS:
        if re.search(r'\b' + re.escape(a) + r'\b', t):
            found.add(a)
    return found


def has_demand(txt):
    t = txt.lower()
    for p in DEMAND_PATTERNS:
        m = re.search(p, t)
        if m:
            return m.group(0)
    return None


def has_migration(txt):
    t = txt.lower()
    for p in MIGRATION_PATTERNS:
        m = re.search(p, t)
        if m:
            return m.group(0)
    return None


all_app_counts = {}
all_demand = []
all_migrations = []
top_per_thread = {}

for pid, (title, up, nc, sub) in THREADS.items():
    fp = f'findings/raw/reddit/d2_tree-{pid}.json'
    try:
        data = json.load(open(fp, encoding='utf-8'))
    except Exception as e:
        print(f"ERR {pid}: {e}")
        continue
    cmts = flatten(data)
    cmts = [c for c in cmts if c['body'] and c['body'] not in ('[deleted]', '[removed]')]
    cmts.sort(key=lambda x: x.get('score', 0) or 0, reverse=True)
    top_per_thread[pid] = {'title': title, 'sub': sub, 'up': up, 'nc': nc,
                            'top5': cmts[:5], 'all_count': len(cmts)}

    for c in cmts:
        b = c['body']
        apps = app_mentions(b)
        for a in apps:
            all_app_counts[a] = all_app_counts.get(a, 0) + 1
        d = has_demand(b)
        if d:
            all_demand.append({'pid': pid, 'sub': sub, 'score': c['score'], 'match': d, 'body': b[:400]})
        m = has_migration(b)
        if m and any(x in b.lower() for x in ['quickbook', 'qbse']):
            all_migrations.append({'pid': pid, 'score': c['score'], 'match': m, 'body': b[:400]})


# Print summary
print("=" * 80)
print("APP MENTIONS RANKED")
print("=" * 80)
for a, c in sorted(all_app_counts.items(), key=lambda x: -x[1]):
    print(f"  {c:>3}x  {a}")

print("\n" + "=" * 80)
print("TOP COMMENT PER THREAD")
print("=" * 80)
for pid, info in top_per_thread.items():
    print(f"\n[{pid}] {info['sub']} | {info['title']} ({info['up']}up {info['nc']}c, {info['all_count']} cmts fetched)")
    for i, c in enumerate(info['top5'][:3]):
        body = c['body'][:300].replace('\n', ' ')
        print(f"  #{i+1} ({c['score']}↑ /u/{c['author']}): {body}")

print("\n" + "=" * 80)
print(f"DEMAND STATEMENTS ({len(all_demand)})")
print("=" * 80)
for d in sorted(all_demand, key=lambda x: -x['score'])[:10]:
    body = d['body'].replace('\n', ' ')
    print(f"  [{d['score']}↑ {d['pid']}] match='{d['match']}': {body[:300]}")

print("\n" + "=" * 80)
print(f"MIGRATION NARRATIVES ({len(all_migrations)})")
print("=" * 80)
for m in sorted(all_migrations, key=lambda x: -x['score'])[:15]:
    body = m['body'].replace('\n', ' ')
    print(f"  [{m['score']}↑ {m['pid']}] match='{m['match']}': {body[:280]}")

# Save synthesis dump
out = {'app_counts': all_app_counts, 'top_per_thread': top_per_thread,
       'demand': all_demand, 'migrations': all_migrations}
with open('findings/raw/reddit/d2_themes_extracted.json', 'w', encoding='utf-8') as f:
    json.dump(out, f, indent=2, ensure_ascii=False, default=str)
print("\n\nWrote findings/raw/reddit/d2_themes_extracted.json")
