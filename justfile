update-secrets:
  sops updatekeys "$( fd sops.yaml )"
