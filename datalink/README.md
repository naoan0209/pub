# S3マウント

再起動でマウントが外れるためsystemdで自動起動させる

## TODO

- バケット名が環境ごとに異なるので、ユニットファイルからはs3mount.shを実行するよう一元化する
- s3mount.shの中でバケット名を指定してマウントする

## 前提

- S3バケットは構築済み
- EC2、VPC、IAMロールは構築済み
- Mountpoint for s3パッケージをインストール済み

## 手順

```
# rootで作業
sudo su -

# ユニットファイルを作成 s3mount.serviceの内容を貼り付け
systemctl edit --force --full s3mount.service
# ctrl + xで抜ける

# s3mount.serviceが作成される
ls -l /etc/systemd/system

# nanoで編集しなかった場合 s3mount.serviceの内容を貼り付け
vim /etc/systemd/system/s3mount.service

# ユニットファイル確認
cat /etc/systemd/system/s3mount.service

# allow_otherを有効にする
echo "user_allow_other" | sudo tee -a /etc/fuse.conf

# サービス開始
systemctl daemon-reload
systemctl status s3mount.service
systemctl enable s3mount.service
systemctl start s3mount.service
systemctl status s3mount.service

# mount確認
mount
# 最終行付近に mountpoint-s3 on がある

# あとはファイルを作成したり、自由に操作


# アンマウントの確認（umountコマンドではアンマウントできないことがある）
systemctl stop s3mount.service
mount

# 再マウント
systemctl start s3mount.service
