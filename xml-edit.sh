#!/bin/sh -eu

usage() {
  cat >&2 <<- EOF
Usage : $0 <tag> <value> <file>

EOF
}

if test $# -lt 3; then
  usage
  exit 1
fi

tag="$1"
value="$2"
file="$3"

result=$(sed -e "s|<${tag}>[^<]*</${tag}>|<${tag}>${value}</${tag}>|g" "$file") || exit 1
echo "$result" > "$file"
