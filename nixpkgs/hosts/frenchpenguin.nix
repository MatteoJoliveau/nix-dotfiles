{ pkgs, ... }:

{
  imports = [
    ../modules/bluetooth.nix
    ../modules/wifi.nix
  ];
}
