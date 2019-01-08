# Based on: pkgs/games/openra/default.nix
# Based on: https://build.opensuse.org/package/show/home:fusion809/openra-d2
{ stdenv, fetchFromGitHub, dos2unix, pkgconfig, makeWrapper
, lua, mono, dotnetPackages, python
, libGL, openal, SDL2
, zenity ? null
}:

with stdenv.lib;

let
  pname = "openra-d2";
  version = "131";
  engine-version = "release-20181215";
  path = makeBinPath ([ mono python ] ++ optional (zenity != null) zenity);
  rpath = makeLibraryPath [ lua openal SDL2 ];

in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  srcs = [
    (fetchFromGitHub {
      owner = "OpenRA";
      repo = "d2";
      rev = "cf3e0327ef82713ba2b112452e6fa5583b87be3e";
      sha256 = "0mr3ix2if3q0pyqq0jdjjrxp6vds4pc1z5pfxc5849iv8w63h17p";
      name = "d2";
    })
    (fetchFromGitHub {
      owner = "OpenRA";
      repo = "OpenRA" ;
      rev = engine-version;
      sha256 = "0p0izykjnz7pz02g2khp7msqa00jhjsrzk9y0g29dirmdv75qa4r";
      name = "engine";

      extraPostFetch = ''
        sed -i 's/curl/curl --insecure/g' $out/thirdparty/{fetch-thirdparty-deps,noget}.sh
        $out/thirdparty/fetch-thirdparty-deps.sh
      '';
    })
  ];

  sourceRoot = ".";

  buildInputs = with dotnetPackages; [
    FuzzyLogicLibrary
    MaxMindDb
    MaxMindGeoIP2
    MonoNat
    NewtonsoftJson
    NUnit3
    NUnitConsole
    OpenNAT
    RestSharp
    SharpFont
    SharpZipLib
    SmartIrc4net
    StyleCopMSBuild
    StyleCopPlusMSBuild
  ] ++ [
    dos2unix
    pkgconfig
    makeWrapper
    lua
    mono
    python
    libGL
    openal
    SDL2
  ];

  postUnpack = ''
    mv engine d2
    cd d2
  '';

  patches = [ ./Makefile.patch ];

  postPatch = ''
    sed -i 's/^VERSION.*/VERSION = ${version}/g' Makefile

    dos2unix *.md

    sed -i \
      -e 's/^VERSION.*/VERSION = ${engine-version}/g' \
      -e '/fetch-geoip-db/d' \
      -e '/GeoLite2-Country.mmdb.gz/d' \
      engine/Makefile

    sed -i 's|locations=.*|locations=${lua}/lib|' engine/thirdparty/configure-native-deps.sh
  '';

  configurePhase = ''
    make version VERSION=${version}
    ( cd engine; make version )
  '';

  makeFlags = "PREFIX=$(out)";

  doCheck = false;
  checkTarget = "check test";

  installPhase = ''
    mkdir -p $out/lib/openra-d2
    substitute ${./launch-game.sh} $out/lib/openra-d2/launch-game.sh --subst-var out
    chmod +x $out/lib/openra-d2/launch-game.sh

    # Setting TERM=xterm fixes an issue with terminfo in mono: System.Exception: Magic number is wrong: 542
    # https://github.com/mono/mono/issues/6752#issuecomment-365212655
    wrapProgram $out/lib/openra-d2/launch-game.sh \
      --prefix PATH : "${path}" \
      --prefix LD_LIBRARY_PATH : "${rpath}" \
      --set TERM xterm

    mkdir -p $out/bin
    makeWrapper $out/lib/openra-d2/launch-game.sh $out/bin/openra-d2 \
      --run "cd $out/lib/openra-d2"

    cp -r engine/{${concatStringsSep "," [
      "glsl"
      "lua"
      "AUTHORS"
      "COPYING"
      "Eluant.dll*"
      "FuzzyLogicLibrary.dll"
      "'global mix database.dat'"
      "ICSharpCode.SharpZipLib.dll"
      "MaxMind.Db.dll"
      "OpenAL-CS.dll"
      "OpenAL-CS.dll.config"
      "Open.Nat.dll"
      "OpenRA.Game.exe"
      "OpenRA.Platforms.Default.dll"
      "OpenRA.Server.exe"
      "OpenRA.Utility.exe"
      "rix0rrr.BeaconLib.dll"
      "SDL2-CS.dll"
      "SDL2-CS.dll.config"
      "SharpFont.dll"
      "SharpFont.dll.config"
      "VERSION"
    ]}} $out/lib/openra-d2

    mkdir $out/lib/openra-d2/mods
    cp -r engine/mods/{common,ra,cnc,d2k,modcontent} $out/lib/openra-d2/mods
    cp -r mods/d2 $out/lib/openra-d2/mods

    mkdir -p $out/share/applications
    cp ${./openra-d2.desktop} $out/share/applications/openra-d2.desktop

    mkdir -p $out/share/doc/packages/openra-d2
    cp -r README.md $out/share/doc/packages/openra-d2/README.md

    mkdir -p $out/share/pixmaps
    cp -r mods/d2/icon.png $out/share/pixmaps/openra-d2.png

#    mkdir -p $out/share/icons/hicolor/{16x16,32x32,48x48,64x64,128x128,256x256}/apps
#    for size in 16 32 48 64 128 256; do
#      size=''${size}x''${size}
#      cp packaging/linux/mod_''${size}.png "$out/share/icons/hicolor/''${size}/apps/openra-d2.png"
#    done
  '';

  dontStrip = true;

  meta = {
    description = "Re-imaginging of the original Command Command & Conquer  Conquer: Red Alert 2 game";
    homepage = https://github.com/OpenRA/d2;
    maintainers = with maintainers; [ fusion809 ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
