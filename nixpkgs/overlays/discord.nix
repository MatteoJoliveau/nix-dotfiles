self: super:
{
  discord = super.discord.overrideAttrs (old: rec {
    version = "0.0.20";
    src = super.fetchurl {
      url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "sha256-3f7yuxigEF3e8qhCetCHKBtV4XUHsx/iYiaCCXjspYw=";
    };
  });
}
