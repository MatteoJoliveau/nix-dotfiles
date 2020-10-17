{ pkgs, ... }:

{
  home.packages = with pkgs; [
    blueman
  ];

  systemd.user.services.mpris-proxy = {
    Unit = {
      Description = "Mpris proxy";
      After = [ "network.target" "sound.target" "bluetooth.target" ];
      StartLimitInterval = 200;
      StartLimitBurst = 5;
    };

    Service = {
      ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
      Restart = "on-failure";
      RestartSec = 10;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
