#!/usr/bin/env bash
# macOS のシステム設定。defaults write は同じ値を何度書いても同じなので冪等。
# 元に戻したいときは各コマンドの `defaults delete` を手で叩く。

set -euo pipefail
# shellcheck source=../lib/common.sh
source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

# --- Finder ------------------------------------------------------------------
log "Finder"
run defaults write com.apple.finder AppleShowAllFiles -bool true            # 隠しファイルを表示
run defaults write com.apple.finder _FXShowPosixPathInTitle -bool true      # タイトルにフルパス
run defaults write com.apple.finder ShowPathbar -bool true                  # パスバーを表示
run defaults write com.apple.finder ShowStatusBar -bool true                # ステータスバーを表示
run defaults write com.apple.finder FXDefaultSearchScope -string SCcf       # 検索は「現在のフォルダ」
run defaults write com.apple.finder FXPreferredViewStyle -string Nlsv       # デフォルトはリスト表示
run defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
run defaults write NSGlobalDomain AppleShowAllExtensions -bool true         # 拡張子を常に表示

# ネットワーク / USB ボリュームに .DS_Store を作らない
run defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
run defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# --- Dock / Mission Control --------------------------------------------------
log "Dock"
run defaults write com.apple.dock expose-animation-duration -float 0.15     # Mission Control を速く
run defaults write com.apple.dock show-recents -bool false                  # 最近使ったアプリを出さない

# --- ダイアログ / 入力 -------------------------------------------------------
log "ダイアログと入力"
run defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true   # 保存ダイアログを常に展開
run defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
run defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true      # 印刷ダイアログも展開
run defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false            # キー長押しでリピート
run defaults write NSGlobalDomain KeyRepeat -int 2
run defaults write NSGlobalDomain InitialKeyRepeat -int 15

# --- スクリーンショット ------------------------------------------------------
log "スクリーンショット"
run defaults write com.apple.screencapture disable-shadow -bool true        # 影を付けない
run defaults write com.apple.screencapture type -string png

# --- 反映 --------------------------------------------------------------------
log "Finder と Dock を再起動して反映します"
run killall Finder >/dev/null 2>&1 || true
run killall Dock >/dev/null 2>&1 || true
run killall SystemUIServer >/dev/null 2>&1 || true

ok "完了 (一部はログインし直すと反映されます)"
