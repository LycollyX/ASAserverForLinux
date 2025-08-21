#!/bin/bash

# --- 設定 ---
# このスクリプトはrootユーザーで実行することを前提としています

# --- ステップ1: 依存関係のインストール ---
echo "Installing prerequisites..."
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y steamcmd
sudo useradd steam

# ASAサーバーのインストールディレクトリ
ASA_SERVER_DIR="/home/steam/Steam/"
# GE-Proton8-21のインストールディレクトリ
PROTON_DIR="/home/steam/Steam/compatibilitytools.d/"
# ASAサーバーのApp ID
ASA_APPID=2430930

# --- ステップ3: ASAサーバーのダウンロード ---
# ASAサーバーをダウンロード
echo "Downloading ASA dedicated server..."
steamcmd +force_install_dir /home/steam/Steam/steamapps/common/ +login anonymous +app_update "$ASA_APPID" validate +quit

# --- ステップ2: Protonのダウンロード ---
# Protonをダウンロード (Proton 8.0を使用)
echo "Downloading Proton..."
cd ~
curl -L -o GE-Proton8-21.tar.gz https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton8-21/GE-Proton8-21.tar.gz
tar -xf GE-Proton8-21.tar.gz
sudo mv GE-Proton8-21 /home/steam/Steam/compatibilitytools.d/
sudo chown -R steam:steam /home/steam/Steam/compatibilitytools.d/GE-Proton8-21
sudo chmod -R +x /home/steam/Steam/compatibilitytools.d/GE-Proton8-21/

# --- ステップ4: systemdサービスのインストール ---
echo "Copying systemd service file from repository..."
sudo cp ./systemd/ark-island.service /etc/systemd/system/ark-island.service

# サービスを有効化し、起動
echo "Enabling and starting the service..."
sudo systemctl daemon-reload
sudo systemctl enable ark-island.service
sudo systemctl start ark-island.service

echo "================================================="
echo "ASA server installation is complete."
echo "The server has been started and will restart automatically."
echo "================================================="