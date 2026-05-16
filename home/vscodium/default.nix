{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../vscode
  ];

  programs.vscodium = {
    enable = true;
    package = lib.mkForce pkgs.unstable.vscodium;
    mutableExtensionsDir = false;
    profiles.default = config.programs.vscode.profiles.default;
  };

  programs.vscode.enable = lib.mkForce false;

  home.shellAliases = {
    code = "codium";
  };
}
