{ osConfig, ... }:
let
  inherit (osConfig.networking) hostName;
in {
  imports =
    if hostName == "artemis" then
      [ ./hosts/artemis ]
    else if hostName == "stormwind" then
      [ ./hosts/stormwind ]
    else if hostName == "ironforge" then
      [ ./hosts/ironforge ]
    else if hostName == "darnassus" then
      [ ./hosts/darnassus ]
    else
      [ ./common ];
}
