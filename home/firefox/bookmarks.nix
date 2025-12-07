{ config, lib, secrets }:

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
  ] ++ lib.optionals (! config.host.work) [
    {
      name = "Paperless";
      url = "https://paperless.${secrets.domain.general}/";
    }
    {
      name = "Home Assistant";
      url = "https://home-assistant.${secrets.domain.general}/";
    }
    {
      name = "Firefly III";
      url = "https://firefly.${secrets.domain.general}/";
    }
    {
      name = "Unifi";
      url = "https://unifi.${secrets.domain.general}/";
    }
  ] ++ lib.optionals config.host.work [
    {
      name = "Gmail";
      url = "https://mail.google.com/mail/u/0/#inbox";
    }
    {
      name = "Calendar";
      url = "https://calendar.google.com/";
    }
    {
      name = "Jira";
      url = "https://robinradar.atlassian.net/";
    }
    {
      name = "Confluence";
      url = "https://robinradar.atlassian.net/wiki/home";
    }
    {
      name = "HiBob";
      url = "https://app.hibob.com/";
    }
    {
      name = "Bitwarden";
      url = "https://vault.bitwarden.com/";
    }
    {
      name = "Declaree";
      url = "https://app.declaree.com/";
    }
    {
      name = "Officevibe";
      url = "https://officevibe.workleap.com/portal/my/home";
    }
    {
      name = "Intranet Robin Radar";
      url = "https://robinradar.atlassian.net/wiki/spaces/RIHTAT/overview";
    }
    {
      name = "IT - Helpdesk";
      url = "https://robinradar.atlassian.net/servicedesk/customer/portal/1";
    }
    {
      name = "IT - Forms";
      url = "https://robinradar.atlassian.net/wiki/spaces/IP/pages/188710913/IT+-+Request+Forms";
    }
    {
      name = "Office - Helpdesk";
      url = "mailto:office-helpdesk@robinradar.com";
    }
    {
      name = "KMS - Workwear";
      url = "https://kms3.zijlstraberoepskleding.nl/";
    }
  ];
}
