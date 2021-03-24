self: super:
{
    discord = super.discord.overrideAttrs (old: rec {
        version = "0.0.14";
        src = super.fetchurl {
            url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
            sha256 = "1rq490fdl5pinhxk8lkfcfmfq7apj79jzf3m14yql1rc9gpilrf2";
        };
    });
}