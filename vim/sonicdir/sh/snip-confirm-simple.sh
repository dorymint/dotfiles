# confirm
unset counter key
counter=0 key=""
while true; do
  [ $counter -lt 3 ] || exit 1
  counter=`expr $counter + 1`
  echo -n "{{_cursor_}}[yes:no]?>"
  read -t 60 key
  case "$key" in
    "no"|"n") exit 1;;
    "yes"|"y") break;;
  esac
done
unset counter key
