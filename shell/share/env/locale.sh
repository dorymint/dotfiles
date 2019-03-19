# locale conf

export LC_MESSAGES=C
export LC_COLLATE=C

if true; then
  export LANG=ja_JP.UTF-8
  export LANGUAGE=ja_JP:en_US
else
  export LANG=en_US.UTF-8
  export LANGUAGE=en_US
fi

### XDG
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_DATA_HOME="$HOME"/.local/share
# set with pam_systemd
#XDG_RUNTIME_DIR

if builtin command -v vim > /dev/null 2>&1; then
  export EDITOR="vim"
fi

if builtin command -v firefox > /dev/null 2>&1; then
  export BROWSER="firefox"
fi

### input method frameworks
imf="ibus"
case "$imf" in
  fcitx)
    if builtin command -v fcitx-autostart > /dev/null 2>&1; then
      export GTK_IM_MODULE=fcitx
      export XMODIFIERS=@im=fcitx
      export QT_IM_MODULE=fcitx
    fi
    ;;
  ibus)
    if builtin command -v ibus-daemon > /dev/null 2>&1; then
      export GTK_IM_MODULE=ibus
      export XMODIFIERS=@im=ibus
      export QT_IM_MODULE=ibus
    fi
    ;;
  *)
    ;;
esac
unset imf

