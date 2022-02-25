self: super:
{
  discord = super.discord.overrideAttrs (old: rec {
    version = "0.0.17";
    src = super.fetchurl {
      url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "058k0cmbm4y572jqw83bayb2zzl2fw2aaz0zj1gvg6sxblp76qil";
    };
  });
}
