# anyenv
if [ -d ${HOME}/.anyenv ] ; then
  export PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init - --no-rehash)"
  for D in `ls $HOME/.anyenv/envs`
  do
    export PATH="$HOME/.anyenv/envs/$D/shims:$PATH"
  done
fi

#}}}
# {{{ Zplug Setting
if [ ! -f $HOME/.zplug/init.zsh ]; then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh
fi
source ~/.zplug/init.zsh

zplug "mafredri/zsh-async", from:github
zplug "chrissicool/zsh-256color"
zplug "b4b4r07/enhancd", use:init.sh
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-completions"
zplug "junegunn/fzf-bin"
zplug "junegunn/fzf"
zplug "peco/peco"
zplug "b4b4r07/dotfiles"

zplug "modules/osx", from:prezto
zplug "modules/prompt", from:prezto
zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme
zstyle ':prezto:module:prompt' theme 'powerline'
POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND="007"
POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND="016"
POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND="red"
POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND="blue"
POWERLEVEL9K_DIR_HOME_FOREGROUND="white"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="white"
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="white"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="021"
POWERLEVEL9K_DIR_HOME_BACKGROUND="021"
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="021"

zstyle ':prezto:load' pmodule \
  'environment' \
  'terminal' \
  'editor' \
  'history' \
  'directory' \
  'spectrum' \
  'utility' \
  'completion' \
  'fasd' \
  'prompt' \
  'git' \
  'tmux'

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load --verbose > /dev/null
# }}}

# zsh起動時にtmux起動
[[ -z "$TMUX" && ! -z "$PS1" ]] && exec tmux

# vim
alias vim='nvim'
export XDG_CONFIG_HOME=~/.config

fpath=(/usr/local/share/zsh-completions $fpath)
 
# 日本語ファイル名を表示可能にする
setopt print_eight_bit
 
# ビープ音の停止
setopt no_beep
 
# ビープ音の停止(補完時)
setopt nolistbeep
 
# cd -<tab>で以前移動したディレクトリを表示
setopt auto_pushd
 
# ヒストリ(履歴)を保存、数を増やす
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
 
# 同時に起動したzshの間でヒストリを共有する
#setopt share_history
 
# 直前と同じコマンドの場合は履歴に追加しない
setopt hist_ignore_dups
 
# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups
 
# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space
 
# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks
 
# キーバインディングをemacs風に(-vはvim)
bindkey -e
# bindkey -v
 
# zsh-completionsの設定
fpath=(/path/to/homebrew/share/zsh-completions $fpath)
 
autoload -U compinit
compinit -u


# -------------------------------------
# 環境変数
# -------------------------------------

# SSHで接続した先で日本語が使えるようにする
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=ja_JP.UTF-8

# エディタ
export EDITOR=/usr/local/bin/nvim

# ページャ
export PAGER=/usr/local/bin/vimpager
export MANPAGER=/usr/local/bin/vimpager


# -------------------------------------
# zshのオプション
# -------------------------------------

## 補完機能の強化
autoload -U compinit
compinit

# ビープを鳴らさない
setopt nobeep

## 色を使う
setopt prompt_subst

## ^Dでログアウトしない。
setopt ignoreeof

## バックグラウンドジョブが終了したらすぐに知らせる。
setopt no_tify

## 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups

# 補完
## タブによるファイルの順番切り替えをしない
unsetopt auto_menu

# cd -[tab]で過去のディレクトリにひとっ飛びできるようにする
setopt auto_pushd

#大文字、小文字を区別せず補完する
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# -------------------------------------
# パス
# -------------------------------------

# 重複する要素を自動的に削除
typeset -U path cdpath fpath manpath

path=(
    $HOME/bin(N-/)
    /usr/local/bin(N-/)
    /usr/local/sbin(N-/)
    $path
)

# -------------------------------------
# プロンプト
# -------------------------------------

