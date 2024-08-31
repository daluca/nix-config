{ osConfig, ... }:

{
  imports =
    if osConfig.networking.hostName == "artemis" then
      [ ./hosts/artemis ]
    else
      [ ./common ];
}
