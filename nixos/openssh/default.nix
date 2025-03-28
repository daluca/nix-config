{ config, lib, ... }:
let
  inherit (lib.path) append;
  inherit (config.networking) hostName domain;
  inherit (config.sops) secrets;
in {
  environment.etc."ssh/ssh_host_ed25519_key.pub".source = append ../../hosts "${hostName}/keys/ssh_host_ed25519_key.pub";

  environment.etc."ssh/ssh_host_ed25519_key" = {
    source = secrets."ssh_host_ed25519_key".path;
    mode = "0400";
  };

  sops.secrets."ssh_host_ed25519_key".key = "id_ed25519";

  environment.etc."ssh/ssh_host_rsa_key.pub".source = append ../../hosts "${hostName}/keys/ssh_host_rsa_key.pub";

  environment.etc."ssh/ssh_host_rsa_key" = {
    source = secrets."ssh_host_rsa_key".path;
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
      extraHostNames = [ "storwind.${domain}" "10.0.0.10" ];
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
      extraHostNames = [ "darnassus.${domain}" "10.2.74.60" ];
      publicKeyFile = ../../hosts/darnassus/keys/ssh_host_ed25519_key.pub;
    };
    "darnassus/rsa" = {
      hostNames = [ "darnassus" ] ++ darnassus.extraHostNames;
      publicKeyFile = ../../hosts/darnassus/keys/ssh_host_rsa_key.pub;
    };
    guiltyspark = {
      extraHostNames = [ "guiltyspark.${domain}" "10.1.219.30" ];
      publicKeyFile = ../../hosts/guiltyspark/keys/ssh_host_ed25519_key.pub;
    };
    "guiltyspark/rsa" = {
      hostNames = [ "guiltyspark" ] ++ guiltyspark.extraHostNames;
      publicKeyFile = ../../hosts/guiltyspark/keys/ssh_host_rsa_key.pub;
    };
    gainas = {
      extraHostNames = [ "gainas.${domain}" "10.2.161.172" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF485Ey6FSRpM/6BnEiN+RXWoKln5YszVumSuCnUc9ae root@gainas";
    };
    "gainas/rsa" = {
      hostNames = [ "gainas" ] ++ gainas.extraHostNames;
      publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCsPlgTOVoTkGVDO4lyqbFOuuJfx8+xmccHZ/R2nC7QMrN7N5d1cYeKNL9pSBC4Eg0+Sco1wOR/ASqziWvu51jAEmkAG3bdf7Jy587xoIROe80ZYow3F5o0tto4gI7InkQBwwjMt7ZMw3/92aYaRyZk9BjCUeHXGdePS54bF9KH70l8o7KtvoEyLrI2A5O+uucmz3nfGym9YSulUmWXT8HcWDRLxVkw4cJ5e1rptuxNIkiayTSBcdRjvIVBfwjmMFMFBtFaHY29nv63A21jw5gxSGkDe/QzEt8JCtjbTpp6XJtYdOGUhpTcSFPG4DAAPU4IjveHRW1xLVvFbqtO0z4S2gnDXex4HEC/2MALxuv81i01U30o75isl2rsWBkBwTzVi2odO5PZ3Y51kYdHgjLHh0VPLxSvCa0v4lZ0yuM2jE0DZWrbSSrlZVvQStJdVbquidLLtrD69CH4MKzA8H2cbX0Oyos6bjyLEbt5o+qUvKdlFwGonkMUpk0E+ig3jdE= root@gainas";
    };
    "github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
    "github.com/rsa".publicKey = "github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=";
    "gitlab.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
    "gitlab.com/rsa".publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bNKTBSpIYDEGk9KxsGh3mySTRgMtXL583qmBpzeQ+jqCMRgBqB98u3z++J1sKlXHWfM9dyhSevkMwSbhoR8XIq/U0tCNyokEi/ueaBMCvbcTHhO7FcwzY92WK4Yt0aGROY5qX2UKSeOvuP4D6TPqKF1onrSzH9bx9XUf2lEdWT/ia1NEKjunUqu1xOB/StKDHMoX4/OKyIzuS0q/T1zOATthvasJFoPrAjkohTyaDUz2LN5JoH839hViyEG82yB+MjcFV5MU3N1l1QL3cVUCh93xSaua1N85qivl+siMkPGbO5xR/En4iEY6K2XPASUEMaieWVNTRCtJ4S8H+9";
  };
}
