{ pkgs, ... }:

let
  wonderdraft = pkgs.callPackage ../pkgs/wonderdraft {};
  dungeondraft = pkgs.callPackage ../pkgs/dungeondraft {};
in
{
  home.file = {
    ".screenlayout/default.sh" = {
      source = ./arandr.sh;
      executable = true;
    };
  };

  home.packages = with pkgs; [
    wonderdraft
    dungeondraft
  ];
}
