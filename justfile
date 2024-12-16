hostname := `hostname`

[private]
default:
    @just --list

update-secrets:
    sops updatekeys "$( fd sops.yaml )"

build-image type:
    nix build .#images.{{ type }}

rebuild host=hostname:
    sudo nixos-rebuild switch --flake .#{{ host }}

deploy host: check
    deploy .#{{ host }} --skip-checks

check:
    nix flake check --all-systems

disko host:
    nix --experimental-features "nix-command flakes" run github:nix-community/disko/v1.10.0 -- --modes disko --flake .#{{ host }}
