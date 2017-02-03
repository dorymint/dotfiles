#!/bin/bash
if [[ -z "$SSH_AUTH_SOCK" ]] && [[ -z "$SSH_AGENT_PID" ]]; then
  eval "$(ssh-agent -s)"
fi
# EOF
