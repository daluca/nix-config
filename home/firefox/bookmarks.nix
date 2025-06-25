{ secrets }:

{
  force = true;
  settings = [
    {
      name = "Radio New Zealand";
      tags = [ "news" ];
      url = "https://www.rnz.co.nz/";
    }
    {
      name = "Hacker News";
      tags = [ "social" ];
      url = "https://news.ycombinator.com/";
    }
    {
      name = "YouTube";
      tags = [ "media" ];
      keyword = "yt";
      url = "https://www.youtube.com/";
    }
    {
      name = "Cricinfo";
      tags = [ "sports" ];
      keyword = "cric";
      url = "https://www.espncricinfo.com/";
    }
    {
      name = "Nextcloud";
      url = "https://cloud.${secrets.cloud.domain}/";
    }
    {
      name = "Miniflux";
      url = "https://feeds.${secrets.cloud.domain}/";
    }
    {
      name = "Linkwarden";
      url = "https://links.${secrets.cloud.domain}/";
    }
    {
      name = "Mealie";
      url = "https://mealie.${secrets.cloud.domain}/";
    }
    {
      name = "RSS Bridge";
      url = "https://rssbridge.${secrets.cloud.domain}/";
    }
    {
      name = "Public WiFi Login";
      url = "http://nmcheck.gnome.org/";
    }
  ];
}
