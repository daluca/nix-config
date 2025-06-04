{ pkgs, ... }:

{
  programs.vscode.profiles.default = {
    extensions = with pkgs.open-vsx; [
      redhat.ansible
      samuelcolvin.jinjahtml
    ] ++ [
      redhat.vscode-yaml
      ms-python.python
    ];
    userSettings = {
      "redhat.telemetry.enabled" = false;
      "ansible.python.interpreterPath" = "${pkgs.python3}/bin/python3";
      "ansible.ansible.path" = "${pkgs.ansible}/bin/ansible";
      "ansible.validation.lint.path" = "${pkgs.ansible-lint}/bin/ansible-lint";
      "ansible.lightspeed.enabled" = false;
      "files.associations" = {
        "**/tasks/*.yaml" = "ansible";
        "**/tasks/*.yml" = "ansible";
        ".yamllint" = "yaml";
        ".ansible-lint" = "yaml";
      };
      "[ansible]" = {
        "editor.rulers" = [ 80 ];
      };
    };
  };
}
