{ stdenv, fetchurl, pkgs }:
let
  name = "boundary";
  version = "0.1.0";
in
stdenv.mkDerivation {
  name = "${name}";

  src = fetchurl {
    url = "https://releases.hashicorp.com/${name}/${version}/${name}_${version}_linux_amd64.zip";
    sha256 = "75eea11381848cf8583932b8bed948801471a2230d256ed3ebd1c63999e1903d";
  };

  buildInputs = [ pkgs.unzip ];

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
    platforms = with stdenv.lib.platforms; linux;
    maintainers = [
      stdenv.lib.maintainers.matteojoliveau
    ];
  };
}
