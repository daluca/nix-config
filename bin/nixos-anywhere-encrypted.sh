#!/usr/bin/env -S nix shell nixpkgs#bash nixpkgs#sops nixos-anywhere --command bash

set -euo pipefail

function usage() {
  echo "Usage: ${0##*/} -h -i -c --debug [SSH_CONNECTION]"
  echo ""
  echo "Options:"
  echo "  -c  --nixos-configuration     NixOS configuration to deploy"
  echo "  -i  --impermanence            Toggle impermanence paths"
  echo "  -h  --help                    Print this help message"
  echo "      --debug                   Toggle bash debug output"
}

POSITIONAL_ARGS=()

IMPERMANENCE=""
DEBUG=false
DEBUG_NIXOS_ANYWHERE=""

while [[ "$#" -ge 1 ]]; do
  case "$1" in
    --impermanence|-i)
      IMPERMANENCE="/persistent/system"
      shift
      ;;
    --nixos-configuration|-c)
      NIXOS_HOST="$2"
      shift 2
      ;;
    --help|-h)
      DEBUG=true
      set +x
      usage
      exit 0
      ;;
    --debug)
      set -x
      shift
      ;;
    --*|-*)
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

IMPERMANENCE=${IMPERMANENCE#/}
[[ "${DEBUG}" == "true" ]] && DEBUG_NIXOS_ANYWHERE="--debug"

# Create a temporary directory
temp="$(mktemp -d)"

# Function to cleanup temporary directory on exit
cleanup() {
  rm -rf "${temp}"
}
trap cleanup EXIT

# Create the directory where sshd expects to find the host keys
install -d -m755 \
  "${temp}/${IMPERMANENCE%/*}/home/daluca/.config/sops/age/" \
  "${temp}/${IMPERMANENCE}/etc/ssh/" \
  "${temp}/${IMPERMANENCE}/var/lib/sops-nix/"

# Decrypt your private key from the password store and copy it to the temporary directory
cp ./nix-config.txt "${temp}/${IMPERMANENCE}/var/lib/sops-nix/keys.txt"
tail -n3 ~/.config/sops/age/keys.txt >> "${temp}/${IMPERMANENCE%/*}/home/daluca/.config/sops/age/keys.txt"
tail -n3 ~/.config/sops/age/keys.txt >> "${temp}/${IMPERMANENCE}/var/lib/sops-nix/keys.txt"
sops -d --extract '["id_rsa"]' --output "${temp}/${IMPERMANENCE}/etc/ssh/ssh_host_rsa_key" "./hosts/${NIXOS_HOST}/${NIXOS_HOST}.sops.yaml"
sops -d --extract '["id_ed25519"]' --output "${temp}/${IMPERMANENCE}/etc/ssh/ssh_host_ed25519_key" "./hosts/${NIXOS_HOST}/${NIXOS_HOST}.sops.yaml"

# Set the correct permissions so sshd will accept the key
chmod 0400 \
  "${temp}/${IMPERMANENCE}/var/lib/sops-nix/keys.txt" \
  "${temp}/${IMPERMANENCE}/etc/ssh/ssh_host_ed25519_key" \
  "${temp}/${IMPERMANENCE}/etc/ssh/ssh_host_rsa_key" \
  "${temp}/${IMPERMANENCE%/*}/home/daluca/.config/sops/age/keys.txt"

# Install NixOS to the host system with our secrets
nixos-anywhere \
  --extra-files "${temp}" \
  --chown "/${IMPERMANENCE%/*}/home/daluca/" 1000:100 \
  --disk-encryption-keys /tmp/passwd <( sops -d --extract '["disk-encryption-key"]' "./hosts/${NIXOS_HOST}/${NIXOS_HOST}.sops.yaml" ) \
  "${DEBUG_NIXOS_ANYWHERE}" \
  --flake ".#${NIXOS_HOST}" \
  --target-host "${POSITIONAL_ARGS[@]}"
