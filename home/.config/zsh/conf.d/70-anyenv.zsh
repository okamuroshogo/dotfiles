# anyenv (rbenv / nodenv / pyenv などをまとめて管理)。
#
# --no-rehash を付けてシェル起動時の rehash を省いている。
# コマンドを見失ったときは `rbenv rehash` などを手で叩く。

if (( $+commands[anyenv] )); then
  eval "$(anyenv init - --no-rehash zsh)"
fi
