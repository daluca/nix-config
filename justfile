hostname := `hostname`

[private]
default:
    @just --list

# all checks on all system types
[group("flake")]
check:
    nix flake check --all-systems

# pre-commit checks
[group("checks")]
pre-commit:
    pre-commit run --all-files

# update all flake inputs
[group("flake")]
update:
    nix flake update

# rotate all sops secrets
[group("secrets")]
rotate:
    fd "sops.yaml$" --exec sops rotate --in-place

# update all sops secrets
[group("secrets")]
update-keys:
    fd "sops.yaml$" --exec sops updatekeys --yes

# rebuild and switch nixos
[group("local")]
switch:
    nh os switch

# rebuild and set to next nixos boot
[group("local")]
boot:
    nh os boot

# deploy on remote host
[group("hosts")]
deploy host:
    deploy --skip-checks .#{{ host }}

# build and push to all hosts
[group("hosts")]
push:
    colmena apply push --on @raspberry-pi,@hetzner,guiltyspark

# remote unlock a host
[no-exit-message]
[group("hosts")]
unlock host:
    sops --decrypt --extract '["disk-encryption-key"]' hosts/{{ host }}/{{ host }}.sops.yaml | ssh root@{{ host }} -p 22022

# add age identity file
[group("repo")]
add-identity file:
    nix run nixpkgs#git-agecrypt -- config add --identity {{ file }}

# clean repository
[group("repo")]
clean:
    unlink result 2>/dev/null || true
    rm ssh_*_key cache-*-key.pem nix-config.txt 2>/dev/null || true
