#!/usr/bin/env bash
# Xcode Command Line Tools を入れる。
# bootstrap.sh 経由なら Homebrew のインストーラが先に入れてくれるので、
# ここは「手で clone したとき」用の保険。GUI ダイアログを出さずに入れる。

set -euo pipefail
# shellcheck source=../lib/common.sh
source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

if /usr/bin/xcode-select -p >/dev/null 2>&1; then
  skip "Command Line Tools は導入済み ($(/usr/bin/xcode-select -p))"
  exit 0
fi

log "Command Line Tools をインストールします (数分かかります)"

# このファイルがあると softwareupdate のカタログに CLT が現れる
placeholder=/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
run sudo touch "$placeholder"
# shellcheck disable=SC2064
trap "sudo rm -f '$placeholder' 2>/dev/null || true" EXIT

label="$(softwareupdate -l 2>/dev/null \
  | grep -B1 'Command Line Tools' \
  | awk -F'*' '/^ *\*/ {print $2}' \
  | sed 's/^ *//' | tail -n1)"

if [[ -n "$label" ]]; then
  run sudo softwareupdate -i "$label" --verbose
else
  warn "softwareupdate のカタログに Command Line Tools が見つかりませんでした"
  warn "GUI インストーラを起動します。ダイアログに従ってください"
  run /usr/bin/xcode-select --install || true
  log "インストール完了を待っています..."
  until /usr/bin/xcode-select -p >/dev/null 2>&1; do sleep 10; done
fi

/usr/bin/xcode-select -p >/dev/null 2>&1 \
  || die "Command Line Tools のインストールに失敗しました"
ok "Command Line Tools: $(/usr/bin/xcode-select -p)"
