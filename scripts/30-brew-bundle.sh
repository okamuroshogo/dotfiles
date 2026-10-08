#!/usr/bin/env bash
# Brewfile に書いたものを入れる。Brewfile が唯一の正 (宣言的)。
#
#   パッケージを足したい/消したいときは Brewfile を編集して ./install.sh --only 30
#
# 注意: ここでは `brew bundle cleanup` は実行しない。
#       Brewfile に無いものを勝手に消すのは危険なので、
#       掃除したいときは手で `brew bundle cleanup --file=Brewfile` を叩く。

set -euo pipefail
# shellcheck source=../lib/common.sh
source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

load_brew_env || die "Homebrew が見つかりません (先に 20-homebrew.sh)"

brewfile="$DOTFILES_DIR/Brewfile"
[[ -f "$brewfile" ]] || die "Brewfile がありません: $brewfile"

if brew bundle check --file="$brewfile" --no-upgrade >/dev/null 2>&1; then
  skip "Brewfile の内容はすべて導入済み"
else
  log "brew bundle install (初回は時間がかかります)"
  run brew bundle install --file="$brewfile" --no-upgrade
fi

log "brew cleanup"
run brew cleanup

if [[ "$DRY_RUN" != "1" ]]; then
  if brew bundle check --file="$brewfile" --no-upgrade >/dev/null 2>&1; then
    ok "Brewfile 充足"
  else
    warn "一部入らなかったものがあります: brew bundle check --file=Brewfile --no-upgrade --verbose で確認"
  fi
fi
