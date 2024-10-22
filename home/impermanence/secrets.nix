{
  home.persistence.home.directories = [ ".config/sops/age" ];

  sops.age = {
    sshKeyPaths = [ "/persistent/system/etc/ssh/ssh_host_ed25519_key" ];
    keyFile = "/persistent/system/var/lib/sops-nix/key.txt";
  };
}
