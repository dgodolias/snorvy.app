#!/usr/bin/env bash
# TikTok hashtag volume scan: query challenge/info for each niche tag
# Output: name, user_count, view_count, view_count_billions
set -e
UA="Mozilla/5.0"
OUT=c:/Users/demosgod/Desktop/PROJECTS/playstore_app/tiktok_volumes.json
TAGS=(
  "manifestation" "manifesting" "369method"
  "habittracker" "habittracking" "streak"
  "periodtracker" "periodtracking"
  "journaling" "journal" "shadowwork"
  "meditation" "selfcare"
  "couplegoals" "lockerwidget" "noteit"
  "moodtracker" "mentalhealth"
  "workout" "gymtok" "fitness"
  "sleep" "sleepsounds"
  "astrology" "tarot" "numerology" "horoscope" "birthchart"
  "astrologia" "tarotreading" "horoscopo"
  "burc" "astroloji"
  "manifestacao" "manifestasyon" "manifestacion"
  "rastreadordehabitos" "aliskanliktakip" "habitostarcer"
)
echo "[" > "$OUT"
FIRST=1
for T in "${TAGS[@]}"; do
  R=$(curl -sS -A "$UA" "https://www.tikwm.com/api/challenge/info?challenge_name=$T" 2>/dev/null || echo '{}')
  CODE=$(echo "$R" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('code',-1))" 2>/dev/null || echo "-1")
  if [ "$CODE" = "0" ]; then
    NAME=$(echo "$R" | python -c "import sys,json; d=json.load(sys.stdin); print(d['data'].get('cha_name',''))")
    USERS=$(echo "$R" | python -c "import sys,json; d=json.load(sys.stdin); print(d['data'].get('user_count',0))")
    VIEWS=$(echo "$R" | python -c "import sys,json; d=json.load(sys.stdin); print(d['data'].get('view_count',0))")
    if [ $FIRST -eq 0 ]; then echo "," >> "$OUT"; fi
    FIRST=0
    echo "  {\"tag\":\"$T\",\"name\":\"$NAME\",\"users\":$USERS,\"views\":$VIEWS}" >> "$OUT"
    echo "$T: $USERS users, $(printf '%.2f' $(echo "$VIEWS/1000000000" | bc -l)) B views" >&2
  else
    echo "$T: not found" >&2
  fi
  sleep 0.5
done
echo "" >> "$OUT"
echo "]" >> "$OUT"
echo "Done. Results in $OUT" >&2
