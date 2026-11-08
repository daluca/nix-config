{
  perSystem = {
    _module.args.secrets = fromTOML (builtins.readFile ../../secrets/secrets.toml);
  };
}
