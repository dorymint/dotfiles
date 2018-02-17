# golang

# GOROOT
if [ -x "${HOME}"/github.com/golang/go/bin/go ]; then
	export GOROOT="${HOME}"/github.com/golang/go
	# priority up
	export PATH="${GOROOT}"/bin:"${PATH}"
	#export PATH="$PATH":"${GOROOT}"/bin
fi

# GOPATH
if [ -d "${HOME}"/go ]; then
	export GOPATH="${HOME}"/go
	export PATH="${PATH}":"${GOPATH}"/bin
fi
