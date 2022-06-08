{ config, pkgs, ... }:
let
  username = builtins.getEnv "USER";
  homedir = builtins.getEnv "HOME";
  version = "22.05";
in
{
  imports = [
    ./modules/alacritty.nix
    ./modules/coreutils.nix
    ./modules/desktop.nix
    ./modules/development.nix
    ./modules/email
    ./modules/fish.nix
    (import ./modules/git.nix { homedir = homedir; })
    ./modules/gpg.nix
    ./modules/greenclip.nix
    ./modules/xmonad.nix
  ];

  nixpkgs.overlays = [
    # Re-enable if upstream is slacking off
    # (import ./overlays/discord.nix) 
  ];

  home.username = username;
  home.homeDirectory = homedir;
  home.stateVersion = version;

  programs.home-manager = {
    enable = true;
    path = "https://github.com/nix-community/home-manager/archive/release-${version}.tar.gz";
  };
  manual.manpages.enable = false;
}
