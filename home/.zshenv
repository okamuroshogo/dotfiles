# ~/.zshenv — すべての zsh (対話/非対話/スクリプト) で読まれる。
# 起動のたびに走るので、ここには XDG のパス定義だけ置いて軽く保つ。

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
