{ pkgs, ... }:

{
  home.packages = with pkgs; [
    feh
    libsecret
    mailspring
    firefox
    aerc
    w3m
    dante
    slack
    teams
    discord
    zoom-us
    gvfs
    glib
    tdesktop
    bitwarden
    bitwarden-cli
    spotify
    unstable.yubioath-desktop
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    gnome3.gnome-keyring
    gnome3.seahorse
    steam
    steam-run-native
    libreoffice-fresh
  ];

  home.file.".face".source = ../images/propic.jpeg;

  home.sessionVariables = {
    GIO_EXTRA_MODULES = "${pkgs.gvfs}/lib/gio/modules";
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Adwaita";
      package = pkgs.gnome3.gnome_themes_standard;
    };
    font =
      {
        package = pkgs.roboto;
        name = "Roboto 11";
      };
    gtk3.extraConfig.gtk-cursor-theme-name = "breeze";
  };

  qt = {
    platformTheme = "gtk";
  };

  xresources = {
    properties = {
      "Xft.dpi" = "110";
    };
  };
}
