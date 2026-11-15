{
  import = [
    {
      id = "dbo7tbbo9jd088bh7o7g";
      to = "netbird_account_settings.main";
    }
  ];

  resource.netbird_account_settings.main =
    let
      days = 24 * 60 * 60;
    in
    {
      network_range = "10.47.0.0/16";
      peer_login_expiration_enabled = true;
      peer_login_expiration = 7 * days;
      user_approval_required = false;
      jwt_groups_enabled = false;
      jwt_groups_claim_name = "groups";
      jwt_allow_groups = [ ];
    };
}
