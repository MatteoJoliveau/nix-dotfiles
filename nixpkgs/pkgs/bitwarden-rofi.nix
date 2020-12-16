{ stdenv, fetchFromGitHub, makeWrapper, pkgs }:
let
  name = "bitwarden-rofi";
  version = "0.4";
in
stdenv.mkDerivation {
  name = "${name}";
  src = fetchFromGitHub {
    owner = "mattydebie";
    repo = "${name}";
    rev = "${version}";
    sha256 = "0qnpk3vjaxr20jb5857hy2f6z4yx67zrfivjzfnd848r27s2v1yh";
  };
  nativeBuildInputs = [ makeWrapper pkgs.keyutils ];
  installPhase = with pkgs; ''
    mkdir -p $out/bin
    substitute bwmenu bwmenu.patched --replace /bin/bash "/usr/bin/env bash"
    install -Dm 755 bwmenu.patched $out/bin/bwmenu
    wrapProgram $out/bin/bwmenu --prefix PATH ":" ${stdenv.lib.makeBinPath [ bash rofi bitwarden-cli jq xclip xsel xdotool keyutils ]}
  '';

  fixupPhase = ''
    keyctl link @u @s
  '';

  meta = {
    description = "Wrapper for Bitwarden and Rofi";
    longDescription = ''
      Wrapper for Bitwarden https://github.com/bitwarden/cli and Rofi
    '';
    homepage = "https://github.com/mattydebie/${name}";
    license = "GPL-3";
    platforms = with stdenv.lib.platforms; linux;
    maintainers = [
      stdenv.lib.maintainers.mattydebie
    ];
  };
}
