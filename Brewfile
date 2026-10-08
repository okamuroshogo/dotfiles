# Brewfile — インストールするものの唯一の正。
#
#   足す/消す:  このファイルを編集して ./install.sh --only 30
#   確認:       brew bundle check --file=Brewfile --verbose
#   整理:       brew bundle cleanup --file=Brewfile        (消す対象の確認)
#               brew bundle cleanup --file=Brewfile --force (実際に消す)
#
# install.sh は cleanup を自動実行しない。勝手に消すのは危険なので手動。

cask_args appdir: "/Applications"

# ---------------------------------------------------------------------------
# tap
# ---------------------------------------------------------------------------
tap "hashicorp/tap"
tap "kayac/tap"
tap "hudochenkov/sshpass"
tap "stablyai/orca"

# ---------------------------------------------------------------------------
# シェル環境
# ---------------------------------------------------------------------------
brew "zsh-completions"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"

# ---------------------------------------------------------------------------
# 言語バージョン管理
#   実際の Ruby / Node / Python は anyenv 経由で入れる (config/envs.conf)。
#   brew で node を入れると anyenv と二重管理になるので入れない。
# ---------------------------------------------------------------------------
brew "anyenv"

# anyenv が Ruby / Python をソースからビルドするときに必要になるもの
brew "autoconf"
brew "gmp"
brew "libyaml"
brew "openssl@3"
brew "pkgconf"
brew "readline"
brew "sqlite"
brew "xz"
brew "zlib"

# ---------------------------------------------------------------------------
# Git
# ---------------------------------------------------------------------------
brew "git"
brew "git-lfs"
brew "gh"
brew "lefthook"

# ---------------------------------------------------------------------------
# メディア / ファイル変換
# ---------------------------------------------------------------------------
brew "ffmpeg"
brew "imagemagick"
brew "yt-dlp"
brew "unar"
brew "wimlib"

# ---------------------------------------------------------------------------
# CLI 道具
# ---------------------------------------------------------------------------
brew "fd"              # find の代わり
brew "jq"
brew "mas"             # App Store のアプリを CLI から
brew "ripgrep"         # grep の代わり (rg)
brew "shellcheck"      # シェルスクリプトの静的検査 (このリポジトリの lint に使う)
brew "tree"
brew "wget"

# ---------------------------------------------------------------------------
# クラウド / インフラ / ネットワーク
# ---------------------------------------------------------------------------
brew "awscli"
brew "openvpn"
brew "hashicorp/tap/terraform"
brew "kayac/tap/ecspresso"
brew "hudochenkov/sshpass/sshpass"

# ---------------------------------------------------------------------------
# ハードウェア
# ---------------------------------------------------------------------------
brew "arduino-cli"

# ---------------------------------------------------------------------------
# GUI: 開発
# ---------------------------------------------------------------------------
cask "android-commandlinetools"
cask "android-studio"
cask "arduino-ide"
cask "charles"
cask "cursor"
cask "docker-desktop"
cask "figma"
cask "gcloud-cli"
cask "iterm2"
cask "pgadmin4"
cask "postman"
cask "session-manager-plugin"
cask "drawio"

# ---------------------------------------------------------------------------
# GUI: AI / エージェント
# ---------------------------------------------------------------------------
cask "chatgpt"
cask "claude-code"
cask "codex"
cask "stablyai/orca/orca"

# ---------------------------------------------------------------------------
# GUI: コミュニケーション
# ---------------------------------------------------------------------------
cask "slack"
cask "discord"
cask "whatsapp"
cask "zoom"

# ---------------------------------------------------------------------------
# GUI: ブラウザ
# ---------------------------------------------------------------------------
cask "google-chrome"

# ---------------------------------------------------------------------------
# GUI: ユーティリティ
# ---------------------------------------------------------------------------
cask "1password"
cask "1password-cli"
cask "clipy"
cask "coconutbattery"
cask "keyboardcleantool"
cask "notunes"
cask "openvpn-connect"
cask "tailscale-app"

# ---------------------------------------------------------------------------
# GUI: その他
# ---------------------------------------------------------------------------
cask "calibre"
cask "epic-games"
cask "moonlight"
cask "spotify"
cask "steam"
cask "vlc"

# ---------------------------------------------------------------------------
# App Store 経由 (mas)
#   Apple ID でサインイン済みかつ購入履歴にあるものだけ入る。
#   必要になったらコメントを外す。ID は `mas list` で確認できる。
# ---------------------------------------------------------------------------
# mas "Xcode",  id: 497799835
# mas "LINE",   id: 539883307
# mas "Kindle", id: 302584613
# mas "RunCat", id: 1429033973
