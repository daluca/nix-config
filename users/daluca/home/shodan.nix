{ lib, ... }:

{
  imports = map (m: lib.custom.relativeToHomeManagerModules m) [
    "impermanence"
  ];
}
