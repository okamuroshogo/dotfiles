#!/usr/bin/env bash
# lib/common.sh — install.sh と scripts/*.sh が共通で使うヘルパ。
# 単体では実行しない (source 専用)。

# --- リポジトリのルート ------------------------------------------------------
if [[ -z "${DOTFILES_DIR:-}" ]]; then
  DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fi
export DOTFILES_DIR

# --- ログ --------------------------------------------------------------------
if [[ -t 1 ]]; then
  _c_reset=$'\033[0m'; _c_blue=$'\033[1;34m'; _c_green=$'\033[1;32m'
  _c_yellow=$'\033[1;33m'; _c_red=$'\033[1;31m'; _c_dim=$'\033[2m'
else
  _c_reset=''; _c_blue=''; _c_green=''; _c_yellow=''; _c_red=''; _c_dim=''
fi

log()  { printf '%s==>%s %s\n'   "$_c_blue"   "$_c_reset" "$*"; }
ok()   { printf '%s  ✓%s %s\n'   "$_c_green"  "$_c_reset" "$*"; }
skip() { printf '%s  -%s %s\n'   "$_c_dim"    "$_c_reset" "$*"; }
warn() { printf '%s  !%s %s\n'   "$_c_yellow" "$_c_reset" "$*" >&2; }
die()  { printf '%s  ✗%s %s\n'   "$_c_red"    "$_c_reset" "$*" >&2; exit 1; }

has() { command -v "$1" >/dev/null 2>&1; }

# --- 実行モード --------------------------------------------------------------
# DRY_RUN=1 のときは副作用のあるコマンドを表示するだけで実行しない。
DRY_RUN="${DRY_RUN:-0}"

run() {
  if [[ "$DRY_RUN" == "1" ]]; then
    printf '%s  (dry-run)%s %s\n' "$_c_dim" "$_c_reset" "$*"
    return 0
  fi
  "$@"
}

# --- 前提チェック ------------------------------------------------------------
require_macos() {
  [[ "$(uname -s)" == "Darwin" ]] || die "macOS 専用です (検出: $(uname -s))"
}

# --- sudo -------------------------------------------------------------------
# Homebrew のインストールと launchd への登録で root が必要。
# 最初に一度だけ聞いて、インストール中はタイムスタンプを維持する。
SUDO_KEEPALIVE_PID=""

sudo_begin() {
  [[ "$DRY_RUN" == "1" ]] && return 0
  sudo -n true 2>/dev/null && return 0

  log "管理者パスワードを一度だけ入力してください (Homebrew / launchd の設定に使用)"
  sudo -v || die "sudo が必要です"

  ( while kill -0 "$$" 2>/dev/null; do sudo -n true 2>/dev/null; sleep 50; done ) &
  SUDO_KEEPALIVE_PID=$!
}

sudo_end() {
  [[ -n "$SUDO_KEEPALIVE_PID" ]] && kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true
  SUDO_KEEPALIVE_PID=""
}

# --- Homebrew ---------------------------------------------------------------
# brew が入っていれば shellenv を現在のシェルに読み込む。見つからなければ 1 を返す。
load_brew_env() {
  local prefix
  if has brew; then
    eval "$(brew shellenv)"
    return 0
  fi
  for prefix in /opt/homebrew /usr/local; do
    if [[ -x "$prefix/bin/brew" ]]; then
      eval "$("$prefix/bin/brew" shellenv)"
      return 0
    fi
  done
  return 1
}

# --- シンボリックリンク ------------------------------------------------------
# link <source> <target>
#   - target が既に正しいリンクなら何もしない (冪等)
#   - 別の実体があれば BACKUP_DIR に退避してから張り替える
BACKUP_DIR="${BACKUP_DIR:-$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)}"

link() {
  local src="$1" dst="$2"

  [[ -e "$src" ]] || die "リンク元が存在しません: $src"

  if [[ -L "$dst" ]] && [[ "$(readlink "$dst")" == "$src" ]]; then
    skip "${dst/#$HOME/~}"
    return 0
  fi

  [[ -d "$(dirname "$dst")" ]] || run mkdir -p "$(dirname "$dst")"

  if [[ -e "$dst" || -L "$dst" ]]; then
    local backup="$BACKUP_DIR/${dst#"$HOME"/}"
    run mkdir -p "$(dirname "$backup")"
    run mv "$dst" "$backup"
    warn "既存ファイルを退避: ${dst/#$HOME/~} -> ${backup/#$HOME/~}"
  fi

  run ln -s "$src" "$dst"
  ok "${dst/#$HOME/~} -> ${src/#$DOTFILES_DIR/.}"
}

# --- root 所有ファイルの配置 -------------------------------------------------
# install_root <mode> <source> <target>
#   内容が同じなら何もしない (冪等)
install_root() {
  local mode="$1" src="$2" dst="$3"

  if [[ -f "$dst" ]] && cmp -s "$src" "$dst"; then
    local cur_mode
    cur_mode="$(stat -f '%OLp' "$dst")"
    if [[ "$cur_mode" == "$mode" ]]; then
      skip "$dst"
      return 0
    fi
  fi

  [[ -d "$(dirname "$dst")" ]] || run sudo mkdir -p "$(dirname "$dst")"
  run sudo install -o root -g wheel -m "$mode" "$src" "$dst"
  ok "$dst (mode $mode, root:wheel)"
}
