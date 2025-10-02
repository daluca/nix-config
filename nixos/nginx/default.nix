{ lib, pkgs, secrets, inputs, ... }:
let
  cloudflare-ipv4 = lib.splitString "\n" (builtins.readFile (builtins.fetchurl {
    url = "https://www.cloudflare.com/ips-v4";
    sha256 = "sha256:0ywy9sg7spafi3gm9q5wb59lbiq0swvf0q3iazl0maq1pj1nsb7h";
  }));
  cloudflare-ipv6 = lib.splitString "\n" (builtins.readFile (builtins.fetchurl {
    url = "https://www.cloudflare.com/ips-v6";
    sha256 = "sha256:1ad09hijignj6zlqvdjxv7rjj8567z357zfavv201b9vx3ikk7cy";
  }));
  cloudflare-real-ips = pkgs.writeText "cloudflare-proxy-ips" /* nginx */ ''
    set_real_ip_from ${lib.concatStringsSep ";\nset_real_ip_from " cloudflare-ipv4};

    set_real_ip_from ${lib.concatStringsSep ";\nset_real_ip_from " cloudflare-ipv6};

    real_ip_header CF-Connecting-IP;
  '';
in {
  # NOTE: Remove in NixOS 25.11
  disabledModules = [
    "services/web-servers/nginx/default.nix"
  ];

  imports = with inputs; [
    (nixpkgs-unstable + "/nixos/modules/services/web-servers/nginx")
  ];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    appendHttpConfig = /* nginx */ ''
      include ${cloudflare-real-ips};
    '';
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "letsencrypt@${secrets.email.alias.primary}";
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
