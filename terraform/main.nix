{
  terraform.required_version = ">= 1.11";

  terraform.backend.s3 = {
    bucket = "terranix";
    key = "nix-config/opentofu.tfstate";
    region = "nbg1";
    endpoint = "nbg1.your-objectstorage.com";
    use_lockfile = true;
    use_path_style = true;
    skip_region_validation = true;
    skip_credentials_validation = true;
  };
}
