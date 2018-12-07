# Based on: pkgs/games/openra/default.nix
# Based on: https://build.opensuse.org/package/show/home:fusion809/openra-gen
{ stdenv, fetchFromGitHub, dos2unix, pkgconfig, makeWrapper
, lua, mono, dotnetPackages, python
, libGL, openal, SDL2
, zenity ? null
}:

with stdenv.lib;

let
  pname = "openra-gen";
  version = "1132";
  engine-version = "gen-20180905";
  path = makeBinPath ([ mono python ] ++ optional (zenity != null) zenity);
  rpath = makeLibraryPath [ lua openal SDL2 ];

in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  srcs = [
    (fetchFromGitHub {
      owner = "MustaphaTR";
      repo = "Generals-Alpha";
      rev = "8753a07216ed20028269bd4112b54ad4b914b21b";
      sha256 = "0r1ibcj5jgbkyg031lkbwsb3gff93d295hl6fhswjb9psg8iafs3";
      name = "Generals-Alpha";
    })
    (fetchFromGitHub {
      owner = "MustaphaTR";
      repo = "OpenRA" ;
      rev = engine-version;
      sha256 = "0wy1h7fg0n8dpy6y91md7x0qnr9rk4xf6155jali4bi8gghw2g5v";
      name = "generals-alpha-engine";

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
    mv generals-alpha-engine Generals-Alpha
    cd Generals-Alpha
  '';

  patches = [ ./Makefile.patch ];

  postPatch = ''
    sed -i 's/^VERSION.*/VERSION = ${version}/g' Makefile

    dos2unix *.md

    sed -i \
      -e 's/^VERSION.*/VERSION = ${engine-version}/g' \
      -e '/fetch-geoip-db/d' \
      -e '/GeoLite2-Country.mmdb.gz/d' \
      generals-alpha-engine/Makefile

    sed -i 's|locations=.*|locations=${lua}/lib|' generals-alpha-engine/thirdparty/configure-native-deps.sh
  '';

  configurePhase = ''
    make version
    ( cd generals-alpha-engine; make version )
  '';

  makeFlags = "PREFIX=$(out)";

  doCheck = false;
  checkTarget = "check test";

  installPhase = ''
    mkdir -p $out/lib/openra-gen
    substitute ${./launch-game.sh} $out/lib/openra-gen/launch-game.sh --subst-var out
    chmod +x $out/lib/openra-gen/launch-game.sh

    # Setting TERM=xterm fixes an issue with terminfo in mono: System.Exception: Magic number is wrong: 542
    # https://github.com/mono/mono/issues/6752#issuecomment-365212655
    wrapProgram $out/lib/openra-gen/launch-game.sh \
      --prefix PATH : "${path}" \
      --prefix LD_LIBRARY_PATH : "${rpath}" \
      --set TERM xterm

    mkdir -p $out/bin
    makeWrapper $out/lib/openra-gen/launch-game.sh $out/bin/openra-gen \
      --run "cd $out/lib/openra-gen"

    cp -r generals-alpha-engine/{${concatStringsSep "," [
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
    ]}} $out/lib/openra-gen

    mkdir $out/lib/openra-gen/mods
    cp -r generals-alpha-engine/mods/{common,modcontent} $out/lib/openra-gen/mods
    cp -r mods/gen $out/lib/openra-gen/mods

    mkdir -p $out/share/applications
    cp ${./openra-gen.desktop} $out/share/applications/openra-gen.desktop

    mkdir -p $out/share/doc/packages/openra-gen
    cp -r README.md $out/share/doc/packages/openra-gen/README.md

    mkdir -p $out/share/pixmaps
    cp -r mods/gen/icon.png $out/share/pixmaps/openra-gen.png

    mkdir -p $out/share/icons/hicolor/{16x16,32x32,48x48,64x64,128x128,256x256}/apps
    for size in 16 32 48 64 128 256; do
      size=''${size}x''${size}
      cp packaging/linux/mod_''${size}.png "$out/share/icons/hicolor/''${size}/apps/openra-gen.png"
    done
  '';

  dontStrip = true;

  meta = {
    description = "Re-imaginging of the original Command & Conquer Command & Conquer: Generals game";
    homepage = http://redalertunplugged.com;
    maintainers = with maintainers; [ msteen ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
