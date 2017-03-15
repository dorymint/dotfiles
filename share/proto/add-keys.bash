#!/bin/sh
if [ -n "$SSH_AUTH_SOCK" ];then
  ssh-add "$HOME"/.ssh/id_rsa
else
  echo "ssh socket: not found"
fi
# EOF
