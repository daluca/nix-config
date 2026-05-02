hostname := `hostname`

[private]
default:
    @just --list

[group("flake")]
check:
    nix flake check --all-systems

[group("checks")]
pre-commit:
    pre-commit run --all-files

[group("flake")]
update:
    nix flake update

[group("secrets")]
rotate:
    fd "sops.yaml$" --exec sops rotate --in-place

[group("secrets")]
update-keys:
    fd "sops.yaml$" --exec sops updatekeys --yes

[group("local")]
switch:
    nh os switch

[group("local")]
boot:
    nh os boot

[group("hosts")]
deploy host:
    deploy --skip-checks .#{{ host }}

[group("hosts")]
push:
    colmena apply push --on @raspberry-pi,@hetzner,guiltyspark

[no-exit-message]
[group("hosts")]
unlock host:
    sops --decrypt --extract '["disk-encryption-key"]' hosts/{{ host }}/{{ host }}.sops.yaml | ssh root@{{ host }} -p 22022
