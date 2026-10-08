#!/usr/bin/env bash
# 自宅Wi-Fi検知でDNSを切り替える仕組みを入れる。
#
#   /usr/local/sbin/dns-switch               スクリプト本体 (root:wheel 755)
#   /usr/local/etc/dns-switch.conf           SSID と DNS の設定 (root:wheel 644)
#   /Library/LaunchDaemons/ro.okamu.dns-switch.plist
#
# LaunchAgent ではなく LaunchDaemon (root) にしてあるのは、
# networksetup -setdnsservers に管理者権限が必要で、
# ユーザ権限だと毎回パスワードを聞かれてしまうため。
# root が実行するファイルなので、所有者を root:wheel に固定して
# 書き換えによる権限昇格の余地を残さないようにしている。
#
# SSID / DNS を変えたいときは config/dns-switch/dns-switch.conf を編集して
# ./install.sh --only 80 を実行する (リポジトリ側が常に正)。

set -euo pipefail
# shellcheck source=../lib/common.sh
source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

label="ro.okamu.dns-switch"
src_dir="$DOTFILES_DIR/config/dns-switch"
plist_dst="/Library/LaunchDaemons/$label.plist"

[[ -f "$DOTFILES_DIR/bin/dns-switch" ]] || die "bin/dns-switch がありません"
[[ -f "$src_dir/dns-switch.conf" ]]     || die "config/dns-switch/dns-switch.conf がありません"
[[ -f "$src_dir/$label.plist" ]]        || die "config/dns-switch/$label.plist がありません"

# 設定が空のままだと「常にDHCPへ戻す」だけの動作になるので気づけるようにする
(
  HOME_SSIDS=()
  HOME_SSID=""
  HOME_DNS=""
  # shellcheck source=/dev/null
  source "$src_dir/dns-switch.conf" || true
  [[ -n "$HOME_SSID" ]] && HOME_SSIDS+=("$HOME_SSID")
  if (( ${#HOME_SSIDS[@]} == 0 )) || [[ -z "$HOME_DNS" ]]; then
    warn "dns-switch.conf の HOME_SSIDS / HOME_DNS が未設定です (常に DHCP に戻す動作になります)"
  fi
) || true

install_root 755 "$DOTFILES_DIR/bin/dns-switch" /usr/local/sbin/dns-switch
install_root 644 "$src_dir/dns-switch.conf"     /usr/local/etc/dns-switch.conf
install_root 644 "$src_dir/$label.plist"        "$plist_dst"

log "launchd に登録します"
# bootout -> bootstrap で、設定が変わっていても確実に読み直させる
run sudo launchctl bootout "system/$label" 2>/dev/null || true
run sudo launchctl bootstrap system "$plist_dst"

if [[ "$DRY_RUN" != "1" ]]; then
  if sudo launchctl print "system/$label" >/dev/null 2>&1; then
    ok "$label を登録しました"
  else
    die "$label の登録に失敗しました"
  fi
fi

log "現在の状態:"
run sudo /usr/local/sbin/dns-switch --status || true

cat <<'MSG'

  ログ:   sudo tail -f /var/log/dns-switch.log
  確認:   sudo dns-switch --status
  手動実行: sudo dns-switch
  停止:   sudo launchctl bootout system/ro.okamu.dns-switch

MSG
