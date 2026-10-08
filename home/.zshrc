# ~/.zshrc — 対話シェル用。
#
# 中身は ~/.config/zsh/conf.d/*.zsh に番号順で分割してある。
# 1ファイル1テーマにしておくと、要らなくなったものを消すのが簡単。
#
# マシン固有の設定 (仕事用のトークン、そのマシンにしか無いパスなど) は
# ~/.zshrc.local に書く。これは git 管理しない。

[[ -o interactive ]] || return

_zsh_conf_d="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/conf.d"
if [[ -d "$_zsh_conf_d" ]]; then
  for _f in "$_zsh_conf_d"/*.zsh(N); do
    source "$_f"
  done
fi
unset _f _zsh_conf_d

[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
