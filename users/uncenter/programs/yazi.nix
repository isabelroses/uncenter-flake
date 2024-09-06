{ pkgs, lib, ... }:
let
  yazi-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "06e5fe1c7a2a4009c483b28b298700590e7b6784";
    hash = "sha256-jg8+GDsHOSIh8QPYxCvMde1c1D9M78El0PljSerkLQc=";
  };
in
{
  programs.yazi = {
    enable = true;
    catppuccin.enable = true;

    enableFishIntegration = true;

    settings = {
      manager = {
        ratio = [
          2
          3
          3
        ];
        sort_by = "natural";
        sort_sensitive = true;
        sort_reverse = true;
        sort_dir_first = true;
        linemode = "none";
        show_hidden = true;
        show_symlink = true;
      };
      preview = {
        tab_size = 4;
      };
      opener = {
        edit = [
          {
            run = "\${EDITOR:-vi} \"$@\"";
            desc = "$EDITOR";
            block = true;
          }
          {
            run = "\${VISUAL:-code} \"$@\"";
            desc = "$VISUAL";
            orphan = true;
          }
        ];
        extract = [
          {
            run = "ouch d -y \"$@\"";
            desc = "Extract here with ouch";
          }
        ];
      };
    };

    keymap = {
      manager.prepend_keymap =
        [
          {
            on = [ "<Space>" ];
            run = [ "select --state=none" ];
            desc = "Toggle the current selection state";
          }

          {
            on = [
              "g"
              "f"
            ];
            run = "cd ~/.config/flake";
            desc = "[ G ]o to the system [ f ]lake directory";
          }
          {
            on = [
              "g"
              "d"
            ];
            run = "cd ~/Dev";
            desc = "[ G ]o to the [ d ]evelopment directory";
          }
          {
            on = [
              "g"
              "D"
            ];
            run = "cd ~/Downloads";
            desc = "[ G ]o to the [ d ]ownloads directory";
          }

          {
            on = [ "m" ];
            run = "plugin --sync hide-preview";
            desc = "Minimize preview";
          }
          {
            on = [ "M" ];
            run = "plugin --sync max-preview";
            desc = "Maximize preview";
          }

          {
            on = [
              "c"
              "m"
            ];
            run = "plugin chmod";
            desc = "Chmod on selected files";
          }

          {
            on = [ "C" ];
            run = "plugin ouch --args=zip";
            desc = "Compress with ouch";
          }
        ]
        ++ (map (
          stepInt:
          let
            step = toString stepInt;
          in
          {
            on = [ step ];
            run = "plugin relative-motions" + (if step != "0" then " --args=" + step else "");
            desc = "Move in relative steps";
          }
        ) (lib.lists.range 0 9));
    };

    plugins = {
      "hide-preview" = "${yazi-plugins}/hide-preview.yazi";
      "max-preview" = "${yazi-plugins}/max-preview.yazi";
      "chmod" = "${yazi-plugins}/chmod.yazi";

      "starship" = pkgs.fetchFromGitHub {
        owner = "Rolv-Apneseth";
        repo = "starship.yazi";
        rev = "5abe29e7750eb98d5a3554925a7d8c242bd9f96d";
        hash = "sha256-jFqMD2GZm3rjLdCL4Wl0xuG5AnaiBgusBYKt5AopQGE=";
      };

      "ouch" = pkgs.fetchFromGitHub {
        owner = "ndtoan96";
        repo = "ouch.yazi";
        rev = "fe6b0a60ce6b7b9a573b975fe3c0dfc79c0b2ac6";
        hash = "sha256-Sc0TGzrdyQh61Pkc2nNUlk8jRLjVNaCJdFqZvgQ/Cp8=";
      };

      "relative-motions" = pkgs.fetchFromGitHub {
        owner = "dedukun";
        repo = "relative-motions.yazi";
        rev = "73f554295f4b69756597c9fe3caf3750a321acea";
        hash = "sha256-jahJC6LXOnr974+zHEH9gqI+J1C68O+PvjSt8pelkP0=";
      };
    };

    initLua = ''
       require("starship"):setup()
      require("relative-motions"):setup({ show_numbers = "relative_absolute" })
    '';
  };
}
