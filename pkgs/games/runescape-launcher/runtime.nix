{ stdenv, fetchurl, dpkg }:

stdenv.mkDerivation rec {
  pname = "runescape-launcher";
  version = "2.2.4";

  src = fetchurl {
    url = "https://content.runescape.com/downloads/ubuntu/pool/non-free/r/runescape-launcher/runescape-launcher_${version}_amd64.deb";
    sha256 = "0bk4af12k1m5cchzymhi9gfk90v6n9qphhxx2x9z1hba5v2yc0gj";
  };

  dontPatchELF = true;
  dontStrip = true;

  nativeBuildInputs = [ dpkg ];
  unpackCmd = "dpkg -x $curSrc .";

  installPhase = ''
    cp -r . $out
    substituteInPlace $out/bin/runescape-launcher --replace /usr/share $out/share
    substituteInPlace $out/share/applications/runescape-launcher.desktop --replace /usr/bin $out/bin    
  '';

  meta = with stdenv.lib; {
    description = "Runescape NXT client";
    homepage = https://www.runescape.com;
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ yegortimoshenko ];
  };
}
