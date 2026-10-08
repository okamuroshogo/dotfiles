# 補完。

# Homebrew が配る補完関数を探せるようにする。
# HOMEBREW_PREFIX は .zprofile の brew shellenv が設定済み。
if [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
  fpath=(
    "$HOMEBREW_PREFIX/share/zsh-completions"(N-/)
    "$HOMEBREW_PREFIX/share/zsh/site-functions"(N-/)
    $fpath
  )
fi

autoload -Uz compinit

# compinit は毎回フルで走ると重いので、キャッシュが24時間以内なら
# 検証を省く (-C)。古くなったら作り直す。
_zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
[[ -d "${_zcompdump:h}" ]] || mkdir -p "${_zcompdump:h}"
if [[ -n ${_zcompdump}(#qN.mh-24) ]]; then
  compinit -C -d "$_zcompdump"
else
  compinit -d "$_zcompdump"
fi
unset _zcompdump

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # 大小を区別しない
zstyle ':completion:*' menu select                          # 候補を矢印で選べる
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
