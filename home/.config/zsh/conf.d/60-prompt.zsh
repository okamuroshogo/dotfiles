# プロンプト。外部プラグインを使わず zsh 標準の vcs_info で組む。
#
#   ~/ServerProjects/dotfiles main*
#   ❯
#
# ブランチ名のうしろの記号:  + = ステージ済みの変更 / * = 未ステージの変更

autoload -Uz vcs_info add-zsh-hook

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr   '+'
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' formats       ' %F{magenta}%b%f%F{yellow}%c%u%f'
zstyle ':vcs_info:git:*' actionformats ' %F{magenta}%b%f|%F{red}%a%f'

add-zsh-hook precmd vcs_info

setopt prompt_subst

# 1行目: カレントディレクトリ + git 情報
# 2行目: 直前のコマンドが成功なら緑、失敗なら赤の ❯
PROMPT='%F{cyan}%~%f${vcs_info_msg_0_}
%(?.%F{green}.%F{red})❯%f '
