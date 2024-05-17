# TODO マルチステージビルド対応

1. codebuildから環境変数TYPEを与える（java, python, shell）
2. buildspec.yml内で `docker build --target ${TYPE}` でマルチステージビルドする
3. Dockerfile内でtargetに応じてビルドするイメージを変更する
  具体的にはTYPEによってCOPYするextra.conf(今fluent-bit-custom.confという名前にしてますがAWSドキュメント見るとextra.confが多いのでこれにしてもいいとおもいます。任せます。)
　　をjava用、Python用、shell用で分岐する
