# Android SDK / NDK。
# SDK が無いマシンでは丸ごと無効になるように、存在チェックで囲んである。

_android_sdk="$HOME/Library/Android/sdk"

if [[ -d "$_android_sdk" ]]; then
  export ANDROID_HOME="$_android_sdk"
  export ANDROID_SDK_ROOT="$_android_sdk"

  path=(
    "$_android_sdk/platform-tools"(N-/)
    "$_android_sdk/cmdline-tools/latest/bin"(N-/)
    $path
  )

  # NDK はバージョン番号つきのディレクトリなので、入っている中で一番新しいものを使う
  _ndk_dirs=("$_android_sdk"/ndk/*(N/on))
  if (( ${#_ndk_dirs} )); then
    export NDK_ROOT="${_ndk_dirs[-1]}"
    export NDKROOT="$NDK_ROOT"      # 古いビルドスクリプトが見る名前
    export ANDROID_NDK_HOME="$NDK_ROOT"
  fi
  unset _ndk_dirs

  # Android Studio 同梱の JDK を使う (別で JDK を入れなくて済む)
  _jbr="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
  if [[ -x "$_jbr/bin/java" ]]; then
    export JAVA_HOME="$_jbr"
    path=("$JAVA_HOME/bin" $path)
  fi
  unset _jbr
fi

unset _android_sdk
