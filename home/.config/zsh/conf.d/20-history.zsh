# 履歴。

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt extended_history           # 実行時刻と所要時間も残す
setopt inc_append_history         # 終了を待たず即座に書く
setopt hist_ignore_dups           # 直前と同じコマンドは残さない
setopt hist_ignore_all_dups       # 重複は古い方を消す
setopt hist_ignore_space          # 行頭スペースのコマンドは残さない
setopt hist_reduce_blanks         # 余分な空白を詰めて保存
setopt hist_verify                # 履歴展開はそのまま実行せず一度見せる

# share_history (複数端末で履歴を即共有) は意図的に入れていない。
# 別の作業中のシェルの履歴が混ざると ↑ が使いづらくなるため。
