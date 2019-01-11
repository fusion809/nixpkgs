{ stdenv, fetchurl, dpkg }:

stdenv.mkDerivation rec {
  pname = "runescape-launcher";
  version = "2.2.4";

  src = fetchurl {
    url = "https://content.runescape.com/downloads/ubuntu/pool/non-free/r/runescape-launcher/runescape-launcher_${version}_amd64.deb";
    sha256 = "0cqnc1dyhw97mc15jkxi30fhkgsiiaaf47mw0j9a8wc2m79j18z1";
  };

  dontPatchELF = true;
  dontStrip = true;

  nativeBuildInputs = [ dpkg ];
  unpackCmd = "dpkg -x $curSrc .";

  installPhase = ''
    cp -r . $out
    substituteInPlace $out/bin/runescape-launcher --replace /usr/share $out/share
    substituteInPlace $out/share/applications/runescape-launcher --replace /usr/bin $out/bin    
  '';

  meta = with stdenv.lib; {
    description = "Runescape NXT client";
    homepage = https://www.runescape.com;
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ yegortimoshenko ];
  };
}
