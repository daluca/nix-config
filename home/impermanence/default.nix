{ inputs, ...}:

{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence

    ./zsh.nix
    ./secrets.nix
    ./openssh.nix
    ./neovim.nix
    ./zoxide.nix
    ./heroic.nix
    ./thunderbird.nix
    ./firefox.nix
    ./signal.nix
  ];

  home.persistence.home = {
    persistentStoragePath = "/persistent/home/daluca";
    allowOther = true;
    directories = [
      ".local/share/keyrings"
    ];
  };
}
