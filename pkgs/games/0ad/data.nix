{ stdenv, fetchurl, zeroad-unwrapped }:

stdenv.mkDerivation rec {
  pname = "0ad-data";
  inherit (zeroad-unwrapped) version;
  commit = "6796749eed54351b45f7c7c545d43a135ccf063e";

  src = fetchurl {
    url = "https://github.com/0ad/0ad/archive/${commit}.tar.gz";
    sha256 = "1dnajfwhy8ync2n75r31nnblrzsy5swyx61jbg0m05and0hxpapp";
  };

  installPhase = ''
    rm binaries/data/tools/fontbuilder/fonts/*.txt
    mkdir -p $out/share/0ad
    cp -r binaries/data $out/share/0ad/
    # The following should be in the main package
    rm -rf $out/share/0ad/data/l10n
  '';

  meta = with stdenv.lib; {
    description = "A free, open-source game of ancient warfare -- data files";
    homepage = "https://play0ad.com/";
    license = licenses.cc-by-sa-30;
    platforms = platforms.linux;
    hydraPlatforms = [];
  };
}
