{ lib, pkgs, ... }:

{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = with pkgs; [
      ge-proton9-15
      ge-proton9-14
      ge-proton9-13
      ge-proton9-12
      ge-proton9-11
      ge-proton8-32
      ge-proton7-55
    ];
  };

  programs.gamemode.enable = true;

  hardware.xpadneo.enable = true;

  systemd.user.extraConfig = ''
    DefaultLimitNOFILE=${builtins.toString (8 * 1024)}
  '';
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "-";
      item = "nofile";
      value = builtins.toString (8 * 1024);
    }
    {
      domain = "*";
      type = "-";
      item = "memlock";
      value = builtins.toString (8 * 1024);
    }
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-run"
  ];
}
