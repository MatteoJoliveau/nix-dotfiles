{ pkgs, ... }:

{
  home.packages = with pkgs; [
    htop
    gotop
    ffmpeg
    pulseaudio
    exa
    bat
    ripgrep
    fd
    jetbrains-mono
    vim
    zip
    unzip
    nmap
    file
    patchelf
    inetutils
  ];

  programs.direnv.enable = true;

  home.sessionVariables = {
    EDITOR = "${pkgs.vim}/bin/vim";
  };
}
