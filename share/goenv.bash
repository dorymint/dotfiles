# goenv

# LOCAL

# GOROOT
if [ -d "$HOME"/github.com/golang/go/bin ]; then
  if [ -z "$GOROOT" ]; then
    export GOROOT="$HOME"/github.com/golang/go
    export PATH="$PATH":"$GOROOT"/bin
  fi
else
  echo 'not found $HOME/github.com/golang/go/bin'
fi

# GOPATH
if [ -d "$HOME"/gowork ]; then
  if [ "$GOPATH" = "" ] && [ "$GOROOT" != "" ]; then
    export GOPATH="$HOME"/gowork
    export PATH="$PATH":"$GOPATH"/bin
  fi
else
  echo 'not found $HOME/gowork'
fi
# EOF
