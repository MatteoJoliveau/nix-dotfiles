{ stdenv, fetchurl, pkgs, lib }:
let
  name = "calc";
  version = "0.1.0";
in
stdenv.mkDerivation {
  name = "${name}";

  src = ./.;
  buildInputs = [ pkgs.ruby_2_7 ];

  # Work around the "unpacker appears to have produced no directories"
  # case that happens when the archive doesn't have a subdirectory.
  setSourceRoot = "sourceRoot=`pwd`";

  installPhase = ''
    mkdir -p $out/bin
    cp ${name} $out/bin/
  '';

  meta = {
    description = "Boundary enables identity-based access management for dynamic infrastructure.";
    longDescription = ''
      Boundary enables identity-based access management for dynamic infrastructure.
    '';
    homepage = "https://boundaryproject.io";
    license = "MPL-2.0";
    platforms = with lib.platforms; linux;
    maintainers = [
      lib.maintainers.matteojoliveau
    ];
  };
}
