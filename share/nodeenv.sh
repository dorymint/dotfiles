# nodeenv.sh
# node_modules/bin
if [ -d "$HOME"/.node_modules/bin ]; then
  export PATH="$HOME"/.node_modules/bin:"$PATH"
fi
# EOF
