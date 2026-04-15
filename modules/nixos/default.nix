{
  jellyplex-watched = import ./jellyplex-watched;
  tunarr = import ./tunarr;
  host = import ./host;
  attic-watch-store = import ./attic-watch-store;
  grub = import ./grub;
  configarr = import ./configarr;
  raspberry-pi = import ./raspberry-pi;
  raspberry-pi-4 = import ./raspberry-pi/4.nix;
  raspberry-pi-5 = import ./raspberry-pi/5.nix;
  digitalocean = import ./digitalocean.nix;
  hetzner = import ./hetzner;
  hetzner-online = import ./hetzner/online;
  hetzner-online-intel = import ./hetzner/online/intel.nix;
  hetzner-cloud = import ./hetzner/cloud;
  hetzner-cloud-x86 = import ./hetzner/cloud/x86.nix;
  hetzner-cloud-arm = import ./hetzner/cloud/arm.nix;
}
