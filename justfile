[private]
default:
  @just --list

update-secrets:
  sops updatekeys "$( fd sops.yaml )"

create-age-key-from-host directory="/etc/ssh":
  #!/usr/bin/env bash
  set -euo pipefail

  mkdir -p "${XDG_CONFIG_HOME:-"${HOME}/.config"}/sops/age/"

  echo "# created: $( date +%FT%T%:z )" > "${XDG_CONFIG_HOME:-"${HOME}/.config"}/sops/age/nix-config.txt"
  echo "# public key: $( ssh-to-age -i {{ directory }}/ssh_host_ed25519_key.pub )" >> "${HOME}/.config/sops/age/nix-config.txt"
  sudo ssh-to-age -i {{ directory }}/ssh_host_ed25519_key -private-key >> "${HOME}/.config/sops/age/nix-config.txt"

build-sd-image host:
  nix build .#nixosConfigurations.{{ host }}.config.system.build.sdImage
