{ ... }:

{
  programs.firefox.policies = {
    DisablePocket = true;
    DisableTelemetry = true;
    PasswordManagerEnabled = false;
    PrimaryPassword = false;
  };
}
