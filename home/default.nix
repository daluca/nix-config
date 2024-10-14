{ osConfig, ... }:

{
  imports =
    if osConfig.networking.hostName == "artemis" then
      [ ./hosts/artemis ]
    else if osConfig.networking.hostName == "stormwind" then
      [ ./hosts/stormwind ]
    else if osConfig.networking.hostName == "ironforge" then
      [ ./hosts/ironforge ]
    else
      [ ./common ];
}
