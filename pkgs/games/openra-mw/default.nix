# Based on: pkgs/games/openra/default.nix
# Based on: https://build.opensuse.org/package/show/home:fusion809/openra-mw
{ stdenv, fetchFromGitHub, dos2unix, pkgconfig, makeWrapper
, lua, mono, dotnetPackages, python
, libGL, openal, SDL2
, zenity ? null
}:

with stdenv.lib;

let
  pname = "openra-mw";
  version = "235";
  engine-version = "0e3c07e9a8f62cd659130ee55ce7e593e055aae4";
  path = makeBinPath ([ mono python ] ++ optional (zenity != null) zenity);
  rpath = makeLibraryPath [ lua openal SDL2 ];

in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  srcs = [
    (fetchFromGitHub {
      owner = "CombinE88";
      repo = "Medieval-Warfare";
      rev = "1e4fc7ea24d0806c5a7cd753490e967d804a3567";
      sha256 = "0swa66mzb6wr8vf1yivrss54dl98jzzwh9b8qrjfwmfrq2i356iq";
      name = "Medieval-Warfare";
    })
    (fetchFromGitHub {
      owner = "CombinE88";
      repo = "OpenRA" ;
      rev = engine-version;
      sha256 = "1j738fzy5b4v0yhla7vglpiv138w0p6pgdhnsv7bdimrci5ki3jc";
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
    mv engine Medieval-Warfare
    cd Medieval-Warfare
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
    mkdir -p $out/lib/openra-mw
    substitute ${./launch-game.sh} $out/lib/openra-mw/launch-game.sh --subst-var out
    chmod +x $out/lib/openra-mw/launch-game.sh

    # Setting TERM=xterm fixes an issue with terminfo in mono: System.Exception: Magic number is wrong: 542
    # https://github.com/mono/mono/issues/6752#issuecomment-365212655
    wrapProgram $out/lib/openra-mw/launch-game.sh \
      --prefix PATH : "${path}" \
      --prefix LD_LIBRARY_PATH : "${rpath}" \
      --set TERM xterm

    mkdir -p $out/bin
    makeWrapper $out/lib/openra-mw/launch-game.sh $out/bin/openra-mw \
      --run "cd $out/lib/openra-mw"

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
    ]}} $out/lib/openra-mw

    mkdir $out/lib/openra-mw/mods
    cp -r engine/mods/{common,modcontent} $out/lib/openra-mw/mods
    cp -r mods/mw $out/lib/openra-mw/mods

    mkdir -p $out/share/applications
    cp ${./openra-mw.desktop} $out/share/applications/openra-mw.desktop

    mkdir -p $out/share/doc/packages/openra-mw
    cp -r README.md $out/share/doc/packages/openra-mw/README.md

    mkdir -p $out/share/pixmaps
    cp -r mods/mw/icon.png $out/share/pixmaps/openra-mw.png
  '';

  dontStrip = true;

  meta = {
    description = "Re-imaginging of the original Command Command & Conquer  Conquer: Medieval Warfare game";
    homepage = https://github.com/OpenRA/mw;
    maintainers = with maintainers; [ fusion809 ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
