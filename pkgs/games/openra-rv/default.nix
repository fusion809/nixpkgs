# Based on: pkgs/games/openra/default.nix
# Based on: https://build.opensuse.org/package/show/home:fusion809/openra-rv
{ stdenv, fetchFromGitHub, dos2unix, pkgconfig, makeWrapper
, lua, mono, dotnetPackages, python
, libGL, openal, SDL2
, zenity ? null
}:

with stdenv.lib;

let
  pname = "openra-rv";
  version = "1184";
  engine-version = "d2d841f";
  path = makeBinPath ([ mono python ] ++ optional (zenity != null) zenity);
  rpath = makeLibraryPath [ lua openal SDL2 ];

in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  srcs = [
    (fetchFromGitHub {
      owner = "MustaphaTR";
      repo = "Romanovs-Vengeance";
      rev = "5a4ac7141db577c55d7f4c7abe483426a746fbbe";
      sha256 = "1y24w6rb8m99pd1hjni29rndymf5z5abqnpyhb8ggsav4g138hix";
      name = "Romanovs-Vengeance";
    })
    (fetchFromGitHub {
      owner = "OpenRA";
      repo = "ra2";
      rev = "afb963a027ef37a9497d45d049606afd9d019dc7";
      sha256 = "17byfkalh4msci5cyfp63hh2sb3b3p9c7i4nysnrx3j3j9pij61s";
      name = "ra2";
    })
    (fetchFromGitHub {
      owner = "GraionDilach";
      repo = "OpenRA" ;
      rev = engine-version;
      sha256 = "0qy1y338bvxmvlfbpm152mg2f3d37axxppyndrp5l592zc3d7kkx";
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
    mv engine Romanovs-Vengeance
    mv ra2/mods/ra2 Romanovs-Vengeance/mods
    cd Romanovs-Vengeance
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
    mkdir -p $out/lib/openra-rv
    substitute ${./launch-game.sh} $out/lib/openra-rv/launch-game.sh --subst-var out
    chmod +x $out/lib/openra-rv/launch-game.sh

    # Setting TERM=xterm fixes an issue with terminfo in mono: System.Exception: Magic number is wrong: 542
    # https://github.com/mono/mono/issues/6752#issuecomment-365212655
    wrapProgram $out/lib/openra-rv/launch-game.sh \
      --prefix PATH : "${path}" \
      --prefix LD_LIBRARY_PATH : "${rpath}" \
      --set TERM xterm

    mkdir -p $out/bin
    makeWrapper $out/lib/openra-rv/launch-game.sh $out/bin/openra-rv \
      --run "cd $out/lib/openra-rv"

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
    ]}} $out/lib/openra-rv

    mkdir $out/lib/openra-rv/mods
    cp -r engine/mods/{common,modcontent} $out/lib/openra-rv/mods
    cp -r mods/{ra2,rv} $out/lib/openra-rv/mods

    mkdir -p $out/share/applications
    cp ${./openra-rv.desktop} $out/share/applications/openra-rv.desktop

    mkdir -p $out/share/doc/packages/openra-rv
    cp -r README.md $out/share/doc/packages/openra-rv/README.md

    mkdir -p $out/share/pixmaps
    cp -r mods/rv/logo.png $out/share/pixmaps/openra-rv.png

    mkdir -p $out/share/icons/hicolor/{16x16,32x32,48x48,64x64,128x128,256x256}/apps
    for size in 16 32 48 64 128 256; do
      size=''${size}x''${size}
      cp packaging/linux/mod_''${size}.png "$out/share/icons/hicolor/''${size}/apps/openra-rv.png"
    done
  '';

  dontStrip = true;

  meta = {
    description = "Re-imaginging of the original Command & Conquer Red Alert 2 game";
    homepage = https://github.com/MustaphaTR/Romanovs-Vengeance;
    maintainers = with maintainers; [ fusion809 ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
