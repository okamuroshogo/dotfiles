# Homebrew で入れた zsh プラグイン。
# 構文ハイライトは他の zle 設定を全部上書きするので必ず最後に読む。
# 要らなくなったら Brewfile から消してこのファイルも消せばいい。

if [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
  # 履歴から入力補完を薄いグレーで先出しする
  _p="$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [[ -r "$_p" ]] && source "$_p"

  # コマンドの打ち間違いを赤く見せる (必ず最後)
  _p="$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  [[ -r "$_p" ]] && source "$_p"

  unset _p
fi
