{
  jellyplex-watched = import ./jellyplex-watched;
  tunarr = import ./tunarr;
  host = import ./host;
  grub = import ./grub;
  configarr = import ./configarr;
  digitalocean = import ./digitalocean.nix;
  hetzner-online = import ./hetzner/online;
  hetzner-online-intel = import ./hetzner/online/intel.nix;
}
