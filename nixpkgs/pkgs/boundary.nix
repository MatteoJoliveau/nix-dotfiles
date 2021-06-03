{ stdenv, fetchurl, pkgs, lib }:
let
  name = "boundary";
  version = "0.2.3";
in
stdenv.mkDerivation {
  name = "${name}";

  src = fetchurl {
    url = "https://releases.hashicorp.com/${name}/${version}/${name}_${version}_linux_amd64.zip";
    sha256 = "02is56vgbvzrljpk45qlgmz4scg3a9hjppfxchzjlghy27hdrgjr";
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
    platforms = with lib.platforms; linux;
    maintainers = [
      lib.maintainers.matteojoliveau
    ];
  };
}
