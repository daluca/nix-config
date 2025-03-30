{ secrets, ... }:

{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
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
