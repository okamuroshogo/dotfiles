#!/usr/bin/env bash
# Homebrew を入れて最新化する。

set -euo pipefail
# shellcheck source=../lib/common.sh
source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

if ! load_brew_env; then
  if [[ "$DRY_RUN" == "1" ]]; then
    skip "(dry-run) Homebrew 公式インストーラを NONINTERACTIVE=1 で実行"
    exit 0
  fi
  log "Homebrew をインストールします"
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  load_brew_env || die "Homebrew のインストールに失敗しました"
fi

ok "brew $(brew --version | head -1 | awk '{print $2}') ($HOMEBREW_PREFIX)"

log "brew update"
run brew update
