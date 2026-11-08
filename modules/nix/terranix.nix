{ inputs, ... }:

{
  imports = with inputs; [
    terranix.flakeModule
  ];

  perSystem =
    {
      self',
      pkgs,
      secrets,
      ...
    }:
    {
      terranix.terranixConfigurations.cloud = {
        modules = [ (inputs.import-tree ../../terraform) ];
        workdir = ".terranix/cloud";
        terraformWrapper = {
          package = pkgs.unstable.opentofu.withPlugins (
            p: with p; [
              hetznercloud_hcloud
              cloudflare_cloudflare
              self'.packages.terraform-provider-netbird
            ]
          );
          prefixText = /* bash */ ''
            export NB_MANAGEMENT_URL=https://netbird.${secrets.domains.general}
          '';
        };
      };
    };
}
