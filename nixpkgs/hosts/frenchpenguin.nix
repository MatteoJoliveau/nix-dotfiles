{ pkgs, ... }:

{
  home.packages = with pkgs; [
    autorandr
  ];
}
