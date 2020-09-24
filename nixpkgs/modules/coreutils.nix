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
    vim
  ];

  programs.direnv.enable = true;

  home.sessionVariables = {
    EDITOR = "${pkgs.vim}/bin/vim";
  };
}
