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
    version = "20181215";
    rev = "release-${version}";
    sha256 = "0p0izykjnz7pz02g2khp7msqa00jhjsrzk9y0g29dirmdv75qa4r";
  };

  playtest = buildUpstreamOpenRAEngine rec {
    version = "20190106";
    rev = "playtest-${version}";
    sha256 = "0ps9x379plrrj1hnj4fpr26lc46mzgxknv5imxi0bmrh5y4781ql";
  };

  bleed = let commit = "f9cf45e63414922e951c1c465a342079e6b3c629"; in buildUpstreamOpenRAEngine {
    version = "25692.git.2d4bad6";
    rev = commit;
    sha256 = "0iwy0bpc43yqnkdq3mbkhb7791fp6rknabrjijqlqj5min2dfmhc";
  };
}
