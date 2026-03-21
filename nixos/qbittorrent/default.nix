{ config, ... }:

{
  services.qbittorrent = {
    enable = true;
    user = "starr";
    group = "starr";
    webuiPort = 8081;
    torrentingPort = 53184;
    serverConfig = {
      LegalNotice.Accepted = true;
      Preferences = {
        WebUI = {
          Address = "127.0.0.1";
          Username = "daluca";
          Password_PBKDF2 = "XXvqgKzJ6WVsYQz57LA1gQ==:Tl9d0T5Pyt+CrFXbqU5RAAcl3ae50n8GiY/Ci3ZD1tLnV2rKtQOS36oGrtDnafmYT8eA6EpVPkes9AImT2YXfA==";
          ReverseProxySupportEnabled = true;
          TrustedReverseProxiesList = "127.0.0.1";
        };
        General = {
          Locale = "en";
          StatusbarExternalIPDisplayed = true;
        };
      };
      BitTorrent.Session = {
        DefaultSavePath = "/storage/torrent/complete";
        TempPathEnabled = true;
        TempPath = "/storage/torrent/incomplete";
        FinishedTorrentExportDirectory = "/var/lib/qBittorrent/qBittorrent/backups/torrents";
      };
    };
  };

  networking.firewall.allowedTCPPorts = with config.services; [
    qbittorrent.torrentingPort
  ];

  systemd.tmpfiles.rules = with config.services; [
    "d /storage/torrent 0775 root starr -"
    "d /storage/torrent/incomplete 0775 root starr -"
    "d /storage/torrent/complete 0775 root starr -"
    "d /storage/torrent/complete/tv 0775 root starr -"
    "d /storage/torrent/complete/movies 0775 root starr -"

    "d ${qbittorrent.profileDir}/qBittorrent/backups 0775 ${qbittorrent.user} ${qbittorrent.group} -"
    "d ${qbittorrent.profileDir}/qBittorrent/backups/torrents 0775 ${qbittorrent.user} ${qbittorrent.group} -"
  ];

  environment.persistence.system.directories = with config.services; [
    { directory = qbittorrent.profileDir; user = qbittorrent.user; group = qbittorrent.group; }
  ];
}
