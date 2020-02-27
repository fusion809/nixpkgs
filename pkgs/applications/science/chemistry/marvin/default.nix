{ stdenv, fetchurl, dpkg, makeWrapper, coreutils, gawk, gnugrep, gnused, jre }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "marvin";
  version = "20.6.0";

  src = fetchurl {
    name = "marvin-${version}.deb";
    url = "http://dl.chemaxon.com/marvin/${version}/marvin_linux_${versions.majorMinor version}.deb";
    sha256 = "1vd1hsj36wzghpn6xnppjmva35kdcin7h0xdj3xmi4w5l3qw7fl6";
  };

  nativeBuildInputs = [ dpkg makeWrapper ];

  unpackPhase = ''
    dpkg-deb -x $src opt
  '';

  installPhase = ''
    wrapBin() {
      makeWrapper $1 $out/bin/$(basename $1) \
        --set INSTALL4J_JAVA_HOME "${jre}" \
        --prefix PATH : ${makeBinPath [ coreutils gawk gnugrep gnused ]}
    }
#     sudo cp -r opt $out
    mkdir -p $out/opt/chemaxon/marvinsuite/.install4j
    cp -r opt/opt/chemaxon/marvinsuite/* $out/opt/chemaxon/marvinsuite
    cp opt/opt/chemaxon/marvinsuite/.install4j/{*.lprop,build.uuid,*.png,*.ico,*.jar,*.utf8,*.conf,MessagesDefault} $out/opt/chemaxon/marvinsuite/.install4j
    mkdir -p $out/bin $out/share/pixmaps $out/share/applications
    for name in LicenseManager MarvinSketch MarvinView; do
      wrapBin $out/opt/chemaxon/marvinsuite/$name
      ln -s {$out/opt/chemaxon/marvinsuite/.install4j,$out/share/pixmaps}/$name.png
    done
    for name in cxcalc cxtrain evaluate molconvert mview msketch; do
      wrapBin $out/opt/chemaxon/marvinsuite/bin/$name
    done
    ${concatStrings (map (name: ''
      substitute ${./. + "/${name}.desktop"} $out/share/applications/${name}.desktop --subst-var out
    '') [ "LicenseManager" "MarvinSketch" "MarvinView" ])}
  '';

  meta = {
    description = "A chemical modelling, analysis and structure drawing program";
    homepage = https://chemaxon.com/products/marvin;
    maintainers = with maintainers; [ fusion809 ];
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
