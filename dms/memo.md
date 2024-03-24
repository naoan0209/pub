# 考えなければいけないこと

## 参考

非常に参考になるので必ず読む
`https://blog.father.gedow.net/2023/10/23/aurora-migration-tips/#note03`

AWS公式の動画
`https://www.youtube.com/watch?v=k_pnnwedtwU`

BlackBelt
`https://www.youtube.com/watch?v=Od83ySfrzGc`

AWS SCT と AWS DMS を使ってMySQLから Amazon Aurora に移行する方法
`https://aws.amazon.com/jp/blogs/news/migrating-from-mysql-to-amazon-aurora-using-aws-sct-and-aws-dms/`

DMSでバージョン互換性の問題が発生したときでも、SCTと組み合わせることで移行可能になるケースがあるとのこ

## 根本的な話

- 基本的にはmysqldumpなどのDBDSネイティブなツールを利用することが推奨されている
- 口述するが、そもそもDMSではなくmysqldumpとバイナリログレプリケーションの組み合わせの方がいいのかもしれない

ほか、事例

- `https://tech.enigmo.co.jp/entry/2021/12/24/100000`
- `https://qiita.com/hmatsu47/items/23e2f0b36ab46234b9db`
- `https://chulip.org/entry/2023/04/19/211347`

ありったけの事例を探してほしい

## Database Freedom

- 無料でデータベース移行をサポートしてくれるらしい
`https://aws.amazon.com/jp/solutions/databasemigrations/database-freedom/`

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
- データ検証の機能は非常に強力なので利用したい、ソースに負荷がかかるのがネック

ソースとしての制約
`https://docs.aws.amazon.com/ja_jp/dms/latest/userguide/CHAP_Source.MySQL.html`

ターゲットとしての制約
`https://docs.aws.amazon.com/ja_jp/dms/latest/userguide/CHAP_Target.MySQL.html`

## 現環境の考慮

- 何をするにも必ずバージョンを考慮した想定をすること
- グループレプリケーションを組んでいる環境でリードレプリカをレプリケーションのソースとして利用したいが、これがそもそも可能なのか
- どのレプリケーション手法にせよ、バージョンとグループレプリケーションについて必ず考慮すること、ほかにもあるかもしれない


## 手順

- S-in時にオンプレ環境でバッチ処理が動いていた場合、以降に影響がある可能性がある
- またAWS環境でのバッチは事前に全て止めておくことが望ましい

## 切り戻し

- 切り戻し時はオンプレ側のグループレプリのプライマリ機をターゲットとして指定する必要があるのではないか
  - 通常の移行時はリードレプリカ機をソースとして指定している想定となるが、切り戻しのタイミングではプライマリを指定する必要があるとすると、単純にソースとターゲットをひっくり返すだけではダメ
  - 非同期レプリケーション（ソースに負荷がかからない）であれば、初期移行時からソースをプライマリ機に指定するのでも良い気がする
- 切り戻し時には、オンプレ側のMySQLのバージョンを上げておかなければいけないのではないか（事前に8.0.28でサーバ構築しておく必要があるのでは？）
