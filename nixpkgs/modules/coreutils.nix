{ pkgs, ... }:

{
  home.packages = with pkgs; [
    htop
    gotop
    ffmpeg
    pulseaudio
    pavucontrol
    exa
    bat
    ripgrep
    fd
    jetbrains-mono
    vim
    zip
    unzip
    nmap
  ];

  programs.direnv.enable = true;

  home.sessionVariables = {
    EDITOR = "${pkgs.vim}/bin/vim";
  };
}
