{ pkgs, ... }:

{
  home.packages = with pkgs; [
    feh
    rofi
    rofi-emoji
    xss-lock
    ranger
    dconf
    playerctl
    brightnessctl
    picom
    xmobar
    pamixer
    flameshot
    xclip
    multilockscreen
    bitwarden-rofi
    dunst
    libnotify
    arandr
  ];

  programs.autorandr = {
    enable = true;
    hooks = {
      postswitch = {
        "change-background" = "~/.fehbg";
      };
    };
  };

  home.file = {
    ".xprofile" = {
      source = ../xmonad/xmonad-session-rc;
      executable = true;
    };
    ".xmonad/xmonad.hs".source = ../xmonad/xmonad.hs;
    ".xmonad/xmobar.hs".source = ../xmonad/xmobar.hs;
    ".xmonad/bin/screenshot".source = ../xmonad/bin/screenshot;
    ".xmonad/bin/select-screenshot".source = ../xmonad/bin/select-screenshot;
    ".xmonad/bin/connect-known-bt".source = ../xmonad/bin/connect-known-bt;
    "Pictures/wallpaper.png".source = ../images/wallpaper.png;
  };

  xdg.configFile = {
    "multilock/config".source = ../configs/multilockscreen.cfg;
    "dunst/dunstrc".source = ../configs/dunstrc;
    "picom/picom.conf".source = ../configs/picom.conf;
    "rofi/config.rasi".source = ../configs/rofi/config.rasi;
    "rofi/onedark.rasi".source = ../configs/rofi/onedark.rasi;
  };
}
