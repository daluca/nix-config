hostname := `hostname`

[private]
default:
    @just --list

update:
    nix flake update

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
