#!/usr/bin/env bash
# home/ 以下のファイルを $HOME に同じ構造でシンボリックリンクする。
#
#   home/.zshrc                    -> ~/.zshrc
#   home/.config/zsh/conf.d/*.zsh  -> ~/.config/zsh/conf.d/*.zsh
#
# ディレクトリごとではなく「ファイル単位」で張るので、
# ~/.config のように他のアプリが使う場所を丸ごと奪わない。
# 既存の実体ファイルは ~/.dotfiles-backup/<日時>/ に退避する。

set -euo pipefail
# shellcheck source=../lib/common.sh
source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

src_root="$DOTFILES_DIR/home"
[[ -d "$src_root" ]] || die "home/ がありません"

count=0
while IFS= read -r -d '' path; do
  rel="${path#./}"
  link "$src_root/$rel" "$HOME/$rel"
  count=$((count + 1))
done < <(cd "$src_root" && find . \( -type f -o -type l \) ! -name '.DS_Store' -print0)

ok "$count 個のファイルを管理下に置きました"

if [[ -d "${BACKUP_DIR:-}" ]]; then
  warn "退避したファイル: ${BACKUP_DIR/#$HOME/~}"
fi
