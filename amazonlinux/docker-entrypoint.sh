#!/bin/bash
# -----------------------------------
# docker-entrypoint.sh
# -----------------------------------
set -e

echo "start $(basename $0)"
echo "引数を解析します"

echo "=== getopts ==="
while getopts "a:b:" opt; do
  case $opt in
    a)
      echo "Option -a was specified with value $OPTARG"
      ;;
    b)
      echo "Option -b was specified with value $OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done
echo "==============="

echo "end $(basename $0)"
