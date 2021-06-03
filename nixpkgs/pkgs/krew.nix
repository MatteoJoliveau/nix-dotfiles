{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "krew";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pwnkg7qsyixj2h8rrdcwyvsqpdvc7q1jd8d62jwbrp3ga8h337r";
  };

  vendorSha256 = "08dfk33ich3bn4rqz545b50i8dp6l5wqpirvx1yafqjx9rlidng3";

  subPackages = [ "cmd/krew" ];

  meta = with lib; {
    description = "Find and install kubectl plugins ";
    longDescription = ''
      Krew is the package manager for kubectl plugins.
    '';
    homepage = "https://krew.sigs.k8s.io";
    license = licenses.asl20;
    maintainers = [
      lib.maintainers.matteojoliveau
    ];
  };
}
