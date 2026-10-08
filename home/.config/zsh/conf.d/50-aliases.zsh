# エイリアス。意図的に最小限。
# 「打つ手間が惜しいほど毎日使うもの」だけに絞ってある。

alias ls='ls -GF'                 # -G 色 / -F 種類を記号で
alias ll='ls -lh'
alias la='ls -lhA'

alias grep='grep --color=auto'

(( $+commands[nvim] )) && alias vim='nvim'
