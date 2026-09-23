{
  flake.homeModules.heroic = { pkgs, ... }: {
    home.packages = with pkgs.unstable; [
      heroic
    ];

    xdg.configFile = with pkgs; {
      "heroic/tools/proton/GE-Proton11".source = lib.getOutput "steamcompattool" GE-Proton11;
      "heroic/tools/proton/GE-Proton11-7".source = lib.getOutput "steamcompattool" GE-Proton11-7;
      "heroic/tools/proton/GE-Proton11-6".source = lib.getOutput "steamcompattool" GE-Proton11-6;
      "heroic/tools/proton/GE-Proton11-5".source = lib.getOutput "steamcompattool" GE-Proton11-5;
      "heroic/tools/proton/GE-Proton11-4".source = lib.getOutput "steamcompattool" GE-Proton11-4;
      "heroic/tools/proton/GE-Proton11-3".source = lib.getOutput "steamcompattool" GE-Proton11-3;
      "heroic/tools/proton/GE-Proton10".source = lib.getOutput "steamcompattool" GE-Proton10;
      "heroic/tools/proton/GE-Proton9".source = lib.getOutput "steamcompattool" GE-Proton9;
      "heroic/tools/proton/GE-Proton8".source = lib.getOutput "steamcompattool" GE-Proton8;
      "heroic/tools/proton/GE-Proton7".source = lib.getOutput "steamcompattool" GE-Proton7;
    };

    home.persistence.home.directories = [
      ".config/heroic"
      ".local/share/Heroic"
    ];
  };
}
