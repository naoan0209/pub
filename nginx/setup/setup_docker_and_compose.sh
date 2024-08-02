#!/bin/bash
# ----------------------------------------------
# Amazon Linux 2023用 Docker&Composeインストール
# ----------------------------------------------
set -e

# Dockerインストール
sudo dnf update
sudo dnf install -y docker

# 起動
sudo systemctl start docker

# sudo不要化
sudo usermod -aG docker $(whoami)

# サービス設定
sudo service docker restart
sudo systemctl enable docker

# 記載時点での最新バージョンのcomposeをインストール
sudo curl -sL "https://github.com/docker/compose/releases/download/v2.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# インストールしたことを確認
docker -v
docker-compose -v
