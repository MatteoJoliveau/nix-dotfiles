{ pkgs, ... }:

let
  sysconfig = (import <nixpkgs/nixos> {}).config;
  hostname = sysconfig.networking.hostName;
in
{
  imports = [
    ./common.nix
    (./hosts + "/${hostname}.nix")
  ];
}
