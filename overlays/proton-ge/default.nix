final: prev: {
  ge-proton9-13 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton9-13";
    version = "GE-Proton9-13";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-/KaFYCLvojxH3coiJaArXMPIIwW5qzK+I0bGyt7oBNY=";
    };
  });

  ge-proton9-12 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton9-12";
    version = "GE-Proton9-12";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-2/vxX5AT1qQ50jBrQkZIzlmzkOAX+qzINEeD3Lo1f40=";
    };
  });

  ge-proton9-11 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton9-11";
    version = "GE-Proton9-11";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-OGsgR56R/MaFxahsb/42kA9CEexGDF/aTZlyf6v8tXo=";
    };
  });

  ge-proton9-10 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton9-10";
    version = "GE-Proton9-10";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-dd0qR/iin3VWAMTOvoOURk6s+PNBnZaXBhnxpczL6w8=";
    };
  });

  ge-proton9-9 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton9-9";
    version = "GE-Proton9-9";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-sUjC6ByO8oeRhg3aZLSDJTc2GstdAdXJOddS37UkkL8=";
    };
  });

  ge-proton9-8 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton9-8";
    version = "GE-Proton9-8";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-J++RavJphMqxVWVzX2mDFs9sVuLfLADQHmnZZI49h5w=";
    };
  });

  ge-proton9-7 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton9-7";
    version = "GE-Proton9-7";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-/FXdyPuCe6rD5HoMOHPVlwRXu3DMJ3lEOnRloYZMA8s=";
    };
  });

  ge-proton9-6 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton9-6";
    version = "GE-Proton9-6";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-KafilifTQfK46KCR09bcniD+2EgYdXNWrq0+2IQST7k=";
    };
  });

  ge-proton9-5 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton9-5";
    version = "GE-Proton9-5";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-bUlV533M5BL5UEOB0ED8VIMmquvVAvIm+E/ZJNjftRU=";
    };
  });

  ge-proton9-4 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton9-4";
    version = "GE-Proton9-4";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-OR4SUqm5Xsycv/KVBW2Ug/lz4Xr6IQBp8gXacorRe3U=";
    };
  });

  ge-proton9-3 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton9-3";
    version = "GE-Proton9-3";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-OBzmbhiF57T2JT9Rr8lPUcAPVMpO9RRnPRoz69DLIqw=";
    };
  });

  ge-proton9-2 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton9-2";
    version = "GE-Proton9-2";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-NqBzKonCYH+hNpVZzDhrVf+r2i6EwLG/IFBXjE2mC7s=";
    };
  });

  ge-proton9-1 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton9-1";
    version = "GE-Proton9-1";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-odpzRlzW7MJGRcorRNo784Rh97ssViO70/1azHRggf0=";
    };
  });

  ge-proton8-32 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-32";
    version = "GE-Proton8-32";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-ZBOF1N434pBQ+dJmzfJO9RdxRndxorxbJBZEIifp0w4=";
    };
  });

  ge-proton8-31 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-31";
    version = "GE-Proton8-31";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-ZBOF1N434pBQ+dJmzfJO9RdxRndxorxbJBZEIifp0w4=";
    };
  });

  ge-proton8-30 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-30";
    version = "GE-Proton8-30";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-ACgvZgMtFkth8s07u0vwC/khnA7D6hGiS+Zd3tbv0os=";
    };
  });

  ge-proton8-29 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-29";
    version = "GE-Proton8-29";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-lnkf3Mb0gKfP/c077OnP9+z2jscm5swUZHVOCqSuzt4=";
    };
  });

  ge-proton8-28 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-28";
    version = "GE-Proton8-28";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-oTSLJ6Q4iQwZ8KWhgPMJ5Sla84Etg3+H+7Ka0NoN1Kg=";
    };
  });

  ge-proton8-27 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-27";
    version = "GE-Proton8-27";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-YeibTA2z69bNE3V/sgFHOHaxl0Uf77unQQc7x2w/1AI=";
    };
  });

  ge-proton8-26 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-26";
    version = "GE-Proton8-26";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-3pw+RvC87SZmATSzfura+x5gKG9V7vSK/Y3vCddAJK8=";
    };
  });

  ge-proton8-25 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-25";
    version = "GE-Proton8-25";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-IoClZ6hl2lsz9OGfFgnz7vEAGlSY2+1K2lDEEsJQOfU=";
    };
  });

  ge-proton8-24 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-24";
    version = "GE-Proton8-24";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-S8qh46TAgS393CjOBljCvOtXUHhCximFMcB70YaP9Pk=";
    };
  });

  ge-proton8-23 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-23";
    version = "GE-Proton8-23";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-3XniKYf/KDRDYhTwffkktbmoISwOtGIABF28bsp8QHA=";
    };
  });

  ge-proton8-22 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-22";
    version = "GE-Proton8-22";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-NwFnyfi9ATHUVq55xqTmxK7DptNYBKD+ElFSK5IqMcQ=";
    };
  });

  ge-proton8-21 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-21";
    version = "GE-Proton8-21";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-52Qt78G8/92wYTDzpU+oGIdqXt/6AkC2KiI/qZW/EjQ=";
    };
  });

  ge-proton8-20 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-20";
    version = "GE-Proton8-20";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-eM8jiTFgSEmleawsBjOaDNFVtR61k+ekxlqFAj+E7lk=";
    };
  });

  ge-proton8-19 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-19";
    version = "GE-Proton8-19";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-LIpusmSrkuj7mNRGQVxbaSb0TU2xF4YKrUrMBg3Ht+k=";
    };
  });

  ge-proton8-18 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-18";
    version = "GE-Proton8-18";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-fQB5YLUM5JRtTGM2n8CMewkuoexBORIYOKKOIn6cDpM=";
    };
  });

  ge-proton8-17 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-17";
    version = "GE-Proton8-17";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-w804j8CoTvhGh9srVmzDO7640jFTvyzvaLa4Z7DvPaM=";
    };
  });
}
