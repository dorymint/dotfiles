# goenv

# LOCAL

# GOROOT
if [[ -d $HOME/github.com/golang/go ]]; then
  if [[ "$GOROOT" = "" ]]; then
    export GOROOT=$HOME/github.com/golang/go
    export PATH=$PATH:$GOROOT/bin
  fi
else
  echo 'not found $HOME/github.com/golang/go'
fi

# GOPATH
if [[ -d $HOME/gowork ]]; then
  if [[ "$GOPATH" = "" ]] && [[ "$GOROOT" != "" ]]; then
    export GOPATH=$HOME/gowork
    export PATH=$PATH:$GOPATH/bin
  fi
else
  echo 'not found $HOME/gowork'
fi
# EOF
