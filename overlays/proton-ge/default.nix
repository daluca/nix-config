final: prev: {
  ge-proton9-16 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton9-16";
    version = "GE-Proton9-16";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-WeqntQxez6XPRZxpPNUAQ8/7sw6TzOKU1yrtPHmQNh0=";
    };
  });

  ge-proton9-15 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton9-15";
    version = "GE-Proton9-15";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-WeqntQxez6XPRZxpPNUAQ8/7sw6TzOKU1yrtPHmQNh0=";
    };
  });

  ge-proton9-14 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton9-14";
    version = "GE-Proton9-14";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-+nFF1VA9W1bySac4jXCa09HT970OZfayUYAp6kLVlEY=";
    };
  });

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

  ge-proton8-16 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-16";
    version = "GE-Proton8-16";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-75A0VCVdYkiMQ1duE9r2+DLBJzV02vUozoVLeo/TIWQ=";
    };
  });

  ge-proton8-15 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-15";
    version = "GE-Proton8-15";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-SzD8gYRl87XedAcN6g8X1wqYmV5QGNZZGWi4q5EF3go=";
    };
  });

  ge-proton8-14 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-14";
    version = "GE-Proton8-14";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-/68J3aVmHqrrcNk4DkYSBzfNyIQmbcUGg3yOlDq1ts8=";
    };
  });

  ge-proton8-13 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-13";
    version = "GE-Proton8-13";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-xfj5HGw1hyoceq0Xfe3MFL8jzJDaUUC03Aw8BUupR1o=";
    };
  });

  ge-proton8-12 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-12";
    version = "GE-Proton8-12";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-FAgdQKxEzl/Z9KqNrDmAf03Zzm+g3lobqC/xZCCxYYA=";
    };
  });

  ge-proton8-11 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-11";
    version = "GE-Proton8-11";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-ucQK5k7/ptgRy/B0nvT6aZdz3nl0YNiKH+uaJJux03g=";
    };
  });

  ge-proton8-10 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-10";
    version = "GE-Proton8-10";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-jBjPoZ2IvFTTATYwZk2oZ66QgjBzPq68CreOoUtIz5Q=";
    };
  });

  ge-proton8-9 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-9";
    version = "GE-Proton8-9";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-XBSkEGiLpza5nGgc33V0rHvpUZHLj3l6pCQ5Bo/7+tI=";
    };
  });

  ge-proton8-8 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-8";
    version = "GE-Proton8-8";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-Vd8ThP7TvPkGOIcaBtCe80O2drykcUduOPJmlVIWPFg=";
    };
  });

  ge-proton8-7 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-7";
    version = "GE-Proton8-7";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-QjBZ/68/98MnP2aVjSkbRriT2Ofo6C0IHIF4CqYIP/U=";
    };
  });

  ge-proton8-6 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-6";
    version = "GE-Proton8-6";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-1P7qk2Lk5PvpH11LW4/GNK3WdldbBQhJtJVJyBJT4bY=";
    };
  });

  ge-proton8-5 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-5";
    version = "GE-Proton8-5";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-DGT829ZIO5YVD/nQbvMeBeR086wQwbSvXqptEL+ghrw=";
    };
  });

  ge-proton8-4 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-4";
    version = "GE-Proton8-4";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-UdX2qnC3s7e560b4Mw5BTWA9e0ehMo/+iGuVDO7nBhc=";
    };
  });

  ge-proton8-3 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-3";
    version = "GE-Proton8-3";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-XTYaDE8JJAM8nD7+DPUnU5J+MtNGrE43qyj48p8o/WM=";
    };
  });

  ge-proton8-2 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-2";
    version = "GE-Proton8-2";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-DJpdmzjaZXCg9+ragjqyDs0X8s41t2DOlSs/6wDQ39g=";
    };
  });

  ge-proton8-1 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton8-1";
    version = "GE-Proton8-1";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-CICI0M5zp52FPBxKh9ecWhtsrQJrUlZKRKcFCtwxP+A=";
    };
  });

  ge-proton7-55 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton7-55";
    version = "GE-Proton7-55";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-6CL+9X4HBNoB/yUMIjA933XlSjE6eJC86RmwiJD6+Ws=";
    };
  });

  ge-proton7-54 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton7-54";
    version = "GE-Proton7-54";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-cQOw8lXGgMcl7SFNdCPfeTblBS9QFsKrtZ0j0oImwcc=";
    };
  });

  ge-proton7-53 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton7-53";
    version = "GE-Proton7-53";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-oEKwDd0/F1YItwVKGlGgt/YS2susMgfOY3c5TPxxYLE=";
    };
  });

  ge-proton7-52 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton7-52";
    version = "GE-Proton7-52";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-+L05y/RgRbXvioF4DnsrDintZD0MvA2xzpuRhJIVN10=";
    };
  });

  ge-proton7-51 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton7-51";
    version = "GE-Proton7-51";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-iRMITFHe1BppOe2I35Sg8OscKagqfzPbGLumaLFXKLw=";
    };
  });

  ge-proton7-50 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton7-50";
    version = "GE-Proton7-50";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-QNp42EEDM74tbggiMjuWlN220T6BCyxSQVUIo53P9ss=";
    };
  });

  ge-proton7-49 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton7-49";
    version = "GE-Proton7-49";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-AnWQ8rjBNBAsEom2MIzcKRlxgJPHJhiiy5ejMz2AnfM=";
    };
  });

  ge-proton7-48 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton7-48";
    version = "GE-Proton7-48";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-53JJ1aBFS5Shwy12nE5VEHYqGMuL+kar+QrXVvRco1k=";
    };
  });

  ge-proton7-47 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton7-47";
    version = "GE-Proton7-47";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-FFQa9EYT17n8fmQIrxsXeQLnHDNhH3qB6Hjzc6Xj7FY=";
    };
  });

  ge-proton7-46 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton7-46";
    version = "GE-Proton7-46";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-FFQa9EYT17n8fmQIrxsXeQLnHDNhH3qB6Hjzc6Xj7FY=";
    };
  });

  ge-proton7-45 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton7-45";
    version = "GE-Proton7-45";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-tuzSt9WBkp8tiXTTJo4TNBfTxwIh6RRopAyx18z4+Ps=";
    };
  });

  ge-proton7-44 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton7-44";
    version = "GE-Proton7-44";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-GYCh43y96qx52bQwlngRClJ6MUurW9dx5x9alt70y18=";
    };
  });

  ge-proton7-43 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton7-43";
    version = "GE-Proton7-43";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-Cwo4iLnQc+6FXYs+EnjSvZJSIJCBI/43Lx91CJk/iOM=";
    };
  });

  ge-proton7-42 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton7-42";
    version = "GE-Proton7-42";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-lTd/NX/VtBQCO/feunBYNp+HqbQVB+8gRAszTb+Pktk=";
    };
  });

  ge-proton7-41 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton7-41";
    version = "GE-Proton7-41";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-fqhZ/ZNBiwPnti9ByQMRVCkbUKndDZxgKH6OdsUA5Fc=";
    };
  });

  ge-proton7-40 = prev.proton-ge-bin.overrideAttrs (oldAttrs: rec {
    pname = "ge-proton7-40";
    version = "GE-Proton7-40";

    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-phK+tvEGPwannXyNeFTnVVyVVW47a+PZbZfY6+2weyw=";
    };
  });
}
