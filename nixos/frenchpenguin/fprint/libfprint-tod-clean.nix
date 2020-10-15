{ stdenv
, pkgs
, fetchFromGitLab
, fetchurl
, pkgconfig
, meson
, ninja
, libusb
, gusb
, pixman
, gobject-introspection
, glib
, nss
, gtk3
, python3
, umockdev
, coreutils
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_43
}:

stdenv.mkDerivation rec {
  pname = "libfprint";
  version = "1.90.2";
  outputs = [ "out" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "3v1n0";
    repo = "libfprint";
    rev = "0e123d0752538d834ee2cca8b471373369ad5e89";
    sha256 = "11yl3nikdyykamafqf3ys1wg7zx3rb81lf11ndd8sf9rkwwfgpn6";
  };

  checkInputs = [ (python3.withPackages (ps: with ps; [ pycairo gobject ])) umockdev ];

  nativeBuildInputs = [
    pkgconfig
    meson
    gobject-introspection
    ninja
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_43
  ];

  buildInputs = [
    libusb
    gusb
    pixman
    glib
    nss
    gtk3
  ];

  mesonFlags = [
    "-Dudev_rules_dir=${placeholder "out"}/lib/udev/rules.d"
    "-Dx11-examples=false"
  ];

  doChecks = true;

  checkPhase = ''
    meson test -C build --print-errorlogs
  '';

  postPatch = ''
    substituteInPlace libfprint/meson.build \
      --replace /bin/echo ${coreutils}/bin/echo
  '';


  meta = with stdenv.lib; {
    homepage = https://fprint.freedesktop.org/;
    description = "A library designed to make it easy to add support for consumer fingerprint readers";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jobojeha ];
  };
}
