# Based on: pkgs/games/openra/default.nix
# Based on: https://build.opensuse.org/package/show/home:fusion809/openra-sp
{ stdenv, fetchFromGitHub, dos2unix, pkgconfig, makeWrapper
, lua, mono, dotnetPackages, python
, libGL, openal, SDL2
, zenity ? null
}:

with stdenv.lib;

let
  pname = "openra-sp";
  version = "153";
  engine-version = "NAs-Test-Build";
  path = makeBinPath ([ mono python ] ++ optional (zenity != null) zenity);
  rpath = makeLibraryPath [ lua openal SDL2 ];

in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  srcs = [
    (fetchFromGitHub {
      owner = "ABrandau";
      repo = "OpenRAModSDK";
      rev = "89148b8cf89bf13911fafb74a1aa2b4cacf027e0";
      sha256 = "1bb8hzd3mhnn76iqiah1161qz98f0yvyryhmrghq03xlbin3mhbi";
      name = "SP";
    })
    (fetchFromGitHub {
      owner = "ABrandau";
      repo = "OpenRA" ;
      rev = engine-version;
      sha256 = "1nl3brvx1bikxm5rmpc7xmd32n722jiyjh86pnar6b6idr1zj2ws";
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
    mv engine SP
    cd SP
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
    mkdir -p $out/lib/openra-sp
    substitute ${./launch-game.sh} $out/lib/openra-sp/launch-game.sh --subst-var out
    chmod +x $out/lib/openra-sp/launch-game.sh

    # Setting TERM=xterm fixes an issue with terminfo in mono: System.Exception: Magic number is wrong: 542
    # https://github.com/mono/mono/issues/6752#issuecomment-365212655
    wrapProgram $out/lib/openra-sp/launch-game.sh \
      --prefix PATH : "${path}" \
      --prefix LD_LIBRARY_PATH : "${rpath}" \
      --set TERM xterm

    mkdir -p $out/bin
    makeWrapper $out/lib/openra-sp/launch-game.sh $out/bin/openra-sp \
      --run "cd $out/lib/openra-sp"

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
    ]}} $out/lib/openra-sp

    mkdir $out/lib/openra-sp/mods
    cp -r engine/mods/{as,ts,common,modcontent} $out/lib/openra-sp/mods
    cp -r mods/sp $out/lib/openra-sp/mods

    mkdir -p $out/share/applications
    cp ${./openra-sp.desktop} $out/share/applications/openra-sp.desktop

    mkdir -p $out/share/doc/packages/openra-sp
    cp -r README.md $out/share/doc/packages/openra-sp/README.md

    mkdir -p $out/share/pixmaps
    cp -r packaging/linux/mod_256x256.png $out/share/pixmaps/openra-sp.png

    mkdir -p $out/share/icons/hicolor/{16x16,32x32,48x48,64x64,128x128,256x256}/apps
    for size in 16 32 48 64 128 256; do
      size=''${size}x''${size}
      cp packaging/linux/mod_''${size}.png "$out/share/icons/hicolor/''${size}/apps/openra-sp.png"
    done
  '';

  dontStrip = true;

  meta = {
    description = "Re-imaginging of the original Command & Conquer Tiberian Sun game";
    homepage = https://github.com/ABrandau/OpenRAModSDK;
    maintainers = with maintainers; [ fusion809 ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
