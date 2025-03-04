{
  sops = {
    defaultSopsFile = ../../secrets/secrets.sops.yaml;
    age = {
      sshKeyPaths = [
        "/etc/ssh/ssh_host_ed25519_key"
      ];
    };
  };

  home.persistence.home.directories = [
    ".config/sops/age"
  ];
}