autoload -U promptinit; promptinit
autoload -Uz colors; colors
autoload -Uz vcs_info
autoload -Uz is-at-least

# -------------------------------------
# エイリアス
# -------------------------------------

# -n 行数表示, -I バイナリファイル無視, svn関係のファイルを無視
alias grep="grep --color -n -I --exclude='*.svn-*' --exclude='entries' --exclude='*/cache/*'"

# ls
alias ls="ls -G" # color for darwin
alias l="ls -la"
alias la="ls -la"
alias ll="ls -1"

export LSCOLORS=gxfxcxdxbxegedabagacag
export LS_COLORS='di=36;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;46'

# 補完候補もLS_COLORSに合わせて色が付くようにする
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# lsがカラー表示になるようエイリアスを設定
case "${OSTYPE}" in
darwin*)
  # Mac
  alias ls="ls -GF"
  ;;
linux*)
  # Linux
  alias ls='ls -F --color'
  ;;
esac

# tree
alias tree="tree -NC" # N: 文字化け対策, C:色をつける


# -------------------------------------
# キーバインド
# -------------------------------------

bindkey -e

function cdup() {
   echo
   cd ..
   zle reset-prompt
}
zle -N cdup
bindkey '^K' cdup

bindkey "^R" history-incremental-search-backward

# -------------------------------------
# その他
# -------------------------------------

DISABLE_AUTO_TITLE="true"
# cdしたあとで、自動的に ls する
function chpwd() { ls }

# iTerm2のタブ名を変更する
function title {
    echo -ne "\033]0;"$*"\007"
}


# -------------------------------------
# tmux 
# -------------------------------------
# tmux (auto start)
is_screen_running() {
  [ ! -z "$WINDOW" ]
}
is_tmux_runnning() {
  [ ! -z "$TMUX" ]
}
is_screen_or_tmux_running() {
  is_screen_running || is_tmux_runnning
}
shell_has_started_interactively() {
  [ ! -z "$PS1" ]
}
resolve_alias() {
  cmd="$1"
  while \
    whence "$cmd" >/dev/null 2>/dev/null \
    && [ "$(whence "$cmd")" != "$cmd" ]
  do
    cmd=$(whence "$cmd")
  done
  echo "$cmd"
}

if ! is_screen_or_tmux_running && shell_has_started_interactively; then
  for cmd in tmux ; do
    if whence $cmd >/dev/null 2>/dev/null; then
      $(resolve_alias "$cmd")
      break
    fi
  done
fi
export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"

export PATH="$HOME/.fastlane/bin:$PATH"
export PATH="/usr/local/git/bin:$PATH"




# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /Users/okamu/.homesick/repos/dotfiles/home/.anyenv/envs/ndenv/versions/v8.2.1/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /Users/okamu/.homesick/repos/dotfiles/home/.anyenv/envs/ndenv/versions/v8.2.1/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /Users/okamu/.homesick/repos/dotfiles/home/.anyenv/envs/ndenv/versions/v8.2.1/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /Users/okamu/.homesick/repos/dotfiles/home/.anyenv/envs/ndenv/versions/v8.2.1/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh

export PATH="$HOME/.yarn/bin:$PATH"
export PATH="$PATH:`yarn global bin`"

## flutter
export PATH="$PATH:`pwd`/flutter/bin"

# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /Users/okamu/ServerProject/okamu.ro/WashingButton/node_modules/tabtab/.completions/slss.zsh ]] && . /Users/okamu/ServerProject/okamu.ro/WashingButton/node_modules/tabtab/.completions/slss.zsh

export PATH=$PATH:`npm bin -g`
export PATH="$PATH":"$HOME/development/Flutter/flutter/.pub-cache/bin"

export PATH="/usr/local/opt/php@7.3/bin:$PATH"
export PATH="/usr/local/opt/php@7.3/sbin:$PATH"
export PATH="$HOME/.config/composer/vendor/bin:$PATH"
