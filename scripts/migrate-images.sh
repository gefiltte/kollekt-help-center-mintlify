#!/bin/bash
set -e
BASE="https://raw.githubusercontent.com/gefiltte/kollekt-help-center-source/main"
DIRS=(
  "for-artists/admin/screenshots"
  "for-artists/chat/screenshots"
  "for-artists/direct-line/screenshots"
  "for-artists/home/screenshots"
  "for-artists/sharing/screenshots"
  "for-artists/user-profile/screenshots"
  "for-fans/chat/screenshots"
  "for-fans/direct-line/screenshots"
  "for-fans/home/screenshots"
  "for-fans/joining/screenshots"
  "for-fans/notifications/screenshots"
  "for-fans/profile/screenshots"
)
OK=0; FAIL=0
for d in "${DIRS[@]}"; do
  mkdir -p "$d"
  FILES=$(curl -sL "https://api.github.com/repos/gefiltte/kollekt-help-center-source/contents/${d}" | python3 -c "import sys,json; [print(f['name']) for f in json.load(sys.stdin) if f['name'].endswith('.png')]" 2>/dev/null)
  for f in $FILES; do
    if curl -sL --fail "${BASE}/${d}/${f}" -o "${d}/${f}"; then
      OK=$((OK+1))
    else
      FAIL=$((FAIL+1))
      echo "FAIL: ${d}/${f}"
    fi
  done
  echo "Done: $d ($OK total so far)"
done
echo "Downloaded $OK images ($FAIL failures)"
