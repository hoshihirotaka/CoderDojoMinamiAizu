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
- イベントページ直リンクを使う（`/tickets/new` は付けない）
  - 第5回（2026-06-28）: `https://coderdojo-minamiaizu.doorkeeper.jp/events/197553`
  - 第6回（2026-07-26）: `https://coderdojo-minamiaizu.doorkeeper.jp/events/196200`
  - ~~第7回（2026-08-16）: `https://coderdojo-minamiaizu.doorkeeper.jp/events/198352`~~（**中止**。送り盆と重なるため）
  - 第7回（2026-09-27）: `https://coderdojo-minamiaizu.doorkeeper.jp/events/199000`（中止分を振り替え。回数は第7回のまま）
  - 第8回（2026-11-15）: `https://coderdojo-minamiaizu.doorkeeper.jp/events/199001`
    - ⚠️ **2026-08-24時点で未公開・会場申請中。確定していない。** **LPへの掲載・外部への日付告知はしないこと。** 確定後にこの注記を消す
- **開催は隔月程度のペース。** 2026年10月は会場と運営の都合により開催しない（意図的な判断であり、日程の漏れではない）
- LPからのリンクに付けるutm: `utm_source=lp&utm_medium=referral&utm_campaign=coderdojo`（`utm_medium=paid` は広告専用。LPでは使わない）
- DoorkeeperからLP（公式サイト）へのリンクは `utm_source=doorkeeper` ＋ 置き場所別のmedium（イベント本文: `utm_medium=event` / コミュニティ説明: `utm_medium=community`）＋ `utm_campaign=coderdojo`。テキストリンクのみ（バナーにしない）。アンカーテキストは「教室の様子・主催者の紹介は公式サイトへ」のように行き先の内容を書く
- **チラシ（紙）からのリンクに付けるutm**: `utm_source=flyer&utm_medium=print&utm_campaign=coderdojo`
  - ⚠️ **QRコードに埋め込むURLに付ける。印刷後は直せない。** チラシを作るたびに、QR生成前に必ず確認すること
  - チラシに文字でもURLを載せる場合、そちらは**utm無しの短いURL**にする（手打ち用。計測は諦める）
  - 配布先（学校／お店）でのutmの出し分けは**現時点では行わない**（2026-08-24判断。まずは付け忘れないことを優先）
  - **QRの飛び先はイベント個別ページではなく固定URLにする。** チラシは頻繁に刷れないため、1回のイベントで使い捨てにならないようにする
  - **未公開のイベントページをQRにしないこと。** 第8回（`events/199001`）は2026-08-24時点で404を返す（公開されるまで読み取った人がエラーになる）
  - 発行済みURL（そのままQRにできる。2026-08-24時点でいずれも200を確認）
    - 公式サイト（**推奨**）: `https://hoshihirotaka.github.io/CoderDojoMinamiAizu/?utm_source=flyer&utm_medium=print&utm_campaign=coderdojo`
    - Doorkeeperトップ: `https://coderdojo-minamiaizu.doorkeeper.jp/?utm_source=flyer&utm_medium=print&utm_campaign=coderdojo`
- プロフィール/一覧ページ
  - `https://coderdojo-minamiaizu.doorkeeper.jp/`

### LPでの計測
- GA4: `G-DSETWZS3SZ`（`<head>` で通常のasync読み込み。**遅延ロードに戻さないこと**。2026-08-20に戻した経緯は `HANDOFF-2026-08-20.md`）
- ページ内ナビのクリック計測: `nav_click`（`.site-nav a`／パラメータ `section` に遷移先アンカー名）
  - `section` は**GA4管理画面でカスタムディメンションに登録しないとレポートに出ない**（DebugView・リアルタイムでは登録前でも見える）
- 申込みボタンのクリック計測: `apply_click`（`.js-apply-button`）
  - **イベント名は変えないこと**（過去データとの連続性）
  - ⚠️ **開催情報を差し替えるときは、申込みボタンに `js-apply-button` を付け直すこと。** 2026-08-06に中止対応でクラスごと外し、8/24まで発火していなかった。クラスが無いとリスナーが1つも付かず、レポート上は「申込0件」と区別が付かない
- ナビ以外のボタンのクリック計測: `button_click`（`[data-track]`／パラメータ `button` に識別子）
  - 現在の対象: `hero_schedule` / `hero_join` / `hero_gallery` / `community_register`
  - 追加したいボタンには `data-track` 属性に識別子を入れるだけでよい
- Doorkeeper側の申込完了計測: `signup_complete`（**Doorkeeper側のプロパティ**／測定ID `G-BWCXQ6HMN7`）
  - GA4の「イベントを作成」で生成。条件は `event_name` = `page_view` かつ `page_location` が正規表現 `/tickets/[^/]+/completed` に一致
  - **ページビュー基準**なので完了ページの再読み込みでも加算される。**申込の実数はDoorkeeperの管理画面が正**。GA4で見るのは流入元別の内訳
- 広告: Google広告は使わない方針（`AW-` タグを入れない）。**Meta広告は出稿予定だがピクセル未導入**（出稿前に対応が必要）

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
