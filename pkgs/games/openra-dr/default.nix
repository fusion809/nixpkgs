# Based on: pkgs/games/openra/default.nix
# Based on: https://build.opensuse.org/package/show/home:fusion809/openra-dr
{ stdenv, fetchFromGitHub, dos2unix, pkgconfig, makeWrapper
, lua, mono, dotnetPackages, python
, libGL, openal, SDL2
, zenity ? null
}:

with stdenv.lib;

let
  pname = "openra-dr";
  version = "237";
  engine-version = "release-20180923";
  path = makeBinPath ([ mono python ] ++ optional (zenity != null) zenity);
  rpath = makeLibraryPath [ lua openal SDL2 ];

in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  srcs = [
    (fetchFromGitHub {
      owner = "drogoganor";
      repo = "DarkReign";
      rev = "c2f0c2d1ea2c6962a96d91f0fe053044ee867dad";
      sha256 = "05n5ycv1pzn3a7ww7vc37waxiip11fr2v39w4lfcg42rl7ylc2ja";
      name = "DarkReign";
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
    mv engine DarkReign
    cd DarkReign
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

  doCheck = true;
  checkTarget = "check test";

  installPhase = ''
    mkdir -p $out/lib/openra-dr
    substitute ${./launch-game.sh} $out/lib/openra-dr/launch-game.sh --subst-var out
    chmod +x $out/lib/openra-dr/launch-game.sh

    # Setting TERM=xterm fixes an issue with terminfo in mono: System.Exception: Magic number is wrong: 542
    # https://github.com/mono/mono/issues/6752#issuecomment-365212655
    wrapProgram $out/lib/openra-dr/launch-game.sh \
      --prefix PATH : "${path}" \
      --prefix LD_LIBRARY_PATH : "${rpath}" \
      --set TERM xterm

    mkdir -p $out/bin
    makeWrapper $out/lib/openra-dr/launch-game.sh $out/bin/openra-dr \
      --run "cd $out/lib/openra-dr"

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
    ]}} $out/lib/openra-dr

    mkdir $out/lib/openra-dr/mods
    cp -r engine/mods/{common,modcontent} $out/lib/openra-dr/mods
    cp -r mods/dr $out/lib/openra-dr/mods

    mkdir -p $out/share/applications
    cp ${./openra-dr.desktop} $out/share/applications/openra-dr.desktop

    mkdir -p $out/share/doc/packages/openra-dr
    cp -r README.md $out/share/doc/packages/openra-dr/README.md

    mkdir -p $out/share/pixmaps
    cp -r mods/dr/icon.png $out/share/pixmaps/openra-dr.png

    mkdir -p $out/share/icons/hicolor/{16x16,32x32,48x48,64x64,128x128,256x256}/apps
    for size in 16 32 48 64 128 256; do
      size=''${size}x''${size}
      cp packaging/linux/mod_''${size}.png "$out/share/icons/hicolor/''${size}/apps/openra-dr.png"
    done
  '';

  dontStrip = true;

  meta = {
    description = "Re-imaginging of the original Dark Reign: The Future of War game";
    homepage = https://github.com/OpenRA/dr;
    maintainers = with maintainers; [ fusion809 ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
