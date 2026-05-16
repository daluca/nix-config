{
  pkgs,
  inputs,
  ...
}:

{
  disabledModules = [
    "services/misc/jellyseerr.nix"
  ];

  imports = [
    (inputs.nixpkgs-unstable + "/nixos/modules/services/misc/seerr.nix")
  ];

  services.seerr = {
    enable = true;
    # TODO: Remove in nixos 26.05
    package = pkgs.unstable.seerr;
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/private 0700 - - -"
  ];

  environment.persistence.system.directories = [
    {
      directory = "/var/lib/private/jellyseerr";
      mode = "0700";
      defaultPerms.mode = "0700";
    }
  ];
}
