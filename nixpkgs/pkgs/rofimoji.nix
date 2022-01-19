{ pkgs, lib, pypkgs }:

pypkgs.buildPythonPackage rec {
  pname = "rofimoji";
  version = "5.3.0";
  format = "wheel";

  src = pypkgs.fetchPypi {
    inherit pname version;
    format = "wheel";
    dist = "py3";
    python = "py3";
    sha256 = "e6307a17e698d9e4336511fe0da20095f2e9d5821338f5d1f84e85b2364e35d6";
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
