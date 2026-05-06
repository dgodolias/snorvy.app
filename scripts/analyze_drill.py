#!/usr/bin/env python
"""Analyze drill.json — cluster complaint themes per app."""
import json, sys, io, re
from collections import Counter
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

d = json.load(open('c:/Users/demosgod/Desktop/PROJECTS/playstore_app/drill.json', encoding='utf-8'))

# Theme categories with multilingual keywords
THEMES = {
    'pricing/billing': ['caro', 'expensive', 'cobr', 'paguei', 'estafa', 'fraude', 'reembolso', 'subscription', 'subscrip', 'pague',
                        'cobrança', 'pagado', 'üye', 'ücretl', 'ücret', 'kart bilgi', 'mahal', 'gratis', 'berlangganan'],
    'language': ['portugu', 'espanhol', 'türkçe', 'turkce', 'idioma', 'language', 'inglês', 'inglés', 'ingles',
                 'dil seçen', 'türkçesi', 'bahasa indonesia', 'in english only'],
    'crashes/bugs': ['trava', 'travar', 'crash', 'bug', 'bugs', 'tela branca', 'kasıyor', 'donuyor', 'erro', 'error',
                      'no funciona', 'não funciona', 'çalışmıyor', 'lento', 'slow', 'freezes'],
    'ads': ['anúncio', 'anuncio', 'ad ', 'ads', 'reklam', 'iklan', 'propaganda', 'publicidade', 'publicidad'],
    'privacy/permissions': ['privacy', 'datos', 'verileri', 'data', 'permis', 'izin', 'localización', 'localização', 'konum'],
    'location-tracking': ['gps', 'localização', 'localización', 'konum', 'location', 'lokasi'],
    'AI complaint': ['ia ', ' ai ', 'gerada', 'generada', 'generative', 'chatgpt', 'inteligencia artif', 'inteligência artif'],
    'IAP/locked features': ['premium', 'pago', 'pagar', 'plan', 'unlock', 'desbloque', 'kilitli', 'free version'],
    'inaccurate/wrong': ['errado', 'incorrecto', 'yanlış', 'wrong', 'inaccurate', 'mentira', 'falso', 'salah'],
    'support/refund': ['suporte', 'soporte', 'destek', 'support', 'reembolso', 'refund', 'iptal', 'cancel'],
}

def classify(text):
    text_lower = text.lower()
    hits = []
    for theme, kws in THEMES.items():
        for kw in kws:
            if kw in text_lower:
                hits.append(theme)
                break
    return hits

print("=" * 100)
print("DRILL RESULTS: 500 reviews per app, theme-clustered")
print("=" * 100)

for key, info in d.items():
    if 'error' in info:
        print(f"\n--- {key} ERROR: {info.get('error')}")
        continue
    print(f"\n=== {key} | {info['title']} ({info['installs']}) ===")
    print(f"  ⭐{info['score']:.2f} ({info['ratings']:,} ratings) | histogram: {info['histogram']}")
    print(f"  Pulled {info['total_reviews_pulled']} recent reviews → {info['low_reviews_count']} low ({info['low_reviews_pct']}%)")
    print(f"  IAP: {info.get('offersIAP')} {info.get('IAPRange') or ''} | adSupported: {info.get('adSupported')}")

    # Cluster themes
    theme_counter = Counter()
    quote_by_theme = {t: [] for t in THEMES}
    for r in info['low_reviews']:
        if not r.get('text'): continue
        themes = classify(r['text'])
        for t in themes:
            theme_counter[t] += 1
            quote_by_theme[t].append(r)
    print(f"\n  Theme distribution (out of {info['low_reviews_count']} low reviews):")
    for theme, n in theme_counter.most_common():
        pct = n / max(1, info['low_reviews_count']) * 100
        print(f"    {theme:25} {n:>3}  ({pct:.0f}%)")
    # Top quote per top 3 themes
    print(f"\n  Top complaints by theme (most upvoted):")
    for theme, n in theme_counter.most_common(4):
        sorted_q = sorted(quote_by_theme[theme], key=lambda r: r.get('thumbs', 0), reverse=True)
        for q in sorted_q[:2]:
            text = q['text'][:240].replace('\n', ' ')
            print(f"    [{theme}] [{q['score']}★ 👍{q.get('thumbs', 0)}] {text}")

print("\n" + "=" * 100)
print("VERDICT TABLE")
print("=" * 100)
print(f"\n{'cell':30} {'installs':>16} {'★':>5} {'1★%':>6} {'low_pct':>8} {'IAP':>10}")
print('-' * 100)
for key, info in d.items():
    if 'error' in info: continue
    h = info.get('histogram', {}) or {}
    s1r = (h.get('1', 0) / max(1, info.get('ratings', 1))) * 100
    print(f"{key:30} {info.get('installs', ''):>16} {info.get('score', 0):>5.2f} {s1r:>6.1f} {info.get('low_reviews_pct', 0):>8.1f} {(info.get('IAPRange') or '')[:30]:>10}")
