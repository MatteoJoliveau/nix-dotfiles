{ stdenv, pkgs, lib }:
let
  name = "calc";
  version = "0.1.0";
in
stdenv.mkDerivation {
  name = "${name}";

  src = ./.;
  buildInputs = [ pkgs.ruby_3_1 ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${name}.rb $out/bin/${name}
    chmod +x $out/bin/${name}
  '';

  meta = {
    description = "Simple CLI calculator";
    license = "MPL-2.0";
    platforms = with lib.platforms; linux;
    maintainers = [
      lib.maintainers.matteojoliveau
    ];
  };
}
