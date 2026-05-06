#!/usr/bin/env bash
# Deep Reddit scan via Arctic Shift archive
# Pull recent posts from niche subreddits + search for app-related posts in country subs
set -e
UA="research-agent/1.0"
OUT=c:/Users/demosgod/Desktop/PROJECTS/playstore_app/reddit_deep.json
echo "{" > "$OUT"

FIRST=1

# Niche-specific subreddits (English) — find recent posts mentioning "app"
NICHE_SUBS=(
  "manifestation"
  "Tarot"
  "astrology"
  "witchcraft"
  "WitchesVsPatriarchy"
  "selfimprovement"
  "GetMotivated"
  "selfcare"
  "BabyBumps"  # tangentially relevant for couple/period stuff
  "SomebodyMakeThis"
  "AppIdeas"
)

for SUB in "${NICHE_SUBS[@]}"; do
  echo "[niche/$SUB] fetching app posts..." >&2
  RES=$(curl -sS -A "$UA" \
    "https://arctic-shift.photon-reddit.com/api/posts/search?subreddit=$SUB&title=app&limit=50&sort=desc&sort_type=created_utc&fields=title,score,num_comments,selftext,id,created_utc" 2>/dev/null || echo '{"data":[]}')

  python <<PYEOF >> "$OUT"
import sys, json
prefix = ',' if not $FIRST else ''
data = $RES
posts = data.get('data') or []
# Filter posts that look like requests or pain points
key_phrases = ['wish', 'looking for', 'need', 'recommend', 'best app', 'is there', 'anyone know', 'hate', 'frustrating', 'missing', 'why no', 'why does', 'should', 'help me find']
filtered = []
for p in posts:
  title = (p.get('title') or '').lower()
  body = (p.get('selftext') or '').lower()
  combined = title + ' ' + body
  hit = any(k in combined for k in key_phrases)
  if hit or p.get('num_comments', 0) >= 3:
    filtered.append({
      'id': p.get('id'),
      'title': p.get('title'),
      'score': p.get('score', 0),
      'comments': p.get('num_comments', 0),
      'date': p.get('created_utc'),
      'body': (p.get('selftext') or '')[:500],
    })
print(prefix + '"niche_$SUB": ' + json.dumps(filtered, ensure_ascii=False))
PYEOF
  FIRST=0
  sleep 1
done

# Country-specific subreddits — search for "app" mentions
COUNTRY_SUBS=(
  "brasil"
  "brasilivre"
  "mexico"
  "Turkey"
  "indonesia"
)

for SUB in "${COUNTRY_SUBS[@]}"; do
  echo "[country/$SUB] fetching..." >&2
  RES=$(curl -sS -A "$UA" \
    "https://arctic-shift.photon-reddit.com/api/posts/search?subreddit=$SUB&title=app&limit=50&sort=desc&sort_type=created_utc&fields=title,score,num_comments,selftext,id,created_utc" 2>/dev/null || echo '{"data":[]}')

  python <<PYEOF >> "$OUT"
import sys, json
prefix = ',' if not $FIRST else ''
data = $RES
posts = data.get('data') or []
filtered = []
for p in posts[:30]:
  filtered.append({
    'id': p.get('id'),
    'title': p.get('title'),
    'score': p.get('score', 0),
    'comments': p.get('num_comments', 0),
    'date': p.get('created_utc'),
    'body': (p.get('selftext') or '')[:300],
  })
print(prefix + '"country_$SUB": ' + json.dumps(filtered, ensure_ascii=False))
PYEOF
  FIRST=0
  sleep 1
done

echo "}" >> "$OUT"
echo "Done. Saved to $OUT" >&2
