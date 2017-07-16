#!/bin/bash

echo "installing homebrew..."
which brew >/dev/null 2>&1 || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "run brew doctor..."
which brew >/dev/null 2>&1 && brew doctor

echo "run brew update..."
which brew >/dev/null 2>&1 && brew update

echo "ok. run brew upgrade..."

brew upgrade --all

formulas=(
    ag
    arp-scan
    carthage
    go
    jq
    makedepend
    mongodb
    nginx
    nkf
    nmap
    neovim/neovim/neovim
    oniguruma
    openssl
    openssl@1.1
    pcre
    pkg-config
    python3
    readline
    redis
    scons
    sqlite
    tmux
    zsh
)

"brew tap..."
brew tap homebrew/dupes
brew tap homebrew/versions
brew tap homebrew/homebrew-php
brew tap homebrew/apache
brew tap sanemat/font

echo "start brew install apps..."
for formula in "${formulas[@]}"; do
    brew install $formula || brew upgrade $formula
done

casks=(
    adobe-creative-cloud
    aerial
    android-file-transfer
    android-platform-tools
    android-ndk
    android-sdk
    android-studio
    appcleaner
    atom
    cyberduck
    docker
    firefox
    google-chrome
    hyperswitch
    imageoptim
    iterm2
    java
    genymotion
    karabiner
    minikube
    mongohub
    mysqlworkbench
    sequel-pro
    sketch
    sketch-toolbox
    skype
    slack
    sublime-text
    thunderbird
    unity
    vagrant
)

echo "start brew cask install apps..."
for cask in "${casks[@]}"; do
    brew cask install $cask
done

brew cleanup
brew cask cleanup

cat << END

**************************************************
HOMEBREW INSTALLED! bye.
**************************************************

END

