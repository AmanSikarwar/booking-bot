#!/usr/bin/env bash
set -euo pipefail
URL=${SUPABASE_URL:-https://lscqahnqffcukyegjvpk.supabase.co}
KEY=${SUPABASE_PUBLISHABLE_KEY:-sb_publishable_fYpoT2raUr0QSOYkKn9DrQ_vue8vlM-}
TOKEN=$(curl -s -X POST "$URL/auth/v1/signup" -H "apikey: $KEY" -H "Content-Type: application/json" -d '{}' | python3 -c 'import sys,json;d=json.load(sys.stdin);print(d.get("access_token") or d, file=sys.stdout)')
case "$TOKEN" in ey*) echo "anon sign-in ok";; *) echo "anon sign-in failed: $TOKEN"; exit 1;; esac
CONV=$(uuidgen | tr A-Z a-z)
send() { curl -sN -X POST "$URL/functions/v1/chat" -H "apikey: $KEY" -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
  -d "{\"conversation_id\":\"$CONV\",\"client_message_id\":\"$1\",\"locale\":\"${3:-en}\",\"kind\":\"${4:-text}\",\"text\":\"$2\"}" -w '\nHTTP %{http_code}\n'; }
M1=$(uuidgen | tr A-Z a-z)
echo "--- search"; send $M1 "I want to check my thyroid" | grep -E "^event|HTTP|replay"
echo "--- replay"; send $M1 "I want to check my thyroid" | grep -E "^event|HTTP|replay"
echo "--- red flag"; send $(uuidgen | tr A-Z a-z) "seene mein dard ho raha hai" | grep -E "^event|HTTP"
echo "--- unauthorized"; curl -s -o /dev/null -w 'HTTP %{http_code}\n' -X POST "$URL/functions/v1/chat" -H "apikey: $KEY" -d '{}'
echo "--- head"; curl -s -o /dev/null -w 'HTTP %{http_code}\n' -I "$URL/functions/v1/chat" -H "apikey: $KEY"
