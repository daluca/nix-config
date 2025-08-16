{ pkgs, ... }:
let
  auto-cpufreq-switcher = pkgs.gnomeExtensions.buildShellExtension {
    uuid = "auto-cpufreq-switcher@ebdendinelli.github.io";
    name = "Auto-cpufreq Switcher";
    pname = "auto-cpufreq-switcher";
    version = 2;
    description = "Simple governor switcher Gnome-Shell-Extension for auto-cpufreq";
    link = "https://extensions.gnome.org/extension/8320/auto-cpufreq-switcher/";
    sha256 = "sha256-PaPxH6MWRbR3Z/bR6xqe4UGmuxQVfZNsuFJIdODiaFg=";
    metadata = "ewogICJuYW1lIjogIkF1dG8tY3B1ZnJlcSBTd2l0Y2hlciIsCiAgImRlc2NyaXB0aW9uIjogIlNpbXBsZSBnb3Zlcm5vciBzd2l0Y2hlciBHbm9tZS1TaGVsbC1FeHRlbnNpb24gZm9yIGF1dG8tY3B1ZnJlcSIsCiAgInV1aWQiOiAiYXV0by1jcHVmcmVxLXN3aXRjaGVyQGViZGVuZGluZWxsaS5naXRodWIuaW8iLAogICJzaGVsbC12ZXJzaW9uIjogWwogICAgIjQ4IgogIF0sCiAgInVybCI6ICJodHRwczovL2dpdGh1Yi5jb20vRUJlbmRpbmVsbGkvYXV0by1jcHVmcmVxLXN3aXRjaGVyIiwKICAidmVyc2lvbiI6IDIKfQ==";
  };
in {
  home.packages = [ auto-cpufreq-switcher ];

  dconf.settings."org/gnome/shell".enabled-extensions = [
    auto-cpufreq-switcher.extensionUuid
  ];
}
