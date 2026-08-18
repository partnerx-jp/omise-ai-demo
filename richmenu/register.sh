#!/usr/bin/env bash
# リッチメニュー(tab1)を再登録：既存削除→作成→画像アップロード→デフォルト設定
# 使い方: demo/omise-ai-demo/richmenu/ で  bash register.sh
set -euo pipefail
cd "$(dirname "$0")"
set -a; . ../../ops/.env; set +a       # LINE_OMISE_ACCESS_TOKEN
TOKEN="$LINE_OMISE_ACCESS_TOKEN"
API=https://api.line.me
# 既存リッチメニューを全削除（クリーンに）
for old in $(curl -s "$API/v2/bot/richmenu/list" -H "Authorization: Bearer $TOKEN" | python3 -c "import sys,json;print(' '.join(m['richMenuId'] for m in json.load(sys.stdin).get('richmenus',[])))"); do
  curl -s -X DELETE "$API/v2/bot/richmenu/$old" -H "Authorization: Bearer $TOKEN" >/dev/null && echo "deleted old: $old"
done
# 請求書登録はLIFF起動（invoice-send がオーナー側から画像送信）。LIFF登録後のURLを設定
INVOICE_SEND_LIFF_URL="${INVOICE_SEND_LIFF_URL:-__SET_AFTER_LIFF_REGISTER__}"
[ "$INVOICE_SEND_LIFF_URL" != "__SET_AFTER_LIFF_REGISTER__" ] || { echo "❌ INVOICE_SEND_LIFF_URL を設定してから実行（register-liff.sh invoice-send compact で取得）"; exit 1; }
export INVOICE_SEND_LIFF_URL
# 作成用JSON（invoice=uri(LIFF)・他7ボタン postback demo={key}）
python3 - > /tmp/richmenu_obj.json <<'PY'
import json, os
liff = os.environ["INVOICE_SEND_LIFF_URL"]
keys=[["daily","monthly","invoice","payment"],["reconcile","shift_notice","shift_request","review"]]
areas=[{"bounds":{"x":c*625,"y":300+r*693,"width":625,"height":693},
        "action":({"type":"uri","uri":liff} if k=="invoice" else {"type":"postback","data":f"demo={k}"})}
       for r,row in enumerate(keys) for c,k in enumerate(row)]
print(json.dumps({"size":{"width":2500,"height":1686},"selected":True,
                  "name":"tab1","chatBarText":"メニュー","areas":areas},ensure_ascii=False))
PY
RID=$(curl -s -X POST "$API/v2/bot/richmenu" -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d @/tmp/richmenu_obj.json | python3 -c "import sys,json;print(json.load(sys.stdin)['richMenuId'])")
echo "created: $RID"
curl -s -X POST "https://api-data.line.me/v2/bot/richmenu/$RID/content" -H "Authorization: Bearer $TOKEN" -H "Content-Type: image/png" --data-binary @tab1.png && echo "image uploaded"
curl -s -X POST "$API/v2/bot/user/all/richmenu/$RID" -H "Authorization: Bearer $TOKEN" && echo "set as default: $RID"
