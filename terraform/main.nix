{
  terraform = {
    required_version = ">= 1.11";

    required_providers = {
      hcloud = {
        source = "hetznercloud/hcloud";
        version = "~> 1.70";
      };

      cloudflare = {
        source = "cloudflare/cloudflare";
        version = "~> 5.27";
      };
    };
  };
}
