#tmuxで困ったらtmux kill-server
#
# anyenv
if [ -d ${HOME}/.anyenv ] ; then
  export PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init - --no-rehash)"
  for D in `ls $HOME/.anyenv/envs`
  do
    export PATH="$HOME/.anyenv/envs/$D/shims:$PATH"
  done
fi

if [ ! -f $HOME/.zplug/init.zsh ]; then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh
fi
source ~/.zplug/init.zsh

ARCH=$(uname -m)
if [[ $ARCH == arm64 ]]; then
    echo "Current Architecture: $ARCH"
	eval $(/opt/homebrew/bin/brew shellenv)
elif [[ $ARCH == x86_64 ]]; then
    echo "Current Architecture: $ARCH"
	eval $(/usr/local/bin/brew shellenv)
fi

