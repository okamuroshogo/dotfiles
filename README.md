# dotfiles

まっさらな macOS を1行で自分の開発環境にするためのリポジトリ。

旧版 (homesick ベース) は [okamuroshogo/dotfiles-archive](https://github.com/okamuroshogo/dotfiles-archive) にアーカイブしてあります。こちらは設計から作り直した版です。

## セットアップ

新しい Mac で、ターミナルを開いて1行:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/okamuroshogo/dotfiles/main/bootstrap.sh)"
```

これだけで以下が終わります。途中で聞かれるのは**管理者パスワード1回だけ**です。

| | 内容 |
|---|---|
| 10 | Xcode Command Line Tools |
| 20 | Homebrew |
| 30 | `Brewfile` の CLI ツールと GUI アプリ |
| 40 | anyenv と rbenv / nodenv / pyenv |
| 50 | Ruby / Node / Python の最新安定版をビルドして global に設定 |
| 60 | `home/` 以下を `~` にシンボリックリンク |
| 70 | macOS のシステム設定 (`defaults`) |
| 80 | 自宅Wi-Fi検知でDNSを切り替える launchd デーモン |

終わったら新しいシェルを開きます:

```sh
exec $SHELL -l
```

> 初回は Ruby と Python をソースからビルドするので、全体で30分〜1時間ほどかかります。

## 設計の方針

**何度実行しても壊れない。** すべてのステップが「今どうなっているか」を見てから動きます。すでに望む状態なら何もしません。途中で失敗しても、直して再実行すれば続きから整います。

**設定ファイルが唯一の正。** 何を入れるか・どう設定するかはすべてリポジトリ内のファイルに書いてあり、スクリプトはそれを現実に反映させるだけです。

| 変えたいもの | 編集するファイル | 反映 |
|---|---|---|
| CLI ツール / GUI アプリ | `Brewfile` | `./install.sh --only 30` |
| Ruby / Node / Python のバージョン | `config/envs.conf` | `./install.sh --only 50` |
| シェルの設定 | `home/.config/zsh/conf.d/*.zsh` | リンク済みなので即反映 |
| Git の設定 | `home/.gitconfig` | 同上 |
| 自宅の SSID と DNS | `config/dns-switch/dns-switch.conf` | `./install.sh --only 80` |
| macOS のシステム設定 | `scripts/70-macos-defaults.sh` | `./install.sh --only 70` |

**既存のファイルを黙って消さない。** `~/.zshrc` などに実体ファイルがあった場合は `~/.dotfiles-backup/<日時>/` に退避してからリンクを張ります。

## install.sh の使い方

```sh
./install.sh                  # 全部
./install.sh --dry-run        # 何をするか見るだけ (実際には変更しない)
./install.sh --list           # ステップ一覧
./install.sh --only 30        # Brewfile だけ入れ直す
./install.sh --only 40 50     # anyenv と言語だけ
./install.sh --skip 70        # macOS 設定だけ飛ばす
```

各ステップは単体でも実行できます (`bash scripts/60-symlinks.sh`)。

## 中身

```
bootstrap.sh                   ワンライナーの入口 (brew を入れて clone して install.sh を呼ぶ)
install.sh                     本体。scripts/ を番号順に実行する
lib/common.sh                  ログ・冪等なリンク・sudo 維持などの共通処理
Brewfile                       入れるものの一覧
config/
  envs.conf                    anyenv で入れる **env とバージョン
  dns-switch/                  DNS 切り替えの設定と launchd plist
bin/dns-switch                 DNS 切り替え本体
scripts/[0-9][0-9]-*.sh        セットアップの各ステップ
home/                          ~ にリンクされるファイル (この構造がそのまま ~ に対応)
  .zshenv .zprofile .zshrc
  .config/zsh/conf.d/*.zsh
  .gitconfig .gitignore_global
```

## シェル設定

`~/.zshrc` 本体はただのローダーで、中身は `~/.config/zsh/conf.d/` に1テーマ1ファイルで置いてあります。要らなくなったらファイルを消すだけで済みます。

```
10-options.zsh       基本の挙動、ロケール、EDITOR、ls の色
20-history.zsh       履歴
30-completion.zsh    補完 (compinit のキャッシュつき)
40-keybindings.zsh   キーバインド
50-aliases.zsh       エイリアス (ls / ll / la / grep / vim のみ)
60-prompt.zsh        プロンプト (zsh 標準の vcs_info、外部プラグインなし)
70-anyenv.zsh        anyenv の初期化
80-android.zsh       Android SDK / NDK (SDK が無いマシンでは自動で無効)
90-plugins.zsh       zsh-autosuggestions / zsh-syntax-highlighting
```

マシン固有の設定は git 管理外のファイルに書きます。

- `~/.zshrc.local` — そのマシンにしかないパス、仕事用のトークンなど
- `~/.gitconfig.local` — 仕事用の `user.email` など

### 旧版から変えたところ

- **tmux を廃止**。自動起動、`tclaude` / `c` 関数、`.tmux.conf`、`reattach-to-user-namespace` をすべて削除
- **zplug / prezto / powerlevel9k を廃止**。起動が遅く依存も多かったので、zsh 標準機能だけでプロンプトと補完を組み直した
- **ショートカットを整理**。`^K` の cdup、`cd` 後の自動 `ls`、`title` 関数などを削除。エイリアスは5つだけ
- **死んだパスを削除**。`/usr/local/bin/nvim`、`vimpager`、`php@7.3`、`imagemagick@6`、serverless の tabtab、Flutter などの Intel 時代の決め打ちパス
- **`LC_ALL` を外した**。`LANG=ja_JP.UTF-8` と矛盾していたため
- **Node を anyenv 一本化**。`brew install node@22` との二重管理をやめた

## 自宅Wi-Fi検知によるDNS切り替え

自宅の Wi-Fi につないだときだけ DNS を固定し、それ以外の場所では自動取得 (DHCP) に戻します。

```sh
sudo dns-switch --status           # 今どう判定されているか
sudo dns-switch                    # 手動で実行
sudo tail -f /var/log/dns-switch.log
sudo launchctl bootout system/ro.okamu.dns-switch   # 止める
```

設定は `config/dns-switch/dns-switch.conf`:

```sh
HOME_SSID="NSD1K-9118-a"
HOME_DNS="192.168.100.53 192.168.100.54"
```

編集したら `./install.sh --only 80` で反映します。

### しくみ

`/Library/LaunchDaemons/ro.okamu.dns-switch.plist` が、

- 起動時 (`RunAtLoad`)
- `/var/run/resolv.conf` と SystemConfiguration の設定ファイルが変わったとき (`WatchPaths`)
- 5分ごとの保険 (`StartInterval`)

に `/usr/local/sbin/dns-switch` を呼びます。

スクリプトは **「あるべき状態」と「今の状態」を比べて、違うときだけ `networksetup` を叩きます**。これは必須の作りです。無条件に書き換えると自分の変更で `resolv.conf` が変わり、`WatchPaths` が自分自身を呼び戻して無限ループになります。

LaunchAgent (ユーザ権限) ではなく **LaunchDaemon (root)** にしてあるのは、`networksetup -setdnsservers` に管理者権限が必要で、ユーザ権限だと毎回パスワードを聞かれてしまうからです。root が実行するファイルなので `/usr/local/sbin/dns-switch` と設定ファイルは `root:wheel` 所有に固定しています。

SSID の取得には `ipconfig getsummary` を使っています。macOS 14 以降、`networksetup -getairportnetwork` は位置情報の許可がないと接続中でも「not associated」としか答えないためです (`networksetup` はフォールバックとして残してあります)。

## メンテナンス

```sh
# dotfiles 自体を更新
git -C ~/.dotfiles pull && ~/.dotfiles/install.sh

# Homebrew
brew update && brew upgrade && brew upgrade --cask

# anyenv と **env をまとめて更新 (anyenv-update プラグイン)
anyenv update

# 言語を最新安定版に上げ直す
~/.dotfiles/install.sh --only 50

# Brewfile に無いものを掃除 (消える対象を確認してから)
brew bundle cleanup --file=~/.dotfiles/Brewfile
brew bundle cleanup --file=~/.dotfiles/Brewfile --force
```

`install.sh` は意図的に `brew upgrade` と `brew bundle cleanup` を自動実行しません。黙ってパッケージを上げたり消したりしないためです。

## 補足

- すでに使っている Mac でも実行できます。`brew bundle` は手で入れた既存アプリを `--adopt` で取り込むので、`/Applications` にあるアプリと衝突しません。
- App Store 経由のアプリ (Xcode, LINE, Kindle など) は `Brewfile` の末尾に `mas` の行をコメントで用意してあります。Apple ID でサインインしたうえでコメントを外してください。

## このリポジトリを触るとき

```sh
shellcheck -S info bootstrap.sh install.sh lib/common.sh scripts/*.sh bin/dns-switch
for f in home/.zshenv home/.zprofile home/.zshrc home/.config/zsh/conf.d/*.zsh; do zsh -n "$f"; done
plutil -lint config/dns-switch/*.plist
./install.sh --dry-run
```

同じ検査を GitHub Actions (`.github/workflows/lint.yml`) でも回しています。コミット前に自動で走らせたい場合は `lefthook install` を一度実行してください。
