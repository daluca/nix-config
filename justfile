hostname := `hostname`

[private]
default:
    @just --list

update-secret-key:
    fd "sops.yaml$" --exec sops updatekeys

rotate-secrets:
    fd "sops.yaml$" --exec sops rotate --in-place

build-image type:
    nix build .#images.{{ type }}

rebuild host=hostname:
    sudo nixos-rebuild switch --flake .#{{ host }}

deploy host:
    deploy .#{{ host }} --skip-checks

check:
    nix flake check --all-systems

disko host:
    nix --experimental-features "nix-command flakes" run github:nix-community/disko/v1.10.0 -- --mode disko --flake .#{{ host }}

nixos-install host:
    nixos-install --flake .#{{ host }} --no-root-passwd
