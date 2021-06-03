{ stdenv, fetchFromGitHub, makeWrapper, pkgs, lib }:
let
  name = "multilockscreen";
  version = "v1.2.0";
in
stdenv.mkDerivation {
  name = "${name}";
  src = fetchFromGitHub {
    owner = "jeffmhubbard";
    repo = "${name}";
    rev = "${version}";
    sha256 = "1bfpbazvhaz9x356nsghz0czysh9b75g79cd9s35v0x0rrzdr9qj";
  };
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out/bin
    substitute ${name} ${name}.patched --replace i3lock i3lock-color
    install -Dm 755 ${name}.patched $out/bin/${name}
    wrapProgram $out/bin/${name} --prefix PATH ":" ${lib.makeBinPath [ pkgs.i3lock-color pkgs.imagemagick pkgs.xorg.xdpyinfo pkgs.bc ]}
  '';

  meta = {
    description = "i3lock wrapper with multi-monitor support";
    longDescription = ''
      i3lock wrapper with multi-monitor support.
    '';
    homepage = "https://github.com/jeffmhubbard/${name}";
    license = "MIT";
    platforms = with lib.platforms; linux;
    maintainers = [
      lib.maintainers.jeffmhubbard
    ];
  };
}
