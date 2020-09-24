{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gnupg
    keybase
    keybase-gui
  ];

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  services.kbfs.enable = true;
}
