# goenv

# TODO: Delete after fix GOROOT
if ! [[ -d $HOME/opt/go ]]; then
  echo 'not found $HOME/opt/go'
fi

# LOCAL
if [[ -d $HOME/opt/go ]] && [[ "$GOROOT" = "" ]]; then
  export GOROOT=$HOME/opt/go
  export PATH=$PATH:$GOROOT/bin
fi

if [[ -d $HOME/gowork ]] && [[ "$GOPATH" = "" ]] && [[ "$GOROOT" != "" ]]; then
  export GOPATH=$HOME/gowork
  export PATH=$PATH:$GOPATH/bin
fi

