{ inputs, ... }:

{
  imports = with inputs; [
    terranix.flakeModule
  ];

  perSystem = { pkgs, ... }: {
    terranix.terranixConfigurations.cloud = {
      modules = [ (inputs.import-tree ../terraform) ];
      workdir = ".terranix/cloud";
      terraformWrapper = {
        package = pkgs.unstable.opentofu.withPlugins (
          p: with p; [
            hetznercloud_hcloud
            cloudflare_cloudflare
          ]
        );
      };
    };
  };
}
