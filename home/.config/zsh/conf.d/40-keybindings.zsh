# キーバインド。emacs 風のまま、よく使うものだけ足す。

bindkey -e

bindkey '^R' history-incremental-search-backward

# ↑↓ で「今打ちかけている文字列に前方一致する履歴」を辿る
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# Option(Alt) + ← → で単語単位の移動
bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word
