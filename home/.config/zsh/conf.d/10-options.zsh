# シェルの基本的な挙動と環境変数。

# --- 挙動 -------------------------------------------------------------------
setopt no_beep no_list_beep       # 音を鳴らさない
setopt print_eight_bit            # 日本語ファイル名をそのまま表示する
setopt auto_pushd                 # cd したら自動で pushd (cd -<Tab> で戻れる)
setopt pushd_ignore_dups
setopt interactive_comments       # コマンドラインで # コメントを使える
setopt no_flow_control            # ^S / ^Q で画面がロックしないように
setopt ignore_eof                 # ^D でうっかりログアウトしない
unsetopt auto_menu                # Tab 連打で候補を勝手に入れ替えない

# --- ロケール ---------------------------------------------------------------
# LC_ALL は全部を上書きしてしまうので設定しない (LANG だけで足りる)
export LANG=ja_JP.UTF-8

# --- エディタ / ページャ ----------------------------------------------------
if (( $+commands[nvim] )); then
  export EDITOR=nvim VISUAL=nvim
else
  export EDITOR=vim VISUAL=vim
fi

export PAGER=less
export LESS='-R -i -M'            # -R 色をそのまま / -i 大小無視検索 / -M 行番号

# --- ls の色 ----------------------------------------------------------------
# LSCOLORS は BSD (macOS 標準の ls) 用、LS_COLORS は GNU ls と補完用。
export LSCOLORS=gxfxcxdxbxegedabagacag
export LS_COLORS='di=36;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;46'
