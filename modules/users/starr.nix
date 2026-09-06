{
  flake.nixosModules.users-starr = {
    users.users.starr = {
      isSystemUser = true;
      group = "starr";
    };

    users.groups.starr = { };
  };
}
