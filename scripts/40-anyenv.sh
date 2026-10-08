#!/usr/bin/env bash
# anyenv 本体と **env (rbenv / nodenv / pyenv) を用意する。
# どの **env を入れるかは config/envs.conf が唯一の正。

set -euo pipefail
# shellcheck source=../lib/common.sh
source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

load_brew_env || die "Homebrew が見つかりません (先に 20-homebrew.sh)"
has anyenv || die "anyenv がありません (Brewfile に入っているか確認してください)"

export ANYENV_ROOT="${ANYENV_ROOT:-$HOME/.anyenv}"
definition_root="${ANYENV_DEFINITION_ROOT:-${XDG_CONFIG_HOME:-$HOME/.config}/anyenv/anyenv-install}"

# --- インストールマニフェスト ------------------------------------------------
if [[ -d "$definition_root" ]]; then
  skip "anyenv マニフェスト: $definition_root"
else
  log "anyenv マニフェストを初期化します"
  run anyenv install --force-init   # --force-init = 確認プロンプトなし
fi

# --- anyenv-update プラグイン (まとめて更新できるようにする) -----------------
plugin_dir="$ANYENV_ROOT/plugins/anyenv-update"
if [[ -d "$plugin_dir" ]]; then
  skip "anyenv-update プラグイン"
else
  log "anyenv-update プラグインを入れます"
  run mkdir -p "$ANYENV_ROOT/plugins"
  run git clone --depth 1 https://github.com/znz/anyenv-update.git "$plugin_dir"
fi

# --- **env 本体 --------------------------------------------------------------
conf="$DOTFILES_DIR/config/envs.conf"
[[ -f "$conf" ]] || die "config/envs.conf がありません"

while read -r env_name _version; do
  [[ -z "$env_name" || "$env_name" == \#* ]] && continue

  if [[ -d "$ANYENV_ROOT/envs/$env_name" ]]; then
    skip "$env_name"
  else
    log "$env_name をインストールします"
    run anyenv install --skip-existing "$env_name"
  fi
done < "$conf"

installed=()
for d in "$ANYENV_ROOT"/envs/*/; do
  [[ -d "$d" ]] && installed+=("$(basename "$d")")
done
ok "導入済み: ${installed[*]:-(なし)}"
