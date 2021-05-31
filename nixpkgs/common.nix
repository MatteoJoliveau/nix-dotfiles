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
    ./modules/email.nix
    ./modules/fish.nix
    (import ./modules/git.nix { homedir = homedir; })
    ./modules/gpg.nix
    ./modules/greenclip.nix
    ./modules/xmonad.nix
  ];

  nixpkgs.overlays = [ (import ./overlays/discord.nix) ];

  home.username = username;
  home.homeDirectory = homedir;
  home.stateVersion = "20.09";

  programs.home-manager = {
    enable = true;
    path = "https://github.com/nix-community/home-manager/archive/release-20.09.tar.gz";
  };

  manual.manpages.enable = false;
}
