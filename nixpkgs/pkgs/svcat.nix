{ stdenv, fetchurl, pkgs }:
let
  name = "svcat";
  version = "0.3.1";
in
stdenv.mkDerivation {
  name = "${name}";

  src = fetchurl {
    url = "https://download.svcat.sh/cli/v${version}/linux/amd64/${name}";
    sha256 = "19gzadhbfldjn3sd2izd2rxvx1pivqb32rl7yxisiv3kwyqs81g0";
    executable = true;
  };

  phases = [ "installPhase" "patchPhase" ]; 

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/svcat
  '';

  meta = {
    description = "Consume services in Kubernetes using the Open Service Broker API";
    longDescription = ''
      Service Catalog lets you provision cloud services directly from the comfort of native Kubernetes tooling. This project is in incubation to bring integration with service brokers to the Kubernetes ecosystem via the Open Service Broker API.
    '';
    homepage = "https://svc-cat.io";
    license = "Apache-2.0";
    platforms = with stdenv.lib.platforms; linux;
    maintainers = [
      stdenv.lib.maintainers.matteojoliveau
    ];
  };
}
