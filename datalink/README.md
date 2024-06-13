# S3マウント

再起動でマウントが外れるためsystemdで自動起動させる

## 手順

1. ユニットファイルを作成

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

# サービス開始
systemctl daemon-reload
systemctl status s3mount.service
systemctl enable s3mount.service
systemctl start s3mount.service

# サービス確認 incactive (dead）
systemctl status s3mount.service


# スクリプト作成 s3mount.shの内容を貼り付け
vim /usr/bin/s3mount.sh

cat /usr/bin/s3mount.sh
chmod +x /usr/bin/s3mount.sh
