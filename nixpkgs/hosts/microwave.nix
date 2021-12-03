{ pkgs, ... }:

{
  home.file = {
    ".screenlayout/default.sh" = {
      source = ./arandr.sh;
      executable = true;
    };
  };

  packageOverrides = pkgs: with pkgs; rec {
    wonderdraft = callPackage pkgs/wonderdraft {};
    dungeondraft = callPackage pkgs/dungeondraft {};
  };

  home.packages = with pkgs; [
    wonderdraft
    dungeondraft
  ];
}
