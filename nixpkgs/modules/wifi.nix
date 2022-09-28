{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wirelesstools
  ];
}
