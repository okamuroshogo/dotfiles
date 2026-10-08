#!/usr/bin/env bash
#
# install.sh — セットアップ本体。scripts/ 以下を番号順に実行する。
#
# 使い方:
#   ./install.sh                     すべて実行
#   ./install.sh --dry-run           何をするか表示するだけ
#   ./install.sh --only 40 50        40番台と50番台のステップだけ実行
#   ./install.sh --skip 30           30番台のステップを飛ばす
#   ./install.sh --list              ステップ一覧
#
# 何度実行しても同じ結果になるように書いてある (冪等)。

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_DIR
# shellcheck source=lib/common.sh
source "$DOTFILES_DIR/lib/common.sh"

ONLY=()
SKIP=()
LIST_ONLY=0

usage() { sed -n '3,12p' "$0" | sed 's/^# \{0,1\}//'; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --only)    shift; while [[ $# -gt 0 && "$1" != --* ]]; do ONLY+=("$1"); shift; done ;;
    --skip)    shift; while [[ $# -gt 0 && "$1" != --* ]]; do SKIP+=("$1"); shift; done ;;
    --list)    LIST_ONLY=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *)         die "不明なオプション: $1 (--help を参照)" ;;
  esac
done
export DRY_RUN
export BACKUP_DIR

require_macos

steps=("$DOTFILES_DIR"/scripts/[0-9][0-9]-*.sh)
[[ -e "${steps[0]}" ]] || die "scripts/ にステップが見つかりません"

if [[ "$LIST_ONLY" == "1" ]]; then
  for s in "${steps[@]}"; do printf '  %s\n' "$(basename "$s")"; done
  exit 0
fi

matches() {
  local name="$1"; shift
  local pat
  for pat in "$@"; do
    [[ "$name" == *"$pat"* ]] && return 0
  done
  return 1
}

trap sudo_end EXIT

# 多くのステップが sudo を必要とするので、最初に一度だけまとめて聞く。
sudo_begin

failed=()
for step in "${steps[@]}"; do
  name="$(basename "$step" .sh)"

  if (( ${#ONLY[@]} )) && ! matches "$name" "${ONLY[@]}"; then
    continue
  fi
  if (( ${#SKIP[@]} )) && matches "$name" "${SKIP[@]}"; then
    skip "$name (--skip)"
    continue
  fi

  log "[$name]"
  if ! /bin/bash "$step"; then
    warn "$name が失敗しました。残りのステップは続行します"
    failed+=("$name")
  fi
done

echo
if (( ${#failed[@]} )); then
  warn "失敗したステップ: ${failed[*]}"
  warn "修正後に ./install.sh --only ${failed[0]%%-*} で再実行できます"
  exit 1
fi

log "完了しました"
cat <<'MSG'

  新しいシェルを開いてください:  exec $SHELL -l

  うまく動かないときは:
    ./install.sh --list            ステップ一覧
    ./install.sh --only 50         特定のステップだけ再実行
    dns-switch --status            DNS 切り替えの状態確認

MSG
