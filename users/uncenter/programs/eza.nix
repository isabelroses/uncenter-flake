{ lib, osConfig, ... }:
{
  programs.eza = lib.mkIf osConfig.glade.programs.enable {
    enable = true;
    icons = "auto";

    extraOptions = [
      "--no-permissions"
      "--no-user"
      "--ignore-glob"
      ".git"
    ];
  };
}
