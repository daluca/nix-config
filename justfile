hostname := `hostname`

[private]
default:
    @just --list

[positional-arguments]
update *args='':
    nix flake update "$@"

update-secret-key:
    fd "sops.yaml$" --exec sops updatekeys --yes

rotate-secrets:
    fd "sops.yaml$" --exec sops rotate --in-place

build-image type:
    nix build .#images.{{ type }}

rebuild host=hostname:
    sudo nixos-rebuild switch --flake .#{{ host }}

deploy host: check
    deploy .#{{ host }} --skip-checks

check:
    nix flake check --all-systems

disko host:
    disko --mode destroy,format,mount --flake .#{{ host }}

nixos-install host:
    nixos-install --flake .#{{ host }} --no-root-passwd

ssh-to-age key:
    #! /usr/bin/env bash

    set -euo pipefail

    PUBLIC_AGE_KEY="$( ssh-to-age -i {{ key }}.pub )"

    # public key: $( ssh-to-age -i {{ key }}.pub )

    cat <<- EOF > nix-config.txt
    # created: $(date --iso-8601=seconds)
    # public key: ${PUBLIC_AGE_KEY}
    $( ssh-to-age -private-key -i {{ key }} )
    EOF

    chmod 0600 nix-config.txt

    echo "age key generated from {{ key }}"
    echo "public key: ${PUBLIC_AGE_KEY}"
