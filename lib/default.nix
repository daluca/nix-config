{ lib }:
let
  inherit (lib.path) append;
in {
  relativeToRoot = append ../.;
  relativeToUsers = append ../users;
  relativeToHosts = append ../hosts;
  relativeToNixosModules = append ../nixos;
  relativeToHomeManagerModules = append ../home;
}
