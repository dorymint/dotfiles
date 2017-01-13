# goenv

# LOCAL

# GOROOT
if [[ -d $HOME/github.com/golang/go ]] && [[ -d $HOME/github.com/golang/go/bin ]]; then
  if [[ "$GOROOT" = "" ]]; then
    export GOROOT=$HOME/github.com/golang/go
# NOTE: Temporary invalid GOROOT 2016/12/23 17:53
#    export GOROOT=$HOME/go
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
