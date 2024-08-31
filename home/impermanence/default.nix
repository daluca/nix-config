{ inputs, ...}:

{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  home.persistence.home = {
    persistentStoragePath = "/persistent/home/daluca";
    allowOther = true;
    directories = [
      ".local/share/keyrings"
    ];
  };
}
