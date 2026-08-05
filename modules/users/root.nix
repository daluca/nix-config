{
  flake.nixosModules.users-root = {
    users.users.root = {
      openssh.authorizedKeys.keyFiles = [
        ../../users/daluca/keys/id_ed25519.pub
      ];
    };

    services.openssh.settings.AllowUsers = [
      "root"
    ];
  };
}
