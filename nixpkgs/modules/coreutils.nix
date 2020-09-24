{ pkgs, ... }:

{
  home.packages = with pkgs; [
    htop
    gotop
    ffmpeg
    bluez
    blueman
    pulseaudio
    exa
    bat
    ripgrep
    fd
    jetbrains-mono
  ];

  programs = {
    direnv.enable = true;
  };
}
