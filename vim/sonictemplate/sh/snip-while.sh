while true; do
  case "${1:-}" in
    "")
      # main
      ;;
    *)
      echo "unknown option \"${1}\""
      exit 1
      ;;
  esac
  shift
done
