{ stdenv
, lib
, fetchurl
, jre
, rpmextract
, makeDesktopItem
}:

let
  desktopItem1 = makeDesktopItem {
    name = "MarvinSketch";
    exec = "$out/opt/chemaxon/marvinsuite/MarvinSketch %f";
    desktopName = "MarvinSketch";
    genericName = "Molecule editor";
    mimeType = "text/xml;text/plain;chemical/x-cml;chemical/x-mdl-molfile;chemical/x-mdl-sdfile;chemical/x-mol2;chemical/x-pdb;chemical/x-xyz;chemical/x-mdl-rdfile;chemical/x-mdl-rxnfile;chemical/x-inchi;";
    categories = "Education;Science;Chemistry;";
  };

  desktopItem2 = makeDesktopItem {
    name = "MarvinView";
    exec = "$out/opt/chemaxon/marvinsuite/bin/MarvinView %f";
    desktopName = "MarvinView";
    genericName = "Molecule viewer";
    mimeType = "text/xml;text/plain;chemical/x-cml;chemical/x-mdl-molfile;chemical/x-mdl-sdfile;chemical/x-mol2;chemical/x-pdb;chemical/x-xyz;chemical/x-mdl-rdfile;chemical/x-mdl-rxnfile;chemical/x-inchi;";
    categories = "Education;Science;Chemistry;";
  };

in
stdenv.mkDerivation rec {
  name = "marvin-${version}";
  version = "18.29";

  src = 
    fetchurl {
      url = "http://dl.chemaxon.com/marvin/${version}.0/marvin_linux_${version}.rpm";
      sha256 = "0pha654ah9lmgl7jri1zb3pvivf32v14y96jm42ywhbmfb1k48bl";
    };

  nativeBuildInputs = [ rpmextract ];

  buildCommand = ''
    rpmextract $src
    mkdir -p $out/bin
    cp -r opt $out
    ln -sf $out/opt/chemaxon/marvinsuite/bin/msketch $out/bin/msketch
    ln -sf $out/opt/chemaxon/marvinsuite/bin/mview $out/bin/mview
    ln -sf $out/opt/chemaxon/marvinsuite/bin/msketch $out/bin/MarvinSketch
    ln -sf $out/opt/chemaxon/marvinsuite/bin/mview $out/bin/MarvinView
  '';

  installPhase = ''
    cp -r ${desktopItem1}/share/applications $out/share
    cp -r ${desktopItem2}/share/applications $out/share
  '';

  meta = with stdenv.lib; {
    description = "A Java-based molecular modelling and editing suite";
    homepage = "https://chemaxon.com/products/marvin";
    license = stdenv.lib.licenses.unfree;
    platforms = platforms.all ;
    maintainers = with maintainers ; [ fusion809 ];
  };
}
