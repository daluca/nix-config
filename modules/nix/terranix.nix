{ inputs, ... }:

{
  imports = with inputs; [
    terranix.flakeModule
  ];

  perSystem = { pkgs, secrets, ... }: {
    terranix.terranixConfigurations.cloud = {
      modules = [ (inputs.import-tree ../../terraform) ];
      workdir = ".terranix/cloud";
      terraformWrapper = {
        package = pkgs.unstable.opentofu.withPlugins (
          p: with p; [
            hetznercloud_hcloud
            cloudflare_cloudflare
            netbirdio_netbird
            trozz_pocketid
          ]
        );
        prefixText = /* bash */ ''
          export NB_MANAGEMENT_URL=https://netbird.${secrets.domains.general}
          export POCKETID_BASE_URL=https://id.${secrets.domains.general}
        '';
      };
    };
  };
}
