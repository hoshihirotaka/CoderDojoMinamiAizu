# AGENTS.md

このリポジトリは「CoderDojo 南会津」のLPとDoorkeeper文面の運用を管理します。別PCで作業する人が迷わないよう、最低限のルールと作業手順をまとめています。

## 1. 主要ファイル
- `index.html`: LP本体
- `styles.css`: LPスタイル
- `assets/`: LP画像
- `content/doorkeeper-common.md`: Doorkeeper用の本文（イベント情報・参加条件・問い合わせなど）
- `content/doorkeeper-community.md`: Doorkeeper用のコミュニティ説明文
- `flyer-review/`: チラシ（画像/PDF）レビュー用の一時フォルダ

## 2. LPとDoorkeeperの関連付けルール
LPとDoorkeeperの内容は **同じ方針・同じ条件がズレないこと** を最優先にします。

### 同期対象（必ず合わせる）
- 参加対象・同伴条件
- 参加費・持ち物
- 参加方法（Doorkeeper申込み）
- よくある質問（LP側）と本文（Doorkeeper側）の矛盾

### 申込みリンク
- イベントページ（申込み直リンク）
  - `https://coderdojo-minamiaizu.doorkeeper.jp/events/194649`
- プロフィール/一覧ページ
  - `https://coderdojo-minamiaizu.doorkeeper.jp/`

### LPでの計測
- GA4: `G-DSETWZS3SZ`
- 申込みボタンのクリック計測: `apply_click`（`#apply-button`）

## 3. チラシ運用方針（Canva）
Canva本体は編集できないため、**レビュー・提案のみ**を行う。

### 運用手順
1. `flyer-review/` にPNGまたはPDFを置く
2. Codexが内容を確認し、`flyer-review/proposals.md` に提案を書く
3. 提案確認後、**PDF/画像と proposals.md は削除**（個人情報保護）
4. GitHubへは原則pushしない（必要なら事前に合意）

### 目的
- チラシ文言や構成の改善提案
- LP/Doorkeeperとの文言一貫性を担保

## 4. 文章トーンの指針
- 「教える」ではなく「一緒に作る」
- 失敗しても大丈夫、ぶつかって学ぶ
- 地域の大人が支える温かさ
- 広域地域のため送迎・親族サポートを歓迎

## 5. よく使う文言（最新方針）
### 同伴条件（LP/Doorkeeper共通）
小学生は保護者または親族の方の同伴をお願いします。おじいちゃん・おばあちゃんの同伴やお友達の親御様の見守りでも問題ありません。

### 友達参加の案内
お友達とのご参加も歓迎しております。遠方の方もいらっしゃると思いますので、お友達とのご参加は送迎していただける親御さんと一緒であれば問題ありません。お申し込みの際に人数を含めていただき、お名前も記載してください。

### 問い合わせ（Doorkeeper）
- メール: hitta.games@gmail.com
- 電話番号は防犯のためWeb上には記載しておりません。チラシをご確認ください。

## 6. 更新手順（ざっくり）
1. 変更箇所の意図を確認
2. LP/Doorkeeperの同期が必要か判断
3. 反映 → 目視確認
4. 必要ならコミット
5. pushは **事前合意がある場合のみ**

## 7. 注意事項
- 個人情報が含まれる可能性がある場合は、作業後に削除
- 変更内容はLPとDoorkeeperで齟齬が出ないよう必ず確認
