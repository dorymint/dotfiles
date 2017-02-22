#!/bin/bash
set -e
#cd `dirname $0`

go=$GOROOT/bin/go
prof=$(pwd)/cover.prof
$go test -race -cover -coverprofile "$prof"
$go tool cover -html "$prof"
# EOF
