# goenv

# GOROOT
if [ -x "$HOME"/github.com/golang/go/bin/go ]; then
  if [ -z "$GOROOT" ]; then
    export GOROOT="$HOME"/github.com/golang/go
    # priority up
    export PATH="$GOROOT"/bin:"$PATH"
  fi
else
  echo 'not found $HOME/github.com/golang/go/bin'
fi

# GOPATH
if [ -d "$HOME"/go ]; then
  if [ "$GOPATH" = "" ] && [ "$GOROOT" != "" ]; then
    export GOPATH="$HOME"/go
    export PATH="$PATH":"$GOPATH"/bin
  fi
else
  echo 'not found $HOME/go'
fi
# EOF
