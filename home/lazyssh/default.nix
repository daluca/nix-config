{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    lazyssh
  ];

  home.persistence.home.directories = [
    ".config/lazyssh"
    ".local/state/lazyssh"
  ];
}
