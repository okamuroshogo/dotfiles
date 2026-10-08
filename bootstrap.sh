#!/bin/bash
#
# bootstrap.sh — まっさらな macOS から1行でセットアップする入口。
#
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/okamuroshogo/dotfiles/main/bootstrap.sh)"
#
# このスクリプトがやることは3つだけ:
#   1. Homebrew を入れる (Xcode Command Line Tools も一緒に入る)
#   2. リポジトリを ~/.dotfiles に clone (既にあれば pull)
#   3. install.sh に処理を渡す
#
# 本体の設定はすべて install.sh 側。何度実行しても壊れない。

set -euo pipefail

DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/okamuroshogo/dotfiles.git}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
DOTFILES_BRANCH="${DOTFILES_BRANCH:-main}"

if [[ -t 1 ]]; then
  blue=$'\033[1;34m'; red=$'\033[1;31m'; reset=$'\033[0m'
else
  blue=''; red=''; reset=''
fi
log() { printf '%s==>%s %s\n' "$blue" "$reset" "$*"; }
die() { printf '%s  ✗%s %s\n' "$red" "$reset" "$*" >&2; exit 1; }

[[ "$(uname -s)" == "Darwin" ]] || die "macOS 専用です"

# --- 1. Homebrew -------------------------------------------------------------
if ! command -v brew >/dev/null 2>&1 \
   && [[ ! -x /opt/homebrew/bin/brew ]] && [[ ! -x /usr/local/bin/brew ]]; then
  log "Homebrew をインストールします (Command Line Tools も自動で入ります)"
  log "管理者パスワードの入力を求められます"
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  log "Homebrew は既にインストール済み"
fi

for prefix in /opt/homebrew /usr/local; do
  if [[ -x "$prefix/bin/brew" ]]; then
    eval "$("$prefix/bin/brew" shellenv)"
    break
  fi
done
command -v brew >/dev/null 2>&1 || die "Homebrew のインストールに失敗しました"

# --- 2. リポジトリ -----------------------------------------------------------
command -v git >/dev/null 2>&1 || brew install git

if [[ -d "$DOTFILES_DIR/.git" ]]; then
  log "既存の $DOTFILES_DIR を更新します"
  git -C "$DOTFILES_DIR" fetch --prune origin
  git -C "$DOTFILES_DIR" checkout "$DOTFILES_BRANCH"
  git -C "$DOTFILES_DIR" pull --ff-only origin "$DOTFILES_BRANCH"
elif [[ -e "$DOTFILES_DIR" ]]; then
  die "$DOTFILES_DIR が git リポジトリではありません。退避してからやり直してください"
else
  log "$DOTFILES_REPO を $DOTFILES_DIR に clone します"
  git clone --branch "$DOTFILES_BRANCH" "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

# --- 3. 本体へ ---------------------------------------------------------------
log "install.sh を実行します"
exec /bin/bash "$DOTFILES_DIR/install.sh" "$@"
