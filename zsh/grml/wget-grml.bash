#!/bin/bash
set -eu
cd "$(dirname "$(readlink -f "$0")")"
[ -d ./new ]

# wget -O is override
wget -O ./new/zshrc.grml http://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
wget -O ./new/zshrc.grml.local http://git.grml.org/f/grml-etc-core/etc/skel/.zshrc

# remember of check the contents
echo "----- diff zshrc.grml -----"
diff -u --color=always ./zshrc.grml ./new/zshrc.grml | less -R

echo -n "diff to next <zshrc.grml.local> >> ENTER"
read -t 60

echo "----- diff zhsrc.grml.local -----"
diff -u --color=always ./zshrc.grml.local ./new/zshrc.grml.local | less -R

[ -f "./update-grml.sh" ]
echo "----- update -----"
bash ./update-grml.sh
# EOF
