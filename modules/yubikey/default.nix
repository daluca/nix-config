{ inputs, ... }:

{
  flake.nixosModules.yubikey = { pkgs, ... }: {
    imports = with inputs.self.nixosModules; [
      home-manager
      smartCards
    ];

    services.udev.packages = with pkgs; [
      yubikey-personalization
    ];

    security.pam.services = {
      login.u2f.enable = true;
      sudo.u2f.enable = true;
    };

    security.pam.u2f.settings = {
      interactive = true;
      cue = true;
    };

    services.udev.extraRules = ''
      ACTION=="remove",\
       ENV{ID_BUS}=="usb",\
       ENV{ID_MODEL_ID}=="0407",\
       ENV{ID_VENDOR_ID}=="1050",\
       ENV{ID_VENDOR}=="Yubico",\
       RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
    '';

    home-manager.users.daluca.imports = with inputs.self.homeManagerModules; [
      yubikey
    ];
  };

  flake.homeManagerModules.yubikey = { config, lib, ... }: {
    xdg.configFile."Yubico/u2f_keys".text =
      with config.home;
      lib.concatStringsSep ":" [
        username
        "h3s2Y3IywzOVDrGRunXpoA8PKZUCmUTRG8Z7KHG1hdTOUxgw5vI2tVQ8KLObx2PT2bFT+rNriCE/Ea7puZ98rg==,irVpmIGEu7eBtsHWoQ+bQSxEn7UnFNPOEHzMVzMtaUJUc5VO31T3hg0sUqtJeiGZ4h6jdWgOIoBob4Tql6ulSQ==,es256,+presence"
        "+wVlTgQUHWtq7RiWvFVhR7/PDIyRK7ZQJ7U2uvOpb0qPBGvKg21fYYtbJXpdzHNl3tb9mFYAsDvy7hLpwSv6SA==,0yobt/pmQ5HYe9FJC96R6yc7Efg8qvtkIzVC/laCsr3AeJZ6SDD1ntjUkE2p3vCUw8nQU7CxVdpfg9jcRvP3Hg==,es256,+presence"
      ];

    programs.gpg.publicKeys = [
      {
        source = ./0x7626A2AB23757525-2026-07-09.asc;
        trust = "ultimate";
      }
    ];
  };
}
