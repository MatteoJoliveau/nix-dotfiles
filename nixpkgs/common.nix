{ config, pkgs, ... }:

let
  username = builtins.getEnv "USER";
  homedir = builtins.getEnv "HOME";
in
{
  imports = [
    ./modules/alacritty.nix
    ./modules/coreutils.nix
    ./modules/desktop.nix
    ./modules/development.nix
    ./modules/fish.nix
    (import ./modules/git.nix { homedir = homedir; })
    ./modules/gpg.nix
    ./modules/greenclip.nix
    ./modules/xmonad.nix
  ];

  home.username = username;
  home.homeDirectory = homedir;
  home.stateVersion = "20.03";

  programs.home-manager = {
    enable = true;
    path = "https://github.com/nix-community/home-manager/archive/release-20.03.tar.gz";
  };
}
