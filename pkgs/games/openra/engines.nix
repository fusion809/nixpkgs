{ buildOpenRAEngine, fetchFromGitHub, abbrevCommit, extraPostFetch }:

let
  buildUpstreamOpenRAEngine = { version, rev, sha256 }: name: (buildOpenRAEngine {
    inherit version;
    description = "Open-source re-implementation of Westwood Studios' 2D Command and Conquer games";
    homepage = https://www.openra.net/;
    mods = [ "cnc" "d2k" "ra" "ts" ];
    src = fetchFromGitHub {
      owner = "OpenRA";
      repo = "OpenRA" ;
      inherit rev sha256 extraPostFetch;
    };
  } name).overrideAttrs (oldAttrs: {
    postInstall = ''
      ${oldAttrs.postInstall}
      cp -r mods/ts $out/lib/openra/mods/
      cp mods/ts/icon.png $(mkdirp $out/share/pixmaps)/openra-ts.png
      ( cd $out/share/applications; sed -e 's/Dawn/Sun/g' -e 's/cnc/ts/g' openra-cnc.desktop > openra-ts.desktop )
    '';
  });

in {
  release = buildUpstreamOpenRAEngine rec {
    version = "20190314";
    rev = "release-${version}";
    sha256 = "15pvn5cx3g0nzbrgpsfz8dngad5wkzp5dz25ydzn8bmxafiijvcr";
  };

  playtest = buildUpstreamOpenRAEngine rec {
    version = "20190302";
    rev = "playtest-${version}";
    sha256 = "1vqvfk2p2lpk3m0d3rpvj34i8cmk3mfc7w4cn4llqd9zp4kk9pya";
  };

  bleed = let commit = "11e4c971c41e1a1fde3534e67a6e8960ae4e0948"; in buildUpstreamOpenRAEngine {
    version = "26095.git.11e4c97";
    rev = commit;
    sha256 = "0dfy170ff1lihyp77aw9xymjydg5mhmc0hafwcy4yw35bnjhcpr3";
  };
}
