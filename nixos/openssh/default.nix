{ config, lib, secrets, ... }:
let
  inherit (config.networking) hostName domain;
in {
  environment.etc."ssh/ssh_host_ed25519_key.pub".source = lib.custom.relativeToHosts "${hostName}/keys/ssh_host_ed25519_key.pub";

  environment.etc."ssh/ssh_host_ed25519_key" = lib.mkIf (! config.environment.persistence.system.enable) {
    source = config.sops.secrets."ssh_host_ed25519_key".path;
    mode = "0400";
  };

  sops.secrets."ssh_host_ed25519_key".key = "id_ed25519";

  environment.etc."ssh/ssh_host_rsa_key.pub".source = lib.custom.relativeToHosts "${hostName}/keys/ssh_host_rsa_key.pub";

  environment.etc."ssh/ssh_host_rsa_key" = lib.mkIf (! config.environment.persistence.system.enable) {
    source = config.sops.secrets."ssh_host_rsa_key".path;
    mode = "0400";
  };

  sops.secrets."ssh_host_rsa_key".key = "id_rsa";

  programs.ssh.knownHosts = rec {
    artemis = {
      extraHostNames = [ "artemis.${domain}" "10.1.127.236" ];
      publicKeyFile = ../../hosts/artemis/keys/ssh_host_ed25519_key.pub;
    };
    "artemis/rsa" = {
      hostNames = [ "artemis" ] ++ artemis.extraHostNames;
      publicKeyFile = ../../hosts/artemis/keys/ssh_host_rsa_key.pub;
    };
    stormwind = {
      extraHostNames = [ "storwind.${domain}" "192.168.178.10" ];
      publicKeyFile = ../../hosts/stormwind/keys/ssh_host_ed25519_key.pub;
    };
    "stormwind/rsa" = {
      hostNames = [ "stormwind" ] ++ stormwind.extraHostNames;
      publicKeyFile = ../../hosts/stormwind/keys/ssh_host_rsa_key.pub;
    };
    ironforge = {
      extraHostNames = [ "ironforge.${domain}" "192.168.1.10" ];
      publicKeyFile = ../../hosts/ironforge/keys/ssh_host_ed25519_key.pub;
    };
    "ironforge/rsa" = {
      hostNames = [ "ironforge" ] ++ ironforge.extraHostNames;
      publicKeyFile = ../../hosts/ironforge/keys/ssh_host_rsa_key.pub;
    };
    darnassus = {
      extraHostNames = [ "darnassus.${domain}" "192.168.1.212" ];
      publicKeyFile = ../../hosts/darnassus/keys/ssh_host_ed25519_key.pub;
    };
    "darnassus/rsa" = {
      hostNames = [ "darnassus" ] ++ darnassus.extraHostNames;
      publicKeyFile = ../../hosts/darnassus/keys/ssh_host_rsa_key.pub;
    };
    guiltyspark = {
      extraHostNames = [ "guiltyspark.${domain}" "192.168.1.21" ];
      publicKeyFile = ../../hosts/guiltyspark/keys/ssh_host_ed25519_key.pub;
    };
    "guiltyspark/rsa" = {
      hostNames = [ "guiltyspark" ] ++ guiltyspark.extraHostNames;
      publicKeyFile = ../../hosts/guiltyspark/keys/ssh_host_rsa_key.pub;
    };
    unifi = {
      extraHostNames = [ "unifi.${domain}" secrets.hosts.unifi.ipv4-address ];
      publicKeyFile = ../../hosts/unifi/keys/ssh_host_ed25519_key.pub;
    };
    "unifi/rsa" = {
      hostNames = [ "unifi" ] ++ unifi.extraHostNames;
      publicKeyFile = ../../hosts/unifi/keys/ssh_host_rsa_key.pub;
    };
    alfa = {
      extraHostNames = [ "alfa.${domain}" secrets.hosts.alfa.ipv4-address ];
      publicKeyFile = ../../hosts/alfa/keys/ssh_host_ed25519_key.pub;
    };
    "alfa/rsa" = {
      hostNames = [ "alfa" ] ++ alfa.extraHostNames;
      publicKeyFile = ../../hosts/alfa/keys/ssh_host_rsa_key.pub;
    };
    bravo = {
      extraHostNames = [ "bravo.${domain}" secrets.hosts.bravo.ipv4-address ];
      publicKeyFile = ../../hosts/bravo/keys/ssh_host_ed25519_key.pub;
    };
    "bravo/rsa" = {
      hostNames = [ "bravo" ] ++ bravo.extraHostNames;
      publicKeyFile = ../../hosts/bravo/keys/ssh_host_rsa_key.pub;
    };
    "github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
    "github.com/rsa".publicKey = "github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=";
    "gitlab.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
    "gitlab.com/rsa".publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bNKTBSpIYDEGk9KxsGh3mySTRgMtXL583qmBpzeQ+jqCMRgBqB98u3z++J1sKlXHWfM9dyhSevkMwSbhoR8XIq/U0tCNyokEi/ueaBMCvbcTHhO7FcwzY92WK4Yt0aGROY5qX2UKSeOvuP4D6TPqKF1onrSzH9bx9XUf2lEdWT/ia1NEKjunUqu1xOB/StKDHMoX4/OKyIzuS0q/T1zOATthvasJFoPrAjkohTyaDUz2LN5JoH839hViyEG82yB+MjcFV5MU3N1l1QL3cVUCh93xSaua1N85qivl+siMkPGbO5xR/En4iEY6K2XPASUEMaieWVNTRCtJ4S8H+9";
  };
}
