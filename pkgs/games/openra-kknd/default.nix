# Based on: pkgs/games/openra/default.nix
# Based on: https://build.opensuse.org/package/show/home:fusion809/openra-kknd
{ stdenv, fetchFromGitHub, dos2unix, pkgconfig, makeWrapper
, lua, mono, dotnetPackages, python
, libGL, openal, SDL2
, zenity ? null
}:

with stdenv.lib;

let
  pname = "openra-kknd";
  version = "141";
  engine-version = "4e8eab4ca00d1910203c8a103dfd2c002714daa8";
  path = makeBinPath ([ mono python ] ++ optional (zenity != null) zenity);
  rpath = makeLibraryPath [ lua openal SDL2 ];

in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  srcs = [
    (fetchFromGitHub {
      owner = "IceReaper";
      repo = "KKnD";
      rev = "503043e36b21939e62b576c7db7bf14a4017e141";
      sha256 = "1w2i7jclv1sbwv64x2a83xhmaxr8w6j8vznfqn9giz6x7cgfz9zb";
      name = "KKnD";
    })
    (fetchFromGitHub {
      owner = "OpenRA";
      repo = "OpenRA" ;
      rev = engine-version;
      sha256 = "1yyqparf93x8yzy1f46gsymgkj5jls25v2yc7ighr3f7mi3igdvq";
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
    mv engine KKnD
    cd KKnD
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
    mkdir -p $out/lib/openra-kknd
    substitute ${./launch-game.sh} $out/lib/openra-kknd/launch-game.sh --subst-var out
    chmod +x $out/lib/openra-kknd/launch-game.sh

    # Setting TERM=xterm fixes an issue with terminfo in mono: System.Exception: Magic number is wrong: 542
    # https://github.com/mono/mono/issues/6752#issuecomment-365212655
    wrapProgram $out/lib/openra-kknd/launch-game.sh \
      --prefix PATH : "${path}" \
      --prefix LD_LIBRARY_PATH : "${rpath}" \
      --set TERM xterm

    mkdir -p $out/bin
    makeWrapper $out/lib/openra-kknd/launch-game.sh $out/bin/openra-kknd \
      --run "cd $out/lib/openra-kknd"

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
    ]}} $out/lib/openra-kknd

    mkdir $out/lib/openra-kknd/mods
    cp -r engine/mods/{common,modcontent} $out/lib/openra-kknd/mods
    cp -r mods/kknd $out/lib/openra-kknd/mods

    mkdir -p $out/share/applications
    cp ${./openra-kknd.desktop} $out/share/applications/openra-kknd.desktop

    mkdir -p $out/share/doc/packages/openra-kknd
    cp -r README.md $out/share/doc/packages/openra-kknd/README.md

    mkdir -p $out/share/pixmaps
    cp -r packaging/linux/mod_256x256.png $out/share/pixmaps/openra-kknd.png

    mkdir -p $out/share/icons/hicolor/{16x16,32x32,48x48,64x64,128x128,256x256}/apps
    for size in 16 32 48 64 128 256; do
      size=''${size}x''${size}
      cp packaging/linux/mod_''${size}.png "$out/share/icons/hicolor/''${size}/apps/openra-kknd.png"
    done
  '';

  dontStrip = true;

  meta = {
    description = "Re-imaginging of the original Krush, Kill n' Destroy game";
    homepage = https://kknd-game.com/;
    maintainers = with maintainers; [ fusion809 ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
