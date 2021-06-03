{ pkgs, lib, pypkgs }:

pypkgs.buildPythonPackage rec {
  pname = "rofimoji";
  version = "5.1.0";
  format = "wheel";

  src = pypkgs.fetchPypi {
    inherit pname version;
    format = "wheel";
    python = "py3";
    sha256 = "1npm13dlxnw6y7kxsnzc9r9jdjnzjg6xsg552m7bz9cndn227ipi";
  };

  propagatedBuildInputs = with pkgs; [ pypkgs.ConfigArgParse emojione xdotool xclip ];

  meta = with lib; {
    description = "A character picker for rofi";
    longDescription = ''
      A character picker for rofi
    '';
    homepage = "https://github.com/fdw/rofimoji";
    license = "MIT";
    platforms = with platforms; linux;
    maintainers = [
      maintainers.fdw
    ];
  };
}
