{
  jellyplex-watched = import ./jellyplex-watched;
  tunarr = import ./tunarr;
  host = import ./host;
  attic-watch-store = import ./attic-watch-store;
  grub = import ./grub;
  configarr = import ./configarr;
  raspberry-pi-4 = import ./raspberry-pi/4.nix;
  digitalocean = import ./digitalocean.nix;
  hetzner-online = import ./hetzner/online;
  hetzner-online-intel = import ./hetzner/online/intel.nix;
}
