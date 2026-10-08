#!/usr/bin/env bash
# config/envs.conf に書いたバージョンを入れて global に設定する。
# latest と書かれていれば最新安定版を解決する。
#
# ソースからのビルドなので初回は Ruby / Python で数分ずつかかる。

set -euo pipefail
# shellcheck source=../lib/common.sh
source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

load_brew_env || die "Homebrew が見つかりません (先に 20-homebrew.sh)"

export ANYENV_ROOT="${ANYENV_ROOT:-$HOME/.anyenv}"
conf="$DOTFILES_DIR/config/envs.conf"
[[ -f "$conf" ]] || die "config/envs.conf がありません"

# ruby-build が Homebrew の OpenSSL を見つけられるようにしておく
if openssl_prefix="$(brew --prefix openssl@3 2>/dev/null)"; then
  export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$openssl_prefix"
fi

# <env> の最新安定版を返す。
resolve_latest() {
  local env_name="$1" cmd="$2" v=""

  case "$env_name" in
    pyenv) v="$("$cmd" latest --known 3 2>/dev/null || true)" ;;
    rbenv) v="$("$cmd" latest --known   2>/dev/null || true)" ;;
  esac

  # latest サブコマンドが無い **env (nodenv など) は一覧から拾う
  if [[ -z "$v" ]]; then
    v="$("$cmd" install --list 2>/dev/null \
      | tr -d '[:blank:]' \
      | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' \
      | tail -1)"
  fi

  printf '%s' "$v"
}

while read -r env_name version; do
  [[ -z "$env_name" || "$env_name" == \#* ]] && continue
  version="${version:-latest}"

  root="$ANYENV_ROOT/envs/$env_name"
  cmd="$root/bin/$env_name"
  if [[ ! -x "$cmd" ]]; then
    warn "$env_name が見つかりません (先に ./install.sh --only 40)"
    continue
  fi

  # rbenv などは <ENV>_ROOT が無いと ~/.rbenv を見てしまうので必ず渡す
  root_var="$(printf '%s' "$env_name" | tr '[:lower:]' '[:upper:]')_ROOT"
  export "${root_var}=${root}"
  export PATH="$root/bin:$root/shims:$PATH"

  if [[ "$version" == "latest" ]]; then
    version="$(resolve_latest "$env_name" "$cmd")"
    [[ -n "$version" ]] || { warn "$env_name: 最新版を解決できませんでした"; continue; }
    log "$env_name: latest -> $version"
  fi

  if "$cmd" versions --bare 2>/dev/null | grep -qxF "$version"; then
    skip "$env_name $version は導入済み"
  else
    log "$env_name $version をビルドします (時間がかかります)"
    run "$cmd" install --skip-existing "$version"
  fi

  current="$("$cmd" global 2>/dev/null || true)"
  if [[ "$current" == "$version" ]]; then
    skip "$env_name global = $version"
  else
    run "$cmd" global "$version"
    ok "$env_name global = $version"
  fi

  run "$cmd" rehash
done < "$conf"
