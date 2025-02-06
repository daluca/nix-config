{
  users.users.root = {
    openssh.authorizedKeys.keyFiles = [
      ../daluca/keys/id_ed25519.pub
    ];
  };

  services.openssh.settings.AllowUsers = [
    "root"
  ];
}
