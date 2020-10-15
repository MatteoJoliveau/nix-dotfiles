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
, libfprint-tod-goodix ? (pkgs.callPackage ./libfprint-tod-goodix.nix { })
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
    libfprint-tod-goodix
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

  postInstall = ''
    mkdir -p $out/lib/libfprint-2/tod-1/
    ln -s ${libfprint-tod-goodix}/usr/lib/libfprint-2/tod-1/libfprint-tod-goodix-53xc-0.0.6.so $out/lib/libfprint-2/tod-1/ 
    ln -s ${libfprint-tod-goodix}/lib/udev/rules.d/60-libfprint-2-tod1-goodix.rules $out/lib/udev/rules.d/ 

  '';

  meta = with stdenv.lib; {
    homepage = https://fprint.freedesktop.org/;
    description = "A library designed to make it easy to add support for consumer fingerprint readers";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jobojeha ];
  };
}
