# richmenu — リッチメニュー（タブ1）

LINE公式アカウント「お店AI」のデフォルトリッチメニュー。8ボタン→postback `demo={key}`→ bot が `flex/{key}.flex.json` を返す。

- 画像: `tab1.png`（2500×1686・Pillow生成）
- サイズ: 上部ヘッダー 300px ＋ 4列×2段（各 625×693）
- 登録日: 2026-07-13 ／ 現在のrichMenuId: `richmenu-d5769cdce2f9398c5866ee663782204f`

## ボタン配置（postback）

| | 列1 | 列2 | 列3 | 列4 |
|---|---|---|---|---|
| 段1 | daily | monthly | invoice | shift_notice |
| 段2 | shift_request | attendance | review | map_rank |

## 再生成・再登録の手順

1. 画像を作り直す: `demo/omise-ai-demo/` で Pillow スクリプトを実行 → `richmenu/tab1.png` 更新。
2. 登録: `demo/ops/.env` の `LINE_OMISE_ACCESS_TOKEN` を使い、既存削除→作成→`api-data.line.me/.../content`へ画像POST→`/v2/bot/user/all/richmenu/{id}`でデフォルト設定。
   - APIホスト注意: 作成・デフォルトは `api.line.me`、画像アップロードは `api-data.line.me`。
   - postback は `data=demo={key}`。エリアは上記表の配置。

> 画像は公開repoに含む（メニュー画像のみ・秘密なし）。トークンは `demo/ops/.env`（gitignore）にのみ。

## ラベル（画像表示名 / postbackキー）
- 段1: 売上実績`daily` / PL`monthly` / 請求書登録`invoice` / シフト通知`shift_notice`
- 段2: シフト回収`shift_request` / 勤務実績`attendance` / 口コミ返信`review` / マップ順位`map_rank`
- 再生成: `python3 gen_tab1.py`（→ tab1.png）／再登録: `bash register.sh`（`.env`のトークン使用）
