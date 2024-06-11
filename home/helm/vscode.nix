{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs.unstable; lib.mkIf config.programs.vscode.enable [ helm-ls ];

  programs.vscode = lib.mkIf config.programs.vscode.enable {
    extensions =
      with pkgs.unstable.vscode-extensions;
      [ tim-koehler.helm-intellisense ]
      ++ pkgs.unstable.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "helm-ls";
          publisher = "helm-ls";
          version = "1.1.1";
          hash = "sha256-opfh7MTFfFHWaQwEAek57IWTGTq1o0OI/9ImoQq96qQ=";
        }
      ];
  };
}
