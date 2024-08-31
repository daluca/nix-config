{ ... }:

{
  imports = [
    ./rules
  ];

  networking.firewall = {
    enable = true;
  };
}
