# 考えなければいけないこと

## 参考

非常に参考になるので必ず読む
`https://blog.father.gedow.net/2023/10/23/aurora-migration-tips/#note03`

AWS公式の動画
`https://www.youtube.com/watch?v=k_pnnwedtwU`

ほか、事例

- `https://tech.enigmo.co.jp/entry/2021/12/24/100000`
- `https://qiita.com/hmatsu47/items/23e2f0b36ab46234b9db`
- `https://chulip.org/entry/2023/04/19/211347`

ありったけの事例を探してほしい

## そもそもDMS以外の選択肢があるか

- DMSは有力だが、参考リンクのとおり、DMS以外にもバイナリログレプリケーションやストアドプロシージャを使った手法を検討してほしい
- 後述するが、DMSの制約事項が完全にクリアできるか現状不透明なため、もっと楽で安全な方法があれば採用したい
- 現在のソースバージョン(8.0.13)からターゲットバージョン（8.0.28）で利用できる機能である必要がある

バイナリログレプリケーション
`https://docs.aws.amazon.com/ja_jp/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Replication.MySQL.html`

## DMS制約事項

`https://docs.aws.amazon.com/ja_jp/dms/latest/userguide/CHAP_Source.MySQL.html#CHAP_Source.MySQL.Limitations`

- あらゆる制約事項を洗い出すこと
- とくに型については注意事項が多い、問題が起こる可能性が高い
- 軽く見たところ、すべてが怪しいがとくに
  - パーティション作成のDDL
  - インデックス、外部キー、カスケード更新、または削除が移行されない
- ここでもバージョンについて必ず考慮すること

ソースとしての制約
`https://docs.aws.amazon.com/ja_jp/dms/latest/userguide/CHAP_Source.MySQL.html`

ターゲットとしての制約
`https://docs.aws.amazon.com/ja_jp/dms/latest/userguide/CHAP_Target.MySQL.html`

## 現環境の考慮

- グループレプリケーションを組んでいる環境でリードレプリカをレプリケーションのソースとして利用したいが、これがそもそも可能なのか
- どのレプリケーション手法にせよ、必ず考慮すること

## バージョンの考慮

- 何をするにも必ずバージョンを考慮した想定をすること

## 手順

- S-in時にオンプレ環境でバッチ処理が動いていた場合を考慮する
- 切り戻し時にはオンプレ側でグループレプリを組んでいるDBのプライマリ機をターゲットとして指定する必要があるのではないか
  - よって、ソースとターゲットをひっくり返すだけではダメ
  - 非同期レプリケーション（ソースに負荷がかからない）であれば、初期移行時からソースをプライマリ機に指定するのでも良い気がする
- 切り戻し時には、オンプレ側のMySQLのバージョンを上げておかなければいけないのではないか（事前に8.0.28でサーバ構築しておく必要があるのでは？）
