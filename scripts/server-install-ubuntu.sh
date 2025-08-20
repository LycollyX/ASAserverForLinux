#!/bin/bash

# --- 設定 ---
# このスクリプトはrootユーザーで実行することを前提としています

# SteamCMDのディレクトリ
STEAMCMD_DIR=~/steamcmd
# ASAサーバーのインストールディレクトリ
ASA_SERVER_DIR=~/asa_server

# --- ステップ1: 依存関係のインストール ---
# 32ビットアーキテクチャの有効化と、steamcmdのインストール
echo "Installing prerequisites..."
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y steamcmd

# --- ステップ2: SteamCMDとProtonのダウンロード ---
# SteamCMDのディレクトリを作成
echo "Creating SteamCMD directory..."
mkdir -p "$STEAMCMD_DIR"

# Protonをダウンロード (Proton 8.0を使用)
echo "Downloading Proton..."
"$STEAMCMD_DIR/steamcmd.sh" +login anonymous +app_update 1493710 +quit

# --- ステップ3: ASAサーバーのダウンロード ---
# ASAサーバーのインストールディレクトリを作成
echo "Creating ASA server directory..."
mkdir -p "$ASA_SERVER_DIR"

# ASAサーバーをダウンロード
echo "Downloading ASA dedicated server..."
"$STEAMCMD_DIR/steamcmd.sh" +force_install_dir "$ASA_SERVER_DIR" +login anonymous +app_update 2430930 validate +quit

# --- ステップ4: systemdサービスのインストール ---
# リポジトリにあるサービスファイルをコピー
echo "Copying systemd service file from repository..."
sudo cp ./systemd/asa-server.service /etc/systemd/system/ark-island.service

# サービスを有効化し、起動
echo "Enabling and starting the service..."
sudo systemctl daemon-reload
sudo systemctl enable asa-server.service
sudo systemctl start asa-server.service

echo "================================================="
echo "ASA server installation is complete."
echo "The server has been started and will restart automatically."
echo "================================================="