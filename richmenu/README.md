# richmenu — リッチメニュー（タブ1）

LINE公式アカウント「お店AI」のデフォルトリッチメニュー。8ボタン→postback `demo={key}`→ bot が `flex/{key}.flex.json` を返す。

- 画像: `tab1.png`（2500×1686・Pillow生成）
- サイズ: 上部ヘッダー 300px ＋ 4列×2段（各 625×693）
- 登録日: 2026-07-13（初版）／ 2026-07-14 8機能を差し替え（勤務実績・マップ順位を外し、入金情報登録・売上照合チェックを追加）
- 現在のrichMenuId: `richmenu-b5744e32a5d5071e5d0e1dd4e054494b`（2026-07-14 8機能版・デフォルト設定済）

## ボタン配置（postback）

| | 列1 | 列2 | 列3 | 列4 |
|---|---|---|---|---|
| 段1 | daily | monthly | invoice | payment |
| 段2 | reconcile | shift_notice | shift_request | review |

## 再生成・再登録の手順

1. 画像を作り直す: `demo/omise-ai-demo/` で Pillow スクリプトを実行 → `richmenu/tab1.png` 更新。
2. 登録: `demo/ops/.env` の `LINE_OMISE_ACCESS_TOKEN` を使い、既存削除→作成→`api-data.line.me/.../content`へ画像POST→`/v2/bot/user/all/richmenu/{id}`でデフォルト設定。
   - APIホスト注意: 作成・デフォルトは `api.line.me`、画像アップロードは `api-data.line.me`。
   - postback は `data=demo={key}`。エリアは上記表の配置。

> 画像は公開repoに含む（メニュー画像のみ・秘密なし）。トークンは `demo/ops/.env`（gitignore）にのみ。

## ラベル（画像表示名 / postbackキー）
- 段1: 売上実績`daily` / PL速報`monthly` / 請求書登録`invoice` / 入金情報登録`payment`
- 段2: 売上照合チェック`reconcile` / 翌日シフト通知`shift_notice` / シフト回収`shift_request` / 口コミ通知`review`
- 各キーは `flex/{key}.flex.json` を返す。承認ボタン付き（`payment`/`reconcile`/`invoice`）は postback `demo={key}&act=done` → `flex/{key}_done.flex.json`。bot(n8n)は汎用取得なので**キー追加でbotコード変更は不要**。
- 外した機能（`attendance`＝勤務実績 / `map_rank`＝マップ順位）の flex・LIFF は削除せず残置（将来の別タブ用）。
- 再生成: `python3 gen_tab1.py`（→ tab1.png）／再登録: `bash register.sh`（`.env`のトークン使用）
