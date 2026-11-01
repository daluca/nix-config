#!/usr/bin/env -S nix
#!nix shell nixpkgs#bash nixpkgs#ssh-to-age --command bash

# shellcheck shell=bash

set -euo pipefail

function usage() {
  echo "Usage: ${0##*/} -h --debug [PRIVATE_KEY]"
  echo
  echo "Options:"
  echo "  -h  --help                    Print this help message"
  echo "      --debug                   Toggle bash debug output"
}

function main() {
  POSITIONAL_ARGS=()

  while [[ "$#" -ge 1 ]]; do
    case "$1" in
      --help|-h)
        set +x
        usage
        exit 0
        ;;
      --debug)
        set -x
        shift
        ;;
      --*|-*)
        set +x
        echo "Unknown argument: $1"
        usage
        exit 1
        ;;
      *)
        POSITIONAL_ARGS+=("$1")
        shift
        ;;
    esac
  done

  set -- "${POSITIONAL_ARGS[@]}"

  [[ "${#POSITIONAL_ARGS}" -ge 1 ]] || exit 1

  PUBLIC_AGE_KEY="$( ssh-to-age -i "${POSITIONAL_ARGS[0]}.pub" )"

  cat << EOF > nix-config.txt
# created: $(date --iso-8601=seconds)
# public key: ${PUBLIC_AGE_KEY}
$( ssh-to-age -private-key -i "${POSITIONAL_ARGS[0]}" )
EOF

  chmod 0600 nix-config.txt

  echo "age key generated from ${POSITIONAL_ARGS[0]}"
  echo "public key: ${PUBLIC_AGE_KEY}"
}

main "$@"
