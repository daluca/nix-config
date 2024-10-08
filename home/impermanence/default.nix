{ inputs, ...}:

{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence

    ./zsh.nix
    ./secrets.nix
    ./openssh.nix
  ];

  home.persistence.home = {
    persistentStoragePath = "/persistent/home/daluca";
    allowOther = true;
    directories = [
      ".local/share/keyrings"
    ];
  };
}
