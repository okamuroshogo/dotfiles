# ~/.zprofile — ログインシェルで一度だけ読まれる。PATH の土台をここで作る。

# --- Homebrew ---------------------------------------------------------------
# Apple Silicon は /opt/homebrew、Intel は /usr/local。両方に対応しておく。
# brew shellenv が PATH / MANPATH / HOMEBREW_PREFIX をまとめて設定してくれる。
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  if [[ -x "$_brew" ]]; then
    eval "$("$_brew" shellenv)"
    break
  fi
done
unset _brew

# --- PATH -------------------------------------------------------------------
# typeset -U で重複を自動的に捨てる。(N-/) は「存在するディレクトリだけ」。
typeset -U path PATH
path=(
  $HOME/.local/bin(N-/)
  $HOME/bin(N-/)
  $path
)
export PATH
