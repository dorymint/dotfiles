# locale
export LC_MESSAGES=C
export LC_COLLATE=C
if true; then
  export LANG=ja_JP.UTF-8
  export LANGUAGE=ja_JP:en_US
else
  export LANG=en_US.UTF-8
  export LANGUAGE=en_US
fi

# XDG
XDG_CONFIG_HOME="$HOME"/.config
XDG_CACHE_HOME="$HOME"/.cache
XDG_DATA_HOME="$HOME"/.local/share

# set by pam_systemd
#XDG_RUNTIME_DIR

