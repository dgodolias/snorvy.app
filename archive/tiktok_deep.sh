#!/usr/bin/env bash
# Deep TikTok scan: for each (niche × country language), get top 5 videos + 30 comments each
set -e
UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
OUT=c:/Users/demosgod/Desktop/PROJECTS/playstore_app/tiktok_deep.json
echo "{" > "$OUT"

# (country_code,language_keyword) pairs
declare -A QUERIES=(
  ["BR_manifestation"]="manifestacao"
  ["BR_tarot"]="tarot"
  ["BR_couple"]="app casal"
  ["BR_selfcare"]="autocuidado"
  ["BR_astrology"]="astrologia"
  ["MX_manifestation"]="manifestacion"
  ["MX_tarot"]="tarot"
  ["MX_couple"]="app pareja"
  ["MX_selfcare"]="autocuidado"
  ["MX_astrology"]="astrologia"
  ["TR_manifestation"]="manifestasyon"
  ["TR_tarot"]="tarot"
  ["TR_couple"]="cift uygulamasi"
  ["TR_selfcare"]="oz bakim"
  ["TR_astrology"]="astroloji"
  ["ID_manifestation"]="manifestasi"
  ["ID_tarot"]="tarot"
  ["ID_couple"]="aplikasi pasangan"
  ["ID_selfcare"]="perawatan diri"
  ["ID_astrology"]="astrologi"
)

FIRST=1
for KEY in "${!QUERIES[@]}"; do
  COUNTRY="${KEY%%_*}"
  NICHE="${KEY##*_}"
  TERM="${QUERIES[$KEY]}"
  echo "[$KEY] ($TERM)..." >&2

  # 1. Search videos
  VIDEOS=$(curl -sS -A "$UA" --data-urlencode "keywords=$TERM" -G \
    "https://www.tikwm.com/api/feed/search?region=$COUNTRY&count=5" 2>/dev/null || echo '{}')

  CODE=$(echo "$VIDEOS" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('code',-1))" 2>/dev/null || echo "-1")
  if [ "$CODE" != "0" ]; then
    echo "  search FAIL" >&2
    sleep 1
    continue
  fi

  # Extract top video IDs and titles via python (handle UTF-8)
  python <<PYEOF >> "$OUT"
import sys, json, urllib.request, time
data = $VIDEOS
videos = (data.get('data') or {}).get('videos') or []
top = videos[:3]  # top 3 to be gentle on rate limit
out_videos = []
for v in top:
  vid = v.get('video_id')
  title = (v.get('title') or '')[:200]
  views = v.get('play_count', 0)
  digg = v.get('digg_count', 0)
  comm = v.get('comment_count', 0)
  region = v.get('region', '')
  uniq = (v.get('author') or {}).get('unique_id', '')

  # Fetch comments
  try:
    url = f'https://www.tikwm.com/api/comment/list?url=https%3A%2F%2Fwww.tiktok.com%2F%40t%2Fvideo%2F{vid}&count=30'
    req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
    with urllib.request.urlopen(req, timeout=15) as r:
      cd = json.loads(r.read())
    cmts = ((cd.get('data') or {}).get('comments') or [])[:30]
    sample = [{'text': (c.get('text') or '')[:300], 'likes': c.get('digg_count', 0), 'replies': c.get('reply_total', 0), 'region': (c.get('user') or {}).get('region', '')} for c in cmts]
  except Exception as e:
    sample = []
  out_videos.append({
    'video_id': vid, 'title': title, 'views': views, 'likes': digg,
    'comment_count': comm, 'region': region, 'author': uniq,
    'comments': sample,
  })
  time.sleep(0.5)

prefix = ',' if not $FIRST else ''
print(prefix + '"$KEY": ' + json.dumps({'term': '$TERM', 'videos': out_videos}, ensure_ascii=False))
PYEOF
  FIRST=0
  sleep 1
done

echo "}" >> "$OUT"
echo "Done. Saved to $OUT" >&2
