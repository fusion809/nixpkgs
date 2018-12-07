# Based on: pkgs/games/openra/default.nix
# Based on: https://build.opensuse.org/package/show/home:fusion809/openra-ra2
{ stdenv, fetchFromGitHub, dos2unix, pkgconfig, makeWrapper
, lua, mono, dotnetPackages, python
, libGL, openal, SDL2
, zenity ? null
}:

with stdenv.lib;

let
  pname = "openra-ra2";
  version = "844";
  engine-version = "release-20180923";
  path = makeBinPath ([ mono python ] ++ optional (zenity != null) zenity);
  rpath = makeLibraryPath [ lua openal SDL2 ];

in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  srcs = [
    (fetchFromGitHub {
      owner = "OpenRA";
      repo = "ra2";
      rev = "64c58633e6e79b3bbb6f542816782e11feab7060";
      sha256 = "0pdwj9ax6axkndlbzsg96yma2383b4ys4j4sryiykg7r939jjf3w";
      name = "ra2";
    })
    (fetchFromGitHub {
      owner = "OpenRA";
      repo = "OpenRA" ;
      rev = engine-version;
      sha256 = "1pgi3zaq9fwwdq6yh19bwxscslqgabjxkvl9bcn1a5agy4bfbqk5";
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
    mv engine ra2
    cd ra2
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
    make version
    ( cd engine; make version )
  '';

  makeFlags = "PREFIX=$(out)";

  doCheck = false;
  checkTarget = "check test";

  installPhase = ''
    mkdir -p $out/lib/openra-ra2
    substitute ${./launch-game.sh} $out/lib/openra-ra2/launch-game.sh --subst-var out
    chmod +x $out/lib/openra-ra2/launch-game.sh

    # Setting TERM=xterm fixes an issue with terminfo in mono: System.Exception: Magic number is wrong: 542
    # https://github.com/mono/mono/issues/6752#issuecomment-365212655
    wrapProgram $out/lib/openra-ra2/launch-game.sh \
      --prefix PATH : "${path}" \
      --prefix LD_LIBRARY_PATH : "${rpath}" \
      --set TERM xterm

    mkdir -p $out/bin
    makeWrapper $out/lib/openra-ra2/launch-game.sh $out/bin/openra-ra2 \
      --run "cd $out/lib/openra-ra2"

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
    ]}} $out/lib/openra-ra2

    mkdir $out/lib/openra-ra2/mods
    cp -r engine/mods/{common,modcontent} $out/lib/openra-ra2/mods
    cp -r mods/ra2 $out/lib/openra-ra2/mods

    mkdir -p $out/share/applications
    cp ${./openra-ra2.desktop} $out/share/applications/openra-ra2.desktop

    mkdir -p $out/share/doc/packages/openra-ra2
    cp -r README.md $out/share/doc/packages/openra-ra2/README.md

    mkdir -p $out/share/pixmaps
    cp -r mods/ra2/logo.png $out/share/pixmaps/openra-ra2.png

    mkdir -p $out/share/icons/hicolor/{16x16,32x32,48x48,64x64,128x128,256x256}/apps
    for size in 16 32 48 64 128 256; do
      size=''${size}x''${size}
      cp packaging/linux/mod_''${size}.png "$out/share/icons/hicolor/''${size}/apps/openra-ra2.png"
    done
  '';

  dontStrip = true;

  meta = {
    description = "Re-imaginging of the original Command & Conquer Red Alert 2 game";
    homepage = https://github.com/OpenRA/ra2;
    maintainers = with maintainers; [ fusion809 ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
