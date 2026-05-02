#! /usr/bin/env -S nix shell nixpkgs#bash nixpkgs#ssh-to-age --command bash

set -euo pipefail

PUBLIC_AGE_KEY="$( ssh-to-age -i "$1.pub" )"

cat <<- EOF > nix-config.txt
# created: $(date --iso-8601=seconds)
# public key: ${PUBLIC_AGE_KEY}
$( ssh-to-age -private-key -i "$1" )
EOF

chmod 0600 nix-config.txt

echo "age key generated from $1"
echo "public key: ${PUBLIC_AGE_KEY}"
