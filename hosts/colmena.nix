{ inputs, outputs }:
let
  deployments = {
    alfa.tags = [ "hetzner" "vps" "germany" ];
    bravo.tags = [ "hetzner" "vps" "germany" ];
    charlie.tags = [ "hetzner" "vps" "germany" ];
    darnassus.tags = [ "raspberry-pi" "united-kingdom" ];
    stormwind.tags = [ "raspberry-pi" "the-netherlands" ];
    ironforge.tags = [ "raspberry-pi" "new-zealand" ];
    dalaran.tags = [ "raspberry-pi" "the-netherlands" ];
    homeassistant.tags = [ "raspberry-pi" "the-netherlands" ];
    unifi.tags = [ "digitalocean" "vps" "australia" ];
    guiltyspark.tags = [ "new-zealand" ];
    artemis = {
      allowLocalDeployment = true;
      targetHost = null;
    };
  };
in {
  meta = with inputs; {
    nixpkgs = import nixpkgs { system = "x86_64-linux"; };
    nodeNixpkgs = builtins.mapAttrs (_: value: value.pkgs) outputs.nixosConfigurations // {
      dalaran = import nixos-raspberrypi.inputs.nixpkgs { system = "aarch64-linux"; };
      homeassistant = import nixos-raspberrypi.inputs.nixpkgs { system = "aarch64-linux"; };
    };
    nodeSpecialArgs = builtins.mapAttrs (_: value: value._module.specialArgs) outputs.nixosConfigurations;
  };
} // (builtins.mapAttrs (name: value: {
  imports = value._module.args.modules;
  deployment = deployments.${name} or { };
}) outputs.nixosConfigurations)
