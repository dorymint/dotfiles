# goenv

# LOCAL

# GOROOT
# TODO: fix GOROOT
if [[ -d $HOME/opt/go ]]; then
  if [[ "$GOROOT" = "" ]]; then
    export GOROOT=$HOME/opt/go
    export PATH=$PATH:$GOROOT/bin
  fi
else
  echo 'not found $HOME/opt/go'
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
