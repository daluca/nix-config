{
  services.kanata = {
    enable = true;
    settings = /* list */ ''
      (defcfg
        process-unmapped-keys yes

        linux-continue-if-no-devs-found yes)

      (defsrc
        caps
      )

      (defalias
        escctrl (tap-hold 200 200 esc lctrl)
      )

      (deflayer base
        @escctrl
      )
    '';
  };
}
