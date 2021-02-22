{ pkgs, ... }:

{
  home.file = {
    ".screenlayout/default.sh" = {
      source = ./arandr.sh;
      executable = true;
    };
  };
}
